package crm.router.technicianemployee;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
@WebServlet(name = "toTechnicianEmployeeActionCenter", value = "/technicianemployee/technicianemployee_actioncenter")
public class toTechnicianEmployeeActionCenter extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/customersupporter/customersupporter_actioncenter.jsp").forward(req, resp);
    }
}
