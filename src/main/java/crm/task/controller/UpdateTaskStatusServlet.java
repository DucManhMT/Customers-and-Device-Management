package crm.task.controller;

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
import java.time.LocalDateTime;

@WebServlet("/task/updateStatus")
public class UpdateTaskStatusServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String requestIdStr = request.getParameter("requestId");
        String newStatus = request.getParameter("status");

        if (requestIdStr == null || newStatus == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }

        Connection connection = null;
        try {
            int requestId = Integer.parseInt(requestIdStr);
            connection = DBcontext.getConnection();
            EntityManager entityManager = new EntityManager(connection);

            Request req = entityManager.find(Request.class, requestId);
            if (req == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Request not found");
                return;
            }

            if (RequestStatus.Finished.equals(req.getRequestStatus())) {
                request.getSession().setAttribute("errorMessage", "Task is already finished");
                response.sendRedirect(request.getContextPath() + "/task/viewAssignedTasks");
                return;
            }

            if ("finished".equals(newStatus)) {
                req.setRequestStatus(RequestStatus.Finished);
                req.setFinishedDate(LocalDateTime.now());

                entityManager.merge(req, Request.class);

                request.getSession().setAttribute("successMessage", "Task #" + requestId + " has been marked as finished successfully!");
                response.sendRedirect(request.getContextPath() + "/task/viewAssignedTasks");
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid status");
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating task status: " + e.getMessage());
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
