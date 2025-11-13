package crm.feedback.controller;

import java.io.IOException;
import java.sql.Connection;

import crm.common.URLConstants;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.feedback.service.FeedbackService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ViewFeedbackDetail", urlPatterns = {URLConstants.CUSTOMER_VIEW_FEEDBACK })
public class ViewFeedbackDetail extends HttpServlet {

    private FeedbackService fedsv = new FeedbackService();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try (Connection connection = DBcontext.getConnection()) {
            EntityManager entityManager = new EntityManager(connection);
            fedsv.setEntityManager(entityManager);

            fedsv.showFeedbackDetails(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            req.getRequestDispatcher("/customer/create_feedback.jsp").forward(req, resp);
        }
    }
}