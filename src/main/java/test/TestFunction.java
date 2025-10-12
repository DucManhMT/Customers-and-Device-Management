package test;

import crm.common.model.*;
import crm.common.repository.Warehouse.ProductWarehouseDAO;
import crm.common.repository.Warehouse.WarehouseDAO;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;


public class TestFunction {
    public static void main(String[] args) {

        ProductWarehouseDAO productWarehouseDAO = new ProductWarehouseDAO();

        List<ProductWarehouse> productWarehouseList = productWarehouseDAO.getAvailableProductsByWarehouse(2);

        for (ProductWarehouse pw : productWarehouseList) {
            System.out.println("Product ID: " + pw.getInventoryItem().getProduct().getProductID());
            System.out.println("Product Name: " + pw.getInventoryItem().getProduct().getProductName());
            System.out.println("Status: " + pw.getProductStatus());
            System.out.println("---------------------------");
        }


    }
}
