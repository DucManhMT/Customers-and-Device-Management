package crm.common.repository;

import crm.common.model.Product;
import crm.core.repository.persistence.repository.AbstractRepository;

public class ProductRepository extends AbstractRepository<Product, Integer> {
    public ProductRepository() {
        super(Product.class);
    }
}
