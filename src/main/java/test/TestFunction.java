package test;

import crm.auth.service.Hasher;
import crm.common.model.*;
import crm.common.repository.Warehouse.ProductDAO;
import crm.common.repository.Warehouse.ProductRequestDAO;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class TestFunction {
    public static void main(String[] args) {

        EntityManager em = new EntityManager(DBcontext.getConnection());

        Type type = em.find(Type.class, 1);

        for (SpecificationType specType : type.getSpecificationTypes()) {
            System.out.println("Specification Type: " + specType.getSpecificationTypeName());
            for (Specification spec : specType.getSpecifications()) {
                System.out.println(" - Specification: " + spec.getSpecificationName() + " = " + spec.getSpecificationValue());
            }
        }

    }
}
