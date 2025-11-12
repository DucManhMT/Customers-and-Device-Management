package crm.customersupporter;

import crm.common.URLConstants;
import crm.service_request.service.RequestService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Map;

@WebServlet(name = "CustomerSupporterDashboardServlet", urlPatterns = URLConstants.CUSTOMER_SUPPORTER_DASHBOARD)
public class CustomerSupporterDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get statistics for all request statuses (no date filter per requirement)
        RequestService requestService = new RequestService();
        Map<String, Integer> stats = requestService.statisticRequestsByStatus(null, null);

        request.setAttribute("requestStats", stats);
        request.setAttribute("totalRequests", stats != null && stats.get("All") != null ? stats.get("All") : 0);

        request.getRequestDispatcher("/customer_supporter/supporter_dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}
