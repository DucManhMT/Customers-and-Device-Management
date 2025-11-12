package crm.inventorymanager.service;

import crm.common.model.ProductRequest;
import crm.common.model.Warehouse;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;

import java.sql.SQLException;

public class AssignWarehouseService {

    public static boolean AssignWarehouseToRequest(int productRequestID, int warehouseID) {
        EntityManager em = new EntityManager(DBcontext.getConnection());

        try {
            em.beginTransaction();

            ProductRequest requestToUpdate = em.find(ProductRequest.class, productRequestID);
            Warehouse warehouse = em.find(Warehouse.class, warehouseID);

            if (requestToUpdate != null && warehouse != null) {
                requestToUpdate.setWarehouse(warehouse);
                em.merge(requestToUpdate, ProductRequest.class);
                em.commit();
                return true;
            }

        } catch (SQLException e) {
            em.rollback();
            throw new RuntimeException(e);
        }
        return false;
    }

}
