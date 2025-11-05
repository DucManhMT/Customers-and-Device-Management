package crm.task.controller;

import crm.common.URLConstants;
import crm.common.model.AccountRequest;
import crm.common.model.Account;
import crm.common.model.Staff;
import crm.common.model.Task;
import crm.common.model.Request;
import crm.common.model.enums.TaskStatus;
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
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "ProcessAssignmentServlet", urlPatterns = {URLConstants.TASK_PROCESS_ASSIGNMENT})
public class ProcessAssignmentServlet extends HttpServlet {
    SelectTechnicianService selectTechnicianService = new SelectTechnicianService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String[] selectedTaskIds = request.getParameterValues("selectedTasks");
        String[] selectedTechnicians = request.getParameterValues("selectedTechnicians");

        if (selectedTaskIds == null || selectedTaskIds.length == 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No tasks selected");
            return;
        }

        if (selectedTechnicians == null || selectedTechnicians.length == 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No technicians selected");
            return;
        }


        Connection connection = DBcontext.getConnection();
        EntityManager entityManager = new EntityManager(connection);
        try {

            connection.setAutoCommit(false);

            try {
                // Get current logged-in leader's Staff record
                Account leaderAccount = (Account) request.getSession().getAttribute("account");
                if (leaderAccount == null) {
                    response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "You must be logged in to assign tasks");
                    return;
                }
                
                List<Staff> allStaff = entityManager.findAll(Staff.class);
                Staff leaderStaff = allStaff.stream()
                    .filter(s -> s.getAccount() != null && leaderAccount.getUsername().equals(s.getAccount().getUsername()))
                    .findFirst()
                    .orElse(null);
                
                if (leaderStaff == null) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, 
                        "Leader staff profile not found. Please contact administrator.");
                    return;
                }

                List<Integer> taskIds = Arrays.stream(selectedTaskIds)
                        .map(id -> Integer.parseInt(id))
                        .collect(Collectors.toList());

                int assignedCount = 0;
                StringBuilder errorMessages = new StringBuilder();

                List<AccountRequest> allAccountRequests = entityManager.findAll(AccountRequest.class);
                List<Task> allTasks = entityManager.findAll(Task.class);

                // Loop through each technician
                for (String techUsername : selectedTechnicians) {
                    Account techAccount = entityManager.find(Account.class, techUsername);
                    if (techAccount == null) {
                        errorMessages.append("Technician '").append(techUsername).append("' not found. ");
                        continue;
                    }

                    // Find the Staff record for this technician
                    Staff techStaff = allStaff.stream()
                        .filter(s -> s.getAccount() != null && techUsername.equals(s.getAccount().getUsername()))
                        .findFirst()
                        .orElse(null);

                    if (techStaff == null) {
                        errorMessages.append("Staff profile for '").append(techUsername).append("' not found. ");
                        continue;
                    }

                    // Loop through each request and create Task for this technician
                    for (Integer requestId : taskIds) {
                        try {
                            Request taskRequest = entityManager.find(Request.class, requestId);
                            if (taskRequest == null) {
                                errorMessages.append("Request #").append(requestId).append(" not found. ");
                                continue;
                            }

                            // Check if Task already exists for this Request + Tech
                            boolean taskAlreadyExists = allTasks.stream()
                                    .anyMatch(t -> t.getRequest() != null 
                                            && t.getRequest().getRequestID() != null
                                            && t.getRequest().getRequestID().equals(requestId)
                                            && t.getAssignTo() != null 
                                            && t.getAssignTo().getStaffID().equals(techStaff.getStaffID())
                                            && (t.getStatus() == TaskStatus.Pending || t.getStatus() == TaskStatus.Processing));

                            if (taskAlreadyExists) {
                                errorMessages.append("Request #").append(requestId)
                                        .append(" already assigned to ").append(techStaff.getStaffName()).append(". ");
                                continue;
                            }

                            // Create new Task record
                            Task newTask = new Task();
                            // Generate next Task ID
                            Integer nextTaskId = allTasks.stream()
                                .map(Task::getTaskID)
                                .max(Integer::compare)
                                .orElse(0) + 1;
                            newTask.setTaskID(nextTaskId);
                            newTask.setAssignBy(leaderStaff);  // Leader is guaranteed to be not null
                            newTask.setAssignTo(techStaff);
                            newTask.setRequest(taskRequest);
                            newTask.setStartDate(LocalDateTime.now()); // Will be set when tech accepts
                            newTask.setEndDate(null);
                            newTask.setDeadline(LocalDateTime.now().plusDays(7)); // 7 days from now
                            
                            // Set description based on Request info
                            String taskDesc = "Task for Request #" + taskRequest.getRequestID();
                            if (taskRequest.getRequestDescription() != null && !taskRequest.getRequestDescription().isEmpty()) {
                                taskDesc = taskRequest.getRequestDescription();
                            }
                            newTask.setDescription(taskDesc);
                            
                            newTask.setStatus(TaskStatus.Pending);
                            entityManager.persist(newTask, Task.class);
                            allTasks.add(newTask); // Add to list for next iteration check

                            // Also create AccountRequest for tracking (initial assignment by leader)
                            boolean arExists = allAccountRequests.stream()
                                    .anyMatch(ar -> ar.getRequest() != null 
                                            && ar.getRequest().getRequestID() != null
                                            && ar.getRequest().getRequestID().equals(requestId)
                                            && ar.getAccount() != null 
                                            && ar.getAccount().getUsername() != null
                                            && ar.getAccount().getUsername().equals(techUsername));

                            if (!arExists) {
                                AccountRequest accountRequest = new AccountRequest();
                                Integer nextARId = selectTechnicianService.getNextAccountRequestId(entityManager);
                                accountRequest.setAccountRequestID(nextARId);
                                accountRequest.setAccount(techAccount);
                                accountRequest.setRequest(taskRequest);
                                entityManager.persist(accountRequest, AccountRequest.class);
                            }

                            assignedCount++;

                        } catch (Exception e) {
                            errorMessages.append("Error assigning Request #").append(requestId)
                                    .append(" to ").append(techStaff.getStaffName()).append(": ")
                                    .append(e.getMessage()).append(". ");
                        }
                    }
                }

                if (assignedCount > 0) {
                    connection.commit();

                    String message = assignedCount + " task(s) successfully assigned";
                    if (selectedTechnicians.length > 1) {
                        message += " to " + selectedTechnicians.length + " technician(s)";
                    }
                    message += ". Waiting for technicians to accept.";
                    
                    request.getSession().setAttribute("successMessage", message);

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