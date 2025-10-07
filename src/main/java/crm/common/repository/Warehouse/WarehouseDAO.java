package crm.common.repository.Warehouse;

import crm.common.model.Product;
import crm.common.model.ProductSpecification;
import crm.common.model.ProductWarehouse;
import crm.common.model.Warehouse;
import crm.common.model.enums.ProductStatus;
import crm.common.repository.FuntionalityDAO;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;

import java.util.*;
import java.util.stream.Collectors;

public class WarehouseDAO extends FuntionalityDAO<Warehouse> {

    public WarehouseDAO() {
        super(Warehouse.class);
    }

    public HashSet<Product> getProductsInWarehouse(int warehouseId) {
        EntityManager em = new EntityManager(DBcontext.getConnection());

        Map<String, Object> conditions = new HashMap<>();
        conditions.put("warehouse", warehouseId);
        conditions.put("productStatus", ProductStatus.In_Stock.name());

        List<ProductWarehouse> pw = em.findWithConditions(ProductWarehouse.class, conditions);

        HashSet<Product> products = pw.stream()
                .filter(pw1 -> pw1.getWarehouse().getWarehouseID() == warehouseId)
                .map(pw1 -> pw1.getInventoryItem().getProduct())
                .collect(Collectors.toCollection(HashSet::new));

        Map<String, Object> productConditions = new HashMap<>();

        for (Product p : products) {
            productConditions.put("product", p.getProductID());
            List<ProductSpecification> specs = em.findWithConditions(ProductSpecification.class, productConditions);
            p.setProductSpecifications(specs);
        }

        return products;
    }


}
