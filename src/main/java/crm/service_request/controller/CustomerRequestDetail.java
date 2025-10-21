package crm.service_request.controller;

import crm.common.MessageConst;
import crm.common.URLConstants;
import crm.common.model.Account;
import crm.common.model.Request;
import crm.service_request.service.RequestService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "CustomerRequestDetail", value = URLConstants.CUSTOMER_REQUEST_DETAIL)
public class CustomerRequestDetail extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        RequestService requestService = new RequestService();
        Account account = (Account) req.getSession().getAttribute("account");
        if (account == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/customer_login");
            return;
        }
        try {
            int requestId = Integer.parseInt(req.getParameter("requestId"));
            Request request = requestService.getRequestById(requestId);
            if (request == null) {
                throw new IllegalArgumentException("Request not found");
            }
            if (requestService.isRequestOwner(request, account.getUsername())) {
                req.setAttribute("request", request);
            } else {
                throw new IllegalArgumentException(MessageConst.MSG20);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", MessageConst.MSG16);
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("/service_request/request-detail-customer.jsp").forward(req, resp);
    }
}
