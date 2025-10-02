package crm.common.repository;

import crm.common.model.ProductContract;
import crm.core.repository.persistence.repository.AbstractRepository;

public class ProductContractRepository extends AbstractRepository<ProductContract, Long> {
    public ProductContractRepository() {
        super(ProductContract.class);
    }
}
