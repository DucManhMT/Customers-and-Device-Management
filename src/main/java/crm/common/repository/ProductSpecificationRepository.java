package crm.common.repository;

import crm.common.model.ProductSpecification;
import crm.core.repository.persistence.repository.AbstractRepository;

public class ProductSpecificationRepository extends AbstractRepository<ProductSpecification, Integer> {
    public ProductSpecificationRepository() {
        super(ProductSpecification.class);
    }
}
