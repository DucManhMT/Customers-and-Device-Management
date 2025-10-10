package crm.service_request.controller;

import java.io.IOException;

import crm.common.model.Request;
import crm.service_request.service.RequestService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "SupporterRequestDetailController", urlPatterns = {"/supporter/requests/detail"})
public class SupporterRequestDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        RequestService requestService = new RequestService();

        try {
            int requestId = Integer.parseInt(req.getParameter("requestId"));
            Request request = requestService.getRequestById(requestId);
            req.setAttribute("request", request);
        } catch (Exception e) {
        }
        req.getRequestDispatcher("/service_request/view-request-detail-suppoter.jsp").forward(req, resp);
    }

}
