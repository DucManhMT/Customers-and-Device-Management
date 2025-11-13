package crm.admin;

import crm.common.MessageConst;
import crm.common.URLConstants;
import crm.common.model.Role;
import crm.common.model.Account;
import crm.common.model.enums.RoleStatus;
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

        if (itemsPerPageParam == null || itemsPerPageParam.trim().isEmpty()) {
            itemsPerPageParam = (String) session.getAttribute("itemsPerPage");
        } else {
            itemsPerPageParam = itemsPerPageParam.trim();
            session.setAttribute("itemsPerPage", itemsPerPageParam);
        }
        String pageParam = request.getParameter("page");

        if (pageParam == null || pageParam.isEmpty()) {
            pageParam = (String) session.getAttribute("page");
        } else {
            session.setAttribute("page", pageParam);
        }


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

        List<Role> allRoles = em.findAll(Role.class);

        List<Role> filteredRoles = allRoles.stream()
                .filter(r -> r.getRoleID() != 1)
                .filter(r -> searchParam == null || searchParam.isEmpty()
                        || (r.getRoleName() != null && r.getRoleName().toLowerCase().contains(searchParam.toLowerCase())))
                .sorted((r1, r2) -> Integer.compare(r1.getRoleID(), r2.getRoleID())) // sort ASC theo ID
                .toList();

        int totalRecords = filteredRoles.size();

        int fromIndex = Math.min(offset, totalRecords);
        int toIndex = Math.min(offset + recordsPerPage, totalRecords);
        List<Role> roles = filteredRoles.subList(fromIndex, toIndex);

        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        Map<Integer, Integer> userCountPerRole = new HashMap<>();
        for (Role role : roles) {
            Map<String, Object> roleCondition = new HashMap<>();
            roleCondition.put("role", role.getRoleID());
            int count = em.findWithConditions(Account.class, roleCondition).size();
            userCountPerRole.put(role.getRoleID(), count);
        }

        int totalRoles = em.count(Role.class) - 1;
        List<Account> allAccounts = em.findAll(Account.class);
        int totalUsers = 0;
        for (Account acc : allAccounts) {
            if (acc.getRole() != null && acc.getRole().getRoleID() != 1) {
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
        System.out.println(recordsPerPage);


        request.getRequestDispatcher("/admin/view_role_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String roleIdParam = request.getParameter("id");

        if (roleIdParam == null || action == null) {
            request.getSession().setAttribute("error", MessageConst.MSG34);
            response.sendRedirect(request.getContextPath() + URLConstants.ADMIN_VIEW_ROLE_LIST);
            return;
        }

        try {
            int roleId = Integer.parseInt(roleIdParam);
            EntityManager em = new EntityManager(DBcontext.getConnection());
            Role role = em.find(Role.class, roleId);

            if (role == null) {
                request.getSession().setAttribute("error", MessageConst.MSG35);
                response.sendRedirect(request.getContextPath() + URLConstants.ADMIN_VIEW_ROLE_LIST);
                return;
            }

            // Lấy số lượng account đang dùng role này
            Map<String, Object> roleCondition = new HashMap<>();
            roleCondition.put("role", roleId);
            int assignedAccountCount = em.findWithConditions(Account.class, roleCondition).size();

            // Xử lý Deactivate
            if ("deactivate".equals(action)) {
                if (assignedAccountCount == 0) {
                    role.setRoleStatus(RoleStatus.Deactive);
                    em.merge(role, Role.class);
                    request.getSession().setAttribute("roleSuccess", MessageConst.MSG36);
                } else {
                    request.getSession().setAttribute("error",
                            MessageConst.MSG37);
                }
            }

            // Xử lý Activate
            else if ("activate".equals(action)) {
                role.setRoleStatus(RoleStatus.Active);
                em.merge(role, Role.class);
                request.getSession().setAttribute("roleSuccess", MessageConst.MSG38);
            }

            // Nếu action không hợp lệ
            else {
                request.getSession().setAttribute("error", MessageConst.MSG39);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "An unexpected error occurred.");
        }

        // Sau khi xử lý, luôn quay lại danh sách role
        response.sendRedirect(request.getContextPath() + URLConstants.ADMIN_VIEW_ROLE_LIST);
    }

}