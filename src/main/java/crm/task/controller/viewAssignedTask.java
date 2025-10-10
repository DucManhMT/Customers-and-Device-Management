package crm.task.controller;

import crm.common.model.Request;
import crm.common.model.AccountRequest;
import crm.common.model.enums.RequestStatus;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/task/viewAssignedTasks")
public class viewAssignedTask extends HttpServlet {

    private static final long serialVersionUID = 1L;

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

        Connection connection = null;
        try {
            connection = DBcontext.getConnection();
            EntityManager entityManager = new EntityManager(connection);

            // HttpSession session = request.getSession(false);
            // if (session == null) {
            //     response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "No active session");
            //     return;
            // }
            
            // String username = (String) session.getAttribute("username");
            // if (username == null || username.trim().isEmpty()) {
            //     response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
            //     return;
            // }
            String username = "technician01";
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

            List<AccountRequest> allAccountRequests = entityManager.findAll(AccountRequest.class);
            
            List<AccountRequest> accountRequests = allAccountRequests.stream()
                    .filter(ar -> ar.getAccount() != null && username.equals(ar.getAccount().getUsername()))
                    .collect(Collectors.toList());

            Set<Integer> assignedRequestIds = new HashSet<>();
            for (AccountRequest ar : accountRequests) {
                if (ar.getRequest() != null && ar.getRequest().getRequestID() != null) {
                    assignedRequestIds.add(ar.getRequest().getRequestID());
                }
            }

            if (assignedRequestIds.isEmpty()) {
                request.setAttribute("assignedRequests", Collections.emptyList());
                request.setAttribute("currentPage", currentPage);
                request.setAttribute("pageSize", pageSize);
                request.setAttribute("totalCount", 0);
                request.setAttribute("totalPages", 1);
                request.setAttribute("startItem", 0);
                request.setAttribute("endItem", 0);
                
                request.setAttribute("totalTasks", 0);
                request.setAttribute("approvedTasks", 0);
                request.setAttribute("finishedTasks", 0);
                
                request.getRequestDispatcher("/task/techemployee/viewAssignedTasks.jsp").forward(request, response);
                return;
            }

            List<Request> allAssignedRequests = entityManager.findAll(Request.class);
            
            List<Request> filteredByAssignment = allAssignedRequests.stream()
                    .filter(req -> assignedRequestIds.contains(req.getRequestID()))
                    .collect(Collectors.toList());
            
            List<Request> filteredRequests = filteredByAssignment;
            if (statusFilter != null && !statusFilter.isEmpty() && !"all status".equalsIgnoreCase(statusFilter)) {
                if ("approved".equals(statusFilter)) {
                    filteredRequests = filteredByAssignment.stream()
                            .filter(req -> RequestStatus.Approved.equals(req.getRequestStatus()))
                            .collect(Collectors.toList());
                } else if ("finished".equals(statusFilter)) {
                    filteredRequests = filteredByAssignment.stream()
                            .filter(req -> RequestStatus.Finished.equals(req.getRequestStatus()))
                            .collect(Collectors.toList());
                }
            }

            if ((fromDate != null && !fromDate.isEmpty()) || (toDate != null && !toDate.isEmpty())) {
                filteredRequests = filteredRequests.stream()
                        .filter(req -> {
                            if (req.getStartDate() == null) return false;
                            
                            LocalDateTime requestDateTime = req.getStartDate();
                            LocalDate requestDate = requestDateTime.toLocalDate();
                            boolean passFromDate = true;
                            boolean passToDate = true;
                            
                            if (fromDate != null && !fromDate.isEmpty()) {
                                try {
                                    LocalDate from = LocalDate.parse(fromDate, DateTimeFormatter.ofPattern("dd-MM-yyyy"));
                                    passFromDate = !requestDate.isBefore(from);
                                } catch (DateTimeParseException e) {
                                    passFromDate = true;
                                }
                            }
                            
                            if (toDate != null && !toDate.isEmpty()) {
                                try {
                                    LocalDate to = LocalDate.parse(toDate, DateTimeFormatter.ofPattern("dd-MM-yyyy"));
                                    passToDate = !requestDate.isAfter(to);
                                } catch (DateTimeParseException e) {
                                    passToDate = true;
                                }
                            }
                            
                            return passFromDate && passToDate;
                        })
                        .collect(Collectors.toList());
            }

            if (sortBy != null && !sortBy.isEmpty()) {
                if ("newest".equals(sortBy)) {
                    filteredRequests.sort((r1, r2) -> 
                        r2.getStartDate() != null && r1.getStartDate() != null ? 
                        r2.getStartDate().compareTo(r1.getStartDate()) : 0);
                } else if ("oldest".equals(sortBy)) {
                    filteredRequests.sort((r1, r2) -> 
                        r1.getStartDate() != null && r2.getStartDate() != null ? 
                        r1.getStartDate().compareTo(r2.getStartDate()) : 0);
                }
            }

            int totalCount = filteredRequests.size();
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);
            int offset = (currentPage - 1) * pageSize;
            int startItem = totalCount > 0 ? offset + 1 : 0;
            int endItem = Math.min(offset + pageSize, totalCount);

            List<Request> paginatedRequests = filteredRequests.stream()
                    .skip(offset)
                    .limit(pageSize)
                    .collect(Collectors.toList());
            int totalTasks = filteredByAssignment.size();
            int approvedTasks = (int) filteredByAssignment.stream()
                    .filter(req -> RequestStatus.Approved.equals(req.getRequestStatus()))
                    .count();
            int finishedTasks = (int) filteredByAssignment.stream()
                    .filter(req -> RequestStatus.Finished.equals(req.getRequestStatus()))
                    .count();
            
            String statsNote = "";
            if (statusFilter != null && !statusFilter.isEmpty() && !"all status".equalsIgnoreCase(statusFilter)) {
                statsNote = " (Filtered: " + filteredRequests.size() + " tasks)";
            }

            request.setAttribute("currentPage", currentPage);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("startItem", startItem);
            request.setAttribute("endItem", endItem);
            request.setAttribute("assignedRequests", paginatedRequests);
            
            request.setAttribute("totalTasks", totalTasks);
            request.setAttribute("approvedTasks", approvedTasks);
            request.setAttribute("finishedTasks", finishedTasks);
            request.setAttribute("statsNote", statsNote);
            
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("fromDate", fromDate);
            request.setAttribute("toDate", toDate);
            
            request.getRequestDispatcher("/task/techemployee/viewAssignedTasks.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading tasks: " + e.getMessage());
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
