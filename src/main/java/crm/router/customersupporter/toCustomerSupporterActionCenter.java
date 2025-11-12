package crm.router.customersupporter;

import crm.common.URLConstants;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "toCustomerSupporterActionCenter", value = "/customer_supporter/customersupporter_actioncenter")
public class toCustomerSupporterActionCenter extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher(URLConstants.CUSTOMER_SUPPORTER_DASHBOARD).forward(req, resp);
    }
}
