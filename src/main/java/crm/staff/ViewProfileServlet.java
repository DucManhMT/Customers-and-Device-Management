package crm.staff;

import crm.common.URLConstants;
import crm.common.model.Account;
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

@WebServlet(name = "StaffProfileServlet", value = URLConstants.STAFF_VIEW_PROFILE)
public class ViewProfileServlet extends HttpServlet {
    private static final String FLASH_ERROR_KEY = "flashErrorMessage";
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        EntityManager em = new EntityManager(DBcontext.getConnection());
        Account account = (Account) session.getAttribute("account");

        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/auth/staff_login");
            return;
        }
        Map<String, Object> cond = new HashMap<>();
        cond.put("account", account.getUsername());
        List<Staff> staffList = em.findWithConditions(Staff.class, cond);

        if (staffList == null || staffList.isEmpty()) {
            session.setAttribute(FLASH_ERROR_KEY, "This account has no staff information.");
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
        request.setAttribute("staff", staff);
        request.setAttribute("accountImage", staff.getImage());
        request.setAttribute("account", account);
        request.getRequestDispatcher("/staff/view_profile.jsp").forward(request, response);


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