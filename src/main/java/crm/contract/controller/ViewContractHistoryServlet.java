package crm.contract.controller;

import crm.common.URLConstants;
import crm.common.model.Account;
import crm.common.model.Contract;
import crm.common.model.Customer;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = URLConstants.CUSTOMER_VIEW_CONTRACT_HISTORY)
public class ViewContractHistoryServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Account account = (Account) request.getSession().getAttribute("account");
        if (account == null) {
            response.sendRedirect(request.getContextPath() + URLConstants.AUTH_CUSTOMER_LOGIN);
            return;
        }

        EntityManager em = new EntityManager(DBcontext.getConnection());
        Map<String, Object> customerCondition = new HashMap<>();
        customerCondition.put("account", account.getUsername());
        List<Customer> customers = em.findWithConditions(Customer.class, customerCondition);
        if (customers.isEmpty()) {
            // Không có customer nào thuộc account này
            request.setAttribute("contracts", List.of());
            request.setAttribute("message", "No contract history found for your account.");
            request.getRequestDispatcher("/Customer/view_contract_history.jsp").forward(request, response);
            return;
        }
        Customer customer = customers.get(0);
        String contractCodeParam = request.getParameter("contractCode");
        String startDateParam = request.getParameter("startDate");

        String pageParam = request.getParameter("page");
        String itemsPerPageParam = request.getParameter("itemsPerPage");

        int page = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
        int recordsPerPage = (itemsPerPageParam != null && !itemsPerPageParam.isEmpty())
                ? Integer.parseInt(itemsPerPageParam)
                : 5;


        int offset = (page - 1) * recordsPerPage;

        Map<String, Object> conditions = new HashMap<>();
        conditions.put("customer", customer.getCustomerID());
        List<Contract> allContracts = em.findWithConditions(Contract.class, conditions);
        List<Contract> filteredContracts = allContracts.stream()
                .filter(c -> (contractCodeParam == null || contractCodeParam.isEmpty() ||
                        c.getContractCode().toLowerCase().contains(contractCodeParam.toLowerCase())))
                .filter(c -> {
                    if (startDateParam == null || startDateParam.isEmpty()) return true;
                    return c.getStartDate().toString().equals(startDateParam);
                })
                .toList();

        int totalRecords = filteredContracts.size();
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        int fromIndex = Math.min(offset, totalRecords);
        int toIndex = Math.min(offset + recordsPerPage, totalRecords);
        List<Contract> contracts = filteredContracts.subList(fromIndex, toIndex);


        request.setAttribute("contracts", contracts);
        request.setAttribute("count", totalRecords);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("recordsPerPage", recordsPerPage);
        request.setAttribute("contractCodeSearch", contractCodeParam);
        request.setAttribute("startDateSearch", startDateParam);


        request.getRequestDispatcher("/customer/view_contract_history.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}