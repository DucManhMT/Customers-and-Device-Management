package crm;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import crm.common.model.*;
import crm.common.model.enums.ProductRequestStatus;
import crm.common.repository.Warehouse.WarehouseDAO;
import crm.contract.repository.ContractRepository;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.service_request.repository.RequestRepository;
import crm.service_request.repository.persistence.query.common.ClauseBuilder;
import crm.service_request.repository.persistence.query.common.PageRequest;
import crm.service_request.service.RequestService;
import crm.task.service.TaskService;

public class Main {
    public static void main(String[] args) {

        EntityManager em = new EntityManager(DBcontext.getConnection());
        List<ProductRequest> productRequests = em.findAll(ProductRequest.class);

        productRequests = productRequests.stream()
                .filter(pr -> pr.getTask().getRequest().getRequestID() == 15)
                .sorted((pr1, pr2) -> pr2.getRequestDate().compareTo(pr1.getRequestDate()))
                .collect(Collectors.toList());

        for (ProductRequest pr : productRequests) {
            System.out.println(pr.getProductRequestID() + " - " + pr.getRequestDate());
        }

    }
}
