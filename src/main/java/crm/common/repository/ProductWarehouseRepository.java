package crm.common.repository;

import crm.common.model.ProductWarehouse;
import crm.core.repository.persistence.repository.AbstractRepository;

public class ProductWarehouseRepository extends AbstractRepository<ProductWarehouse, Integer> {
    public ProductWarehouseRepository() {
        super(ProductWarehouse.class);
    }
}
