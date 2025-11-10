package crm.task.controller;

import crm.common.URLConstants;
import crm.common.model.Request;
import crm.common.model.AccountRequest;
import crm.common.model.Customer;
import crm.common.model.Account;
import crm.common.model.Contract;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "RequestDetailServlet", urlPatterns = {URLConstants.REQUSET_DETAIL})
public class TaskDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleTaskDetail(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleTaskDetail(request, response);
    }

    private void handleTaskDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String requestIdStr = request.getParameter("id");
        if (requestIdStr == null) {
            Object attr = request.getAttribute("id");
            if (attr != null)
                requestIdStr = attr.toString();
        }

        if (requestIdStr == null || requestIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Request ID is required");
            return;
        }

        try (Connection connection = DBcontext.getConnection()) {
            int requestId = Integer.parseInt(requestIdStr);
            EntityManager entityManager = new EntityManager(connection);

            Request task = entityManager.find(Request.class, requestId);
            if (task == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Request not found");
                return;
            }

            Customer customer = null;
            Contract contract = null;
            if (task.getContract() != null) {
                contract = task.getContract();
                customer = (contract.getCustomer() != null) ? contract.getCustomer() : null;
            }

            List<AccountRequest> allAccountRequests = entityManager.findAll(AccountRequest.class);
            List<Account> assignedAccounts = allAccountRequests.stream()
                    .filter(ar -> ar.getRequest() != null &&
                            ar.getRequest().getRequestID() != null &&
                            ar.getRequest().getRequestID().equals(requestId))
                    .filter(ar -> ar.getAccount() != null && ar.getAccount().getRole() != null &&
                            ar.getAccount().getRole().getRoleID() == 6)
                    .map(AccountRequest::getAccount)
                    .collect(Collectors.toList());

            request.setAttribute("task", task);
            request.setAttribute("customer", customer);
            request.setAttribute("contract", contract);
            request.setAttribute("assignedAccounts", assignedAccounts);

            request.getRequestDispatcher("/technician_employee/task_detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error loading task details: " + e.getMessage());
        }
    }
}
