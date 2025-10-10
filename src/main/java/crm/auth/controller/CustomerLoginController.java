package crm.auth.controller;

import crm.auth.service.Hasher;
import crm.auth.service.LoginService;
import crm.common.model.Account;
import crm.common.repository.account.AccountDAO;
import crm.common.validator.Validator;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "CustomerLoginController", value = "/customer_login_controller")
public class CustomerLoginController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (Validator.isValidUsername(username) && Validator.isValidPassword(password)) {
            Account account = LoginService.login(username, password);
            if (account != null){
                HttpSession session = request.getSession();
                session.setAttribute("account", account);
                response.sendRedirect(request.getContextPath() + "/customer/customer_dashboard");
                return; // ✅ stop after redirect
            } else {
                request.setAttribute("error", "Invalid username or password.");
                request.getRequestDispatcher("/auth/customer_login.jsp").forward(request, response);
                return; // ✅ stop after forward
            }

        } else {
            request.setAttribute("error", "Invalid username or password format.");
            request.getRequestDispatcher("/auth/customer_login.jsp").forward(request, response);
            return; // ✅ stop after forward
        }
    }

}