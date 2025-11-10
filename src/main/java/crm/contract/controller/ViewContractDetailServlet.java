package crm.contract.controller;

import crm.common.URLConstants;
import crm.common.model.Contract;
import crm.common.model.Customer;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * View detailed information about a single contract (for customer side).
 * Expects contractId as query parameter.
 * URL: /contract/detail?contractId=123
 */
@WebServlet(urlPatterns = URLConstants.CONTRACT_DETAIL, name = "ViewContractDetailServlet")
public class ViewContractDetailServlet extends HttpServlet {
    private static final String ATTR_ERROR = "error";
    private static final String VIEW = "/customer/view_contract_detail.jsp";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String contractIdParam = req.getParameter("contractId");
        if (contractIdParam == null || contractIdParam.isBlank()) {
            req.setAttribute(ATTR_ERROR, "contractId is required");
            forward(req, resp);
            return;
        }
        int contractId;
        try {
            contractId = Integer.parseInt(contractIdParam.trim());
        } catch (NumberFormatException e) {
            req.setAttribute(ATTR_ERROR, "Invalid contractId");
            forward(req, resp);
            return;
        }

        EntityManager em = new EntityManager(DBcontext.getConnection());
        Contract contract = em.find(Contract.class, contractId);
        if (contract == null) {
            req.setAttribute(ATTR_ERROR, "Contract not found");
            forward(req, resp);
            return;
        }
        Customer customer = null;
        try {
            customer = contract.getCustomer();
        } catch (Exception ignored) {
            // allow null
        }
        req.setAttribute("contract", contract);
        req.setAttribute("customer", customer);
        forward(req, resp);
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp) {
        try {
            req.getRequestDispatcher(VIEW).forward(req, resp);
        } catch (Exception ignored) {
            // If forwarding fails, nothing more to do.
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            doGet(req, resp);
        } catch (ServletException | IOException e) {
            req.setAttribute(ATTR_ERROR, "Error processing request: " + e.getMessage());
            forward(req, resp);
        }
    }
}
