package crm.task.controller;

import crm.common.URLConstants;
import crm.task.service.TaskService;
import jakarta.json.Json;
import jakarta.json.JsonObject;
import jakarta.json.JsonReader;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(urlPatterns = URLConstants.TECHLEAD_DELETE_TASK, name = "DeleteTaskController")
public class DeleteTaskController extends HttpServlet {

    private static final TaskService taskService = new TaskService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        JsonObject requestJson;
        try (JsonReader reader = Json.createReader(req.getReader())) {
            requestJson = reader.readObject();
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            writeJson(resp, false, "Invalid JSON input");
            return;
        }

        String taskIdParam = requestJson.getString("taskId", null);
        if (taskIdParam == null || taskIdParam.isBlank()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            writeJson(resp, false, "taskId is required");
            return;
        }

        try {
            int taskId = Integer.parseInt(taskIdParam.trim());
            boolean deleted = taskService.deleteTaskIfAllowed(taskId);

            if (deleted) {
                writeJson(resp, true, "Task deleted successfully.");
            } else {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                writeJson(resp, false, "Only Pending or Processing tasks can be deleted.");
            }

        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            writeJson(resp, false, "Invalid taskId format");
        } catch (IllegalArgumentException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            writeJson(resp, false, e.getMessage());
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            writeJson(resp, false, "Failed to delete task.");
        }
    }

    private void writeJson(HttpServletResponse resp, boolean success, String message) throws IOException {
        try (PrintWriter out = resp.getWriter()) {
            JsonObject json = Json.createObjectBuilder()
                    .add("success", success)
                    .add("message", message)
                    .build();
            out.print(json.toString());
        }
    }
}
