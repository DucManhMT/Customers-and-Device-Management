package crm.feedback.controller;

import crm.common.model.Feedback;
import crm.common.model.Account;
import crm.common.model.enums.FeedbackStatus;
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

@WebServlet(urlPatterns = {"/feedback/delete"})
public class FeedbackDeleteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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
                int rqid = (Integer) feedback.getRequestID().getForeignKeyValue();
                if (feedback == null) {
                    req.getSession().setAttribute("errorMessage", "Feedback not found");
                    resp.sendRedirect(req.getContextPath() + "/feedback/list");
                    return;
                }

                Account account = (Account) req.getSession().getAttribute("account");
                String username = account != null ? account.getUsername() : null;
                Integer roleId = account != null && account.getRole() != null ? account.getRole().getRoleID() : null;
//                if (username == null || (!username.equals(feedback.getCustomerID()) && !(roleId != null && roleId == 1))) {
//                    req.getSession().setAttribute("errorMessage", "You don't have permission to delete this feedback.");
//                    resp.sendRedirect(req.getContextPath() + "/feedback/view?requestId=" + rqid);
//                    return;
//                }

                feedback.setFeedbackStatus(FeedbackStatus.Deleted);
                em.merge(feedback, Feedback.class);

                req.getSession().setAttribute("successMessage", "Feedback deleted (hidden) successfully.");
                resp.sendRedirect(req.getContextPath() + "/customer/customer_actioncenter.jsp");
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
