package crm.staff;

import crm.common.MessageConst;
import crm.common.URLConstants;
import crm.common.model.Contract;
import crm.common.model.Customer;
import crm.common.model.Request;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.*;
import java.util.logging.Logger;

@WebServlet(urlPatterns = URLConstants.STAFF_VIEW_CUSTOMER_DETAIL, name = "StaffViewCustomerDetailServlet")
public class StaffViewCustomerDetailServlet extends HttpServlet {
    private static final String ATTR_ERROR = "error";
    private static final String VIEW = "/staff/view_customer_detail.jsp";
    private static final Logger logger = Logger.getLogger(StaffViewCustomerDetailServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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

        EntityManager em = new EntityManager(DBcontext.getConnection());
        Customer customer = em.find(Customer.class, customerId);
        if (customer == null) {
            req.setAttribute(ATTR_ERROR, MessageConst.MSG74);
            forward(req, resp);
            return;
        }

        // Load contracts for this customer
        Map<String, Object> contractCond = new HashMap<>();
        contractCond.put("customer", customer.getCustomerID());
        List<Contract> contracts = em.findWithConditions(Contract.class, contractCond);

        String customerAccountStatus = null;
        try {
            crm.common.model.Account acc = customer.getAccount();
            if (acc != null && acc.getAccountStatus() != null) {
                customerAccountStatus = acc.getAccountStatus().name();
            }
        } catch (Exception ignore) {
            // leave as null when lazy relation cannot be loaded safely
        }

        // Map contractID -> list of requests
        Map<Integer, List<Request>> contractRequests = new HashMap<>();
        for (Contract c : contracts) {
            if (c == null || c.getContractID() == null)
                continue;
            Map<String, Object> requestCond = new HashMap<>();
            requestCond.put("contract", c.getContractID());
            List<Request> reqs = em.findWithConditions(Request.class, requestCond);
            contractRequests.put(c.getContractID(), reqs != null ? reqs : List.of());
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
