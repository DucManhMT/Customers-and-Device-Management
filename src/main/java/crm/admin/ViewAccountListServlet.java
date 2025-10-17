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

        // Search parameters
        String searchUsername = request.getParameter("searchUsername");
        String searchName = request.getParameter("searchName");
        String searchEmail = request.getParameter("searchEmail");
        String roleFilter = request.getParameter("roleFilter");
        String statusFilter = request.getParameter("statusFilter");

        // Order by username
        Map<String, SortDirection> orderConditions = new HashMap<>();
        orderConditions.put("username", SortDirection.ASC);

        // Lấy danh sách role cho dropdown
        List<Role> roleList = em.findAll(Role.class);

        // Query tất cả account (không áp dụng search cứng ở query mà sẽ lọc mềm phía dưới)
        List<Account> accounts = em.findWithOrderAndPagination(Account.class, orderConditions, recordsPerPage, offset);
        int totalRecords = em.count(Account.class);
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        // Chuẩn bị accountInfos cho JSP
        List<Map<String, Object>> accountInfos = new ArrayList<>();
        for (Account acc : accounts) {
            // Nếu role là "id1" thì bỏ qua
            if (acc.getRole() != null && acc.getRole().getRoleID() == 1) {
                continue;
            }
            String username = acc.getUsername();
            String email = null;
            String name = null;
            Role roleObj = acc.getRole();
            String status = acc.getAccountStatus().toString();

            // Lấy tên và email từ Customer hoặc Staff
            Map<String, Object> condCustomer = new HashMap<>();
            condCustomer.put("account", username);
            List<Customer> customers = em.findWithConditions(Customer.class, condCustomer);
            if (!customers.isEmpty()) {
                name = customers.get(0).getCustomerName();
                email = customers.get(0).getEmail();
            } else {
                Map<String, Object> condStaff = new HashMap<>();
                condStaff.put("account", username);
                List<Staff> staffs = em.findWithConditions(Staff.class, condStaff);
                if (!staffs.isEmpty()) {
                    name = staffs.get(0).getStaffName();
                    email = staffs.get(0).getEmail();
                }
            }

            // Search từng ký tự, chỉ lọc field có nhập, field khác để trống thì bỏ qua
            if (!isMatch(username, searchUsername)
                    || !isMatch(name, searchName)
                    || !isMatch(email, searchEmail)
                    || !isMatch(roleObj != null ? String.valueOf(roleObj.getRoleID()) : null, roleFilter)
                    || !isMatch(status, statusFilter)) {
                continue;
            }

            Map<String, Object> info = new HashMap<>();
            info.put("username", username);
            info.put("name", name);
            info.put("email", email);
            info.put("role", roleObj);
            info.put("status", status);
            accountInfos.add(info);
        }

        request.setAttribute("accountInfos", accountInfos);
        request.setAttribute("roleList", roleList);
        request.setAttribute("count", totalRecords);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("itemsPerPage", recordsPerPage);

        // Để giữ lại giá trị filter trên trang
        request.setAttribute("searchUsername", searchUsername);
        request.setAttribute("searchName", searchName);
        request.setAttribute("searchEmail", searchEmail);
        request.setAttribute("roleFilter", roleFilter);
        request.setAttribute("statusFilter", statusFilter);

        request.getRequestDispatcher("/admin/view_account_list.jsp").forward(request, response);
    }

    // Hàm so khớp từng field, cho phép tìm gần đúng và không cần nhập hết
    private boolean isMatch(String value, String query) {
        if (query == null || query.isEmpty()) return true; // không lọc nếu bỏ trống
        if (value == null) return false;
        return value.toLowerCase().contains(query.trim().toLowerCase());
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}