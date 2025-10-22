package crm.service_request.controller;

import crm.common.MessageConst;
import crm.common.URLConstants;
import crm.common.model.Account;
import crm.common.model.Request;
import crm.service_request.model.RequestLog;
import crm.service_request.service.RequestLogService;
import crm.service_request.service.RequestService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "StaffRequestTimeline", urlPatterns = {URLConstants.STAFF_REQUEST_TIMELINE})
public class StaffRequestTimeline extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        RequestService requestService = new RequestService();
        RequestLogService requestLogService = new RequestLogService();
        Account account = (Account) req.getSession().getAttribute("account");
        if (account == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/customer_login");
            return;
        }
        try {
            int requestId = Integer.parseInt(req.getParameter("requestId"));
            Request request = requestService.getRequestById(requestId);
            if (request == null) {
                throw new IllegalArgumentException(MessageConst.MSG14);
            }
            List<RequestLog> logs = requestLogService.getLogsByRequestId(requestId);
            req.setAttribute("logs", logs);
            req.setAttribute("request", request);

        } catch (NumberFormatException e) {
            req.setAttribute("error", MessageConst.MSG16);
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", MessageConst.MSG15);
        }
        req.getRequestDispatcher("/service_request/staff_request_timeline.jsp").forward(req, resp);
    }
}
