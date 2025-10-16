package crm.common.repository.Warehouse;

import crm.common.model.ProductRequest;
import crm.common.repository.FuntionalityDAO;

public class ProductRequestDAO extends FuntionalityDAO<ProductRequest> {
    public ProductRequestDAO() {
        super(ProductRequest.class);
    }
}
