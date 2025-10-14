package test;

import crm.common.model.*;
import crm.common.model.enums.WarehouseRequestStatus;
import crm.common.repository.Warehouse.ProductDAO;
import crm.common.repository.Warehouse.ProductWarehouseDAO;
import crm.common.repository.Warehouse.WarehouseDAO;
import crm.common.repository.Warehouse.WarehouseRequestDAO;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;


public class TestFunction {
    public static void main(String[] args) {

        ProductDAO productDAO = new ProductDAO();
        Product product = productDAO.findIncludeSpec(1);

        System.out.println(product.getProductName());
        for (ProductSpecification ps : product.getProductSpecifications()) {
            System.out.println(ps.getSpecification().getSpecificationName() + ": " + ps.getSpecification().getSpecificationValue());
        }


    }
}
