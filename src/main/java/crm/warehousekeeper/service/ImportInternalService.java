package crm.warehousekeeper.service;

import crm.common.model.InventoryItem;
import crm.common.model.ProductTransaction;
import crm.common.model.ProductWarehouse;
import crm.common.model.WarehouseRequest;
import crm.common.model.enums.ProductStatus;
import crm.common.model.enums.TransactionStatus;
import crm.common.model.enums.WarehouseRequestStatus;
import crm.common.repository.Warehouse.ProductWarehouseDAO;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.service.IDGeneratorService;

import java.time.LocalDateTime;

public class ImportInternalService {

    public static boolean importInternalProducts(String[] selectedItems, WarehouseRequest warehouseRequest,
            String note) {

        EntityManager em = new EntityManager(DBcontext.getConnection());
        ProductWarehouseDAO productWarehouseDAO = new ProductWarehouseDAO();
        try {
            em.beginTransaction();

            for (String itemIdStr : selectedItems) {
                try {
                    int itemId = Integer.parseInt(itemIdStr);

                    InventoryItem item = em.find(InventoryItem.class, itemId);

                    if (item != null) {

                        ProductTransaction productTransaction = new ProductTransaction();

                        productTransaction.setTransactionID(IDGeneratorService.generateID(ProductTransaction.class));
                        productTransaction.setTransactionStatus(TransactionStatus.Import);
                        productTransaction.setTransactionDate(LocalDateTime.now());
                        productTransaction.setInventoryItem(item);
                        productTransaction.setNote(note);
                        productTransaction.setSourceWarehouseEntity(warehouseRequest.getSourceWarehouse());
                        productTransaction.setDestinationWarehouseEntity(warehouseRequest.getDestinationWarehouse());
                        productTransaction.setWarehouseRequest(warehouseRequest);

                        em.persist(productTransaction, ProductTransaction.class);

                        ProductWarehouse productWarehouse = new ProductWarehouse();

                        productWarehouse.setProductWarehouseID(IDGeneratorService.generateID(ProductWarehouse.class));
                        productWarehouse.setInventoryItem(item);
                        productWarehouse.setWarehouse(warehouseRequest.getDestinationWarehouse());
                        productWarehouse.setProductStatus(ProductStatus.In_Stock);

                        boolean isCreated = em.persist(productWarehouse, ProductWarehouse.class);
                    } else {
                        throw new Exception("Item not found for item ID: " + itemId);
                    }
                } catch (NumberFormatException ignored) {
                    // Skip invalid item ID
                } catch (Exception e) {

                }
            }

            warehouseRequest.setWarehouseRequestStatus(WarehouseRequestStatus.Finished);
            em.merge(warehouseRequest, WarehouseRequest.class);

            em.commit();

        } catch (Exception e) {
            em.rollback();
            e.printStackTrace();
            return false;
        }
        return true;
    }

}
