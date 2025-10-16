package test;

import crm.auth.service.Hasher;
import crm.common.model.*;
import crm.common.repository.Warehouse.ProductDAO;
import crm.common.repository.Warehouse.ProductRequestDAO;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;

import java.util.List;


public class TestFunction {
    public static void main(String[] args) {

        ProductRequestDAO productRequestDAO = new ProductRequestDAO();
        List<ProductRequest> list = productRequestDAO.findAll();
        for (ProductRequest pr : list) {
            System.out.println(pr);
        }

    }
}
