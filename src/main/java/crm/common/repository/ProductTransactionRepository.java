package crm.common.repository;

import crm.common.model.ProductTransaction;
import crm.core.repository.persistence.repository.AbstractRepository;

public class ProductTransactionRepository extends AbstractRepository<ProductTransaction, Long> {
    public ProductTransactionRepository() {
        super(ProductTransaction.class);
    }
}
