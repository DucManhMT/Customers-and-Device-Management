package crm.common.repository;

import crm.common.model.RequestLog;
import crm.core.repository.persistence.repository.AbstractRepository;

public class RequestLogRepository extends AbstractRepository<RequestLog, Integer> {
    public RequestLogRepository() {
        super(RequestLog.class);
    }
}
