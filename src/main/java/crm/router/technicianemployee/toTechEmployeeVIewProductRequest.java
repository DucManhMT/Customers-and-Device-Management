package crm.router.technicianemployee;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "toTechEmployeeVIewProductRequest", value = "/technician_employee/view_product_request")
public class toTechEmployeeVIewProductRequest extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/technician_employee/techemp_view_product_request.jsp").forward(req, resp);
    }
}
