package crm.common.repository.Warehouse;

import crm.common.model.ProductTransaction;
import crm.common.repository.FuntionalityDAO;

public class ProductTransactionDAO extends FuntionalityDAO<ProductTransaction> {

    public ProductTransactionDAO() {
        super(ProductTransaction.class);
    }
}
