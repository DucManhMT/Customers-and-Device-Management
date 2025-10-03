package crm.service_request.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import crm.common.model.Contract;
import crm.common.model.Request;
import crm.common.repository.ContractRepository;
import crm.core.repository.persistence.config.TransactionManager;
import crm.service_request.service.RequestService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.transaction.Transaction;

@WebServlet(name = "RequestCreationController", urlPatterns = { "/requests/create" })
public class RequestCreationController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        RequestService requestService = new RequestService();
        try {
            String description = req.getParameter("description");
            Long contractId = Long.parseLong(req.getParameter("contractId"));
            if (contractId == null || contractId <= 0) {
                throw new IllegalArgumentException("Contract ID cannot be null !");
            }
            if (description == null || description.trim().isEmpty()) {
                throw new IllegalArgumentException("Description cannot be empty !");
            }
            requestService.createServiceRequest(description, contractId);
            req.setAttribute("success", "Request created successfully ");
        } catch (SQLException e) {
            req.setAttribute("description", req.getParameter("description"));
            req.setAttribute("contractId", req.getParameter("contractId"));
            req.setAttribute("error", "Something went wrong while creating request !");
        } catch (NumberFormatException e) {
            req.setAttribute("description", req.getParameter("description"));
            req.setAttribute("contractId", req.getParameter("contractId"));
            req.setAttribute("error", "Contract ID cannot be null !");
        } catch (IllegalArgumentException e) {
            req.setAttribute("description", req.getParameter("description"));
            req.setAttribute("contractId", req.getParameter("contractId"));
            req.setAttribute("error", e.getMessage());
        }
        doGet(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Contract> contracts = null;
        try {
            // will update later to find contract by customer id
            ContractRepository contractRepo = new ContractRepository();
            TransactionManager.beginTransaction();
            contracts = (List<Contract>) contractRepo.findAll();
        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } finally {
            try {
                TransactionManager.commit();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        req.setAttribute("contracts", contracts);

        req.getRequestDispatcher("/service-request/request-creation.jsp").forward(req, resp);
    }

}
