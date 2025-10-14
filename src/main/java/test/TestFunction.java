package test;

import crm.common.model.*;
import crm.common.model.enums.WarehouseRequestStatus;
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

        WarehouseRequest warehouseRequest = new WarehouseRequest();
        WarehouseRequestDAO warehouseRequestDAO = new WarehouseRequestDAO();

        WarehouseDAO warehouseDAO = new WarehouseDAO();

        Warehouse warehouse = warehouseDAO.find(1);
        Warehouse destinationWarehouse = warehouseDAO.find(2);

        warehouseRequest.setWarehouseRequestID(1);
        warehouseRequest.setSourceWarehouse(warehouse);
        warehouseRequest.setDestinationWarehouse(destinationWarehouse);
        warehouseRequest.setDate(LocalDateTime.now());
        warehouseRequest.setWarehouseRequestStatus(WarehouseRequestStatus.Pending);

        warehouseRequestDAO.persist(warehouseRequest);


    }
}
