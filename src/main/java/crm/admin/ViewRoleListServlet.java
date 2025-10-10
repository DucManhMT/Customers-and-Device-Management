package crm.admin;

import crm.common.model.Role;
import crm.common.model.Account;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import crm.core.config.DBcontext;
import java.util.Map;

@WebServlet(urlPatterns = "/ViewRoleList")
public class ViewRoleListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        EntityManager em = new EntityManager(DBcontext.getConnection());

        String searchParam = request.getParameter("search");

        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            page = Integer.parseInt(pageParam);
        }
        int recordsPerPage = 5;
        String itemsPerPageParam = request.getParameter("itemsPerPage");
        if (itemsPerPageParam != null && !itemsPerPageParam.isEmpty()) {
            recordsPerPage = Integer.parseInt(itemsPerPageParam);
        }
        int offset = (page - 1) * recordsPerPage;

        Map<String, Object> conditions = new HashMap<>();
        if (searchParam != null && !searchParam.isEmpty()) {
            conditions.put("roleName", searchParam);
        }

        List<Role> roles;
        int totalRecords;
        if (!conditions.isEmpty()) {
            roles = em.findWithConditionsAndPagination(Role.class, conditions, recordsPerPage, offset);
            totalRecords = em.findWithConditions(Role.class, conditions).size();
        } else {
            roles = em.findWithPagination(Role.class, recordsPerPage, offset);
            totalRecords = em.count(Role.class);
        }
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        Map<Integer, Integer> userCountPerRole = new HashMap<>();
        for (Role role : roles) {
            Map<String, Object> roleCondition = new HashMap<>();
            roleCondition.put("role", role.getRoleID());
            int count = em.findWithConditions(Account.class, roleCondition).size();
            userCountPerRole.put(role.getRoleID(), count);
        }

        int totalRoles = em.count(Role.class);
        List<Account> allAccounts = em.findAll(Account.class);
        int totalUsers = 0;
        for (Account acc : allAccounts) {
            if (acc.getRole() != null) {
                totalUsers++;
            }
        }
        request.setAttribute("totalRoles", totalRoles);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("userCountPerRole", userCountPerRole);

        request.setAttribute("roles", roles);
        request.setAttribute("count", totalRecords);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("itemsPerPage", recordsPerPage);
        request.setAttribute("search", searchParam);

        request.getRequestDispatcher("/admin/ViewRoleList.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}