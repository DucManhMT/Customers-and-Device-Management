package crm.common.repository.Request;

import crm.common.model.Request;
import crm.common.repository.FuntionalityDAO;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;

public class RequestDAO extends FuntionalityDAO<Request> {

    EntityManager em = new EntityManager(DBcontext.getConnection());
    public RequestDAO() {
        super(Request.class);
    }

//    public Request findRequestByTechnicianEmployee(String username) {
//        Request request = em.findWithConditions();
//    }

}
