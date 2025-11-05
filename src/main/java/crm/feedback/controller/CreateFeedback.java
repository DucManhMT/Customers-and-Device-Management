package crm.feedback.controller;

import java.io.IOException;

import crm.common.URLConstants;
import crm.common.model.Account;
import crm.feedback.service.FeedbackService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "CreateFeedback", urlPatterns = { URLConstants.CUSTOMER_CREATE_FEEDBACK })
public class CreateFeedback extends HttpServlet {
    private FeedbackService fedsv = new FeedbackService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        Account account = (Account) req.getSession().getAttribute("account");
        if (account == null) {
            resp.sendRedirect(req.getContextPath() + URLConstants.AUTH_CUSTOMER_LOGIN);
            return;
        }
        String username = account.getUsername();
        if (username == null || username.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + URLConstants.AUTH_CUSTOMER_LOGIN);
            return;
        }

        try {

            fedsv.showCreateFeedbackForm(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            req.getRequestDispatcher("/Customer/create_feedback.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Account account = (Account) req.getSession().getAttribute("account");
        if (account == null) {
            resp.sendRedirect(req.getContextPath() + URLConstants.AUTH_CUSTOMER_LOGIN);
            return;
        }
        String username = account.getUsername();

        try {

            fedsv.createFeedback(req, resp, username);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Error creating feedback: " + e.getMessage());
            fedsv.showCreateFeedbackForm(req, resp);
        }
    }

}
