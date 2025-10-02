package crm.common.repository;

import crm.common.model.ProductRequest;
import crm.core.repository.persistence.repository.AbstractRepository;

public class ProductRequestRepository extends AbstractRepository<ProductRequest, Integer> {
    public ProductRequestRepository() {
        super(ProductRequest.class);
    }
}
