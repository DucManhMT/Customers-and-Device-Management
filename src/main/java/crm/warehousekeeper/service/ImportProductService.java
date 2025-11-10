package crm.warehousekeeper.service;

import crm.common.model.InventoryItem;
import crm.common.model.ProductImportedLog;
import crm.common.model.Warehouse;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.service.IDGeneratorService;

import java.time.LocalDateTime;

public class ImportProductService {
    public static boolean importProducts(InventoryItem item, Warehouse warehouse){

        EntityManager em = new EntityManager(DBcontext.getConnection());

        try{
            em.beginTransaction();

            ProductImportedLog productImportedLog = new ProductImportedLog();
            productImportedLog.setProductImportedLogID(IDGeneratorService.generateID(ProductImportedLog.class));
            productImportedLog.setInventoryItem(item);
            productImportedLog.setWarehouse(warehouse);
            productImportedLog.setImportedDate(LocalDateTime.now());

            em.persist(item, InventoryItem.class);
            em.persist(productImportedLog, ProductImportedLog.class);

            em.commit();
        } catch (Exception e){
            em.rollback();
            e.printStackTrace();
            return false;
        }
        return true;

    }
}
