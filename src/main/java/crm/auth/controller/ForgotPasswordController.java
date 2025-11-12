package crm.auth.controller;

import crm.auth.service.NewPasswordService;
import crm.common.model.Customer;
import crm.common.model.Staff;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ForgotPasswordController", urlPatterns = "/auth/forgot_password_controller")
public class ForgotPasswordController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        EntityManager em = new EntityManager(DBcontext.getConnection());
        Map<String, Object> conditions = new HashMap<>();
        conditions.put("account", username);
        try {
            List<Customer> customers =  em.findWithConditions(Customer.class, conditions);
            List<Staff> staffs = em.findWithConditions(Staff.class, conditions);
            if (staffs.isEmpty() && customers.isEmpty()) {
                req.setAttribute("error", "Username does not exist.");
                req.getRequestDispatcher("/auth/forgot_password").forward(req, resp);
                return;
            }
            String email = "";
            if (!staffs.isEmpty()) {
                email = staffs.get(0).getEmail();
            }
            if (!customers.isEmpty()) {
                email = customers.get(0).getEmail();
            }

            boolean emailSent = NewPasswordService.sendNewPassword(email);
            if (emailSent) {
                req.setAttribute("success", "A new password has been sent to your email.");
                req.getRequestDispatcher("/auth/forgot_password").forward(req, resp);
                System.out.println("New password email sent successfully to " + email);
                return;
            } else {
                req.setAttribute("error", "Failed to send new password email. Please try again.");
                req.getRequestDispatcher("/auth/forgot_password").forward(req, resp);
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to send new password email. Please try again.");
            req.getRequestDispatcher("/auth/forgot_password").forward(req, resp);
            return;
        }
    }
}
