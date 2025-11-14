package crm.staff;

import crm.common.URLConstants;
import crm.service_request.service.RequestService;
import crm.task.dto.TaskMetrics;
import crm.task.service.TaskMetricsService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

@WebServlet(name = "TechLeadDashboardServlet", value = URLConstants.TECHLEAD_DASHBOARD)
public class TechLeadDashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // --- Task metrics (in-memory filtering) ---
        TaskMetrics metrics = new TaskMetricsService()
                .getMetrics();
        request.setAttribute("taskPending", metrics.getPending());
        request.setAttribute("taskProcessing", metrics.getProcessing());
        request.setAttribute("taskFinished", metrics.getFinished());
        request.setAttribute("taskRejected", metrics.getRejected());
        request.setAttribute("taskOverdue", metrics.getOverdue());
        request.setAttribute("taskTotal", metrics.getTotal());

        // --- Request metrics via RequestService (Approved, Processing, Finished) ---
        RequestService reqService = new RequestService();
        Map<String, Integer> reqStats = reqService.statisticRequestsByStatus(null, null);
        int approved = reqStats.getOrDefault("Approved", 0);
        int processing = reqStats.getOrDefault("Processing", 0);
        int finished = reqStats.getOrDefault("Finished", 0);
        int techFinished = reqStats.getOrDefault("Tech_Finished", 0);
        request.setAttribute("reqApproved", approved);
        request.setAttribute("reqProcessing", processing);
        request.setAttribute("reqFinished", finished);
        request.setAttribute("reqTechFinished", techFinished);

        request.getRequestDispatcher("/technician_leader/techlead_dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
