package crm.common.repository;

import crm.common.model.ProductExported;
import crm.core.repository.persistence.repository.AbstractRepository;

public class ProductExportedRepository extends AbstractRepository<ProductExported, Integer> {
    public ProductExportedRepository() {
        super(ProductExported.class);
    }
}
