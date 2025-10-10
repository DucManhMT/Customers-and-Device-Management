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

    public List<Product> getProductsInWarehouse(int warehouseId) {
        EntityManager em = new EntityManager(DBcontext.getConnection());

        List<Product> products;

        Map<String, Object> conditions = new HashMap<>();
        conditions.put("warehouse", warehouseId);
        conditions.put("productStatus", ProductStatus.In_Stock.name());

        List<ProductWarehouse> pw = em.findWithConditions(ProductWarehouse.class, conditions);

        HashSet<Product> uniqueProducts = pw.stream()
                .filter(pw1 -> pw1.getWarehouse().getWarehouseID() == warehouseId)
                .map(pw1 -> pw1.getInventoryItem().getProduct())
                .collect(Collectors.toCollection(HashSet::new));

        Map<String, Object> productConditions = new HashMap<>();

        for (Product p : uniqueProducts) {
            productConditions.put("product", p.getProductID());
            List<ProductSpecification> specs = em.findWithConditions(ProductSpecification.class, productConditions);
            p.setProductSpecifications(specs);
        }

        products = uniqueProducts.stream().toList();

        return products;
    }

    public List<Map<String, Object>> getInventorySummary() {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        List<Map<String, Object>> inventorySummary = new ArrayList<>();

        // Get all in-stock product warehouse items
        Map<String, Object> conditions = new HashMap<>();
        conditions.put("productStatus", ProductStatus.In_Stock.name());
        List<ProductWarehouse> productWarehouses = em.findWithConditions(ProductWarehouse.class, conditions);

        // Group by warehouse ID and product ID
        Map<Integer, Map<Integer, Long>> warehouseProductCountMap = new HashMap<>();
        Map<Integer, Warehouse> warehouseMap = new HashMap<>();
        Map<Integer, Product> productMap = new HashMap<>();

        for (ProductWarehouse pw : productWarehouses) {
            Warehouse warehouse = pw.getWarehouse();
            Product product = pw.getInventoryItem().getProduct();

            int warehouseId = warehouse.getWarehouseID();
            int productId = product.getProductID();

            // Store warehouse and product objects for later retrieval
            warehouseMap.put(warehouseId, warehouse);
            productMap.put(productId, product);

            // Count items by warehouseId and productId
            warehouseProductCountMap
                    .computeIfAbsent(warehouseId, k -> new HashMap<>())
                    .merge(productId, 1L, Long::sum);
        }

        // Load specifications for each product
        Map<String, Object> specConditions = new HashMap<>();
        for (Map.Entry<Integer, Product> entry : productMap.entrySet()) {
            Product product = entry.getValue();
            specConditions.clear();
            specConditions.put("product", product.getProductID());
            List<ProductSpecification> specs = em.findWithConditions(ProductSpecification.class, specConditions);
            product.setProductSpecifications(specs);
        }

        // Create result list
        for (Map.Entry<Integer, Map<Integer, Long>> warehouseEntry : warehouseProductCountMap.entrySet()) {
            int warehouseId = warehouseEntry.getKey();
            Warehouse warehouse = warehouseMap.get(warehouseId);
            Map<Integer, Long> productCountMap = warehouseEntry.getValue();

            for (Map.Entry<Integer, Long> productEntry : productCountMap.entrySet()) {
                int productId = productEntry.getKey();
                Product product = productMap.get(productId);
                Long count = productEntry.getValue();

                Map<String, Object> item = new HashMap<>();
                item.put("warehouse", warehouse);
                item.put("product", product);
                item.put("count", count);
                inventorySummary.add(item);
            }
        }

        return inventorySummary;
    }


}
