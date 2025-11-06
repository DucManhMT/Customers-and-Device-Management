package crm;

import java.util.List;

import crm.common.model.WarehouseRequest;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;

public class Main {
    public static void main(String[] args) {
        EntityManager em = new EntityManager(DBcontext.getConnection());

        List<WarehouseRequest> warehouseRequests = em.findAll(WarehouseRequest.class);

        for (WarehouseRequest warehouseRequest : warehouseRequests){
            System.out.println("Warehouse Request ID: " + warehouseRequest.getWarehouseRequestID());
            System.out.println("Date: " + warehouseRequest.getDate());
            System.out.println("Status: " + warehouseRequest.getWarehouseRequestStatus());
            System.out.println("Note: " + warehouseRequest.getNote());
            System.out.println("Destination Warehouse ID: " + (warehouseRequest.getDestinationWarehouse() != null ? warehouseRequest.getDestinationWarehouse().getWarehouseID() : "N/A"));
            System.out.println("--------------------------------------------------");
        }

    }
}
