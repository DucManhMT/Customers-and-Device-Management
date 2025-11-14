package crm.task.controller;

import crm.common.URLConstants;
import crm.common.model.ProductRequest;
import crm.common.model.Task;
import crm.common.model.enums.ProductRequestStatus;
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
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "UpdateTaskStatusServlet", urlPatterns = { URLConstants.TECHEM_UPDATE_TASK_STATUS })
public class UpdateTaskStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String taskIdStr = request.getParameter("taskId");
        String newStatus = request.getParameter("status");

        if (taskIdStr == null || newStatus == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }

        Connection connection = null;

        try {
            int taskId = Integer.parseInt(taskIdStr);
            connection = DBcontext.getConnection();
            connection.setAutoCommit(false);
            EntityManager entityManager = new EntityManager(connection);

            Task task = entityManager.find(Task.class, taskId);
            if (task == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Task not found");
                return;
            }

            if (TaskStatus.Finished.equals(task.getStatus())) {
                request.getSession().setAttribute("errorMessage", "Task is already finished");
                response.sendRedirect(request.getContextPath() + URLConstants.TECHEM_VIEW_ASSIGNED_TASK);
                return;
            }

            if ("finished".equals(newStatus)) {
                Map<String, Object> conditions = new HashMap<>();
                conditions.put("task", taskId);
                List<ProductRequest> productRequests = entityManager.findWithConditions(ProductRequest.class, conditions);
                
                boolean hasPendingRequests = productRequests.stream()
                    .anyMatch(pr -> pr.getStatus() == ProductRequestStatus.Pending 
                                 || pr.getStatus() == ProductRequestStatus.Transporting
                                 || pr.getStatus() == ProductRequestStatus.Accepted);
                
                if (hasPendingRequests) {
                    request.getSession().setAttribute("errorMessage", "Cannot mark task as finished. There are still pending product requests.");
                    response.sendRedirect(request.getContextPath() + URLConstants.TECHEM_VIEW_ASSIGNED_TASK);
                    return;
                }

                task.setStatus(TaskStatus.Finished);
                task.setEndDate(LocalDateTime.now());
                entityManager.merge(task, Task.class);

                connection.commit();

                request.getSession().setAttribute("successMessage",
                        "Task #" + taskId + " has been marked as finished successfully!");
                response.sendRedirect(request.getContextPath() + URLConstants.TECHEM_VIEW_ASSIGNED_TASK);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid status");
            }

        } catch (NumberFormatException e) {
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid task ID");
        } catch (Exception e) {
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating task status: " + e.getMessage());
        }
    }
}
