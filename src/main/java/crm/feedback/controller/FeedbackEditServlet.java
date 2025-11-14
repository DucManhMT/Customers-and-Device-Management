package crm.feedback.controller;

import crm.common.model.Feedback;
import crm.common.model.Account;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet(urlPatterns = {"/feedback/edit"})
public class FeedbackEditServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fid = req.getParameter("feedbackId");
        if (fid == null || fid.trim().isEmpty()) {
            req.getSession().setAttribute("errorMessage", "Feedback ID is required");
            resp.sendRedirect(req.getContextPath() + "/feedback/list");
            return;
        }

        try (Connection connection = DBcontext.getConnection()) {
            EntityManager em = new EntityManager(connection);
            try {
                Integer id = Integer.parseInt(fid.trim());
                Feedback feedback = em.find(Feedback.class, id);
                if (feedback == null) {
                    req.getSession().setAttribute("errorMessage", "Feedback not found");
                    resp.sendRedirect(req.getContextPath() + "/feedback/list");
                    return;
                }

                Account account = (Account) req.getSession().getAttribute("account");
                String username = account != null ? account.getUsername() : null;
                Integer roleId = account != null && account.getRole() != null ? account.getRole().getRoleID() : null;
             
                if (username == null || (!username.equals(feedback.getCustomerID()) && !(roleId != null && (roleId == 1 || roleId == 3)))) {
                    req.getSession().setAttribute("errorMessage", "You don't have permission to edit this feedback.");
                    resp.sendRedirect(req.getContextPath() + "/feedback/view?feedbackId=" + id);
                    return;
                }

                req.setAttribute("feedback", feedback);
                req.getRequestDispatcher("/customer/edit_feedback.jsp").forward(req, resp);
                return;
            } catch (NumberFormatException nfe) {
                req.getSession().setAttribute("errorMessage", "Invalid feedback id format");
                resp.sendRedirect(req.getContextPath() + "/feedback/list");
                return;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fid = req.getParameter("feedbackId");
        String description = req.getParameter("description");
        String ratingStr = req.getParameter("rating");

        if (fid == null || fid.trim().isEmpty()) {
            req.getSession().setAttribute("errorMessage", "Feedback ID is required");
            resp.sendRedirect(req.getContextPath() + "/feedback/list");
            return;
        }

        try (Connection connection = DBcontext.getConnection()) {
            EntityManager em = new EntityManager(connection);
            try {
                Integer id = Integer.parseInt(fid.trim());
                Feedback feedback = em.find(Feedback.class, id);
                if (feedback == null) {
                    req.getSession().setAttribute("errorMessage", "Feedback not found");
                    resp.sendRedirect(req.getContextPath() + "/feedback/list");
                    return;
                }

                Account account = (Account) req.getSession().getAttribute("account");
                String username = account != null ? account.getUsername() : null;
                Integer roleId = account != null && account.getRole() != null ? account.getRole().getRoleID() : null;
                if (username == null || (!username.equals(feedback.getCustomerID()) && !(roleId != null && (roleId == 1 || roleId == 3)))) {
                    req.getSession().setAttribute("errorMessage", "You don't have permission to edit this feedback.");
                    resp.sendRedirect(req.getContextPath() + "/feedback/view?feedbackId=" + id);
                    return;
                }

                Integer rating = null;
                try {
                    if (ratingStr != null && !ratingStr.trim().isEmpty()) rating = Integer.parseInt(ratingStr.trim());
                } catch (NumberFormatException ignored) {}

                if (rating != null && (rating < 1 || rating > 5)) {
                    req.setAttribute("errorMessage", "Rating must be between 1 and 5");
                    req.setAttribute("feedback", feedback);
                    req.getRequestDispatcher("/customer/edit_feedback.jsp").forward(req, resp);
                    return;
                }

                feedback.setDescription(description != null ? description.trim() : null);
                if (rating != null) feedback.setRating(rating);

                em.merge(feedback, Feedback.class);

                req.getSession().setAttribute("successMessage", "Feedback updated successfully!");
                resp.sendRedirect(req.getContextPath() + "/customer/feedback/view?requestId=" + feedback.getRequestID().getForeignKeyValue());
                return;
            } catch (NumberFormatException nfe) {
                req.getSession().setAttribute("errorMessage", "Invalid feedback id format");
                resp.sendRedirect(req.getContextPath() + "/feedback/list");
                return;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
}
