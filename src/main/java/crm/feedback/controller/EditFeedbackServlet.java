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
//@WebServlet("/feedback/edit")
//public class EditFeedbackServlet extends HttpServlet {
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
//            req.getRequestDispatcher("/feedback/editFeedback.jsp").forward(req, resp);
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
//        String rating = req.getParameter("rating");
//        String content = req.getParameter("content");
//        String response = req.getParameter("response");
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
//            // Update feedback fields
//            if (rating != null && !rating.trim().isEmpty()) {
//                feedback.setRating(Integer.parseInt(rating));
//            }
//            if (content != null) {
//                feedback.setContent(content.trim());
//            }
//            if (response != null) {
//                feedback.setResponse(response.trim());
//            }
//
//            feedbackService.updateFeedback(feedback);
//
//            // Redirect back to feedback view with success message
//            resp.sendRedirect("../feedback/view?feedbackId=" + feedbackId + "&success=updated");
//
//        } catch (NumberFormatException e) {
//            req.setAttribute("error", "Invalid feedback ID or rating");
//            resp.sendRedirect("../feedback/list");
//        } catch (SQLException e) {
//            req.setAttribute("error", "Database error: " + e.getMessage());
//            resp.sendRedirect("../feedback/list");
//        }
//    }
//}