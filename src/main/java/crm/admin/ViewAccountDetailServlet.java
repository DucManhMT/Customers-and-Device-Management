package crm.admin;

import crm.common.URLConstants;
import crm.common.model.Account;
import crm.common.model.Customer;
import crm.common.model.Role;
import crm.common.model.Staff;
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

@WebServlet(name = "ViewAccountDetailServlet", value = URLConstants.ADMIN_VIEW_ACCOUNT_DETAIL)
public class ViewAccountDetailServlet extends HttpServlet {
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
        String username = request.getParameter("id");
        String role = request.getParameter("role");
        EntityManager em = new EntityManager(DBcontext.getConnection());
        Role roleName = em.find(Role.class, Integer.parseInt(role));
        Account account = em.find(Account.class, username);
        if (Integer.parseInt(role) == 2) {

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
                    String actionCenter = getActionCenterPath(request, account);
                    redirectTarget = request.getContextPath() + actionCenter;
                }

                response.sendRedirect(redirectTarget);
                return;
            }
            Customer customer = customers.get(0);

            request.setAttribute("accountName", customer.getCustomerName());
            request.setAttribute("accountEmail", customer.getEmail());
            request.setAttribute("accountPhone", customer.getPhone());
            request.setAttribute("accountAddress", customer.getAddress());
            request.setAttribute("role", roleName);

        } else {
            Map<String, Object> cond = new HashMap<>();
            cond.put("account", username);
            List<Staff> staffList = em.findWithConditions(Staff.class, cond);

            if (staffList == null || staffList.isEmpty()) {
                session.setAttribute(FLASH_ERROR_KEY, "This profile has no staff information.");
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
                        // ignore, fallback below
                    }
                }
                if (redirectTarget == null) {
                    String actionCenter = getActionCenterPath(request, account);
                    redirectTarget = request.getContextPath() + actionCenter;
                }
                response.sendRedirect(redirectTarget);
                return;
            }

            Staff staff = staffList.get(0);
            request.setAttribute("accountName", staff.getStaffName());
            request.setAttribute("accountEmail", staff.getEmail());
            request.setAttribute("accountPhone", staff.getPhone());
            request.setAttribute("accountAddress", staff.getAddress());
            request.setAttribute("accountDoB", staff.getDateOfBirth());
            request.setAttribute("accountImage", staff.getImage());
            request.setAttribute("role", roleName);

        }
        request.setAttribute("username", username);
        request.setAttribute("roleID", Integer.parseInt(role));
        System.out.println("Set attributes for username: " + username + " and roleID: " + role);

        request.getRequestDispatcher("/admin/view_account_detail.jsp").forward(request, response);
    }
    private String getActionCenterPath(HttpServletRequest request, Account account) {
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
                return "/"; // hoặc đổi sang "/staff" tuỳ ứng dụng
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}