package crm.common.repository.Warehouse;

import crm.common.model.ProductWarehouse;
import crm.common.model.enums.ProductStatus;
import crm.common.repository.FuntionalityDAO;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import java.util.List;

public class ProductWarehouseDAO extends FuntionalityDAO<ProductWarehouse> {

    EntityManager em;

    public ProductWarehouseDAO() {
        super(ProductWarehouse.class);
    }

    public List<ProductWarehouse> getAvailableProductsByWarehouse(int warehouseID) {

        em = new EntityManager(DBcontext.getConnection());

        List<ProductWarehouse> productWarehouseList = em.findAll(ProductWarehouse.class);

        productWarehouseList = productWarehouseList.stream()
                .filter(pw -> pw.getWarehouse().getWarehouseID().equals(warehouseID)
                        && pw.getProductStatus() == ProductStatus.In_Stock)
                .toList();

        return productWarehouseList;
    }
}
