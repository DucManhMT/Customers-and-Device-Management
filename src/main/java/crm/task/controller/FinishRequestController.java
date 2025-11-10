package crm.task.controller;

import java.io.IOException;

import crm.common.MessageConst;
import crm.common.URLConstants;
import crm.common.model.Account;
import crm.service_request.service.RequestService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = URLConstants.TECHLEAD_FINISH_REQUEST, name = "FinishRequestController")
public class FinishRequestController extends HttpServlet {
    private final RequestService requestService = new RequestService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String requestIdParam = req.getParameter("requestId");
        Account account = (Account) req.getSession().getAttribute("account");

        if (account == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/staff_login");
            return;
        }

        try {
            if (requestIdParam == null || requestIdParam.isEmpty()) {
                throw new IllegalArgumentException(MessageConst.MSG16);
            }

            int requestId = Integer.parseInt(requestIdParam);
            requestService.finishRequest(requestId, null);

            req.setAttribute("id", requestId);
            resp.sendRedirect(req.getContextPath() + "/task/detail?id=" + requestIdParam);
            return;
        } catch (IllegalArgumentException e) {
            req.setAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            req.setAttribute("errorMessage", MessageConst.MSG15);
        }
        req.getRequestDispatcher("/task/detail?id=" + requestIdParam).forward(req, resp);

    }
}
