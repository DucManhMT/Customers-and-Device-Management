package test;

import crm.common.model.*;
import crm.common.repository.Warehouse.ProductWarehouseDAO;
import crm.common.repository.Warehouse.WarehouseDAO;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;


public class TestFunction {
    public static void main(String[] args) {

        WarehouseDAO warehouseDAO = new WarehouseDAO();

        List<Map<String, Object>> inventorySummary = warehouseDAO.getInventorySummary();
        for (Map<String, Object> entry : inventorySummary) {
            Warehouse warehouse = (Warehouse) entry.get("warehouse");
            Product product = (Product) entry.get("product");
            Long count = (Long) entry.get("count");

            System.out.println("Warehouse: " + warehouse.getWarehouseName() +
                    ", Product: " + product.getProductName() +
                    ", Count: " + count);
            for(ProductSpecification spec : product.getProductSpecifications()) {
                System.out.println("   Spec: " + spec.getSpecification().getSpecificationName() + " = " + spec.getSpecification().getSpecificationValue());
            }
        }

    }
}
