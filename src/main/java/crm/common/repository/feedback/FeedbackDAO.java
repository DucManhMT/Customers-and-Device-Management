package crm.common.repository.feedback;

import crm.common.model.Feedback;
import crm.core.repository.persistence.repository.SimpleRepository;

public class FeedbackDAO extends SimpleRepository<Feedback, Integer> {
    
    public FeedbackDAO() {
        super(Feedback.class);
    }
}