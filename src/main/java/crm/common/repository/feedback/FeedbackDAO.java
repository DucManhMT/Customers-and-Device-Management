package crm.common.repository.feedback;

import crm.common.model.Feedback;

public class FeedbackDAO extends SimpleRepository<Feedback, Integer> {
    
    public FeedbackDAO() {
        super(Feedback.class);
    }
}