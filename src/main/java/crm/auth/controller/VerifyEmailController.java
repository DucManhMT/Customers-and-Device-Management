package crm.auth.controller;

import crm.auth.service.OTPProvider;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.json.Json;
import jakarta.json.JsonObject;
import jakarta.json.JsonReader;

import java.io.IOException;
import java.io.StringReader;

@WebServlet(name = "VerifyEmailController", value = "/api/verify_email")
public class VerifyEmailController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        // Đọc JSON từ body
        String body = req.getReader().lines().reduce("", (acc, line) -> acc + line);
        JsonReader jsonReader = Json.createReader(new StringReader(body));
        JsonObject json = jsonReader.readObject();

        String action = json.containsKey("action") ? json.getString("action") : null;
        String email = json.containsKey("email") ? json.getString("email") : null;
        String otp = json.containsKey("otp") ? json.getString("otp") : null;

        if ("verify".equals(action) && email != null && otp != null && !otp.isEmpty()) {
            boolean isValid = OTPProvider.verifyOTP(otp, email);
            if (isValid) {
                resp.getWriter().write("{\"success\":true, \"message\":\"OTP verified successfully.\"}");
            } else {
                resp.getWriter().write("{\"success\":false, \"message\":\"Invalid or expired OTP.\"}");
            }
            return;

        } else if ("send".equals(action) && email != null) {
            String generatedOtp = OTPProvider.generateOTP();
            boolean emailSent = OTPProvider.sendOTPEmail(email, generatedOtp);
            if (emailSent) {
                resp.setStatus(HttpServletResponse.SC_OK);
                resp.getWriter().write("{\"success\":true, \"message\":\"OTP sent successfully.\"}");
            } else {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().write("{\"success\":false, \"message\":\"Failed to send OTP email.\"}");
            }
            return;

        } else {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"success\":false, \"message\":\"Invalid request parameters.\"}");
        }
    }
}
