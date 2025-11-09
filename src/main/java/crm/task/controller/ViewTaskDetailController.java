package crm.task.controller;

import crm.common.model.Contract;
import crm.common.model.Customer;
import crm.common.model.Request;
import crm.common.model.Staff;
import crm.common.model.Task;
import crm.task.service.TaskService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(urlPatterns = "/technician_leader/tasks/detail", name = "ViewTaskDetailController")
public class ViewTaskDetailController extends HttpServlet {

    private static final String ATTR_ERROR = "error";
    private static final String VIEW = "/technician_leader/view_task_detail.jsp";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            handle(req, resp);
        } catch (Exception e) {
            req.setAttribute(ATTR_ERROR, "Unexpected error: " + e.getMessage());
            try {
                req.getRequestDispatcher(VIEW).forward(req, resp);
            } catch (Exception ignored) {
                // give up if forwarding fails
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            handle(req, resp);
        } catch (Exception e) {
            req.setAttribute(ATTR_ERROR, "Unexpected error: " + e.getMessage());
            try {
                req.getRequestDispatcher(VIEW).forward(req, resp);
            } catch (Exception ignored) {
                // give up if forwarding fails
            }
        }
    }

    private void handle(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String taskIdParam = req.getParameter("taskId");
        if (taskIdParam == null || taskIdParam.isBlank()) {
            req.setAttribute(ATTR_ERROR, "taskId is required");
            req.getRequestDispatcher(VIEW).forward(req, resp);
            return;
        }

        int taskId;
        try {
            taskId = Integer.parseInt(taskIdParam.trim());
        } catch (NumberFormatException nfe) {
            req.setAttribute(ATTR_ERROR, "Invalid taskId");
            req.getRequestDispatcher(VIEW).forward(req, resp);
            return;
        }

        TaskService taskService = new TaskService();
        Task task = taskService.getTaskById(taskId);
        if (task == null) {
            req.setAttribute(ATTR_ERROR, "Task not found");
            req.getRequestDispatcher(VIEW).forward(req, resp);
            return;
        }

        // Resolve assignment and request hierarchy details
        Staff assignBy = null;
        Staff assignTo = null;
        Request request = null;
        Contract contract = null;
        Customer customer = null;
        try {
            assignBy = task.getAssignBy();
        } catch (Exception ignored) {
            // Lazy fetch or mapping issue; allow null to be shown as N/A in view
        }
        try {
            assignTo = task.getAssignTo();
        } catch (Exception ignored) {
            // Lazy fetch or mapping issue; allow null to be shown as N/A in view
        }
        try {
            request = task.getRequest();
            if (request != null) {
                contract = request.getContract();
                if (contract != null) {
                    customer = contract.getCustomer();
                }
            }
        } catch (Exception ignored) {
            // Safe to ignore optional nested references
        }

        req.setAttribute("task", task);
        req.setAttribute("assignBy", assignBy);
        req.setAttribute("assignTo", assignTo);
        req.setAttribute("requestObj", request);
        req.setAttribute("contract", contract);
        req.setAttribute("customer", customer);

        req.getRequestDispatcher(VIEW).forward(req, resp);
    }
}
