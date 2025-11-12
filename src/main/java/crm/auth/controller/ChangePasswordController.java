package crm.auth.controller;

import crm.auth.service.Hasher;
import crm.auth.service.NewPasswordService;
import crm.common.model.Account;
import crm.core.validator.Validator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ChangePasswordController", value = "/auth/change_password_controller")
public class ChangePasswordController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String oldPass = req.getParameter("oldPassword");
        String newPass = req.getParameter("newPassword");
        HttpSession session = req.getSession(false);
        if (!Validator.isValidPassword(newPass)) {
            session.setAttribute("error", "New password is invalid.");
            resp.sendRedirect(req.getContextPath()+ "/auth/change_password");
            return;
        }

        if (session != null && session.getAttribute("account") != null) {
            try{
                Account account = (Account) session.getAttribute("account");
                if (!account.getPasswordHash().equals(Hasher.hashPassword(oldPass))) {
                    session.setAttribute("success", "Password changed successfully.");
                    resp.sendRedirect(req.getContextPath()+ "/auth/change_password");
                    return;
                }
                boolean success = NewPasswordService.changePassword(newPass, account);
                if (success) {
                    session.setAttribute("success", "Password changed successfully.");
                } else {
                    session.setAttribute("error", "Failed to change password. Please try again.");
                }
                resp.sendRedirect(req.getContextPath()+ "/auth/change_password");
            }catch (Exception e){
                e.printStackTrace();
            }
        }
    }
}
