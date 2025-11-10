package crm;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import crm.common.model.*;
import crm.common.model.enums.ProductStatus;
import crm.common.model.enums.TransactionStatus;
import crm.common.repository.Warehouse.WarehouseDAO;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.service.IDGeneratorService;
import crm.service_request.repository.ContractRepository;
import crm.service_request.repository.RequestRepository;
import crm.service_request.repository.persistence.query.common.ClauseBuilder;
import crm.service_request.repository.persistence.query.common.PageRequest;
import crm.service_request.service.RequestService;

public class Main {
    public static void main(String[] args) {
        EntityManager em = new EntityManager(DBcontext.getConnection());

        Warehouse warehouse = em.find(Warehouse.class, 1);
        InventoryItem inventoryItem = em.find(InventoryItem.class, 1);

        ProductWarehouse productWarehouse = new ProductWarehouse();

        productWarehouse.setProductWarehouseID(401);
        System.out.println("Generated ProductWarehouse ID: " + productWarehouse.getProductWarehouseID());
        productWarehouse.setProductStatus(ProductStatus.In_Stock);
        productWarehouse.setWarehouse(warehouse);
        productWarehouse.setInventoryItem(inventoryItem);

        boolean isCreated = em.persist(productWarehouse, ProductWarehouse.class);
    }
}
