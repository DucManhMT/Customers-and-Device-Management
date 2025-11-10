package crm.task.controller;

import crm.common.model.Contract;
import crm.common.model.Customer;
import crm.common.model.Request;
import crm.common.model.Task;
import crm.service_request.repository.RequestRepository;
import crm.task.service.TaskService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = "/technician_leader/requests/detail", name = "TechLeadRequestDetailController")
public class TechLeadRequestDetailController extends HttpServlet {
    private static final String ATTR_ERROR = "error";
    private static final String VIEW = "/technician_leader/view_request_detail.jsp";

    // Mark as transient to satisfy servlet serialization lint rules
    private static final RequestRepository requestRepository = new RequestRepository();
    private static final TaskService taskService = new TaskService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            handle(req, resp);
        } catch (Exception e) {
            req.setAttribute(ATTR_ERROR, "Unexpected error: " + e.getMessage());
            try {
                req.getRequestDispatcher(VIEW).forward(req, resp);
            } catch (Exception ignored) {
                // forwarding failed; nothing further we can do
            }
        }
    }

    private void handle(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String requestIdParam = req.getParameter("requestId");
        if (requestIdParam == null || requestIdParam.isBlank()) {
            // try fallback param name "id"
            requestIdParam = req.getParameter("id");
        }
        if (requestIdParam == null || requestIdParam.isBlank()) {
            Object attr = req.getAttribute("requestId");
            if (attr != null) {
                requestIdParam = String.valueOf(attr);
            }
        }
        if (requestIdParam == null || requestIdParam.isBlank()) {
            req.setAttribute(ATTR_ERROR, "requestId is required");
            req.getRequestDispatcher(VIEW).forward(req, resp);
            return;
        }

        int requestId;
        try {
            requestId = Integer.parseInt(requestIdParam.trim());
        } catch (NumberFormatException nfe) {
            req.setAttribute(ATTR_ERROR, "Invalid requestId");
            req.getRequestDispatcher(VIEW).forward(req, resp);
            return;
        }

        Request request = requestRepository.findById(requestId);
        if (request == null) {
            req.setAttribute(ATTR_ERROR, "Request not found");
            req.getRequestDispatcher(VIEW).forward(req, resp);
            return;
        }

        Contract contract = null;
        Customer customer = null;
        try {
            contract = request.getContract();
            if (contract != null) {
                customer = contract.getCustomer();
            }
        } catch (Exception ignored) {
            // allow nulls and show N/A in the view
        }

        List<Task> tasks = taskService.getTasksByRequestId(requestId);

        req.setAttribute("requestObj", request);
        req.setAttribute("contract", contract);
        req.setAttribute("customer", customer);
        req.setAttribute("tasks", tasks);

        req.getRequestDispatcher(VIEW).forward(req, resp);
    }
}
