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

        List<WarehouseRequest> warehouseRequests = em.findAll(WarehouseRequest.class);

        Warehouse userWarehouse = em.find(Warehouse.class, 2);

        warehouseRequests = warehouseRequests.stream()
                .filter(wr -> wr.getSourceWarehouse() != null)
                .filter(wr -> wr.getSourceWarehouse().getWarehouseID() == userWarehouse.getWarehouseID())
                .toList();

        for (WarehouseRequest wr : warehouseRequests) {
            System.out.println("Warehouse Request ID: " + wr.getWarehouseRequestID());
            System.out.println("Source Warehouse ID: " + wr.getSourceWarehouse().getWarehouseID());
            System.out.println("Destination Warehouse ID: " + wr.getDestinationWarehouse().getWarehouseID());
        }


    }
}
