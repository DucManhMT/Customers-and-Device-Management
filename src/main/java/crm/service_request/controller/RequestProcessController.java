package crm.service_request.controller;

import crm.common.MessageConst;
import crm.common.model.Account;
import crm.common.model.enums.RequestStatus;
import crm.service_request.service.RequestService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "RequestProcessController", value = "/supporter/requests/process")
public class RequestProcessController extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        RequestService requestService = new RequestService();
        try {
            int requestId = Integer.parseInt(req.getParameter("requestId"));
            if (!requestService.isExist(requestId)) {
                throw new IllegalArgumentException(MessageConst.MSG14);
            }
            req.setAttribute("request", requestService.getRequestById(requestId));
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid request ID");
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("/service_request/process-request.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        RequestService requestService = new RequestService();
        Account account = (Account) req.getSession().getAttribute("account");
        if (account == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/customer_login");
            return;
        }
        try {
            int requestId = Integer.parseInt(req.getParameter("requestId"));
            String status = req.getParameter("status");
            String note = req.getParameter("note");
            String username = account.getUsername();
            if (!requestService.isExist(requestId)) {
                throw new IllegalArgumentException(MessageConst.MSG14);
            }
            if (status == null || status.isEmpty()) {
                throw new IllegalArgumentException(MessageConst.MSG19);
            }
            requestService.updateRequestStatus(requestId, RequestStatus.valueOf(status), note, username);
            req.setAttribute("message", MessageConst.MSG17);
            req.setAttribute("request", requestService.getRequestById(requestId));
        } catch (NumberFormatException e) {
            req.setAttribute("error", MessageConst.MSG16);
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", e.getMessage());
        } catch (Exception e) {
            req.setAttribute("error", MessageConst.MSG18);
        }
        doGet(req, resp);
    }
}
