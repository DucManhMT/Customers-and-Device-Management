package crm.feedback.service;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

import crm.common.URLConstants;
import crm.common.model.Account;
import crm.common.model.Feedback;
import crm.common.model.Request;
import crm.common.model.enums.FeedbackStatus;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.repository.hibernate.entitymanager.LazyReference;
import crm.core.service.IDGeneratorService;
import crm.service_request.repository.persistence.query.common.Page;
import crm.service_request.repository.persistence.query.common.PageRequest;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class FeedbackService {

    public void showCreateFeedbackForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Account account = (Account) req.getSession().getAttribute("account");
        String username = account != null ? account.getUsername() : null;
        Integer roleId = account != null ? account.getRole().getRoleID() : null;
        req.setAttribute("currentUsername", username);

        String requestIdStr = req.getParameter("requestId");

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

            Feedback existingFeedback = null;
            if (requestIdStr != null && !requestIdStr.trim().isEmpty()) {
                try {
                    int reqId = Integer.parseInt(requestIdStr.trim());
                    List<Feedback> allFeedbacks = entityManager.findAll(Feedback.class);
                    for (Feedback fb : allFeedbacks) {
                        // allow creating a new feedback if the previous one was soft-deleted
                        if (fb.getFeedbackStatus() != null && fb.getFeedbackStatus() == FeedbackStatus.Deleted) {
                            continue;
                        }
                        if (fb.getRequestID() != null && fb.getRequestID().getForeignKeyValue() != null
                                && fb.getRequestID().getForeignKeyValue().equals(reqId)
                                && fb.getCustomerID() != null && fb.getCustomerID().equals(username)) {
                            existingFeedback = fb;
                            break;
                        }
                    }
                } catch (Exception ex) {
                }
            }

            if (existingFeedback != null) {
                req.getSession().setAttribute("alreadyFeedback", true);
                req.getSession().setAttribute("feedback", existingFeedback);
                req.getSession().setAttribute("requestId", requestIdStr);
                req.getSession().setAttribute("currentUsername", username);
                req.getSession().setAttribute("currentRoleId", roleId);
                resp.sendRedirect(req.getContextPath() + URLConstants.CUSTOMER_VIEW_FEEDBACK);
                return;
            }

            Page<Feedback> feedbackPage = getFeedbackByUsernamePaginated(entityManager, username, page, recordsPerPage);
            req.setAttribute("recentFeedbacks", feedbackPage.getContent());
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", feedbackPage.getTotalPages());
            req.setAttribute("recordsPerPage", recordsPerPage);
            req.setAttribute("totalRecords", feedbackPage.getTotalElements());
            req.setAttribute("currentUsername", username);
            req.setAttribute("requestId", requestIdStr);
        } catch (SQLException e) {
            e.printStackTrace();
            if (e.getMessage() != null && !e.getMessage().contains("No data found")) {
                req.setAttribute("errorMessage", "Unable to load feedback data: " + e.getMessage());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        req.getRequestDispatcher("/customer/create_feedback.jsp").forward(req, resp);
    }

    public void createFeedback(HttpServletRequest req, HttpServletResponse resp, String username)
            throws ServletException, IOException {

        String feedbackType = req.getParameter("feedbackType");
        String customContent = req.getParameter("customContent");
        String ratingStr = req.getParameter("rating");
        String description = req.getParameter("description");
        String requestIdStr = req.getParameter("requestId");

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
            }

            int rating = Integer.parseInt(ratingStr);
            if (rating < 1 || rating > 5) {
                throw new IllegalArgumentException("Rating must be from 1 to 5");
            }

            Integer requestId = null;
            if (requestIdStr != null && !requestIdStr.trim().isEmpty()) {
                requestId = Integer.parseInt(requestIdStr.trim());
            } else {
                throw new IllegalArgumentException("Request ID is required");
            }

            try (Connection connection = DBcontext.getConnection()) {
                EntityManager entityManager = new EntityManager(connection);
                LocalDateTime now = LocalDateTime.now();

                Feedback feedback = new Feedback();
                feedback.setFeedbackID(IDGeneratorService.generateID(Feedback.class));
                feedback.setContent(content);
                feedback.setRating(rating);
                feedback.setDescription(description != null ? description.trim() : null);
                feedback.setFeedbackDate(now);
                feedback.setResponseDate(now);
                feedback.setCustomerID(username);
                feedback.setRequestID(new LazyReference<>(Request.class, requestId));
                feedback.setFeedbackStatus(FeedbackStatus.Pending);

                entityManager.persist(feedback, Feedback.class);

                req.setAttribute("successMessage", "Feedback created successfully! Thank you, " + username + ".");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Failed to create feedback. Please try again.");
        }

        showCreateFeedbackForm(req, resp);
    }

    public void showFeedbackList(HttpServletRequest req, HttpServletResponse resp)
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
        String fromDateStr = req.getParameter("fromDate");
        String toDateStr = req.getParameter("toDate");
        String q = req.getParameter("q");
        String status = req.getParameter("status");

        try {
            if (ratingStr != null && !ratingStr.trim().isEmpty()) {
                rating = Integer.parseInt(ratingStr);
            }
        } catch (NumberFormatException e) {
        }

        Account account = (Account) req.getSession().getAttribute("account");
        Integer roleId = account != null ? account.getRole().getRoleID() : null;
        if (roleId != null && roleId == 2) {
            username = account.getUsername();
        }

        try (Connection connection = DBcontext.getConnection()) {
            EntityManager entityManager = new EntityManager(connection);

            Page<Feedback> feedbackPage = getFeedbacksWithFilters(entityManager, page, recordsPerPage, username,
                    rating, status, fromDateStr, toDateStr, q, roleId);

            req.setAttribute("feedbacks", feedbackPage.getContent());
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", feedbackPage.getTotalPages());
            req.setAttribute("recordsPerPage", recordsPerPage);
            req.setAttribute("totalRecords", feedbackPage.getTotalElements());
            req.setAttribute("username", username);
            req.setAttribute("rating", ratingStr);
            req.setAttribute("fromDate", fromDateStr);
            req.setAttribute("toDate", toDateStr);
            req.setAttribute("q", q);
            req.setAttribute("status", status);
            req.setAttribute("currentUsername", username);

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Failed to load feedbacks: " + e.getMessage());
        }

        req.getRequestDispatcher("/customer/list_feedback.jsp").forward(req, resp);
    }

    public void showFeedbackDetails(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Account account = (Account) req.getSession().getAttribute("account");
        String requestIdStr = (String) req.getSession().getAttribute("requestId");
        if (requestIdStr == null) {
            requestIdStr = (String) req.getParameter("requestId");
        }
        String username = account != null ? account.getUsername() : null;
        Integer roleId = account != null ? account.getRole().getRoleID() : null;
        req.setAttribute("currentUsername", username);

        if (requestIdStr != null && !requestIdStr.trim().isEmpty()) {
            try (Connection connection = DBcontext.getConnection()) {
                EntityManager entityManager = new EntityManager(connection);
                int reqId = Integer.parseInt(requestIdStr.trim());
                List<Feedback> allFeedbacks = entityManager.findAll(Feedback.class);
                Feedback feedback = null;
                for (Feedback fb : allFeedbacks) {
                    // Skip deleted feedbacks for non-supporters; supporters (roleId == 3) may view deleted entries
                    if (fb.getFeedbackStatus() != null && fb.getFeedbackStatus() == FeedbackStatus.Deleted) {
                        if (roleId == null || roleId != 3) {
                            continue;
                        }
                    }
                    if (fb.getRequestID() != null && fb.getRequestID().getForeignKeyValue() != null
                            && fb.getRequestID().getForeignKeyValue().equals(reqId)) {
                        feedback = fb;
                        break;
                    }
                }
                if (feedback == null) {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Feedback not found for this request");
                    return;
                }
                req.setAttribute("feedback", feedback);
                req.setAttribute("currentRoleId", roleId);
                System.out.println(roleId);
                if (roleId != null && roleId == 2) {
                    req.getRequestDispatcher("/customer/view_feedback.jsp").forward(req, resp);
                } else if (roleId != null && roleId == 3) {
                    req.getRequestDispatcher("/customer_supporter/view_feedback_detail.jsp").forward(req, resp);
                } else {
                    req.getRequestDispatcher("/customer/view_feedback.jsp").forward(req, resp);
                }
                return;
            } catch (NumberFormatException e) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request ID format");
                return;
            } catch (SQLException e) {
                e.printStackTrace();
                req.setAttribute("errorMessage", "Failed to load feedback details: " + e.getMessage());
                req.getRequestDispatcher("/customer/create_feedback.jsp").forward(req, resp);
                return;
            }
        }
    }

    public Page<Feedback> getFeedbackByUsernamePaginated(EntityManager entityManager, String username, int page,
                                                         int recordsPerPage) throws SQLException {
        try {
            List<Feedback> allFeedbacks = entityManager.findAll(Feedback.class);
            List<Feedback> userFeedbacks = new ArrayList<>();

            for (Feedback feedback : allFeedbacks) {
                // skip deleted feedbacks
                if (feedback.getFeedbackStatus() != null && feedback.getFeedbackStatus() == FeedbackStatus.Deleted) {
                    continue;
                }
                if (username != null && feedback.getCustomerID() != null && feedback.getCustomerID().equals(username)) {
                    userFeedbacks.add(feedback);
                }
            }

            userFeedbacks.sort((f1, f2) -> {
                if (f1.getFeedbackDate() == null && f2.getFeedbackDate() == null)
                    return 0;
                if (f1.getFeedbackDate() == null)
                    return 1;
                if (f2.getFeedbackDate() == null)
                    return -1;
                return f2.getFeedbackDate().compareTo(f1.getFeedbackDate());
            });

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

    public Page<Feedback> getFeedbacksWithFilters(EntityManager entityManager, int page, int recordsPerPage,
                                                  String username, Integer rating) throws SQLException {
        return getFeedbacksWithFilters(entityManager, page, recordsPerPage, username, rating, null, null, null, null, null);
    }

    /**
     * Extended filter that supports username (partial, case-insensitive), rating and status.
     */
    public Page<Feedback> getFeedbacksWithFilters(EntityManager entityManager, int page, int recordsPerPage,
                                                  String username, Integer rating, String status) throws SQLException {
        // delegate to extended filter with no date-range, no free-text query and no role
        return getFeedbacksWithFilters(entityManager, page, recordsPerPage, username, rating, status, null, null, null, null);
    }

    /**
     * Extended filter supporting username (partial), rating, status, date range (from/to in yyyy-MM-dd), and free-text q.
     */
    public Page<Feedback> getFeedbacksWithFilters(EntityManager entityManager, int page, int recordsPerPage,
                                                  String username, Integer rating, String status, String fromDateStr, String toDateStr, String q, Integer roleId) throws SQLException {
        try {
            List<Feedback> allFeedbacks = entityManager.findAll(Feedback.class);
            List<Feedback> filteredFeedbacks = new ArrayList<>();

            String usernameNorm = (username != null) ? username.trim().toLowerCase() : null;
            String statusNorm = (status != null) ? status.trim().toLowerCase() : null;
            String qNorm = (q != null) ? q.trim().toLowerCase() : null;

            LocalDateTime fromDate = null;
            LocalDateTime toDate = null;
            try {
                if (fromDateStr != null && !fromDateStr.trim().isEmpty()) {
                    LocalDate ld = LocalDate.parse(fromDateStr.trim());
                    fromDate = ld.atStartOfDay();
                }
                if (toDateStr != null && !toDateStr.trim().isEmpty()) {
                    LocalDate ld = LocalDate.parse(toDateStr.trim());
                    toDate = ld.atTime(LocalTime.MAX);
                }
            } catch (Exception ex) {
                // ignore parse errors and treat as no date filter
                fromDate = null;
                toDate = null;
            }

            for (Feedback feedback : allFeedbacks) {
                // exclude soft-deleted feedbacks from filter results unless the viewer is a supporter (roleId == 3)
                if (feedback.getFeedbackStatus() != null && feedback.getFeedbackStatus() == FeedbackStatus.Deleted) {
                    if (roleId == null || roleId != 3) {
                        continue;
                    }
                }

                boolean matches = true;

                // username: partial, case-insensitive
                if (usernameNorm != null && !usernameNorm.isEmpty()) {
                    String cust = feedback.getCustomerID();
                    boolean customerMatch = (cust != null && cust.toLowerCase().contains(usernameNorm));
                    if (!customerMatch) {
                        matches = false;
                    }
                }

                // rating: exact match
                if (rating != null) {
                    if (feedback.getRating() == null || !feedback.getRating().equals(rating)) {
                        matches = false;
                    }
                }

                // status: compare enum name case-insensitive
                if (statusNorm != null && !statusNorm.isEmpty()) {
                    if (feedback.getFeedbackStatus() == null || !feedback.getFeedbackStatus().name().toLowerCase().equals(statusNorm)) {
                        matches = false;
                    }
                }

                // date range
                if ((fromDate != null || toDate != null) && feedback.getFeedbackDate() != null) {
                    LocalDateTime fd = feedback.getFeedbackDate();
                    if (fromDate != null && fd.isBefore(fromDate)) {
                        matches = false;
                    }
                    if (toDate != null && fd.isAfter(toDate)) {
                        matches = false;
                    }
                }

                // free-text q searched in content and description
                if (qNorm != null && !qNorm.isEmpty()) {
                    String content = feedback.getContent() != null ? feedback.getContent().toLowerCase() : "";
                    String desc = feedback.getDescription() != null ? feedback.getDescription().toLowerCase() : "";
                    if (!content.contains(qNorm) && !desc.contains(qNorm)) {
                        matches = false;
                    }
                }

                if (matches) {
                    filteredFeedbacks.add(feedback);
                }
            }

            filteredFeedbacks.sort((f1, f2) -> {
                if (f1.getFeedbackDate() == null && f2.getFeedbackDate() == null)
                    return 0;
                if (f1.getFeedbackDate() == null)
                    return 1;
                if (f2.getFeedbackDate() == null)
                    return -1;
                return f2.getFeedbackDate().compareTo(f1.getFeedbackDate());
            });

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

    public Feedback getFeedbackById(EntityManager entityManager, Integer feedbackId) throws SQLException {
        try {
            return entityManager.find(Feedback.class, feedbackId);
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to retrieve feedback", e);
        }
    }

    public void updateFeedback(EntityManager entityManager, Feedback feedback) throws SQLException {
        try {
            entityManager.merge(feedback, Feedback.class);
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to update feedback", e);
        }
    }

    public void deleteFeedback(EntityManager entityManager, Integer feedbackId) throws SQLException {
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
