package crm.feedback.repository;

import crm.common.model.Feedback;
import crm.common.model.enums.FeedbackStatus;
import crm.core.repository.hibernate.entitymanager.EntityManager;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {
    private EntityManager entityManager;

    public void setEntityManager(EntityManager entityManager) {
        this.entityManager = entityManager;
    }

    public List<Feedback> findAllFeedbacks() throws SQLException {
        try {
            return entityManager.findAll(Feedback.class);
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to retrieve all feedbacks", e);
        }
    }

    public List<Feedback> findActiveFeedbacks() throws SQLException {
        try {
            List<Feedback> allFeedbacks = entityManager.findAll(Feedback.class);
            List<Feedback> activeFeedbacks = new ArrayList<>();

            for (Feedback feedback : allFeedbacks) {
                if (feedback.getFeedbackStatus() != null && feedback.getFeedbackStatus() == FeedbackStatus.Deleted) {
                    continue;
                }
                activeFeedbacks.add(feedback);
            }

            System.out.println("[DAO] findActiveFeedbacks: Found " + activeFeedbacks.size() + " active feedbacks");
            return activeFeedbacks;
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to retrieve active feedbacks", e);
        }
    }

    public Feedback findFeedbackById(Integer feedbackId) throws SQLException {
        try {
            System.out.println("[DAO] findFeedbackById: FeedbackID=" + feedbackId);
            return entityManager.find(Feedback.class, feedbackId);
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to retrieve feedback by ID", e);
        }
    }

    public Feedback findFeedbackByRequestId(Integer requestId) throws SQLException {
        try {
            List<Feedback> allFeedbacks = entityManager.findAll(Feedback.class);

            for (Feedback fb : allFeedbacks) {
                if (fb.getFeedbackStatus() != null && fb.getFeedbackStatus() == FeedbackStatus.Deleted) {
                    continue;
                }
                if (fb.getRequestID() != null && fb.getRequestID().getForeignKeyValue() != null
                        && fb.getRequestID().getForeignKeyValue().equals(requestId)) {
                    System.out.println("[DAO] findFeedbackByRequestId: Found feedback for RequestID=" + requestId);
                    return fb;
                }
            }

            System.out.println("[DAO] findFeedbackByRequestId: No feedback found for RequestID=" + requestId);
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to retrieve feedback by request ID", e);
        }
    }

    public void saveFeedback(Feedback feedback) throws SQLException {
        try {
            entityManager.persist(feedback, Feedback.class);
            System.out.println("[DAO] saveFeedback: Saved feedback ID=" + feedback.getFeedbackID());
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to save feedback", e);
        }
    }

    public void updateFeedback(Feedback feedback) throws SQLException {
        try {
            entityManager.merge(feedback, Feedback.class);
            System.out.println("[DAO] updateFeedback: Updated feedback ID=" + feedback.getFeedbackID());
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to update feedback", e);
        }
    }

    public void deleteFeedback(Integer feedbackId) throws SQLException {
        try {
            Feedback feedback = entityManager.find(Feedback.class, feedbackId);
            if (feedback != null) {
                entityManager.remove(feedback, Feedback.class);
                System.out.println("[DAO] deleteFeedback: Deleted feedback ID=" + feedbackId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to delete feedback", e);
        }
    }
}
