package crm.common.repository.feedback;

import crm.common.model.Feedback;
import crm.service_request.repository.persistence.repository.AbstractRepository;

public class FeedbackDAO extends AbstractRepository<Feedback, Integer> {

    public FeedbackDAO() {
        super(Feedback.class);
    }
}