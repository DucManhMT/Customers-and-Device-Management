package crm.feedback.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import crm.common.model.Feedback;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.config.DBcontext;
import crm.core.service.IDGeneratorService;
import crm.service_request.repository.persistence.query.common.Page;
import crm.service_request.repository.persistence.query.common.PageRequest;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "FeedbackController", urlPatterns = { "/feedback/create", "/feedback/list", "/feedback/view" })
public class FeedbackController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = getAction(req);

        String username = (String) req.getSession().getAttribute("username");
        if (username == null || username.trim().isEmpty()) {
            username = "customer001";
            req.getSession().setAttribute("username", username);
        }

        try {
            switch (action) {
                case "create":
                    showCreateFeedbackForm(req, resp);
                    break;
                case "list":
                    showFeedbackList(req, resp);
                    break;
                case "view":
                    showFeedbackDetails(req, resp);
                    break;
                default:
                    showCreateFeedbackForm(req, resp);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            req.getRequestDispatcher("/feedback/createFeedback.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = (String) req.getSession().getAttribute("username");
        if (username == null || username.trim().isEmpty()) {
            username = "customer001";
            req.getSession().setAttribute("username", username);
        }

        String action = getAction(req);

        try {
            switch (action) {
                case "create":
                    createFeedback(req, resp, username);
                    break;
                default:
                    resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Error creating feedback: " + e.getMessage());
            showCreateFeedbackForm(req, resp);
        }
    }

    private String getAction(HttpServletRequest req) {
        String pathInfo = req.getPathInfo();
        String servletPath = req.getServletPath();

        if (servletPath.contains("/feedback/")) {
            String action = servletPath.substring(servletPath.lastIndexOf("/") + 1);
            return action;
        }

        if (pathInfo == null || pathInfo.equals("/")) {
            return "create";
        }

        return pathInfo.substring(1);
    }

    private void showCreateFeedbackForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = (String) req.getSession().getAttribute("username");
        req.setAttribute("currentUsername", username);

        req.removeAttribute("errorMessage");

        int page = 1;
        int recordsPerPage = 5;

        try {
            if (req.getParameter("page") != null) {
                page = Integer.parseInt(req.getParameter("page"));
            }
            if (req.getParameter("recordsPerPage") != null) {
                recordsPerPage = Integer.parseInt(req.getParameter("recordsPerPage"));
            }
        } catch (NumberFormatException e) {
        }

        try (Connection connection = DBcontext.getConnection()) {
            EntityManager entityManager = new EntityManager(connection);
            
            Page<Feedback> feedbackPage = getFeedbackByUsernamePaginated(entityManager, username, page, recordsPerPage);
            req.setAttribute("recentFeedbacks", feedbackPage.getContent());
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", feedbackPage.getTotalPages());
            req.setAttribute("recordsPerPage", recordsPerPage);
            req.setAttribute("totalRecords", feedbackPage.getTotalElements());

        } catch (SQLException e) {
            e.printStackTrace();
            if (e.getMessage() != null && !e.getMessage().contains("No data found")) {
                req.setAttribute("errorMessage", "Unable to load feedback data: " + e.getMessage());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        req.getRequestDispatcher("/feedback/createFeedback.jsp").forward(req, resp);
    }

    private void createFeedback(HttpServletRequest req, HttpServletResponse resp, String username)
            throws ServletException, IOException {

        String feedbackType = req.getParameter("feedbackType");
        String customContent = req.getParameter("customContent");
        String ratingStr = req.getParameter("rating");
        String response = req.getParameter("response");

        String content = "";

        try {
            if ("other".equals(feedbackType)) {
                if (customContent == null || customContent.trim().isEmpty()) {
                    throw new IllegalArgumentException("Please enter content for 'Other' option");
                }
                content = customContent.trim();
            } else if (feedbackType != null) {
                switch (feedbackType) {
                    case "repair_quality":
                        content = "Repair and Warranty Quality";
                        break;
                    case "service_quality":
                        content = "Service Quality";
                        break;
                    case "staff_attitude":
                        content = "Staff Attitude";
                        break;
                    default:
                        throw new IllegalArgumentException("Please select feedback type");
                }
            } else {
                throw new IllegalArgumentException("Please select feedback type");
            }

            if (ratingStr == null || ratingStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Please select rating");
            }

            int rating = Integer.parseInt(ratingStr);

            if (rating < 1 || rating > 5) {
                throw new IllegalArgumentException("Rating must be from 1 to 5");
            }

            try (Connection connection = DBcontext.getConnection()) {
                EntityManager entityManager = new EntityManager(connection);
                
                createFeedbackWithEntityManager(entityManager, content, rating, username, response);

                req.setAttribute("successMessage",
                        "Feedback created successfully! Thank you " + username + " for your review.");

                showCreateFeedbackForm(req, resp);
            } catch (SQLException e) {
                e.printStackTrace();
                throw new RuntimeException("Database error when creating feedback", e);
            }

        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid data format");
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Unknown error when creating feedback", e);
        }
    }

    private void showFeedbackList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int page = 1;
        int recordsPerPage = 10;

        try {
            if (req.getParameter("page") != null) {
                page = Integer.parseInt(req.getParameter("page"));
            }
            if (req.getParameter("recordsPerPage") != null) {
                recordsPerPage = Integer.parseInt(req.getParameter("recordsPerPage"));
            }
        } catch (NumberFormatException e) {
        }

        String username = req.getParameter("username");
        String ratingStr = req.getParameter("rating");
        Integer rating = null;

        try {
            if (ratingStr != null && !ratingStr.trim().isEmpty()) {
                rating = Integer.parseInt(ratingStr);
            }
        } catch (NumberFormatException e) {
        }

        try (Connection connection = DBcontext.getConnection()) {
            EntityManager entityManager = new EntityManager(connection);
            
            Page<Feedback> feedbackPage = getFeedbacksWithFilters(entityManager, page, recordsPerPage, username, rating);

            req.setAttribute("feedbacks", feedbackPage.getContent());
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", feedbackPage.getTotalPages());
            req.setAttribute("recordsPerPage", recordsPerPage);
            req.setAttribute("username", username);
            req.setAttribute("rating", ratingStr);

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Failed to load feedbacks: " + e.getMessage());
        }

        req.getRequestDispatcher("/feedback/listFeedback.jsp").forward(req, resp);
    }

    private void showFeedbackDetails(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String feedbackIdStr = req.getParameter("feedbackId");
        if (feedbackIdStr == null || feedbackIdStr.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Feedback ID is required");
            return;
        }

        try (Connection connection = DBcontext.getConnection()) {
            EntityManager entityManager = new EntityManager(connection);
            
            Integer feedbackId = Integer.parseInt(feedbackIdStr);

            Feedback feedback = getFeedbackById(entityManager, feedbackId);
            if (feedback == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Feedback not found");
                return;
            }

            req.setAttribute("feedback", feedback);
            req.getRequestDispatcher("/feedback/viewFeedback.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid feedback ID format");
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Failed to load feedback details: " + e.getMessage());
            req.getRequestDispatcher("/feedback/createFeedback.jsp").forward(req, resp);
        }
    }

    // Helper methods using EntityManager
    private Feedback createFeedbackWithEntityManager(EntityManager entityManager, String content, int rating, String username, String response) throws SQLException {
        try {
            LocalDateTime currentTimestamp = LocalDateTime.now();

            Feedback feedback = new Feedback();
            feedback.setFeedbackID(IDGeneratorService.generateID(Feedback.class));
            feedback.setContent(content);
            feedback.setRating(rating);
            feedback.setResponse(response != null ? response.trim() : null);
            feedback.setFeedbackDate(currentTimestamp);
            feedback.setCustomerID(username);

            entityManager.persist(feedback, Feedback.class);
            return feedback;
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to create feedback", e);
        }
    }

    private Page<Feedback> getFeedbackByUsernamePaginated(EntityManager entityManager, String username, int page, int recordsPerPage) throws SQLException {
        try {
            // Get all feedbacks first, then filter by username
            List<Feedback> allFeedbacks = entityManager.findAll(Feedback.class);
            List<Feedback> userFeedbacks = new ArrayList<>();
            
            for (Feedback feedback : allFeedbacks) {
                if (username == null || feedback.getCustomerID() == null || feedback.getCustomerID().equals(username)) {
                    userFeedbacks.add(feedback);
                }
            }
            
            // Sort by feedback date descending
            userFeedbacks.sort((f1, f2) -> {
                if (f1.getFeedbackDate() == null && f2.getFeedbackDate() == null) return 0;
                if (f1.getFeedbackDate() == null) return 1;
                if (f2.getFeedbackDate() == null) return -1;
                return f2.getFeedbackDate().compareTo(f1.getFeedbackDate());
            });
            
            // Apply pagination
            int totalCount = userFeedbacks.size();
            int offset = (page - 1) * recordsPerPage;
            int startIndex = offset;
            int endIndex = Math.min(startIndex + recordsPerPage, totalCount);
            
            List<Feedback> paginatedList = new ArrayList<>();
            for (int i = startIndex; i < endIndex; i++) {
                paginatedList.add(userFeedbacks.get(i));
            }
            
            PageRequest pageRequest = new PageRequest(page, recordsPerPage);
            Page<Feedback> pageResult = new Page<>(totalCount, pageRequest, paginatedList);
            
            return pageResult;
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to retrieve paginated feedbacks", e);
        }
    }

    private Page<Feedback> getFeedbacksWithFilters(EntityManager entityManager, int page, int recordsPerPage, String username, Integer rating) throws SQLException {
        try {
            // Get all feedbacks first
            List<Feedback> allFeedbacks = entityManager.findAll(Feedback.class);
            List<Feedback> filteredFeedbacks = new ArrayList<>();
            
            for (Feedback feedback : allFeedbacks) {
                boolean matches = true;
                
                // Filter by username
                if (username != null && !username.trim().isEmpty()) {
                    if (feedback.getCustomerID() == null || !feedback.getCustomerID().equals(username)) {
                        matches = false;
                    }
                }
                
                // Filter by rating
                if (rating != null) {
                    if (feedback.getRating() == null || !feedback.getRating().equals(rating)) {
                        matches = false;
                    }
                }
                
                if (matches) {
                    filteredFeedbacks.add(feedback);
                }
            }
            
            // Sort by feedback date descending
            filteredFeedbacks.sort((f1, f2) -> {
                if (f1.getFeedbackDate() == null && f2.getFeedbackDate() == null) return 0;
                if (f1.getFeedbackDate() == null) return 1;
                if (f2.getFeedbackDate() == null) return -1;
                return f2.getFeedbackDate().compareTo(f1.getFeedbackDate());
            });
            
            // Apply pagination
            int totalCount = filteredFeedbacks.size();
            int offset = (page - 1) * recordsPerPage;
            int startIndex = offset;
            int endIndex = Math.min(startIndex + recordsPerPage, totalCount);
            
            List<Feedback> paginatedList = new ArrayList<>();
            for (int i = startIndex; i < endIndex; i++) {
                paginatedList.add(filteredFeedbacks.get(i));
            }
            
            PageRequest pageRequest = new PageRequest(page, recordsPerPage);
            Page<Feedback> pageResult = new Page<>(totalCount, pageRequest, paginatedList);
            
            return pageResult;
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to retrieve filtered feedbacks", e);
        }
    }

    private Feedback getFeedbackById(EntityManager entityManager, Integer feedbackId) throws SQLException {
        try {
            return entityManager.find(Feedback.class, feedbackId);
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to retrieve feedback", e);
        }
    }

    private void updateFeedback(EntityManager entityManager, Feedback feedback) throws SQLException {
        try {
            entityManager.merge(feedback, Feedback.class);
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to update feedback", e);
        }
    }

    private void deleteFeedback(EntityManager entityManager, Integer feedbackId) throws SQLException {
        try {
            Feedback feedback = entityManager.find(Feedback.class, feedbackId);
            if (feedback != null) {
                entityManager.remove(feedback, Feedback.class);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to delete feedback", e);
        }
    }
}