package crm.task.controller;

import crm.common.model.Task;
import crm.service_request.repository.persistence.query.common.Page;
import crm.task.dto.TaskFilter;
import crm.task.service.TaskService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@WebServlet(urlPatterns = "/technician_leader/tasks/list", name = "ViewTaskListController")
public class ViewTaskListController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int page = 1;
            int recordsPerPage = 15;
            String pageParam = req.getParameter("page");
            String rppParam = req.getParameter("recordsPerPage");
            if (pageParam != null && !pageParam.isBlank()) {
                page = Integer.parseInt(pageParam);
            }
            if (rppParam != null && !rppParam.isBlank()) {
                recordsPerPage = Integer.parseInt(rppParam);
            }

            // Collect filters
            TaskFilter filter = new TaskFilter();
            String reqIdParam = req.getParameter("requestId");
            if (reqIdParam != null && !reqIdParam.isBlank()) {
                filter.setRequestId(Integer.parseInt(reqIdParam));
            }
            filter.setStatus(req.getParameter("status"));
            filter.setStaffName(req.getParameter("staffName"));
            String nearDue = req.getParameter("nearDue");
            String overdue = req.getParameter("overdue");
            filter.setNearDue("on".equalsIgnoreCase(nearDue) || "true".equalsIgnoreCase(nearDue));
            filter.setOverdue("on".equalsIgnoreCase(overdue) || "true".equalsIgnoreCase(overdue));
            String nearDueDays = req.getParameter("nearDueDays");
            if (nearDueDays != null && !nearDueDays.isBlank()) {
                filter.setNearDueHours(Integer.parseInt(nearDueDays)); // reused as days
            }
            String sortDir = req.getParameter("sortDir");
            filter.setSortDir(sortDir == null || sortDir.isBlank() ? "asc" : sortDir);
            filter.setPage(page);
            filter.setSize(recordsPerPage);

            TaskService taskService = new TaskService();
            Page<Task> taskPage = taskService.searchTasks(filter);

            req.setAttribute("currentPage", page);
            req.setAttribute("recordsPerPage", recordsPerPage);
            req.setAttribute("totalPages", taskPage != null ? taskPage.getTotalPages() : 1);
            req.setAttribute("totalRecords", taskPage != null ? taskPage.getTotalElements() : 0);
            req.setAttribute("tasks", taskPage != null ? taskPage.getContent() : null);
            req.setAttribute("isFirstPage", taskPage == null || taskPage.isFirst());
            req.setAttribute("isLastPage", taskPage == null || taskPage.isLast());
            req.setAttribute("requestId", filter.getRequestId());
            req.setAttribute("status", filter.getStatus());
            req.setAttribute("staffName", filter.getStaffName());
            req.setAttribute("sortDir", filter.getSortDir());
            req.setAttribute("nearDue", filter.getNearDue());
            req.setAttribute("overdue", filter.getOverdue());
            req.setAttribute("nearDueHours", filter.getNearDueHours());

            // Build highlight maps for JSP (near due & overdue)
            Map<Integer, Boolean> nearDueMap = new HashMap<>();
            Map<Integer, Boolean> overdueMap = new HashMap<>();
            if (taskPage != null && taskPage.getContent() != null) {
                LocalDateTime now = LocalDateTime.now();
                int days = filter.getNearDueHours() == null ? 1 : filter.getNearDueHours();
                LocalDateTime edge = now.plusDays(days);
                for (Task t : taskPage.getContent()) {
                    if (t == null || t.getDeadline() == null)
                        continue;
                    if (t.getDeadline().isBefore(now)) {
                        overdueMap.put(t.getTaskID(), Boolean.TRUE);
                    } else if ((t.getDeadline().isEqual(now) || t.getDeadline().isAfter(now))
                            && (t.getDeadline().isBefore(edge) || t.getDeadline().isEqual(edge))) {
                        nearDueMap.put(t.getTaskID(), Boolean.TRUE);
                    }
                }
            }
            req.setAttribute("nearDueMap", nearDueMap);
            req.setAttribute("overdueMap", overdueMap);

            // Mini dashboard (trên trang hiện tại)
            int pageCount = (taskPage != null && taskPage.getContent() != null) ? taskPage.getContent().size() : 0;
            int nearDueCount = nearDueMap.size();
            int overdueCount = overdueMap.size();
            long totalMatched = taskPage != null ? taskPage.getTotalElements() : 0L;
            java.util.Map<String, Integer> statusCounts = new java.util.HashMap<>();
            if (taskPage != null && taskPage.getContent() != null) {
                for (Task t : taskPage.getContent()) {
                    String st = (t != null && t.getStatus() != null) ? t.getStatus().name() : "UNKNOWN";
                    statusCounts.put(st, statusCounts.getOrDefault(st, 0) + 1);
                }
            }
            req.setAttribute("dashboardTotalMatched", totalMatched);
            req.setAttribute("dashboardPageCount", pageCount);
            req.setAttribute("dashboardNearDueCount", nearDueCount);
            req.setAttribute("dashboardOverdueCount", overdueCount);
            req.setAttribute("dashboardStatusCounts", statusCounts);
        } catch (Exception e) {
            req.setAttribute("error", "Có lỗi xảy ra khi hiển thị danh sách task.");
        } finally {
            try {
                req.getRequestDispatcher("/technician_leader/view_task_list.jsp").forward(req, resp);
            } catch (Exception ex) {
                // Log and fallback: send simple error
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Forward error");
            }
        }
    }
}
