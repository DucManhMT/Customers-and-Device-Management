package crm.task.controller;

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

@WebServlet("/task/detail")
public class TaskDetailServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String requestIdStr = request.getParameter("id");
        
        if (requestIdStr == null || requestIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Task ID is required");
            return;
        }
        
        Connection connection = null;
        try {
            int requestId = Integer.parseInt(requestIdStr);
            connection = DBcontext.getConnection();
            EntityManager entityManager = new EntityManager(connection);
            
            Request task = entityManager.find(Request.class, requestId);
            if (task == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Task not found");
                return;
            }
            
            Customer customer = null;
            Contract contract = null;
            if (task.getContract() != null) {
                contract = task.getContract();
                if (contract.getCustomer() != null) {
                    customer = contract.getCustomer();
                }
            }

            List<AccountRequest> allAccountRequests = entityManager.findAll(AccountRequest.class);
            List<Account> assignedAccounts = allAccountRequests.stream()
                    .filter(ar -> ar.getRequest() != null && 
                                 ar.getRequest().getRequestID() != null && 
                                 ar.getRequest().getRequestID().equals(requestId))
                    .filter(ar -> ar.getAccount() != null)
                    .map(ar -> ar.getAccount())
                    .collect(Collectors.toList());
            
            request.setAttribute("task", task);
            request.setAttribute("customer", customer);
            request.setAttribute("contract", contract);
            request.setAttribute("assignedAccounts", assignedAccounts);
            
            request.getRequestDispatcher("/task/techemployee/taskDetail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid task ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading task details: " + e.getMessage());
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }
}