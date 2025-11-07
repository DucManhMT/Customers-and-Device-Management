package crm.task.controller;

import crm.common.URLConstants;
import crm.common.model.Account;
import crm.common.model.AccountRequest;
import crm.common.model.Staff;
import crm.common.model.Task;
import crm.common.model.Request;
import crm.common.model.enums.TaskStatus;
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
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "TechnicianAssignmentDecisionServlet", urlPatterns = { URLConstants.TASK_ASSIGNMENT_DECISION })
public class TechnicianAssignmentDecisionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String taskIdStr = request.getParameter("taskId");
        String decision = request.getParameter("decision");

        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing taskId");
            return;
        }

        if (decision == null || decision.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing decision");
            return;
        }

        Account account = (Account) request.getSession().getAttribute("account");
        if (account == null) {
            response.sendRedirect(request.getContextPath() + URLConstants.AUTH_STAFF_LOGIN);
            return;
        }

        int taskId;
        try {
            taskId = Integer.parseInt(taskIdStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid taskId");
            return;
        }

        Connection conn = null;
        try {
            conn = DBcontext.getConnection();
            conn.setAutoCommit(false);
            EntityManager em = new EntityManager(conn);

            // Find the Task
            Task task = em.find(Task.class, taskId);
            if (task == null) {
                request.getSession().setAttribute("errorMessage", "Task not found.");
                response.sendRedirect(request.getContextPath() + URLConstants.TECHEM_VIEW_ASSIGNED_TASK);
                return;
            }

            // Verify this task is assigned to current technician
            Staff assignedTo = task.getAssignTo();
            if (assignedTo == null || assignedTo.getAccount() == null 
                    || !account.getUsername().equals(assignedTo.getAccount().getUsername())) {
                request.getSession().setAttribute("errorMessage", "This task is not assigned to you.");
                response.sendRedirect(request.getContextPath() + URLConstants.TECHEM_VIEW_ASSIGNED_TASK);
                return;
            }

            if ("accept".equalsIgnoreCase(decision)) {
                // Accept task - update status to Processing
                task.getAssignBy();
                task.getAssignTo();
                Request req = task.getRequest();
                
                task.setStatus(TaskStatus.Processing);
                task.setStartDate(LocalDateTime.now());
                em.merge(task, Task.class);

                // Update Request status to Processing
                if (req != null) {
                    req.setRequestStatus(RequestStatus.Processing);
                    em.merge(req, Request.class);
                }

                // Create AccountRequest to track that this tech accepted the request
                List<AccountRequest> allAccountRequests = em.findAll(AccountRequest.class);
                AccountRequest existingAR = allAccountRequests.stream()
                    .filter(ar -> ar.getAccount() != null && account.getUsername().equals(ar.getAccount().getUsername())
                            && ar.getRequest() != null && ar.getRequest().getRequestID() != null
                            && ar.getRequest().getRequestID().equals(task.getRequest().getRequestID()))
                    .findFirst()
                    .orElse(null);

                if (existingAR == null) {
                    AccountRequest newAR = new AccountRequest();
                    Integer nextId = allAccountRequests.stream()
                        .map(AccountRequest::getAccountRequestID)
                        .max(Integer::compare)
                        .orElse(0) + 1;
                    newAR.setAccountRequestID(nextId);
                    newAR.setAccount(account);
                    newAR.setRequest(task.getRequest());
                    em.persist(newAR, AccountRequest.class);
                }

                conn.commit();
                request.getSession().setAttribute("successMessage", "You have accepted the task. Status is now Processing.");
            } else {
                // Reject task - set status to Reject
                task.getAssignBy();
                task.getAssignTo();
                task.getRequest();
                
                task.setStatus(TaskStatus.Reject);
                em.merge(task, Task.class);

                conn.commit();
                request.getSession().setAttribute("successMessage", "You declined the assigned task.");
            }

            // Redirect to Pending Assignments page
            response.sendRedirect(request.getContextPath() + URLConstants.TASK_VIEW_RECEIVED_ASSIGNMENTS);

        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try { 
                    conn.rollback();
                } catch (Exception ex) { 
                    ex.printStackTrace(); 
                }
            }
            request.getSession().setAttribute("errorMessage", "Error processing assignment decision: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + URLConstants.TASK_VIEW_RECEIVED_ASSIGNMENTS);
        } finally {
            if (conn != null) {
                try { 
                    conn.setAutoCommit(true); 
                    conn.close();
                } catch (Exception ignore) {}
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String taskIdStr = request.getParameter("taskId");
        
        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Missing taskId");
            response.sendRedirect(request.getContextPath() + URLConstants.TECHEM_VIEW_ASSIGNED_TASK);
            return;
        }

        int taskId;
        try {
            taskId = Integer.parseInt(taskIdStr);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid taskId");
            response.sendRedirect(request.getContextPath() + URLConstants.TECHEM_VIEW_ASSIGNED_TASK);
            return;
        }

        try (Connection conn = DBcontext.getConnection()) {
            EntityManager em = new EntityManager(conn);
            Task task = em.find(Task.class, taskId);
            if (task == null) {
                request.getSession().setAttribute("errorMessage", "Task not found");
                response.sendRedirect(request.getContextPath() + URLConstants.TECHEM_VIEW_ASSIGNED_TASK);
                return;
            }

            request.setAttribute("taskItem", task);
            request.getRequestDispatcher("/technician_employee/assignment_decision.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading assignment decision page: " + e.getMessage());
        }
    }
}
