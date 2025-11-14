package crm.customer.controller;

import crm.common.URLConstants;
import crm.common.model.Customer;

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

@WebServlet(name = "EditProfileServlet", value = URLConstants.CUSTOMER_EDIT_PROFILE)
public class EditProfileServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("id");
        EntityManager em = new EntityManager(DBcontext.getConnection());

        Map<String, Object> cond = new HashMap<>();
        cond.put("account", username);
        Customer customer = em.findWithConditions(Customer.class, cond).get(0);

        request.setAttribute("accountName", customer.getCustomerName());
        request.setAttribute("accountEmail", customer.getEmail());
        request.setAttribute("accountPhone", customer.getPhone());
        request.setAttribute("accountAddress", customer.getAddress());

        request.setAttribute("username", username);
        request.getRequestDispatcher("/customer/edit_profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        String username = request.getParameter("id");

        String accountName = request.getParameter("accountName");
        if (!Validator.isValidName(accountName)) {
            request.getSession().setAttribute("error", "Account name contains invalid characters.");
            response.sendRedirect(request.getContextPath() + "/customer/profile/edit?id=" + username);
            return;
        }
        String accountEmail = request.getParameter("accountEmail");
        if (!Validator.isValidEmail(accountEmail)) {
            request.getSession().setAttribute("error", "Invalid email format.");
            response.sendRedirect(request.getContextPath() + "/customer/profile/edit?id=" + username);
            return;
        }
        String accountPhone = request.getParameter("accountPhone");
        if (!Validator.isValidPhone(accountPhone)) {
            request.getSession().setAttribute("error", "Invalid phone number format.");
            response.sendRedirect(request.getContextPath() + "/customer/profile/edit?id=" + username);
            return;
        }
        // Tìm customer hiện tại
        Customer currentCustomer = em.findWithConditions(Customer.class, Map.of("account", username)).get(0);

        // Tìm tất cả có cùng số điện thoại, trừ chính mình
        List<Customer> existingPhones = em.findWithConditions(Customer.class, Map.of("phone", accountPhone))
                .stream()
                .filter(c -> !c.getCustomerID().equals(currentCustomer.getCustomerID()))
                .toList();

        if (!existingPhones.isEmpty()) {
            request.getSession().setAttribute("error", "Phone number already in use by another customer.");
            response.sendRedirect(request.getContextPath() + "/customer/profile/edit?id=" + username);
            return;
        }

        String accountAddress = request.getParameter("accountAddress");
        Map<String, Object> cond = new HashMap<>();
        cond.put("account", username);
        Customer customer = em.findWithConditions(Customer.class, cond).get(0);
        customer.setCustomerName(accountName);
        customer.setEmail(accountEmail);
        customer.setPhone(accountPhone);
        customer.setAddress(accountAddress);
        em.merge(customer, Customer.class);

        request.getSession().setAttribute("success", "Account updated successfully.");
        response.sendRedirect(request.getContextPath() + "/customer/profile/edit?id=" + username);
    }
}