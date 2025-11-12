package crm.customer;

import crm.common.URLConstants;
import crm.common.model.Account;
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

@WebServlet(name = "ViewProfileServlet", value = URLConstants.CUSTOMER_VIEW_PROFILE)
public class ViewProfileServlet extends HttpServlet {
    private static final String FLASH_ERROR_KEY = "flashErrorMessage";
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
        String username = request.getParameter("id");
        Account account = em.find(Account.class, username);
        Map<String,Object> cond = new HashMap();
        cond.put("account", username);
        List<Customer> customers = em.findWithConditions(Customer.class, cond);

        if (account == null || customers == null || customers.isEmpty()) {
            String errorMsg = "This account has no customer information.";
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
        request.setAttribute("account", account);
        request.setAttribute("customer", customer);

        request.getRequestDispatcher("/customer/view_profile.jsp").forward(request, response);
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}