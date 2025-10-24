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

        // Get all products and all warehouses
        List<Product> allProducts = em.findAll(Product.class);
        List<Warehouse> allWarehouses = em.findAll(Warehouse.class);

        // Load specifications for all products
        Map<String, Object> specConditions = new HashMap<>();
        for (Product product : allProducts) {
            specConditions.clear();
            specConditions.put("product", product.getProductID());
            List<ProductSpecification> specs = em.findWithConditions(ProductSpecification.class, specConditions);
            product.setProductSpecifications(specs);
        }

        // Get all in-stock items to calculate counts
        Map<String, Object> stockConditions = new HashMap<>();
        stockConditions.put("productStatus", ProductStatus.In_Stock.name());
        List<ProductWarehouse> inStockItems = em.findWithConditions(ProductWarehouse.class, stockConditions);

        // Create a map to track counts for each warehouse-product combination
        Map<Integer, Map<Integer, Long>> warehouseProductCountMap = new HashMap<>();

        // Populate the count map with in-stock items
        for (ProductWarehouse pw : inStockItems) {
            int warehouseId = pw.getWarehouse().getWarehouseID();
            int productId = pw.getInventoryItem().getProduct().getProductID();

            warehouseProductCountMap
                    .computeIfAbsent(warehouseId, k -> new HashMap<>())
                    .merge(productId, 1L, Long::sum);
        }

        // Create inventory summary for all warehouse-product combinations
        for (Warehouse warehouse : allWarehouses) {
            for (Product product : allProducts) {
                Map<String, Object> item = new HashMap<>();
                item.put("warehouse", warehouse);
                item.put("product", product);

                // Get count from map or default to 0 if not found (out of stock)
                Long count = warehouseProductCountMap
                        .getOrDefault(warehouse.getWarehouseID(), Collections.emptyMap())
                        .getOrDefault(product.getProductID(), 0L);

                item.put("count", count);
                inventorySummary.add(item);
            }
        }

        return inventorySummary;
    }


    public Warehouse getWarehouseByUsername(String username) {
        EntityManager em = new EntityManager(DBcontext.getConnection());

        List<Warehouse> warehouse = em.findAll(Warehouse.class);
        for (Warehouse wh : warehouse) {
            if (wh.getManagerAccount().getUsername().equals(username)) {
                return wh;
            }
        }
        return null;
    }


}
