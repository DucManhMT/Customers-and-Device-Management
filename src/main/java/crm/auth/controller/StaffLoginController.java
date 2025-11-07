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
        HttpSession session = req.getSession();
        if (Validator.isValidUsername(username) && Validator.isValidPassword(password)) {
            Account account = LoginService.login(username, password);
            if (account != null){
                session.removeAttribute("error");
                session.setAttribute("account", account);
                switch (account.getRole().getRoleName()) {
                    case "TechnicianLeader":
                        session.removeAttribute("error");
                        resp.sendRedirect(req.getContextPath() + "/technician_leader/techlead_actioncenter");
                        return; // ✅ stop after redirect
                    case "TechnicianEmployee":
                        session.removeAttribute("error");
                        resp.sendRedirect(req.getContextPath() + "/technician_employee/techemployee_actioncenter");
                        return; // ✅ stop after redirect
                    case "CustomerSupporter":
                        session.removeAttribute("error");
                        resp.sendRedirect(req.getContextPath() + "/customer_supporter/customersupporter_actioncenter");
                        return; // ✅ stop after redirect
                    case "WarehouseKeeper":
                        session.removeAttribute("error");
                        resp.sendRedirect(req.getContextPath() + "/warehouse_keeper/warehousekeeper_actioncenter");
                        return; // ✅ stop after redirect
                    case "Admin":
                        session.removeAttribute("error");
                        resp.sendRedirect(req.getContextPath() + "/admin/admin_actioncenter");
                        return; // ✅ stop after redirect
                    case "InventoryManager":
                        session.removeAttribute("error");
                        resp.sendRedirect(req.getContextPath() + "/inventory_manager/inventorymanager_actioncenter");
                        return; // ✅ stop after redirect
                    default:
                        session.setAttribute("error", "Invalid username or password.");
                        resp.sendRedirect(req.getContextPath() + "/auth/staff_login");
                        return; // ✅ stop after forward
                }

            } else {
                session.setAttribute("error", "Invalid username or password.");
                resp.sendRedirect(req.getContextPath() + "/auth/staff_login");
                return; // ✅ stop after forward
            }

        } else {
            session.setAttribute("error", "Invalid username or password format.");
            resp.sendRedirect(req.getContextPath() + "/auth/staff_login");
            return; // ✅ stop after forward
        }
    }
}
