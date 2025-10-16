package crm.admin;

import crm.common.URLConstants;
import crm.common.model.Role;
import crm.common.model.Account;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.repository.hibernate.querybuilder.enums.SortDirection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = URLConstants.ADMIN_VIEW_ROLE_LIST)
public class ViewRoleListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        HttpSession session = request.getSession();

        // ItemsPerPage
        String itemsPerPageParam = request.getParameter("itemsPerPage");
        if (itemsPerPageParam == null || itemsPerPageParam.isEmpty()) {
            itemsPerPageParam = (String) session.getAttribute("itemsPerPage");
        } else {
            session.setAttribute("itemsPerPage", itemsPerPageParam);
        }
        // Page
        String pageParam = request.getParameter("page");
        if (pageParam == null || pageParam.isEmpty()) {
            pageParam = (String) session.getAttribute("page");
        } else {
            session.setAttribute("page", pageParam);
        }
        // Search


        String error = (String) session.getAttribute("error");
        if (error != null) {
            request.setAttribute("error", error);
            session.removeAttribute("error");
        }

        int page = 1;
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int recordsPerPage = 5;
        if (itemsPerPageParam != null && !itemsPerPageParam.isEmpty()) {
            try {
                recordsPerPage = Integer.parseInt(itemsPerPageParam);
            } catch (NumberFormatException e) {
                recordsPerPage = 5;
            }
        }
        int offset = (page - 1) * recordsPerPage;
        String searchParam = request.getParameter("search");

        Map<String, Object> conditions = new HashMap<>();
        if (searchParam != null && !searchParam.isEmpty()) {
            conditions.put("roleName", searchParam);
        }

        // Order by ID
        Map<String, SortDirection> orderConditions = new HashMap<>();
        orderConditions.put("roleID", SortDirection.ASC);

        List<Role> roles;
        int totalRecords;
        if (!conditions.isEmpty()) {
            // Having Search
            roles = em.findWithConditionsOrderAndPagination(Role.class, conditions, orderConditions, recordsPerPage, offset);
            totalRecords = em.findWithConditions(Role.class, conditions).size();
        } else {
            // No search
            roles = em.findWithOrderAndPagination(Role.class, orderConditions, recordsPerPage, offset);
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

        request.getRequestDispatcher("/admin/view_role_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            String roleIdParam = request.getParameter("id");
            if (roleIdParam != null) {
                try {
                    int roleId = Integer.parseInt(roleIdParam);
                    EntityManager em = new EntityManager(DBcontext.getConnection());
                    Role roleToDelete = em.find(Role.class, roleId);
                    if (roleToDelete != null) {
                        em.remove(roleToDelete, Role.class);
                    }
                } catch (Exception e) {
                    request.getSession().setAttribute("error", "This role can't be delete because have assigned to one or more account.");
                }
            }
            response.sendRedirect(request.getContextPath() + URLConstants.ADMIN_VIEW_ROLE_LIST);
            return;
        }
    }
}