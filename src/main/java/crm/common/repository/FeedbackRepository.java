package crm.common.repository;

import crm.common.model.Feedback;
import crm.core.repository.persistence.repository.AbstractRepository;

public class FeedbackRepository extends AbstractRepository<Feedback, Long> {
    public FeedbackRepository() {
        super(Feedback.class);
    }
}
