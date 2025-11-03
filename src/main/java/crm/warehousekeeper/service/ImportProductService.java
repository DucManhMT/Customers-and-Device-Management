package crm.warehousekeeper.service;

import crm.common.model.InventoryItem;
import crm.common.model.Warehouse;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;

public class ImportProductService {
    public static boolean ImportProducts(InventoryItem item, Warehouse warehouse){

        EntityManager em = new EntityManager(DBcontext.getConnection());

        try{
            em.beginTransaction();
            em.persist(item, InventoryItem.class);



            em.commit();
        } catch (Exception e){
            em.rollback();
            e.printStackTrace();
            return false;
        }
        return true;

    }
}
