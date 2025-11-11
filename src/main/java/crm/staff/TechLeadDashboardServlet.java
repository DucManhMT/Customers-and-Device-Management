package crm.staff;

import crm.common.URLConstants;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Tech Lead Dashboard servlet.
 * Provides a consolidated view with mini task & request metrics and navigation
 * links.
 * TODO: Replace placeholder metrics with real queries to repositories/service
 * layers
 * once those are available for technician leader role.
 */
@WebServlet(name = "TechLeadDashboardServlet", value = URLConstants.TECHLEAD_DASHBOARD)
public class TechLeadDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Placeholder demo metrics (replace with real services)
        request.setAttribute("taskTotal", 0); // total tasks matched
        request.setAttribute("taskNearDue", 0); // tasks near deadline
        request.setAttribute("taskOverdue", 0); // overdue tasks
        request.setAttribute("taskOnPage", 0); // tasks displayed on last list page

        request.setAttribute("requestTotal", 0); // approved requests total
        request.setAttribute("requestPendingAssign", 0); // approved requests not yet assigned
        request.setAttribute("requestAssigned", 0); // approved requests already assigned

        request.getRequestDispatcher("/technician_leader/techlead_dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
