package crm.service_request.controller;

import java.io.IOException;

import crm.common.model.Account;
import crm.common.model.Request;
import crm.core.validator.Validator;
import crm.service_request.repository.ContractRepository;
import crm.service_request.repository.CustomerRepository;
import crm.service_request.repository.persistence.query.common.Page;
import crm.service_request.service.RequestService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "CustomerRequestController", urlPatterns = { "/customer/requests" })
public class CustomerRequestController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ContractRepository contractRepository = new ContractRepository();
        Account account = (Account) req.getSession().getAttribute("account");
        CustomerRepository customerRepository = new CustomerRepository();
        RequestService requestService = new RequestService();
        try {
            // Default values, magic numbers should be avoided in future
            int page = 1;
            int recordsPerPage = 15;
            if (req.getParameter("page") != null)
                page = Integer.parseInt(req.getParameter("page"));
            if (req.getParameter("recordsPerPage") != null)
                recordsPerPage = Integer.parseInt(req.getParameter("recordsPerPage"));
            // Get filter params
            String field = req.getParameter("field");
            String sort = req.getParameter("sort");
            int contractId = Validator.parseInt(req.getParameter("contractId"), 0);
            System.out.println("Contract ID: " + contractId);
            String status = req.getParameter("status");

            req.setAttribute("contracts", contractRepository.findByUsername(account.getUsername()));

            Page<Request> requestPage = requestService.getRequestByUsername(account.getUsername(), field, sort, null,
                    status, contractId, page, recordsPerPage);

            req.setAttribute("currentPage", page);
            req.setAttribute("recordsPerPage", recordsPerPage);
            req.setAttribute("totalPages", requestPage.getTotalPages());
            req.setAttribute("totalRecords", requestPage.getTotalElements());
            req.setAttribute("field", field);
            req.setAttribute("sort", sort);
            req.setAttribute("status", status);
            req.setAttribute("contractId", contractId);
            req.setAttribute("requests", requestPage.getContent());
            req.setAttribute("isFirstPage", requestPage.isFirst());
            req.setAttribute("isLastPage", requestPage.isLast());
        } catch (Exception e) {
            req.setAttribute("error", "Something went wrong while displaying requests!");
        }
        req.getRequestDispatcher("/service_request/view-service-request.jsp").forward(req, resp);
    }

}
