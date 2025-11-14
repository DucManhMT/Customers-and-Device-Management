package crm.task.controller;

import crm.common.URLConstants;
import crm.common.model.Account;
import crm.common.model.Staff;
import crm.common.model.Task;
import crm.common.model.Request;
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
import java.util.List;
import java.util.stream.Collectors;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@WebServlet(name = "ViewReceivedAssignmentsServlet", urlPatterns = { URLConstants.TASK_VIEW_RECEIVED_ASSIGNMENTS })
public class ViewReceivedAssignmentsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        loadReceivedAssignments(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        loadReceivedAssignments(request, response);
    }

    private void loadReceivedAssignments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Account account = (Account) request.getSession().getAttribute("account");
        if (account == null) {
            response.sendRedirect(request.getContextPath() + URLConstants.AUTH_STAFF_LOGIN);
            return;
        }

        try (Connection conn = DBcontext.getConnection()) {
            EntityManager em = new EntityManager(conn);

            // Find current tech's Staff record to get StaffID
            List<Staff> allStaff = em.findAll(Staff.class);
            Staff currentStaff = allStaff.stream()
                    .filter(s -> s.getAccount() != null && account.getUsername().equals(s.getAccount().getUsername()))
                    .findFirst()
                    .orElse(null);

            if (currentStaff == null) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Staff profile not found");
                return;
            }

            // Get all Task records where assignTo = current tech and status = Pending
            List<Task> allTasks = em.findAll(Task.class);

            // Filter out null tasks first (caused by EntityMapper errors)
            allTasks = allTasks.stream()
                    .filter(task -> {
                        if (task == null) {
                            return false;
                        }
                        return true;
                    })
                    .collect(Collectors.toList());

            List<Task> pendingTasks = allTasks.stream()
                    .filter(task -> {
                        try {
                            if (task.getAssignTo() == null) {

                                return false;
                            }
                            if (!currentStaff.getStaffID().equals(task.getAssignTo().getStaffID())) {

                                return false;
                            }
                            if (!TaskStatus.Pending.equals(task.getStatus())) {

                                return false;
                            }

                            return true;
                        } catch (Exception e) {

                            e.printStackTrace();
                            return false;
                        }
                    })
                    .collect(Collectors.toList());

            // Apply optional filters from query params: customerFilter (name), phoneFilter,
            // fromDate, toDate, sort by time
            String customerFilter = request.getParameter("customerFilter");
            String phoneFilter = request.getParameter("phoneFilter");
            String fromDateStr = request.getParameter("fromDate");
            String toDateStr = request.getParameter("toDate");
            String sort = request.getParameter("sort"); // time_desc (default) or time_asc

            LocalDateTime fromDate = null;
            LocalDateTime toDate = null;
            try {
                if (fromDateStr != null && !fromDateStr.trim().isEmpty()) {
                    fromDate = LocalDate.parse(fromDateStr.trim()).atStartOfDay();
                }
                if (toDateStr != null && !toDateStr.trim().isEmpty()) {
                    toDate = LocalDate.parse(toDateStr.trim()).atTime(LocalTime.MAX);
                }
            } catch (Exception ex) {
                fromDate = null;
                toDate = null;
            }

            final String custLow = customerFilter != null ? customerFilter.trim().toLowerCase() : null;
            final String phoneLow = phoneFilter != null ? phoneFilter.trim().toLowerCase() : null;
            final LocalDateTime fromDateFinal = fromDate;
            final LocalDateTime toDateFinal = toDate;

            boolean hasAnyFilter = (custLow != null && !custLow.isEmpty()) || (phoneLow != null && !phoneLow.isEmpty())
                    || (fromDateFinal != null) || (toDateFinal != null);

            if (hasAnyFilter) {
                pendingTasks = pendingTasks.stream().filter(task -> {
                    if (task == null)
                        return false; // Null check

                    boolean ok = true;
                    Request r = task.getRequest();
                    if (r == null)
                        return false;

                    if (custLow != null && !custLow.isEmpty()) {
                        try {
                            if (r.getContract() != null && r.getContract().getCustomer() != null
                                    && r.getContract().getCustomer().getCustomerName() != null) {
                                if (!r.getContract().getCustomer().getCustomerName().toLowerCase().contains(custLow)) {
                                    ok = false;
                                }
                            } else {
                                ok = false;
                            }
                        } catch (Exception ex) {
                            ok = false;
                        }
                    }
                    if (phoneLow != null && !phoneLow.isEmpty()) {
                        try {
                            if (r.getContract() != null && r.getContract().getCustomer() != null
                                    && r.getContract().getCustomer().getPhone() != null) {
                                if (!r.getContract().getCustomer().getPhone().toLowerCase().contains(phoneLow)) {
                                    ok = false;
                                }
                            } else {
                                ok = false;
                            }
                        } catch (Exception ex) {
                            ok = false;
                        }
                    }
                    if ((fromDateFinal != null || toDateFinal != null) && r.getStartDate() != null) {
                        LocalDateTime sd = r.getStartDate();
                        if (fromDateFinal != null && sd.isBefore(fromDateFinal))
                            ok = false;
                        if (toDateFinal != null && sd.isAfter(toDateFinal))
                            ok = false;
                    }
                    return ok;
                }).collect(Collectors.toList());
            }

            // sort by startDate of Request
            if ("time_asc".equals(sort)) {
                pendingTasks.sort((a, b) -> {
                    if (a == null && b == null)
                        return 0;
                    if (a == null)
                        return -1;
                    if (b == null)
                        return 1;
                    LocalDateTime aDate = a.getRequest() != null ? a.getRequest().getStartDate() : null;
                    LocalDateTime bDate = b.getRequest() != null ? b.getRequest().getStartDate() : null;
                    if (aDate == null && bDate == null)
                        return 0;
                    if (aDate == null)
                        return -1;
                    if (bDate == null)
                        return 1;
                    return aDate.compareTo(bDate);
                });
            } else {
                // default newest first
                pendingTasks.sort((a, b) -> {
                    if (a == null && b == null)
                        return 0;
                    if (a == null)
                        return 1;
                    if (b == null)
                        return -1;
                    LocalDateTime aDate = a.getRequest() != null ? a.getRequest().getStartDate() : null;
                    LocalDateTime bDate = b.getRequest() != null ? b.getRequest().getStartDate() : null;
                    if (aDate == null && bDate == null)
                        return 0;
                    if (aDate == null)
                        return 1;
                    if (bDate == null)
                        return -1;
                    return bDate.compareTo(aDate);
                });
            }

            // expose filter params back to JSP (for form pre-fill)
            request.setAttribute("customerFilter", customerFilter);
            request.setAttribute("phoneFilter", phoneFilter);
            request.setAttribute("fromDate", fromDateStr);
            request.setAttribute("toDate", toDateStr);
            request.setAttribute("sort", sort);

            request.setAttribute("pendingTasks", pendingTasks);
            request.getRequestDispatcher("/technician_employee/view_received_assignments.jsp").forward(request,
                    response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error loading received assignments: " + e.getMessage());
        }
    }
}
