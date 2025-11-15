package crm.task.controller;

import crm.common.URLConstants;
import crm.common.model.Account;
import crm.common.model.Staff;
import crm.common.model.Task;
import crm.common.model.enums.TaskStatus;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet(name = "viewAssignedTask", urlPatterns = { URLConstants.TECHEM_VIEW_ASSIGNED_TASK })
public class viewAssignedTask extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        loadTasks(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String statusFilter = request.getParameter("statusFilter");
        String sortBy = request.getParameter("sortBy");
        String pageStr = request.getParameter("page");
        String pageSizeStr = request.getParameter("pageSize");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");

        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);

        int page = 1;
        int pageSize = 6;
        try {
            if (pageStr != null && !pageStr.isEmpty()) {
                page = Integer.parseInt(pageStr);
            }
            if (pageSizeStr != null && !pageSizeStr.isEmpty()) {
                pageSize = Integer.parseInt(pageSizeStr);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);

        loadTasks(request, response);
    }

    private void loadTasks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String successMessage = (String) request.getSession().getAttribute("successMessage");
        String errorMessage = (String) request.getSession().getAttribute("errorMessage");

        if (successMessage != null) {
            request.setAttribute("successMessage", successMessage);
            request.getSession().removeAttribute("successMessage");
        }

        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
            request.getSession().removeAttribute("errorMessage");
        }

        try {
            EntityManager entityManager = new EntityManager(DBcontext.getConnection());

            Account account = (Account) request.getSession().getAttribute("account");
            if (account == null) {
                response.sendRedirect(request.getContextPath() + URLConstants.AUTH_CUSTOMER_LOGIN);
                return;
            }
            String username = account.getUsername();
            if (username == null || username.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + URLConstants.AUTH_CUSTOMER_LOGIN);
                return;
            }

            String statusFilter = (String) request.getAttribute("statusFilter");
            String sortBy = (String) request.getAttribute("sortBy");
            String fromDate = (String) request.getAttribute("fromDate");
            String toDate = (String) request.getAttribute("toDate");
            Integer currentPage = (Integer) request.getAttribute("currentPage");
            Integer pageSize = (Integer) request.getAttribute("pageSize");

            if (currentPage == null)
                currentPage = 1;
            if (pageSize == null)
                pageSize = 6;

            // Get current user's staff record
            List<Staff> allStaff = entityManager.findAll(Staff.class);
            Staff currentStaff = allStaff.stream()
                    .filter(s -> s.getAccount() != null && username.equals(s.getAccount().getUsername()))
                    .findFirst()
                    .orElse(null);

            if (currentStaff == null) {
                request.setAttribute("errorMessage", "Staff record not found for current user.");
                request.setAttribute("assignedTasks", Collections.emptyList());
                request.setAttribute("currentPage", currentPage);
                request.setAttribute("pageSize", pageSize);
                request.setAttribute("totalCount", 0);
                request.setAttribute("totalPages", 1);
                request.setAttribute("startItem", 0);
                request.setAttribute("endItem", 0);
                request.setAttribute("totalTasks", 0);
                request.setAttribute("processingTasks", 0);
                request.setAttribute("finishedTasks", 0);
                request.getRequestDispatcher("/technician_employee/view_assigned_tasks.jsp").forward(request, response);
                return;
            }

            // Get all tasks assigned TO current technician (not Pending or Rejected)
            List<Task> allTasks = entityManager.findAll(Task.class);
            System.out.println("DEBUG viewAssignedTask: Total tasks in DB: " + allTasks.size());

            List<Task> myTasks = allTasks.stream()
                    .filter(task -> task != null)
                    .filter(task -> task.getAssignTo() != null)
                    .filter(task -> currentStaff.getStaffID().equals(task.getAssignTo().getStaffID()))
                    .filter(task -> task.getStatus() == TaskStatus.Processing
                            || task.getStatus() == TaskStatus.Finished)
                    .collect(Collectors.toList());

            System.out.println("DEBUG viewAssignedTask: My tasks (Processing/Finished): " + myTasks.size());

            if (myTasks.isEmpty()) {
                request.setAttribute("assignedTasks", Collections.emptyList());
                request.setAttribute("currentPage", currentPage);
                request.setAttribute("pageSize", pageSize);
                request.setAttribute("totalCount", 0);
                request.setAttribute("totalPages", 1);
                request.setAttribute("startItem", 0);
                request.setAttribute("endItem", 0);
                request.setAttribute("totalTasks", 0);
                request.setAttribute("processingTasks", 0);
                request.setAttribute("finishedTasks", 0);
                request.getRequestDispatcher("/technician_employee/view_assigned_tasks.jsp").forward(request, response);
                return;
            }

            // Filter by status
            List<Task> filteredTasks = myTasks;
            if (statusFilter != null && !statusFilter.isEmpty() && !"all status".equalsIgnoreCase(statusFilter)) {
                if ("processing".equals(statusFilter)) {
                    filteredTasks = myTasks.stream()
                            .filter(task -> TaskStatus.Processing.equals(task.getStatus()))
                            .collect(Collectors.toList());
                } else if ("finished".equals(statusFilter)) {
                    filteredTasks = myTasks.stream()
                            .filter(task -> TaskStatus.Finished.equals(task.getStatus()))
                            .collect(Collectors.toList());
                }
            }

            // Filter by date range (using Task startDate or Request startDate)
            if ((fromDate != null && !fromDate.isEmpty()) || (toDate != null && !toDate.isEmpty())) {
                filteredTasks = filteredTasks.stream()
                        .filter(task -> {
                            LocalDateTime taskDateTime = task.getStartDate();
                            if (taskDateTime == null && task.getRequest() != null) {
                                taskDateTime = task.getRequest().getStartDate();
                            }
                            if (taskDateTime == null)
                                return false;

                            LocalDate taskDate = taskDateTime.toLocalDate();
                            boolean passFromDate = true;
                            boolean passToDate = true;

                            if (fromDate != null && !fromDate.isEmpty()) {
                                try {
                                    LocalDate from = LocalDate.parse(fromDate);
                                    passFromDate = !taskDate.isBefore(from);
                                } catch (DateTimeParseException e) {
                                    passFromDate = true;
                                }
                            }

                            if (toDate != null && !toDate.isEmpty()) {
                                try {
                                    LocalDate to = LocalDate.parse(toDate);
                                    passToDate = !taskDate.isAfter(to);
                                } catch (DateTimeParseException e) {
                                    passToDate = true;
                                }
                            }

                            return passFromDate && passToDate;
                        })
                        .collect(Collectors.toList());
            }

            // Sort tasks
            if (sortBy != null && !sortBy.isEmpty()) {
                if ("newest".equals(sortBy)) {
                    filteredTasks.sort((t1, t2) -> {
                        LocalDateTime d1 = t1.getStartDate() != null ? t1.getStartDate()
                                : (t1.getRequest() != null ? t1.getRequest().getStartDate() : null);
                        LocalDateTime d2 = t2.getStartDate() != null ? t2.getStartDate()
                                : (t2.getRequest() != null ? t2.getRequest().getStartDate() : null);
                        if (d2 != null && d1 != null)
                            return d2.compareTo(d1);
                        return 0;
                    });
                } else if ("oldest".equals(sortBy)) {
                    filteredTasks.sort((t1, t2) -> {
                        LocalDateTime d1 = t1.getStartDate() != null ? t1.getStartDate()
                                : (t1.getRequest() != null ? t1.getRequest().getStartDate() : null);
                        LocalDateTime d2 = t2.getStartDate() != null ? t2.getStartDate()
                                : (t2.getRequest() != null ? t2.getRequest().getStartDate() : null);
                        if (d1 != null && d2 != null)
                            return d1.compareTo(d2);
                        return 0;
                    });
                }
            }

            // Pagination
            int totalCount = filteredTasks.size();
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);
            int offset = (currentPage - 1) * pageSize;
            int startItem = totalCount > 0 ? offset + 1 : 0;
            int endItem = Math.min(offset + pageSize, totalCount);

            List<Task> paginatedTasks = filteredTasks.stream()
                    .skip(offset)
                    .limit(pageSize)
                    .collect(Collectors.toList());

            // Calculate statistics
            int totalTasks = myTasks.size();
            int processingTasks = (int) myTasks.stream()
                    .filter(task -> TaskStatus.Processing.equals(task.getStatus()))
                    .count();
            int finishedTasks = (int) myTasks.stream()
                    .filter(task -> TaskStatus.Finished.equals(task.getStatus()))
                    .count();

            String statsNote = "";
            if (statusFilter != null && !statusFilter.isEmpty() && !"all status".equalsIgnoreCase(statusFilter)) {
                statsNote = " (Filtered: " + filteredTasks.size() + " tasks)";
            }

            request.setAttribute("currentPage", currentPage);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("startItem", startItem);
            request.setAttribute("endItem", endItem);
            request.setAttribute("assignedTasks", paginatedTasks);

            request.setAttribute("totalTasks", totalTasks);
            request.setAttribute("processingTasks", processingTasks);
            request.setAttribute("finishedTasks", finishedTasks);
            request.setAttribute("statsNote", statsNote);

            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("fromDate", fromDate);
            request.setAttribute("toDate", toDate);

            request.getRequestDispatcher("/technician_employee/view_assigned_tasks.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading tasks: " + e.getMessage());
        }
    }
}
