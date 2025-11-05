package crm.feedback.controller;

import crm.common.model.Feedback;
import crm.common.model.enums.FeedbackStatus;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.common.model.Account;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;

@WebServlet(urlPatterns = {"/feedback/respond"})
public class RespondFeedbackServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String requestIdStr = req.getParameter("requestId");
        String feedbackIdStr = req.getParameter("feedbackId");
        if ((feedbackIdStr == null || feedbackIdStr.trim().isEmpty())
                && (requestIdStr == null || requestIdStr.trim().isEmpty())) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "feedbackId or requestId is required");
            return;
        }

        Account account = (Account) req.getSession().getAttribute("account");
        Integer roleId = account != null && account.getRole() != null ? account.getRole().getRoleID() : null;
        if (roleId == null || (roleId != 3 && roleId != 1)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "You don't have permission to respond to feedback");
            return;
        }

        try (Connection connection = DBcontext.getConnection()) {
            EntityManager em = new EntityManager(connection);
            try {
                Feedback feedback = null;
                if (requestIdStr != null && !requestIdStr.trim().isEmpty()) {
                    int reqId = Integer.parseInt(requestIdStr.trim());
                    for (Feedback fb : em.findAll(Feedback.class)) {
                        Object fk = null;
                        if (fb.getRequestID() != null) fk = fb.getRequestID().getForeignKeyValue();
                        Integer fkInt = null;
                        if (fk instanceof Integer) fkInt = (Integer) fk;
                        else if (fk instanceof Number) fkInt = ((Number) fk).intValue();
                        if (fkInt != null && fkInt.equals(reqId)) {
                            feedback = fb;
                            break;
                        }
                    }
                    if (feedback == null) {
                        resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Feedback not found for requestId " + requestIdStr);
                        return;
                    }
                } else {
                    Integer fid = Integer.parseInt(feedbackIdStr.trim());
                    feedback = em.find(Feedback.class, fid);
                    if (feedback == null) {
                        resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Feedback not found");
                        return;
                    }
                }
                req.setAttribute("feedback", feedback);
                req.getRequestDispatcher("/customer_supporter/respond_feedback.jsp").forward(req, resp);
            } catch (NumberFormatException nfe) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid id format");
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String requestIdStr = req.getParameter("requestId");
        String feedbackIdStr = req.getParameter("feedbackId");
        String responseText = req.getParameter("response");

        // clear any leftover session messages so we only show fresh messages
        try {
            req.getSession().removeAttribute("successMessage");
            req.getSession().removeAttribute("errorMessage");
        } catch (Exception ignored) {}

        if ((feedbackIdStr == null || feedbackIdStr.trim().isEmpty())
                && (requestIdStr == null || requestIdStr.trim().isEmpty())) {
            req.setAttribute("errorMessage", "feedbackId or requestId is required");
            // nothing to show, redirect to list
            resp.sendRedirect(req.getContextPath() + "/feedback/list");
            return;
        }

        Account account = (Account) req.getSession().getAttribute("account");
        Integer roleId = account != null && account.getRole() != null ? account.getRole().getRoleID() : null;
        if (roleId == null || (roleId != 3 && roleId != 1)) {
            req.getSession().setAttribute("errorMessage", "You don't have permission to perform this action.");
            resp.sendRedirect(req.getContextPath() + "/feedback/list");
            return;
        }

        try (Connection connection = DBcontext.getConnection()) {
            EntityManager em = new EntityManager(connection);
            try {
                Feedback feedback = null;
                if (requestIdStr != null && !requestIdStr.trim().isEmpty()) {
                    int reqId = Integer.parseInt(requestIdStr.trim());
                    for (Feedback fb : em.findAll(Feedback.class)) {
                        Object fk = null;
                        if (fb.getRequestID() != null) fk = fb.getRequestID().getForeignKeyValue();
                        Integer fkInt = null;
                        if (fk instanceof Integer) fkInt = (Integer) fk;
                        else if (fk instanceof Number) fkInt = ((Number) fk).intValue();
                        if (fkInt != null && fkInt.equals(reqId)) {
                            feedback = fb;
                            break;
                        }
                    }
                    if (feedback == null) {
                        req.getSession().setAttribute("errorMessage", "Feedback not found for requestId " + requestIdStr);
                        resp.sendRedirect(req.getContextPath() + "/feedback/list");
                        return;
                    }
                } else {
                    Integer fid = Integer.parseInt(feedbackIdStr.trim());
                    feedback = em.find(Feedback.class, fid);
                    if (feedback == null) {
                        req.getSession().setAttribute("errorMessage", "Feedback not found");
                        resp.sendRedirect(req.getContextPath() + "/feedback/list");
                        return;
                    }
                }

                String normalized = (responseText != null) ? responseText.trim() : null;
                if (normalized != null && normalized.length() > 255) {
                    normalized = normalized.substring(0, 255);
                }
                // decide view path early
                String viewPath;
                if (roleId != null && roleId == 3) {
                    viewPath = "/customer_supporter/view_feedback_detail.jsp";
                } else {
                    viewPath = "/customer/view_feedback.jsp";
                }

                // duplicate detection: if the submitted response equals the existing one, report and don't update
                String existing = feedback.getResponse();
                String existingNorm = (existing != null) ? existing.trim() : null;
                boolean bothEmpty = (normalized == null || normalized.isEmpty()) && (existingNorm == null || existingNorm.isEmpty());
                boolean same = (normalized != null && normalized.equals(existingNorm));
                if (bothEmpty || same) {
                    // nothing changed
                    req.setAttribute("feedback", feedback);
                    req.setAttribute("errorMessage", "Response is duplicate; no changes were made.");
                    req.setAttribute("currentUsername", account != null ? account.getUsername() : null);
                    req.setAttribute("currentRoleId", roleId);
                    if (requestIdStr != null && !requestIdStr.trim().isEmpty()) {
                        req.setAttribute("requestId", requestIdStr.trim());
                    } else {
                        req.setAttribute("feedbackId", feedback.getFeedbackID());
                    }
                    req.getRequestDispatcher(viewPath).forward(req, resp);
                    return;
                }

                // apply changes and persist
                if (normalized == null || normalized.isEmpty()) {
                    feedback.setResponse(null);
                    feedback.setResponseDate(null);
                    feedback.setFeedbackStatus(FeedbackStatus.Pending);
                } else {
                    feedback.setResponse(normalized);
                    feedback.setResponseDate(LocalDateTime.now());
                    feedback.setFeedbackStatus(FeedbackStatus.Responded);
                }

                em.merge(feedback, Feedback.class);

                // Prepare request attributes and forward to the appropriate detail view so messages
                // appear via request attributes (no redirect)
                req.setAttribute("feedback", feedback);
                req.setAttribute("successMessage", "Response saved successfully.");
                req.setAttribute("currentUsername", account != null ? account.getUsername() : null);
                req.setAttribute("currentRoleId", roleId);
                if (requestIdStr != null && !requestIdStr.trim().isEmpty()) {
                    req.setAttribute("requestId", requestIdStr.trim());
                } else {
                    req.setAttribute("feedbackId", feedback.getFeedbackID());
                }

                req.getRequestDispatcher(viewPath).forward(req, resp);
                return;
            } catch (NumberFormatException nfe) {
                req.getSession().setAttribute("errorMessage", "Invalid feedbackId format");
                resp.sendRedirect(req.getContextPath() + "/feedback/list");
                return;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
}
