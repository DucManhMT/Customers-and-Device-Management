package crm.contract.controller;

import crm.common.URLConstants;
import crm.common.model.Account;
import crm.common.model.Contract;
import crm.common.model.Customer;
import crm.common.model.ProductContract;
import crm.common.model.Request;
import crm.contract.service.ContractService;
import crm.contract.service.ProductContractService;
import crm.service_request.service.RequestService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = URLConstants.CONTRACT_DETAIL, name = "ViewContractDetailServlet")
public class ViewContractDetailController extends HttpServlet {
    private static final String ATTR_ERROR = "error";
    private static final String VIEW = "/customer/view_contract_detail.jsp";
    private static final ContractService contractService = new ContractService();
    private static final ProductContractService productContractService = new ProductContractService();
    private static final RequestService requestService = new RequestService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Account account = (Account) req.getSession().getAttribute("account");

        String contractIdParam = req.getParameter("contractId");
        if (contractIdParam == null || contractIdParam.isBlank()) {
            req.setAttribute(ATTR_ERROR, "contractId is required");
            forward(req, resp);
            return;
        }
        int contractId;
        try {
            contractId = Integer.parseInt(contractIdParam.trim());
            Contract contract = contractService.getContractById(contractId);
            if (contract == null) {
                throw new IllegalArgumentException("Contract not found");
            }
            if (account != null && account.getRole() != null && "Customer".equals(account.getRole().getRoleName())) {
                Customer customer = null;
                try {
                    customer = contract.getCustomer();
                } catch (Exception ignored) {
                    // allow null
                }
                if (customer == null || customer.getAccount() == null ||
                        customer.getAccount().getUsername() == null ||
                        !customer.getAccount().getUsername().equals(account.getUsername())) {
                    req.setAttribute(ATTR_ERROR, "You do not have permission to view this contract");
                    forward(req, resp);
                    return;
                }
            }

            List<ProductContract> productContracts = productContractService.findByContractId(contractId);
            // Requests list (if service method exists)
            List<Request> requests = null;
            try {
                requests = requestService.getRequestsByContractId(contractId);
            } catch (Exception ignored) {
                // optional
            }

            // Expose data to view
            req.setAttribute("contract", contract);
            try {
                req.setAttribute("customer", contract.getCustomer());
            } catch (Exception ignored) {
                req.setAttribute("customer", null);
            }
            req.setAttribute("productContracts", productContracts);
            if (requests != null) {
                req.setAttribute("requests", requests);
            }

        } catch (NumberFormatException e) {
            req.setAttribute(ATTR_ERROR, "Invalid contractId");

        } catch (IllegalArgumentException e) {
            req.setAttribute(ATTR_ERROR, e.getMessage());
        }

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
