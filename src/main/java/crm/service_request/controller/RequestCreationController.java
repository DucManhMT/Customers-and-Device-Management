package crm.service_request.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import crm.common.MessageConst;
import crm.common.model.Account;
import crm.common.model.Contract;
import crm.service_request.repository.ContractRepository;
import crm.service_request.service.RequestService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RequestCreationController", urlPatterns = {"/customer/requests/create"})
public class RequestCreationController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        RequestService requestService = new RequestService();

        try {
            String description = req.getParameter("description");
            int contractId = Integer.parseInt(req.getParameter("contractId"));
            if (contractId <= 0) {
                throw new IllegalArgumentException(MessageConst.MSG11);
            }
            if (description == null || description.trim().isEmpty()) {
                throw new IllegalArgumentException(MessageConst.MSG12);
            }

            requestService.createServiceRequest(description, contractId);
            req.setAttribute("success", MessageConst.MSG10);
        } catch (SQLException e) {
            req.setAttribute("description", req.getParameter("description"));
            req.setAttribute("contractId", req.getParameter("contractId"));
            req.setAttribute("error", MessageConst.MSG13);
        } catch (NumberFormatException e) {
            req.setAttribute("description", req.getParameter("description"));
            req.setAttribute("contractId", req.getParameter("contractId"));
            req.setAttribute("error", MessageConst.MSG11);
        } catch (IllegalArgumentException e) {
            req.setAttribute("description", req.getParameter("description"));
            req.setAttribute("contractId", req.getParameter("contractId"));
            req.setAttribute("error", e.getMessage());
        }
        doGet(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Account account = (Account) req.getSession().getAttribute("account");
        ContractRepository contractRepo = new ContractRepository();
        
        if (account == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/customer_login");
            return;
        }

        List<Contract> contracts = contractRepo.findByUsername(account.getUsername());
        req.setAttribute("contracts", contracts);

        req.getRequestDispatcher("/service_request/request-creation.jsp").forward(req, resp);
    }

}
