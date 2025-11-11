package crm.task.service;

import crm.common.model.ProductRequest;
import crm.common.model.enums.ProductRequestStatus;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;

import java.sql.SQLException;

public class TechEmProductRequestService {

    public static boolean isFinished(ProductRequest productRequest, String action) {

        EntityManager em = new EntityManager(DBcontext.getConnection());

        try {
            em.beginTransaction();

            productRequest.setStatus(action.equals("finished") ? ProductRequestStatus.Finished : ProductRequestStatus.Rejected);

            em.merge(productRequest, ProductRequest.class);
            em.commit();

            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            em.rollback();
        }
        return false;
    }

}
