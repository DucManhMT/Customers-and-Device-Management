package crm.router.auth;

import crm.common.URLConstants;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "toStaffLogin", value = URLConstants.AUTH_STAFF_LOGIN)
public class toStaffLogin extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/auth/staff_login.jsp").forward(req, resp);
    }
}