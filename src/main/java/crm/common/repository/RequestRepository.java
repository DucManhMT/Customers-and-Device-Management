package crm.common.repository;

import crm.common.model.Request;
import crm.core.repository.persistence.repository.AbstractRepository;

public class RequestRepository extends AbstractRepository<Request, Long> {
    public RequestRepository() {
        super(Request.class);
    }
}
