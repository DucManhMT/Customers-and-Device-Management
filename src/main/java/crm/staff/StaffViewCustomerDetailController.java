package crm.staff;

import crm.common.MessageConst;
import crm.common.URLConstants;
import crm.common.model.Account;
import crm.common.model.Contract;
import crm.common.model.Customer;
import crm.common.model.Request;
import crm.contract.repository.ContractRepository;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.service_request.repository.CustomerRepository;
import crm.service_request.repository.RequestRepository;
import crm.service_request.repository.persistence.query.common.ClauseBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.*;

@WebServlet(urlPatterns = URLConstants.STAFF_VIEW_CUSTOMER_DETAIL, name = "StaffViewCustomerDetailServlet")
public class StaffViewCustomerDetailController extends HttpServlet {
    private static final String ATTR_ERROR = "error";
    private static final String VIEW = "/staff/view_customer_detail.jsp";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        CustomerRepository customerRepo = new CustomerRepository();
        ContractRepository contractRepo = new ContractRepository();

        String customerIdParam = req.getParameter("customerId");
        if (customerIdParam == null || customerIdParam.isBlank()) {
            req.setAttribute(ATTR_ERROR, MessageConst.MSG72);
            forward(req, resp);
            return;
        }
        int customerId;
        try {
            customerId = Integer.parseInt(customerIdParam.trim());
        } catch (NumberFormatException e) {
            req.setAttribute(ATTR_ERROR, MessageConst.MSG73);
            forward(req, resp);
            return;
        }

        Customer customer = customerRepo.findById(customerId);

        if (customer == null) {
            req.setAttribute(ATTR_ERROR, MessageConst.MSG74);
            forward(req, resp);
            return;
        }

        List<Contract> contracts = contractRepo.findWithCondition(ClauseBuilder.builder()
                .equal("customer.customerID", customerId));

        String customerAccountStatus = null;
        try {
            Account acc = customer.getAccount();
            if (acc != null && acc.getAccountStatus() != null) {
                customerAccountStatus = acc.getAccountStatus().name();
            }
        } catch (Exception ignore) {
            // leave as null when lazy relation cannot be loaded safely
        }

        Map<Integer, List<Request>> contractRequests = new HashMap<>();
        for (Contract c : contracts) {
            if (c == null || c.getContractID() == null)
                continue;
            Map<String, Object> requestCond = new HashMap<>();
            requestCond.put("contract", c.getContractID());
            contractRequests.put(c.getContractID(), c.getRequests());
        }

        req.setAttribute("customer", customer);
        req.setAttribute("customerAccountStatus", customerAccountStatus);
        req.setAttribute("contracts", contracts);
        req.setAttribute("contractRequests", contractRequests);
        forward(req, resp);
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        req.getRequestDispatcher(VIEW).forward(req, resp);

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        doGet(req, resp);

    }
}
