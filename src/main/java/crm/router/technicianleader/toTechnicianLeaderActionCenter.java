package crm.router.technicianleader;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "toTechnicianLeaderActionCenter", value = "/technicianleader/technicianleader_actioncenter")
public class toTechnicianLeaderActionCenter extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.getRequestDispatcher("/technician_leader/techlead_actioncenter.jsp").forward(request, response);
    }
}
