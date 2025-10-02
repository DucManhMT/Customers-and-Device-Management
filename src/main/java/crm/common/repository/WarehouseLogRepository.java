package crm.common.repository;

import crm.common.model.WarehouseLog;
import crm.core.repository.persistence.repository.AbstractRepository;

public class WarehouseLogRepository extends AbstractRepository<WarehouseLog, Long> {
    public WarehouseLogRepository() {
        super(WarehouseLog.class);
    }
}
