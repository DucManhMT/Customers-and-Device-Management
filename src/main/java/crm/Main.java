package crm;

import java.util.List;

import crm.common.model.Account;
import crm.common.model.Warehouse;
import crm.common.model.WarehouseRequest;
import crm.common.repository.Warehouse.WarehouseDAO;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;

public class Main {
    public static void main(String[] args) {
        EntityManager em = new EntityManager(DBcontext.getConnection());

        WarehouseRequest firstRequest = em.findAll(WarehouseRequest.class).get(1);

        System.out.println("First Warehouse source destination: " + firstRequest.getSourceWarehouse());
    }
}
