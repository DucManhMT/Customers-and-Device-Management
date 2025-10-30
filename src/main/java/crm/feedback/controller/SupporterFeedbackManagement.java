package crm.feedback.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import crm.common.URLConstants;
import crm.common.model.Account;
import crm.common.model.Feedback;
import crm.common.model.enums.FeedbackStatus;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.feedback.service.FeedbackService;
import crm.service_request.repository.persistence.query.common.Page;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "SupporterFeedbackManagement", urlPatterns = { URLConstants.CUSTOMER_SUPPORTER_FEEDBACK_MANAGEMENT })
public class SupporterFeedbackManagement extends HttpServlet {

    private FeedbackService fedsv = new FeedbackService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Account account = (Account) req.getSession().getAttribute("account");
        if (account == null) {
            resp.sendRedirect(req.getContextPath() + URLConstants.AUTH_STAFF_LOGIN);
            return;
        }

        int page = 1;
        int pageSize = 10;
        String pageStr = req.getParameter("page");
        String pageSizeStr = req.getParameter("pageSize");
        String username = req.getParameter("username");
        String ratingStr = req.getParameter("rating");
        Integer rating = null;
        String statusFilter = req.getParameter("status");

        try {
            if (pageStr != null) page = Integer.parseInt(pageStr);
        } catch (NumberFormatException e) {
        }
        try {
            if (pageSizeStr != null) pageSize = Integer.parseInt(pageSizeStr);
        } catch (NumberFormatException e) {
        }
        try {
            if (ratingStr != null && !ratingStr.trim().isEmpty()) rating = Integer.parseInt(ratingStr);
        } catch (NumberFormatException e) {
        }

        try (Connection connection = DBcontext.getConnection()) {
            EntityManager entityManager = new EntityManager(connection);

            Page<Feedback> feedbackPage = fedsv.getFeedbacksWithFilters(entityManager, page, pageSize, username, rating, statusFilter);

            List<Feedback> allFeedbacks = entityManager.findAll(Feedback.class);
            int respondedCount = 0;
            int pendingCount = 0;
            for (Feedback f : allFeedbacks) {
                boolean matches = true;
                if (username != null && !username.trim().isEmpty()) {
                    if (f.getCustomerID() == null || !f.getCustomerID().equals(username)) matches = false;
                }
                if (rating != null) {
                    if (f.getRating() == null || !f.getRating().equals(rating)) matches = false;
                }
                if (!matches) continue;
                if (f.getResponse() != null && !f.getResponse().trim().isEmpty()) respondedCount++; else pendingCount++;
            }

            req.setAttribute("feedbacks", feedbackPage.getContent());
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", feedbackPage.getTotalPages());
            req.setAttribute("pageSize", pageSize);
            req.setAttribute("totalCount", feedbackPage.getTotalElements());
            req.setAttribute("respondedCount", respondedCount);
            req.setAttribute("pendingCount", pendingCount);
            req.setAttribute("usernameFilter", username);
            req.setAttribute("ratingFilter", ratingStr);
            req.setAttribute("statusFilter", statusFilter);

            req.getRequestDispatcher("/customer_supporter/feedback_management.jsp").forward(req, resp);

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Failed to load feedback list: " + e.getMessage());
            req.getRequestDispatcher("/customer_supporter/feedback_management.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Unexpected error: " + e.getMessage());
            req.getRequestDispatcher("/customer_supporter/feedback_management.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Account account = (Account) req.getSession().getAttribute("account");
        if (account == null) {
            resp.sendRedirect(req.getContextPath() + URLConstants.AUTH_STAFF_LOGIN);
            return;
        }

        String action = req.getParameter("action");
        if (action == null) action = "";
        if ("respond".equalsIgnoreCase(action)) {
            String feedbackIdStr = req.getParameter("feedbackId");
            String responseText = req.getParameter("responseText");
            try (Connection connection = DBcontext.getConnection()) {
                EntityManager entityManager = new EntityManager(connection);
                Integer fid = null;
                try { fid = Integer.parseInt(feedbackIdStr); } catch (NumberFormatException e) { }
                if (fid == null) {
                    req.getSession().setAttribute("errorMessage", "Invalid feedback ID");
                    resp.sendRedirect(req.getContextPath() + URLConstants.CUSTOMER_SUPPORTER_FEEDBACK_MANAGEMENT);
                    return;
                }
                Feedback fb = fedsv.getFeedbackById(entityManager, fid);
                if (fb == null) {
                    req.getSession().setAttribute("errorMessage", "Feedback not found");
                    resp.sendRedirect(req.getContextPath() + URLConstants.CUSTOMER_SUPPORTER_FEEDBACK_MANAGEMENT);
                    return;
                }
                fb.setResponse(responseText != null ? responseText.trim() : null);
                fb.setFeedbackStatus(FeedbackStatus.Responded);
                fedsv.updateFeedback(entityManager, fb);
                req.getSession().setAttribute("successMessage", "Responded to feedback #" + fid);
                resp.sendRedirect(req.getContextPath() + URLConstants.CUSTOMER_SUPPORTER_FEEDBACK_MANAGEMENT);
                return;
            } catch (SQLException e) {
                e.printStackTrace();
                req.getSession().setAttribute("errorMessage", "Failed to respond: " + e.getMessage());
                resp.sendRedirect(req.getContextPath() + URLConstants.CUSTOMER_SUPPORTER_FEEDBACK_MANAGEMENT);
                return;
            }
        }
        doGet(req, resp);
    }
}
