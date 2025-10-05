package test;

import crm.common.model.InventoryItem;
import crm.common.model.Product;
import crm.common.model.ProductWarehouse;
import crm.common.model.Warehouse;
import crm.common.model.enums.ProductStatus;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class TestFunction {
    public static void main(String[] args) {
        EntityManager em = new EntityManager(DBcontext.getConnection());

        Map<String, Object> conditions = new HashMap<>();
        conditions.put("warehouse", 1);
        conditions.put("productStatus", ProductStatus.In_Stock.name());

        List<ProductWarehouse> pw = em.findWithConditions(ProductWarehouse.class, conditions);

        HashSet<Product> warehouse = pw.stream()
                .filter(pw1 -> pw1.getWarehouse().getWarehouseID() == 1)
                .map(pw1 -> pw1.getInventoryItem().getProduct())
                .collect(Collectors.toCollection(HashSet::new));

        for (Product p : warehouse) {
            System.out.println(p.getProductID() + p.getProductName());
        }



        Map<Integer, Long> productCounts = pw.stream()
                .filter(pw1 -> pw1.getWarehouse().getWarehouseID() == 1)
                .collect(Collectors.groupingBy(
                        pw1 -> pw1.getInventoryItem().getProduct().getProductID(),
                        Collectors.counting()
                ));

//        for(Map.Entry<Integer, Long> entry : productCounts.entrySet()) {
//            for(ProductWarehouse pw1 : pw) {
//                if(pw1.getInventoryItem().getProduct().getProductID() == entry.getKey()) {
//                    System.out.println("Product Name: " + pw1.getInventoryItem().getProduct().getProductName() + ", Count: " + entry.getValue());
//                    break;
//                }
//            }
//        }

    }
}
