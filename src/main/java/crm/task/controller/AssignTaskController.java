package crm.task.controller;

import crm.common.URLConstants;
import crm.common.model.Account;
import crm.common.model.Request;
import crm.common.model.Staff;
import crm.core.utils.DateTimeConverter;
import crm.task.service.TaskService;
import crm.common.model.Task;
import crm.common.model.enums.TaskStatus;
import crm.common.model.enums.RequestStatus;
import crm.task.repository.StaffRepository;
import crm.service_request.repository.RequestRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = URLConstants.TECHLEAD_ASSIGN_TASK, name = "AssignTaskController")
public class AssignTaskController extends HttpServlet {

    private final RequestRepository requestRepository = new RequestRepository();
    private final StaffRepository staffRepository = new StaffRepository();
    private final TaskService taskService = new TaskService();

    private static final String PARAM_REQUEST_ID = "requestId";
    private static final String PARAM_ASSIGN_TO = "assignTo";
    private static final String PARAM_START_DATE = "startDate";
    private static final String PARAM_DEADLINE = "deadline";
    private static final String PARAM_DESCRIPTION = "description";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Account account = (Account) req.getSession().getAttribute("account");
        if (account == null) {
            try {
                resp.sendRedirect(req.getContextPath() + "/auth/staff_login");
            } catch (IOException e) {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
            return;
        }

        Integer requestId = parseInt(req.getParameter(PARAM_REQUEST_ID));
        Integer assignToId = parseInt(req.getParameter(PARAM_ASSIGN_TO));

        Request request = requestId != null ? requestRepository.findById(requestId) : null;
        Staff assignTo = assignToId != null ? staffRepository.findById(assignToId) : null;
        Staff assignBy = staffRepository.findByUsername(account.getUsername());

        req.setAttribute("requestObj", request);
        req.setAttribute(PARAM_ASSIGN_TO, assignTo);
        req.setAttribute("assignBy", assignBy);
        req.setAttribute(PARAM_REQUEST_ID, requestId);
        req.setAttribute("assignToId", assignToId);

        // Validate request status for assignment eligibility
        if (request != null && request.getRequestStatus() != null
                && request.getRequestStatus() != RequestStatus.Approved
                && request.getRequestStatus() != RequestStatus.Processing) {
            List<String> errors = new ArrayList<>();
            errors.add("Only Approved or Processing requests can be assigned.");
            req.setAttribute("errors", errors);
        }

        // Load technician's current schedule (existing tasks)
        if (assignToId != null) {
            List<Task> assignToTasks = taskService.getTasksByStaffId(assignToId).stream()
                    .filter((t) -> t.getStatus().equals(TaskStatus.Processing)
                            || t.getStatus().equals(TaskStatus.Pending))
                    .toList();
            req.setAttribute("assignToTasks", assignToTasks);
        }

        try {
            req.getRequestDispatcher("/technician_leader/assign_task.jsp").forward(req, resp);
        } catch (ServletException | IOException e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Account account = (Account) req.getSession().getAttribute("account");
        if (account == null) {
            try {
                resp.sendRedirect(req.getContextPath() + "/auth/staff_login");
            } catch (IOException e) {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
            return;
        }

        List<String> errors = new ArrayList<>();
        Integer requestId = parseInt(req.getParameter(PARAM_REQUEST_ID));
        Integer assignToId = parseInt(req.getParameter(PARAM_ASSIGN_TO));
        String startDateStr = req.getParameter(PARAM_START_DATE);
        String deadlineStr = req.getParameter(PARAM_DEADLINE);
        String description = req.getParameter(PARAM_DESCRIPTION);

        // Validate existence of request & staff
        Request request = null;
        if (requestId == null) {
            errors.add("Missing requestId.");
        } else {
            request = requestRepository.findById(requestId);
            if (request == null) {
                errors.add("Request do not exsit.");
            } else {
                // Enforce assignment only for Approved or Processing
                RequestStatus status = request.getRequestStatus();
                if (status != RequestStatus.Approved && status != RequestStatus.Processing) {
                    errors.add("Only Approved or Processing requests can be assigned.");
                }
            }
        }
        Staff assignTo = null;
        if (assignToId == null) {
            errors.add("Missing assignTo.");
        } else {
            assignTo = staffRepository.findById(assignToId);
            if (assignTo == null) {
                errors.add("Tech employee do not exsit.");
            }
        }

        Staff assignBy = staffRepository.findByUsername(account.getUsername());
        if (assignBy == null) {
            errors.add("Assign By Unknown.");
        }

        // Required fields
        if (isBlank(startDateStr))
            errors.add("StartDate is required.");
        if (isBlank(deadlineStr))
            errors.add("Deadline is required.");
        if (isBlank(description))
            errors.add("Description is required.");

        LocalDate startDate = null;
        LocalDate deadline = null;
        LocalDate todayStart = LocalDate.now();
        if (!isBlank(startDateStr)) {
            try {
                startDate = LocalDate.parse(startDateStr);
            } catch (DateTimeParseException e) {
                errors.add("Invalid startDate.");
            }
        }
        if (!isBlank(deadlineStr)) {
            try {
                deadline = LocalDate.parse(deadlineStr);
            } catch (DateTimeParseException e) {
                errors.add("Invalid deadline.");
            }
        }
        if (startDate != null && startDate.isBefore(todayStart)) {
            errors.add("Start Date cannot be before today.");
        }
        if (deadline != null && deadline.isBefore(todayStart)) {
            errors.add("Deadline cannot be before today.");
        }
        if (startDate != null && deadline != null && deadline.isBefore(startDate)) {
            errors.add("Deadline can not before startDate.");
        }

        // Check time conflict extracted to helper
        if (errors.isEmpty() && assignToId != null && startDate != null && deadline != null
                && taskService.hasTimeConflict(assignToId, startDate, deadline)) {
            errors.add("Selected time conflicts with existing tasks or is invalid.");
        }

        if (!errors.isEmpty()) {
            // re-populate attributes and errors
            req.setAttribute("errors", errors);
            req.setAttribute("requestObj", request);
            req.setAttribute(PARAM_ASSIGN_TO, assignTo);
            req.setAttribute("assignBy", assignBy);
            req.setAttribute(PARAM_REQUEST_ID, requestId);
            req.setAttribute("assignToId", assignToId);
            req.setAttribute(PARAM_START_DATE, startDateStr);
            req.setAttribute(PARAM_DEADLINE, deadlineStr);
            req.setAttribute(PARAM_DESCRIPTION, description);
            if (assignToId != null) {
                List<Task> assignToTasks = taskService.getTasksByStaffId(assignToId).stream()
                        .filter(t -> t.getStatus().equals(TaskStatus.Processing)
                                || t.getStatus().equals(TaskStatus.Pending))
                        .toList();
                req.setAttribute("assignToTasks", assignToTasks);
            }
            try {
                doGet(req, resp);
            } catch (ServletException | IOException e) {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
            return;
        }

        // Create task
        if (assignBy != null && assignTo != null) {
            Task created = taskService.createTask(assignBy.getStaffID(), assignTo.getStaffID(), requestId,
                    DateTimeConverter.toStartOfDay(startDate), DateTimeConverter.toEndOfDay(deadline),
                    description);
            if (created == null) {
                // System error during assignment
                errors.add("Unable to assign task. Please try again later.");
                req.setAttribute("errors", errors);
                req.setAttribute("requestObj", request);
                req.setAttribute(PARAM_ASSIGN_TO, assignTo);
                req.setAttribute("assignBy", assignBy);
                req.setAttribute(PARAM_REQUEST_ID, requestId);
                req.setAttribute("assignToId", assignToId);
                req.setAttribute(PARAM_START_DATE, startDateStr);
                req.setAttribute(PARAM_DEADLINE, deadlineStr);
                req.setAttribute(PARAM_DESCRIPTION, description);
                if (assignToId != null) {
                    List<Task> assignToTasks = taskService.getTasksByStaffId(assignToId).stream()
                            .filter(t -> t.getStatus().equals(TaskStatus.Processing)
                                    || t.getStatus().equals(TaskStatus.Pending))
                            .toList();
                    req.setAttribute("assignToTasks", assignToTasks);
                }
                try {
                    doGet(req, resp);
                } catch (ServletException | IOException e) {
                    resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                }
                return;
            }
        }

        // Redirect về danh sách task theo request để xem
        try {
            resp.sendRedirect(
                    req.getContextPath() + URLConstants.TECHLEAD_SELECT_TECHNICIAN + "?selectedTasks=" + requestId);
        } catch (IOException e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private Integer parseInt(String s) {
        try {
            return (s == null || s.isBlank()) ? null : Integer.parseInt(s);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private boolean isBlank(String s) {
        return s == null || s.isBlank();
    }

}
