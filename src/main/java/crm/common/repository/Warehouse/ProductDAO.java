package crm.common.repository.Warehouse;

import crm.common.model.Product;
import crm.common.repository.FuntionalityDAO;

public class ProductDAO extends FuntionalityDAO<Product> {

    public ProductDAO() {
        super(Product.class);
    }

}
