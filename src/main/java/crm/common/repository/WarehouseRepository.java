package crm.common.repository;

import crm.common.model.Warehouse;
import crm.core.repository.persistence.repository.AbstractRepository;

public class WarehouseRepository extends AbstractRepository<Warehouse, Integer> {
    public WarehouseRepository() {
        super(Warehouse.class);
    }
}
