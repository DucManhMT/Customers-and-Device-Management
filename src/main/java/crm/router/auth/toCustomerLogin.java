package crm.router.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "toCustomerLogin", value = "/auth/customer_login")
public class toCustomerLogin extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
            request.getRequestDispatcher("/auth/customer_login.jsp").forward(request, response);
    }
}
