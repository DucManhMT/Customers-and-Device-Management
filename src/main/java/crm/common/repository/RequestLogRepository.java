package crm.common.repository;

import crm.common.model.RequestLog;
import crm.core.repository.persistence.repository.AbstractRepository;

public class RequestLogRepository extends AbstractRepository<RequestLog, Long> {
    public RequestLogRepository() {
        super(RequestLog.class);
    }
}
