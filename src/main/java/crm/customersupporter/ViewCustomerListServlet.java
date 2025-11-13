package crm.customersupporter;

import crm.common.URLConstants;
import crm.common.model.Account;
import crm.common.model.Customer;
import crm.common.model.enums.AccountStatus;
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

@WebServlet(name = "ViewCustomerListServlet", value = URLConstants.CUSTOMER_SUPPORTER_VIEW_CUSTOMERS_LIST)
public class ViewCustomerListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        HttpSession session = request.getSession();

        String itemsPerPageParam = request.getParameter("itemsPerPage");
        String pageParam = request.getParameter("page");

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
        String searchUsername = request.getParameter("searchUsername");
        String searchName = request.getParameter("searchName");
        String searchEmail = request.getParameter("searchEmail");

        if (searchUsername == null) searchUsername = "";
        if (searchName == null) searchName = "";
        if (searchEmail == null) searchEmail = "";

        // Order by username (kept for possible DAO calls)
        Map<String, SortDirection> orderConditions = new HashMap<>();
        orderConditions.put("account", SortDirection.ASC);

        List<Customer> allCustomers = em.findWithOrderAndPagination(Customer.class, orderConditions, Integer.MAX_VALUE, 0);
        if (allCustomers == null) allCustomers = new ArrayList<>();

        // 2) Build customerInfos for every customer whose account is Active
        List<Map<String, Object>> allInfos = new ArrayList<>();
        for (Customer c : allCustomers) {
            if (c == null) continue;

            String username = c.getAccount().getUsername();
            if (username == null) continue;

            // Load account to check status
            Account acc = em.find(Account.class, username);
            if (acc == null) continue;

            // Only include accounts with AccountStatus.Active
            if (acc.getAccountStatus() == null || acc.getAccountStatus() != AccountStatus.Active) {
                continue;
            }

            String name = c.getCustomerName();
            String email = c.getEmail();
            String status = acc.getAccountStatus() != null ? acc.getAccountStatus().toString() : null;

            Map<String, Object> info = new HashMap<>();
            info.put("username", username);
            info.put("name", name);
            info.put("email", email);
            info.put("status", status);
            allInfos.add(info);
        }

        List<Map<String, Object>> filteredInfos = new ArrayList<>();
        for (Map<String, Object> info : allInfos) {
            String username = (String) info.get("username");
            String name = (String) info.get("name");
            String email = (String) info.get("email");

            if (!isMatch(username, searchUsername)) continue;
            if (!isMatch(name, searchName)) continue;
            if (!isMatch(email, searchEmail)) continue;

            filteredInfos.add(info);
        }

        int totalRecords = filteredInfos.size();
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
        if (totalPages == 0) totalPages = 1;

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

        request.setAttribute("accountInfos", pageInfos);
        request.setAttribute("count", totalRecords);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("itemsPerPage", recordsPerPage);

        // Keep filter values for the view
        request.setAttribute("searchUsername", searchUsername);
        request.setAttribute("searchName", searchName);
        request.setAttribute("searchEmail", searchEmail);

        // persist page/items into session so next requests without params keep them
        session.setAttribute("page", String.valueOf(page));
        session.setAttribute("itemsPerPage", String.valueOf(recordsPerPage));


        request.getRequestDispatcher("/customer_supporter/view_customer_list.jsp").forward(request, response);
    }
    private boolean isMatch(String value, String query) {
        if (query == null || query.isEmpty()) return true;
        if (value == null) return false;
        return value.toLowerCase().contains(query.trim().toLowerCase());
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}