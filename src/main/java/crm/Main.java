package crm;

import java.util.List;

import crm.common.model.Account;
import crm.common.model.Request;
import crm.common.model.Warehouse;
import crm.common.model.WarehouseRequest;
import crm.common.repository.Warehouse.WarehouseDAO;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.service_request.repository.RequestRepository;
import crm.service_request.repository.persistence.query.common.ClauseBuilder;
import crm.service_request.repository.persistence.query.common.PageRequest;
import crm.service_request.service.RequestService;

public class Main {
    public static void main(String[] args) {
        RequestService requestService = new RequestService();
        requestService.getRequestWithCondition("Customer 4", null, null, "09112003", null, 1, 10).getContent()
                .forEach((r) -> {
                    System.out
                            .println(r.getRequestID() + "-" + r.getContract().getCustomer().getCustomerName() + " - " +
                                    r.getContract().getCustomer().getPhone());
                });
    }
}
