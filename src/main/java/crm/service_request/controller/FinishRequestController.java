package crm.service_request.controller;

import crm.common.MessageConst;
import crm.common.URLConstants;
import crm.common.model.Account;
import crm.service_request.service.RequestService;
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

@WebServlet(urlPatterns = URLConstants.TECHLEAD_FINISH_REQUEST, name = "FinishRequestController")
public class FinishRequestController extends HttpServlet {
    private static final RequestService requestService = new RequestService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        Account account = (Account) req.getSession().getAttribute("account");
        if (account == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            writeJson(resp, false, "User not authenticated.");
            return;
        }

        JsonObject requestJson;
        try (JsonReader reader = Json.createReader(req.getReader())) {
            requestJson = reader.readObject();
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            writeJson(resp, false, "Invalid JSON input.");
            return;
        }

        String requestIdParam = requestJson.getString("requestId", null);
        if (requestIdParam == null || requestIdParam.isBlank()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            writeJson(resp, false, "requestId is required.");
            return;
        }

        try {
            int requestId = Integer.parseInt(requestIdParam.trim());
            // Pass the authenticated account to ensure proper auditing and to avoid
            // null-related failures
            requestService.finishRequest(requestId, account);

            writeJson(resp, true, "Request marked as finished successfully.");
        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            writeJson(resp, false, "Invalid requestId format.");
        } catch (IllegalArgumentException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            writeJson(resp, false, e.getMessage());
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            writeJson(resp, false, "Failed to finish request.");
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
