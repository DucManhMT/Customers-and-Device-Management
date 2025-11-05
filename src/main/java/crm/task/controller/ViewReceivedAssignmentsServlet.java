package crm.task.controller;

import crm.common.URLConstants;
import crm.common.model.Account;
import crm.common.model.AccountRequest;
import crm.common.model.Request;
import crm.common.model.enums.RequestStatus;
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

            List<AccountRequest> allAccountRequests = em.findAll(AccountRequest.class);

            // Filter assignments that belong to the current technician
            List<AccountRequest> myAssignments = allAccountRequests.stream()
                    .filter(ar -> ar.getAccount() != null && account.getUsername().equals(ar.getAccount().getUsername()))
                    .collect(Collectors.toList());

            // Extract the Request objects for these assignments and show only those with Approved status
            // Technicians can accept or decline approved tasks assigned to them
            List<Request> pendingRequests = myAssignments.stream()
                    .map(AccountRequest::getRequest)
                    .filter(r -> r != null && RequestStatus.Approved.equals(r.getRequestStatus()))
                    .collect(Collectors.toList());

            // Apply optional filters from query params: customerFilter (name), phoneFilter, fromDate, toDate, sort by time
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
                pendingRequests = pendingRequests.stream().filter(r -> {
                    boolean ok = true;
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
                        if (fromDateFinal != null && sd.isBefore(fromDateFinal)) ok = false;
                        if (toDateFinal != null && sd.isAfter(toDateFinal)) ok = false;
                    }
                    return ok;
                }).collect(Collectors.toList());
            }

            // sort by startDate
            if ("time_asc".equals(sort)) {
                pendingRequests.sort((a, b) -> {
                    if (a.getStartDate() == null && b.getStartDate() == null) return 0;
                    if (a.getStartDate() == null) return -1;
                    if (b.getStartDate() == null) return 1;
                    return a.getStartDate().compareTo(b.getStartDate());
                });
            } else {
                // default newest first
                pendingRequests.sort((a, b) -> {
                    if (a.getStartDate() == null && b.getStartDate() == null) return 0;
                    if (a.getStartDate() == null) return 1;
                    if (b.getStartDate() == null) return -1;
                    return b.getStartDate().compareTo(a.getStartDate());
                });
            }

            // expose filter params back to JSP (for form pre-fill)
            request.setAttribute("customerFilter", customerFilter);
            request.setAttribute("phoneFilter", phoneFilter);
            request.setAttribute("fromDate", fromDateStr);
            request.setAttribute("toDate", toDateStr);
            request.setAttribute("sort", sort);

            request.setAttribute("assignments", myAssignments);
            request.setAttribute("pendingRequests", pendingRequests);
            request.getRequestDispatcher("/technician_employee/view_received_assignments.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading received assignments: " + e.getMessage());
        }
    }
}
