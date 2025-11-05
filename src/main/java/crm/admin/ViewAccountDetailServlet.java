package crm.admin;

import crm.common.URLConstants;
import crm.common.model.Customer;
import crm.common.model.Role;
import crm.common.model.Staff;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ViewAccountDetailServlet", value = URLConstants.ADMIN_VIEW_ACCOUNT_DETAIL)
public class ViewAccountDetailServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("id");
        String role = request.getParameter("role");
        System.out.println("Role ID: " + role);
        EntityManager em = new EntityManager(DBcontext.getConnection());
        Role roleName = em.find(Role.class, Integer.parseInt(role));
        if (Integer.parseInt(role) == 2) {
            Map<String, Object> cond = new HashMap<>();
            cond.put("account", username);
            Customer customer = em.findWithConditions(Customer.class, cond).get(0);

            request.setAttribute("accountName", customer.getCustomerName());
            request.setAttribute("accountEmail", customer.getEmail());
            request.setAttribute("accountPhone", customer.getPhone());
            request.setAttribute("accountAddress", customer.getAddress());
            request.setAttribute("role", roleName);

        } else {
            Map<String, Object> cond = new HashMap<>();
            cond.put("account", username);
            Staff staff = em.findWithConditions(Staff.class, cond).get(0);
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}