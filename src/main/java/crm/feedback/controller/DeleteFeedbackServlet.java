//package crm.feedback.controller;
//
//import java.io.IOException;
//import java.sql.SQLException;
//
//import crm.common.model.Feedback;
//import crm.feedback.service.FeedbackService;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//
//@WebServlet("/feedback/delete")
//public class DeleteFeedbackServlet extends HttpServlet {
//
//    private FeedbackService feedbackService;
//
//    @Override
//    public void init() throws ServletException {
//        super.init();
//        feedbackService = new FeedbackService();
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        String feedbackIdStr = req.getParameter("feedbackId");
//
//        if (feedbackIdStr == null || feedbackIdStr.trim().isEmpty()) {
//            resp.sendRedirect("../feedback/list");
//            return;
//        }
//
//        try {
//            int feedbackId = Integer.parseInt(feedbackIdStr);
//            Feedback feedback = feedbackService.getFeedbackById(feedbackId);
//
//            if (feedback == null) {
//                req.setAttribute("error", "Feedback not found");
//                resp.sendRedirect("../feedback/list");
//                return;
//            }
//
//            req.setAttribute("feedback", feedback);
//            req.getRequestDispatcher("/feedback/deleteFeedback.jsp").forward(req, resp);
//
//        } catch (NumberFormatException e) {
//            req.setAttribute("error", "Invalid feedback ID");
//            resp.sendRedirect("../feedback/list");
//        } catch (SQLException e) {
//            req.setAttribute("error", "Database error: " + e.getMessage());
//            resp.sendRedirect("../feedback/list");
//        }
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        String feedbackIdStr = req.getParameter("feedbackId");
//        String confirmDelete = req.getParameter("confirmDelete");
//
//        if (feedbackIdStr == null || feedbackIdStr.trim().isEmpty()) {
//            resp.sendRedirect("../feedback/list");
//            return;
//        }
//
//        if (confirmDelete == null || !"true".equals(confirmDelete)) {
//            resp.sendRedirect("../feedback/view?feedbackId=" + feedbackIdStr);
//            return;
//        }
//
//        try {
//            int feedbackId = Integer.parseInt(feedbackIdStr);
//            feedbackService.deleteFeedback(feedbackId);
//
//            // Redirect back to feedback list with success message
//            resp.sendRedirect("../feedback/list?success=deleted");
//
//        } catch (NumberFormatException e) {
//            req.setAttribute("error", "Invalid feedback ID");
//            resp.sendRedirect("../feedback/list");
//        } catch (SQLException e) {
//            req.setAttribute("error", "Database error: " + e.getMessage());
//            resp.sendRedirect("../feedback/list");
//        }
//    }
//}