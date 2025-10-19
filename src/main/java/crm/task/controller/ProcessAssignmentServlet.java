package crm.task.controller;

import crm.common.URLConstants;
import crm.common.model.AccountRequest;
import crm.common.model.Account;
import crm.common.model.Request;
import crm.common.model.enums.RequestStatus;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.task.service.SelectTechnicianService;
import crm.core.config.DBcontext;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name="ProcessAssignmentServlet", urlPatterns = { URLConstants.TASK_PROCESS_ASSIGNMENT})
public class ProcessAssignmentServlet extends HttpServlet {
    SelectTechnicianService selectTechnicianService = new SelectTechnicianService();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String[] selectedTaskIds = request.getParameterValues("selectedTasks");
        String selectedTechnician = request.getParameter("selectedTechnician");
        
        if (selectedTaskIds == null || selectedTaskIds.length == 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No tasks selected");
            return;
        }
        
        if (selectedTechnician == null || selectedTechnician.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No technician selected");
            return;
        }

        try (
            Connection connection = DBcontext.getConnection();
            EntityManager entityManager = new EntityManager(connection)) {
            
            connection.setAutoCommit(false);
            
            try {
                Account techAccount = entityManager.find(Account.class, selectedTechnician);
                if (techAccount == null) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid technician selected");
                    return;
                }
                
                List<Integer> taskIds = Arrays.stream(selectedTaskIds)
                    .map(id -> Integer.parseInt(id))
                    .collect(Collectors.toList());
                
                int assignedCount = 0;
                StringBuilder errorMessages = new StringBuilder();
                
                for (Integer taskId : taskIds) {
                    try {
                        Request taskRequest = entityManager.find(Request.class, taskId);
                        if (taskRequest == null) {
                            errorMessages.append("Task ").append(taskId).append(" not found. ");
                            continue;
                        }
                        
                        AccountRequest accountRequest = new AccountRequest();
                        Integer nextId = selectTechnicianService.getNextAccountRequestId(entityManager);
                        accountRequest.setAccountRequestID(nextId);
                        accountRequest.setAccount(techAccount);
                        accountRequest.setRequest(taskRequest);
                        
                        entityManager.persist(accountRequest, AccountRequest.class);
                        
                        taskRequest.setRequestStatus(RequestStatus.Processing);
                        entityManager.merge(taskRequest, Request.class);
                        
                        assignedCount++;
                        
                    } catch (Exception e) {
                        errorMessages.append("Error assigning task ").append(taskId).append(": ").append(e.getMessage()).append(". ");
                    }
                }
                
                if (assignedCount > 0) {
                    connection.commit();
                    
                    request.getSession().setAttribute("successMessage", 
                        assignedCount + " task(s) successfully assigned to technician and moved to Processing status.");
                    
                    if (errorMessages.length() > 0) {
                        request.getSession().setAttribute("warningMessage", 
                            "Some tasks could not be assigned: " + errorMessages.toString());
                    }
                } else {
                    connection.rollback();
                    request.getSession().setAttribute("errorMessage", 
                        "No tasks were assigned. " + errorMessages.toString());
                }
                
                response.sendRedirect(request.getContextPath() + "/task/viewAprovedTask");
                
            } catch (Exception e) {
                connection.rollback();
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                    "Error processing assignment: " + e.getMessage());
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Database connection error: " + e.getMessage());
        }
    }
}