package crm.contract.controller;

import crm.common.MessageConst;
import crm.common.URLConstants;
import crm.common.model.Account;
import crm.common.model.Contract;
import crm.common.model.Customer;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.net.URI;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = URLConstants.CUSTOMER_VIEW_CONTRACT_HISTORY)
public class ViewContractHistoryServlet extends HttpServlet {
    private static final String FLASH_ERROR_KEY = "flashErrorMessage";
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/auth/customer_login");
            return;
        }

        Account sessionAccount = (Account) session.getAttribute("account");
        if (sessionAccount == null) {
            response.sendRedirect(request.getContextPath() + "/auth/customer_login");
            return;
        }

        EntityManager em = new EntityManager(DBcontext.getConnection());
        Account account = em.find(Account.class, sessionAccount.getUsername());
        Map<String,Object> cond = new HashMap();
        cond.put("account", sessionAccount.getUsername());
        List<Customer> customers = em.findWithConditions(Customer.class, cond);

        if (account == null || customers == null || customers.isEmpty()) {
            String errorMsg = MessageConst.MSG44;
            session.setAttribute(FLASH_ERROR_KEY, errorMsg);

            // Lấy Referer và validate host để tránh open-redirect
            String referer = request.getHeader("Referer");
            String redirectTarget = null;
            if (referer != null && !referer.isEmpty()) {
                try {
                    URI u = new URI(referer);
                    String refererHost = u.getHost();
                    if (refererHost != null && refererHost.equalsIgnoreCase(request.getServerName())) {
                        redirectTarget = referer;
                    }
                } catch (Exception ex) {
                    // ignore -> fallback below
                }
            }

            // Fallback: redirect về action-center của session hiện tại
            if (redirectTarget == null) {
                redirectTarget = request.getContextPath() + getActionCenterPath(sessionAccount);
            }

            response.sendRedirect(redirectTarget);
            return;
        }
        Customer customer = customers.get(0);
        String contractCodeParam = request.getParameter("contractCode");
        String startDateParam = request.getParameter("startDate");

        String pageParam = request.getParameter("page");
        String itemsPerPageParam = request.getParameter("itemsPerPage");

        int page = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
        int recordsPerPage = (itemsPerPageParam != null && !itemsPerPageParam.isEmpty())
                ? Integer.parseInt(itemsPerPageParam)
                : 5;


        int offset = (page - 1) * recordsPerPage;

        Map<String, Object> conditions = new HashMap<>();
        conditions.put("customer", customer.getCustomerID());
        List<Contract> allContracts = em.findWithConditions(Contract.class, conditions);
        List<Contract> filteredContracts = allContracts.stream()
                .filter(c -> (contractCodeParam == null || contractCodeParam.isEmpty() ||
                        c.getContractCode().toLowerCase().contains(contractCodeParam.toLowerCase())))
                .filter(c -> {
                    if (startDateParam == null || startDateParam.isEmpty()) return true;
                    return c.getStartDate().toString().equals(startDateParam);
                })
                .toList();

        int totalRecords = filteredContracts.size();
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        int fromIndex = Math.min(offset, totalRecords);
        int toIndex = Math.min(offset + recordsPerPage, totalRecords);
        List<Contract> contracts = filteredContracts.subList(fromIndex, toIndex);


        request.setAttribute("contracts", contracts);
        request.setAttribute("count", totalRecords);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("recordsPerPage", recordsPerPage);
        request.setAttribute("contractCodeSearch", contractCodeParam);
        request.setAttribute("startDateSearch", startDateParam);


        request.getRequestDispatcher("/customer/view_contract_history.jsp").forward(request, response);
    }
    private String getActionCenterPath(Account account) {
        if (account == null || account.getRole() == null || account.getRole().getRoleName() == null) {
            return "/"; // fallback generic
        }

        String roleName = account.getRole().getRoleName();
        switch (roleName) {
            case "TechnicianLeader":
                return "/technician_leader/techlead_actioncenter";
            case "TechnicianEmployee":
                return "/technician_employee/techemployee_actioncenter";
            case "CustomerSupporter":
                return "/customer_supporter/customersupporter_actioncenter";
            case "WarehouseKeeper":
                return "/warehouse_keeper/warehousekeeper_actioncenter";
            case "Admin":
                return "/admin/admin_actioncenter";
            case "InventoryManager":
                return "/inventory_manager/inventorymanager_actioncenter";
            case "Customer":
                return "/customer/customer_actioncenter";
            default:
                return "/"; // or "/staff" / dashboard depending on your app
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}