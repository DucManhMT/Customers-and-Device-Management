package crm;

import java.sql.SQLException;
import java.util.List;

import crm.auth.service.Hasher;
import crm.auth.service.LoginService;
import crm.common.model.Request;
import crm.common.model.enums.RequestStatus;
import crm.core.repository.persistence.config.TransactionManager;
import crm.core.repository.persistence.query.clause.ClauseBuilder;
import crm.core.repository.persistence.query.common.PageRequest;
import crm.customer.repository.CustomerRepository;
import crm.service_request.repository.RequestRepository;
import crm.service_request.service.RequestService;

public class Main {
    public static void main(String[] args) {
        System.out.println(LoginService.login("customer01", "@Maxkeptergg2005"));

    }

    public static void testRequest() {
        List<Request> requests;
        RequestService requestService = new RequestService();
        PageRequest pageRequest = new PageRequest(1, 10);
        requests = requestService.getRequestByUsername("customer01", null, null, null, null, 0, 1, 10).getContent();
        requests.forEach(r -> {
            System.out.println("Request ID: " + r.getRequestID());
            System.out.println("Description: " + r.getRequestDescription());
            System.out.println("Status: " + r.getRequestStatus());
            System.out.println("Start Date: " + r.getStartDate());
            System.out
                    .println("Contract ID: " + (r.getContract() != null ? r.getContract().getContractID() : "N/A"));
            System.out.println("---------------------------");
        });
    }

    public static void testCustomer() {
        CustomerRepository customerRepository = new CustomerRepository();
        customerRepository.findWithCondition(ClauseBuilder.builder().equal("Username", "customer01")).forEach(c -> {
            System.out.println("Customer ID: " + c.getCustomerID());
            System.out.println("Name: " + c.getCustomerName());
            System.out.println("Email: " + c.getEmail());
            System.out.println("Phone: " + c.getAccount().getUsername());
            System.out.println("---------------------------");
        });
    }
}
