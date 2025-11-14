package crm.warehousekeeper.service;

import crm.common.model.ProductExported;
import crm.common.model.ProductRequest;
import crm.common.model.ProductWarehouse;
import crm.common.model.WarehouseLog;
import crm.common.model.enums.ProductRequestStatus;
import crm.common.model.enums.ProductStatus;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.service.IDGeneratorService;

import java.time.LocalDate;
import java.util.List;

public class ExportProductService {
    public static void exportProducts(ProductRequest productRequest, List<String> itemIds) {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        int numberOfItems = itemIds.size();
        WarehouseLog whl = new WarehouseLog();
        whl.setWarehouseLogID(IDGeneratorService.generateID(WarehouseLog.class));
        whl.setLogDate(LocalDate.now());
        whl.setWarehouse(productRequest.getWarehouse());
        whl.setProductRequest(productRequest);
        try {
            em.beginTransaction();
            em.persist(whl, WarehouseLog.class);

            for (String itemId : itemIds) {
                try {
                    int id = Integer.parseInt(itemId);
                    ProductWarehouse item = em.find(ProductWarehouse.class, id);
                    if (item != null) {
                        ProductExported exportedItem = new ProductExported();
                        exportedItem.setProductWarehouse(item);
                        exportedItem.setWarehouseLog(whl);
                        item.setProductStatus(ProductStatus.Exported);
                        // Update the item in the warehouse as exported
                        em.merge(item, ProductWarehouse.class);
                        // Persist the exported item record
                        em.persist(exportedItem, ProductExported.class);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            int actualQuantity = productRequest.getActualQuantity() == null ? 0 : productRequest.getActualQuantity();
            actualQuantity += numberOfItems;
            productRequest.setActualQuantity(actualQuantity);
            if (actualQuantity > 0) {
                productRequest.setStatus(ProductRequestStatus.Transporting);
                em.merge(productRequest, ProductRequest.class);
            }

            em.commit();
        } catch (Exception e) {
            em.rollback();
            e.printStackTrace();
        }
    }
}
