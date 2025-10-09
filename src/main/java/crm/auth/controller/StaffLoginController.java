package crm.auth.controller;

import crm.auth.service.LoginService;
import crm.common.model.Account;
import crm.core.validator.Validator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "StaffLoginController", value = "/staff_login_controller")
public class StaffLoginController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (Validator.isValidUsername(username) && Validator.isValidPassword(password)) {
            Account account = LoginService.login(username, password);
            if (account != null){
                HttpSession session = req.getSession();
                session.setAttribute("account", account);
                resp.sendRedirect(req.getContextPath() + "/staff/staff_actioncenter");
                return; // ✅ stop after redirect
            } else {
                req.setAttribute("error", "Invalid username or password.");
                req.getRequestDispatcher("/auth/staff_login.jsp").forward(req, resp);
                return; // ✅ stop after forward
            }

        } else {
            req.setAttribute("error", "Invalid username or password format.");
            req.getRequestDispatcher("/auth/staff_login.jsp").forward(req, resp);
            return; // ✅ stop after forward
        }
    }
}
