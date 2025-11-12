package crm.router.technicianleader;

import crm.common.URLConstants;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "toTechnicianLeaderActionCenter", value = "/technician_leader/techlead_actioncenter")
public class toTechnicianLeaderActionCenter extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.getRequestDispatcher(URLConstants.TECHLEAD_DASHBOARD).forward(request, response);
    }
}
