// package crm.feedback.service;

// import java.sql.SQLException;
// import java.time.LocalDateTime;
// import java.util.List;

// import crm.common.model.Feedback;
// import crm.common.repository.feedback.FeedbackDAO;
// import crm.core.config.TransactionManager;
// import crm.core.service.IDGeneratorService;
// import crm.service_request.repository.persistence.query.common.Order;
// import crm.service_request.repository.persistence.query.common.Page;
// import crm.service_request.repository.persistence.query.common.PageRequest;
// import crm.service_request.repository.persistence.query.common.Sort;

// public class FeedbackService {

//     public Feedback createFeedback(String content, int rating, String username, String response) throws SQLException {
//         LocalDateTime currentTimestamp = LocalDateTime.now();

//         Feedback feedback = new Feedback();
//         feedback.setFeedbackID(IDGeneratorService.generateID(Feedback.class));
//         feedback.setContent(content);
//         feedback.setRating(rating);
//         feedback.setResponse(response != null ? response.trim() : null);
//         feedback.setFeedbackDate(currentTimestamp);
//         feedback.setCustomerID(username);

//         FeedbackDAO feedbackDAO = new FeedbackDAO();
//         try {
//             TransactionManager.beginTransaction();
//             feedbackDAO.save(feedback);
//             TransactionManager.commit();
//         } catch (Exception e) {
//             e.printStackTrace();
//             TransactionManager.rollback();
//             throw new SQLException("Failed to create feedback", e);
//         }

//         return feedback;
//     }

//     public Page<Feedback> getFeedbacks(int page, int recordsPerPage, String username, Integer rating)
//             throws SQLException {
//         FeedbackDAO feedbackRepository = new FeedbackDAO();
//         Sort sort = Sort.by(Order.desc("FeedbackDate"));
//         PageRequest pageRequest = new PageRequest(page, recordsPerPage, sort);

//         try {
//             Page<Feedback> allFeedbacks = feedbackRepository.findAll(pageRequest);

//             return allFeedbacks;
//         } catch (Exception e) {
//             e.printStackTrace();
//             throw new SQLException("Failed to retrieve feedbacks", e);
//         }
//     }

//     public Feedback getFeedbackById(Integer feedbackId) throws SQLException {
//         FeedbackDAO feedbackRepository = new FeedbackDAO();
//         try {
//             return feedbackRepository.findById(feedbackId);
//         } catch (Exception e) {
//             e.printStackTrace();
//             throw new SQLException("Failed to retrieve feedback", e);
//         }
//     }

//     public void updateFeedback(Feedback feedback) throws SQLException {
//         FeedbackDAO feedbackRepository = new FeedbackDAO();
//         try {
//             TransactionManager.beginTransaction();
//             feedbackRepository.update(feedback);
//             TransactionManager.commit();
//         } catch (Exception e) {
//             e.printStackTrace();
//             TransactionManager.rollback();
//             throw new SQLException("Failed to update feedback", e);
//         }
//     }

//     public void deleteFeedback(Integer feedbackId) throws SQLException {
//         FeedbackDAO feedbackRepository = new FeedbackDAO();
//         try {
//             TransactionManager.beginTransaction();
//             feedbackRepository.deleteById(feedbackId);
//             TransactionManager.commit();
//         } catch (Exception e) {
//             e.printStackTrace();
//             TransactionManager.rollback();
//             throw new SQLException("Failed to delete feedback", e);
//         }
//     }

//     public List<Feedback> getRecentFeedbacks(String username, int limit) throws SQLException {
//         FeedbackDAO feedbackRepository = new FeedbackDAO();
//         Sort sort = Sort.by(Order.desc("FeedbackDate"));
//         PageRequest pageRequest = new PageRequest(1, limit, sort);

//         try {
//             Page<Feedback> page = feedbackRepository.findAll(pageRequest);

//             if (page == null || page.getContent() == null) {
//                 return new java.util.ArrayList<>();
//             }

//             return (List<Feedback>) page.getContent();
//         } catch (Exception e) {
//             e.printStackTrace();
//             return new java.util.ArrayList<>();
//         }
//     }

//     public List<Feedback> getFeedbackByUsername(String username, int page, int limit) throws SQLException {
//         FeedbackDAO feedbackRepository = new FeedbackDAO();
//         Sort sort = Sort.by(Order.desc("FeedbackDate"));
//         PageRequest pageRequest = new PageRequest(page, limit, sort);

//         try {
//             Page<Feedback> allFeedbacks = feedbackRepository.findAll(pageRequest);

//             if (allFeedbacks == null || allFeedbacks.getContent() == null) {
//                 return new java.util.ArrayList<>();
//             }

//             List<Feedback> userFeedbacks = new java.util.ArrayList<>();
//             for (Feedback feedback : allFeedbacks.getContent()) {
//                 userFeedbacks.add(feedback);
//             }

//             return userFeedbacks;
//         } catch (Exception e) {
//             e.printStackTrace();
//             return new java.util.ArrayList<>();
//         }
//     }

//     public Page<Feedback> getFeedbackByUsernamePaginated(String username, int page, int recordsPerPage)
//             throws SQLException {
//         FeedbackDAO feedbackRepository = new FeedbackDAO();
//         Sort sort = Sort.by(Order.desc("FeedbackDate"));
//         PageRequest pageRequest = new PageRequest(page, recordsPerPage, sort);

//         try {
//             Page<Feedback> allFeedbacks = feedbackRepository.findAll(pageRequest);
//             return allFeedbacks;
//         } catch (Exception e) {
//             e.printStackTrace();
//             throw new SQLException("Failed to retrieve paginated feedbacks", e);
//         }
//     }

// }