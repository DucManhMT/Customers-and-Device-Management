package crm.admin;

import crm.common.URLConstants;
import crm.common.model.Account;
import crm.common.model.Customer;
import crm.common.model.Role;
import crm.common.model.Staff;
import crm.common.model.enums.RoleStatus;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.validator.Validator;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "EditAccountServlet", value = URLConstants.ADMIN_EDIT_ACCOUNT)
public class EditAccountServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("id");
        String role = request.getParameter("role");
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
            request.setAttribute("role", roleName);

        }

        List<Role> allRoles = em.findAll(Role.class);

        List<Role> filteredRoles = allRoles.stream()
                .filter(r -> r.getRoleID() != 1)
                .filter(r-> r.getRoleStatus() == RoleStatus.Active)
                .filter(r -> {
                    if (Integer.parseInt(role) != 2) {
                        return r.getRoleID() != 2;
                    }
                    return true;
                })
                .toList();
        request.setAttribute("allRole", filteredRoles);

        request.setAttribute("username", username);
        request.setAttribute("roleID", role);
        request.getRequestDispatcher("/admin/edit_account.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        String username = request.getParameter("id");
        String role = request.getParameter("role");

        String accountName = request.getParameter("accountName");
        if (!Validator.isValidName(accountName)) {
            request.getSession().setAttribute("error", "Account name contains invalid characters.");
            response.sendRedirect(request.getContextPath() + "/admin/account_list/edit_account?id=" + username + "&role=" + role);
            return;
        }
        String accountEmail = request.getParameter("accountEmail");
        if (!Validator.isValidEmail(accountEmail)) {
            request.getSession().setAttribute("error", "Invalid email format.");
            response.sendRedirect(request.getContextPath() + "/admin/account_list/edit_account?id=" + username + "&role=" + role);
            return;
        }
        String accountPhone = request.getParameter("accountPhone");
        if (!Validator.isValidPhone(accountPhone)) {
            request.getSession().setAttribute("error", "Invalid phone number format.");
            response.sendRedirect(request.getContextPath() + "/admin/account_list/edit_account?id=" + username + "&role=" + role);
            return;
        }
        if (Integer.parseInt(role) == 2) { // Customer

            Customer currentCustomer = em.findWithConditions(Customer.class, Map.of("account", username)).get(0);

// Tìm tất cả có cùng số điện thoại, trừ chính mình
            List<Customer> existingPhones = em.findWithConditions(Customer.class, Map.of("phone", accountPhone))
                    .stream()
                    .filter(c -> !c.getCustomerID().equals(currentCustomer.getCustomerID()))
                    .toList();

            if (!existingPhones.isEmpty()) {
                request.getSession().setAttribute("error", "Phone number already in use by another customer.");
                response.sendRedirect(request.getContextPath() + "/admin/account_list/edit_account?id=" + username + "&role=" + role);
                return;
            }
        } else { // Staff
            Map<String, Object> cond = new HashMap<>();
            cond.put("account", username);
            Staff currentStaff = em.findWithConditions(Staff.class, cond).get(0);
            List<Staff> existingPhones = em.findWithConditions(Staff.class, Map.of("phone", accountPhone))
                    .stream()
                    .filter(s -> !s.getStaffID().equals(currentStaff.getStaffID()))
                    .toList();

            if (!existingPhones.isEmpty()) {
                request.setAttribute("error", "Phone number already in use by another staff.");
                response.sendRedirect(request.getContextPath() + "/admin/account_list/edit_account?id=" + username + "&role=" + role);
                return;
            }
        }
        String accountAddress = request.getParameter("accountAddress");
        String newpassword = request.getParameter("newPassword");
        if (Integer.parseInt(role) == 2) {
            Map<String, Object> cond = new HashMap<>();
            cond.put("account", username);
            Customer customer = em.findWithConditions(Customer.class, cond).get(0);
            customer.setCustomerName(accountName);
            customer.setEmail(accountEmail);
            customer.setPhone(accountPhone);
            customer.setAddress(accountAddress);
            em.merge(customer, Customer.class);


        } else {
            Map<String, Object> cond = new HashMap<>();
            cond.put("account", username);
            Staff staff = em.findWithConditions(Staff.class, cond).get(0);
            staff.setStaffName(accountName);
            staff.setEmail(accountEmail);
            staff.setPhone(accountPhone);
            staff.setAddress(accountAddress);
            em.merge(staff, Staff.class);

        }

        Account account = em.find(Account.class, username);
        if (newpassword != null && !newpassword.isEmpty()) {
            account.setPasswordHash(newpassword);
        }
        if (Integer.parseInt(role)!= 2 && role != null && !role.isEmpty()) {
            String roleSelect = request.getParameter("roleSelect");
            Role newRole = em.find(Role.class, Integer.parseInt(roleSelect));
            if (newRole != null) {
                account.setRole(newRole);
            }
        }

        em.merge(account, Account.class);
        request.getSession().setAttribute("success", "Account updated successfully.");
        response.sendRedirect(request.getContextPath() + "/admin/account_list");

    }
}