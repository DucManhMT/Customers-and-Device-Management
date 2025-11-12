package crm.admin;

import crm.common.URLConstants;
import crm.common.model.Account;
import crm.common.model.Role;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminActionCenterServlet", value = URLConstants.ADMIN_ACTION_CENTER)
public class AdminActionCenterServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        EntityManager em = new EntityManager(DBcontext.getConnection());

        List<Role> allRoles = em.findAll(Role.class);

        Map<Integer, Integer> userCountPerRole = new HashMap<>();
        for (Role role : allRoles) {
            if (role == null) continue;
            if (role.getRoleID() != null && role.getRoleID() == 1) {
                continue;
            }
            Map<String, Object> roleCondition = new HashMap<>();
            roleCondition.put("role", role.getRoleID());
            int count = em.findWithConditions(Account.class, roleCondition).size();
            userCountPerRole.put(role.getRoleID(), count);
        }

        int totalRoles = Math.max(0, em.count(Role.class) - 1);

        List<Account> allAccounts = em.findAll(Account.class);
        int totalUsers = 0;
        for (Account acc : allAccounts) {
            try {
                if (acc.getRole() != null && acc.getRole().getRoleID() != 1) {
                    totalUsers++;
                }
            } catch (Exception ex) {
            }
        }

        request.setAttribute("totalRoles", totalRoles);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("userCountPerRole", userCountPerRole);
        request.setAttribute("roles", allRoles);

        request.getRequestDispatcher("/admin/admin_actioncenter.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}