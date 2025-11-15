package crm.task.controller;

import crm.common.URLConstants;
import crm.common.model.Request;
import crm.common.model.AccountRequest;
import crm.common.model.Customer;
import crm.common.model.Account;
import crm.common.model.Contract;
import crm.common.model.Staff;
import crm.common.model.Task;
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
        String taskIdStr = request.getParameter("id");
        if (taskIdStr == null) {
            Object attr = request.getAttribute("id");
            if (attr != null)
                taskIdStr = attr.toString();
        }

        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Task ID is required");
            return;
        }

        try  {
            Connection connection = DBcontext.getConnection();
            int taskId = Integer.parseInt(taskIdStr);
            EntityManager entityManager = new EntityManager(connection);

            Account account = (Account) request.getSession().getAttribute("account");
            if (account == null) {
                response.sendRedirect(request.getContextPath() + URLConstants.AUTH_CUSTOMER_LOGIN);
                return;
            }

            List<Staff> allStaff = entityManager.findAll(Staff.class);
            Staff currentStaff = allStaff.stream()
                    .filter(s -> s.getAccount() != null && account.getUsername().equals(s.getAccount().getUsername()))
                    .findFirst()
                    .orElse(null);

            if (currentStaff == null) {
                request.getSession().setAttribute("errorMessage", "Staff record not found for current user.");
                response.sendRedirect(request.getContextPath() + URLConstants.TECHEM_VIEW_ASSIGNED_TASK);
                return;
            }

            Task taskObj = entityManager.find(Task.class, taskId);
            if (taskObj == null || taskObj.getAssignTo() == null || 
                !currentStaff.getStaffID().equals(taskObj.getAssignTo().getStaffID())) {
                request.getSession().setAttribute("errorMessage", "Task not found or not assigned to you.");
                response.sendRedirect(request.getContextPath() + URLConstants.TECHEM_VIEW_ASSIGNED_TASK);
                return;
            }

            Request requestObj = taskObj.getRequest();

            Customer customer = null;
            Contract contract = null;
            if (requestObj.getContract() != null) {
                contract = requestObj.getContract();
                if (contract.getCustomer() != null) {
                    customer = contract.getCustomer();
                }
            }

            List<AccountRequest> allAccountRequests = entityManager.findAll(AccountRequest.class);
            List<Account> assignedAccounts = allAccountRequests.stream()
                    .filter(ar -> ar.getRequest() != null &&
                            ar.getRequest().getRequestID() != null &&
                            ar.getRequest().getRequestID().equals(requestObj.getRequestID()))
                    .filter(ar -> ar.getAccount() != null && ar.getAccount().getRole() != null &&
                            ar.getAccount().getRole().getRoleID() == 6)
                    .map(AccountRequest::getAccount)
                    .collect(Collectors.toList());

            request.setAttribute("requestObj", requestObj);
            request.setAttribute("taskObj", taskObj);
            request.setAttribute("customer", customer);
            request.setAttribute("contract", contract);
            request.setAttribute("assignedAccounts", assignedAccounts);

            request.getRequestDispatcher("/technician_employee/task_detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid task ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error loading task details: " + e.getMessage());
        }
    }
}
