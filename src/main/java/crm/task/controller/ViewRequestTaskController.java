package crm.task.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

import crm.common.model.Task;
import crm.task.service.TaskService;

@WebServlet(urlPatterns = "/tasks/viewRequest", name = "ViewRequestTaskController")
public class ViewRequestTaskController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String requestIdParam = req.getParameter("requestId");
        try {
            if (requestIdParam == null || requestIdParam.isEmpty()) {
                throw new IllegalArgumentException();
            }
            int requestId = Integer.parseInt(requestIdParam);
            req.setAttribute("requestId", requestId);
            List<Task> tasks = new TaskService().getTasksByRequestId(requestId);
            req.setAttribute("tasks", tasks);
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", "Invalid request ID.");
        }
        req.getRequestDispatcher("/technician_leader/view_request_task.jsp").forward(req, resp);
    }
}
