package crm;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import crm.common.model.*;
import crm.common.model.enums.ProductRequestStatus;
import crm.common.repository.Warehouse.WarehouseDAO;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.service_request.repository.ContractRepository;
import crm.service_request.repository.RequestRepository;
import crm.service_request.repository.persistence.query.common.ClauseBuilder;
import crm.service_request.repository.persistence.query.common.PageRequest;
import crm.service_request.service.RequestService;
import crm.task.service.TaskService;

public class Main {
    public static void main(String[] args) {
        EntityManager em = new EntityManager(DBcontext.getConnection());

        Map<String, Object> conditions = new HashMap<>();
        conditions.put("warehouse", 1);
        conditions.put("status", ProductRequestStatus.Pending.name());

        List<ProductRequest> productRequests = em.findWithConditions(ProductRequest.class,conditions);

        for(ProductRequest pr : productRequests) {
            System.out.println(pr);
        }

    }
}
