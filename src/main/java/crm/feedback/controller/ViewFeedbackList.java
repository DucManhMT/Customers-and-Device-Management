
package crm.feedback.controller;

import java.io.IOException;

import crm.common.URLConstants;
import crm.feedback.service.FeedbackService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ViewFeedbackList", urlPatterns = {
        URLConstants.CUSTOMER_VIEW_FEEDBACK_LIST })
public class ViewFeedbackList extends HttpServlet {

    private FeedbackService fedsv = new FeedbackService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            fedsv.showFeedbackList(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            req.getRequestDispatcher("/customer/create_feedback.jsp").forward(req, resp);
        }
    }
}