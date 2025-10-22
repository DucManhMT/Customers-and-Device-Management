package crm.admin;

import crm.common.URLConstants;
import crm.common.model.Account;
import crm.common.model.Customer;
import crm.common.model.Role;
import crm.common.model.Staff;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.repository.hibernate.querybuilder.enums.SortDirection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ViewAccountList", value = URLConstants.ADMIN_VIEW_ACCOUNT_LIST)
public class ViewAccountListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        HttpSession session = request.getSession();

        // --- Read params (trimmed) ---
        String itemsPerPageParam = trimParam(request.getParameter("itemsPerPage"));
        String pageParam = trimParam(request.getParameter("page"));
        System.out.println("itemsPerPageParam: " + itemsPerPageParam);
        System.out.println("pageParam: " + pageParam);

        // Keep session fallback behavior
        if (itemsPerPageParam == null || itemsPerPageParam.isEmpty()) {
            itemsPerPageParam = (String) session.getAttribute("itemsPerPage");
        } else {
            session.setAttribute("itemsPerPage", itemsPerPageParam);
        }

        if (pageParam == null || pageParam.isEmpty()) {
            pageParam = (String) session.getAttribute("page");
        } else {
            session.setAttribute("page", pageParam);
        }

        // default values
        int page = 1;
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Math.max(1, Integer.parseInt(pageParam));
            } catch (NumberFormatException ignored) {
                page = 1;
            }
        }

        int recordsPerPage = 5;
        if (itemsPerPageParam != null && !itemsPerPageParam.isEmpty()) {
            try {
                recordsPerPage = Math.max(1, Integer.parseInt(itemsPerPageParam));
            } catch (NumberFormatException ignored) {
                recordsPerPage = 5;
            }
        }

        // Search/filter params (trim)
        String searchUsername = trimParam(request.getParameter("searchUsername"));
        String searchName = trimParam(request.getParameter("searchName"));
        String searchEmail = trimParam(request.getParameter("searchEmail"));
        String roleFilter = trimParam(request.getParameter("roleFilter"));
        String statusFilter = trimParam(request.getParameter("statusFilter"));

        if (searchUsername == null) searchUsername = "";
        if (searchName == null) searchName = "";
        if (searchEmail == null) searchEmail = "";
        if (roleFilter == null) roleFilter = "";
        if (statusFilter == null) statusFilter = "";

        // Order by username (kept for possible DAO calls)
        Map<String, SortDirection> orderConditions = new HashMap<>();
        orderConditions.put("username", SortDirection.ASC);

        // Lấy danh sách role cho dropdown
        List<Role> roleList = em.findAll(Role.class);

        // --- IMPORTANT CHANGE ---
        // Previously you fetched a paginated list and then filtered it,
        // which made pagination/count inconsistent with filters.
        // Now we build the full list of accountInfos (unpaginated),
        // apply filters in-memory, and only then paginate the filtered list.
        //
        // NOTE: If your DB is large this is inefficient. The ideal solution
        // is to apply filters in the DB (query + count). If EntityManager
        // can build conditional queries (LIKE, =), prefer that.
        //

        // 1) Fetch all accounts (ordered). If dataset is very large, replace with DB-side filtering.
        List<Account> allAccounts = em.findWithOrderAndPagination(Account.class, orderConditions, Integer.MAX_VALUE, 0);
        if (allAccounts == null) allAccounts = new ArrayList<>();

        // 2) Build accountInfos for every account (no pagination yet)
        List<Map<String, Object>> allInfos = new ArrayList<>();
        for (Account acc : allAccounts) {
            if (acc == null) continue;

            // Optionally skip role id 1 as before
            if (acc.getRole() != null && acc.getRole().getRoleID() == 1) {
                continue;
            }

            String username = acc.getUsername();
            String email = null;
            String name = null;
            Role roleObj = acc.getRole();
            String status = acc.getAccountStatus() != null ? acc.getAccountStatus().toString() : null;

            // Find name/email from Customer first, then Staff (safe checks)
            Map<String, Object> condCustomer = new HashMap<>();
            condCustomer.put("account", username);
            List<Customer> customers = em.findWithConditions(Customer.class, condCustomer);
            Customer firstCustomer = firstNonNull(customers);
            if (firstCustomer != null) {
                name = firstCustomer.getCustomerName();
                email = firstCustomer.getEmail();
            } else {
                Map<String, Object> condStaff = new HashMap<>();
                condStaff.put("account", username);
                List<Staff> staffs = em.findWithConditions(Staff.class, condStaff);
                Staff firstStaff = firstNonNull(staffs);
                if (firstStaff != null) {
                    name = firstStaff.getStaffName();
                    email = firstStaff.getEmail();
                }
            }

            Map<String, Object> info = new HashMap<>();
            info.put("username", username);
            info.put("name", name);
            info.put("email", email);
            info.put("role", roleObj);
            info.put("roleId", roleObj != null ? roleObj.getRoleID() : null);
            info.put("roleName", roleObj != null ? roleObj.getRoleName() : null);
            info.put("status", status);
            allInfos.add(info);
        }

        // 3) Apply filters to allInfos (now filteredInfos contains all matching records)
        List<Map<String, Object>> filteredInfos = new ArrayList<>();
        for (Map<String, Object> info : allInfos) {
            String username = (String) info.get("username");
            String name = (String) info.get("name");
            String email = (String) info.get("email");
            String status = (String) info.get("status");
            String roleIdStr = info.get("roleId") != null ? String.valueOf(info.get("roleId")) : null;

            if (!isMatch(username, searchUsername)) continue;
            if (!isMatch(name, searchName)) continue;
            if (!isMatch(email, searchEmail)) continue;
            if (!isMatch(roleIdStr, roleFilter)) continue;
            if (!isMatch(status, statusFilter)) continue;

            filteredInfos.add(info);
        }

        // 4) Pagination on filteredInfos
        int totalRecords = filteredInfos.size();
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
        if (totalPages == 0) totalPages = 1;

        // If requested page is out of range, clamp it
        if (page > totalPages) page = totalPages;
        if (page < 1) page = 1;

        int fromIndex = (page - 1) * recordsPerPage;
        int toIndex = Math.min(fromIndex + recordsPerPage, totalRecords);

        List<Map<String, Object>> pageInfos;
        if (fromIndex >= totalRecords) {
            pageInfos = new ArrayList<>();
        } else {
            pageInfos = filteredInfos.subList(fromIndex, toIndex);
        }

        // 5) Set attributes for JSP
        request.setAttribute("accountInfos", pageInfos);
        request.setAttribute("roleList", roleList);
        request.setAttribute("count", totalRecords);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("itemsPerPage", recordsPerPage);

        // Keep filter values for the view
        request.setAttribute("searchUsername", searchUsername);
        request.setAttribute("searchName", searchName);
        request.setAttribute("searchEmail", searchEmail);
        request.setAttribute("roleFilter", roleFilter);
        request.setAttribute("statusFilter", statusFilter);

        // persist page/items into session so next requests without params keep them
        session.setAttribute("page", String.valueOf(page));
        session.setAttribute("itemsPerPage", String.valueOf(recordsPerPage));

        request.getRequestDispatcher("/admin/view_account_list.jsp").forward(request, response);
    }

    // Helpers
    private boolean isMatch(String value, String query) {
        if (query == null || query.isEmpty()) return true;
        if (value == null) return false;
        return value.toLowerCase().contains(query.trim().toLowerCase());
    }

    private String trimParam(String p) {
        return p == null ? null : p.trim();
    }

    private <T> T firstNonNull(List<T> list) {
        if (list == null || list.isEmpty()) return null;
        for (T t : list) if (t != null) return t;
        return null;
    }




    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}