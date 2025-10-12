package crm.auth.controller;

import crm.common.model.*;
import crm.common.model.enums.AccountStatus;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.service.IDGeneratorService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "CustomerRegisterController", value = "/auth/customer_register_controller")
public class CustomerRegisterController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = new EntityManager(DBcontext.getConnection());



        // Account details
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        Role role = em.find(Role.class, 2);

        Account newAccount = new Account();
        newAccount.setUsername(username);
        newAccount.setPasswordHash(password);
        newAccount.setRole(role);
        newAccount.setAccountStatus(AccountStatus.Active);

        boolean hasAccount = em.persist(newAccount, Account.class);
        // Customer details
        String firstName = req.getParameter("firstName");
        String lastName = req.getParameter("lastName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String provinceID = req.getParameter("province");
        String villageID = req.getParameter("village");
        String address = req.getParameter("address");

        String fullName = firstName + " " + lastName;
        String provinceName = em.find(Province.class, Integer.parseInt(provinceID)).getProvinceName();
        String villageName = em.find(Village.class, Integer.parseInt(villageID)).getVillageName();
        String fullAddress = address + ", " + villageName + ", " + provinceName;

        Customer newCustomer = new Customer();
        newCustomer.setCustomerID(IDGeneratorService.generateID(Customer.class));
        newCustomer.setCustomerName(fullName);
        newCustomer.setPhone(phone);
        newCustomer.setEmail(email);
        newCustomer.setAddress(fullAddress);
        newCustomer.setAccount(newAccount);

        boolean hasCustomer = em.persist(newCustomer, Customer.class);

        if (hasAccount && hasCustomer) {
            req.getSession().setAttribute("registerMessage", "Registration successful!");
            req.getSession().setAttribute("registerStatus", "success");
        } else {
            req.getSession().setAttribute("registerMessage", "Registration failed. Please try again.");
            req.getSession().setAttribute("registerStatus", "error");
        }

// Redirect back to registration page
        resp.sendRedirect(req.getContextPath() + "/auth/customer_register");

        // You can now use these variables for registration logic
    }
}