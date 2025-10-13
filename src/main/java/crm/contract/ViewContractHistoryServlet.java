package crm.contract;

import crm.common.model.Contract;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = "/ViewContractHistory")
public class ViewContractHistoryServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        String contractIdParam = request.getParameter("contractId");
        String startDateParam = request.getParameter("startDate");

        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            page = Integer.parseInt(pageParam);
        }

        int recordsPerPage = 5;
        String itemsPerPageParam = request.getParameter("itemsPerPage");
        if (itemsPerPageParam != null && !itemsPerPageParam.isEmpty()) {
            recordsPerPage = Integer.parseInt(itemsPerPageParam);
        }

        int offset = (page - 1) * recordsPerPage;

        Map<String, Object> conditions = new HashMap<>();
        if (contractIdParam != null && !contractIdParam.isEmpty()) {
            conditions.put("contractID", Integer.parseInt(contractIdParam));
        }
        if (startDateParam != null && !startDateParam.isEmpty()) {
            conditions.put("startDate", java.sql.Date.valueOf(startDateParam));
        }

        List<Contract> contracts;
        int totalRecords;

        if (!conditions.isEmpty()) {
            contracts = em.findWithConditionsAndPagination(Contract.class, conditions, recordsPerPage, offset);
            totalRecords = em.findWithConditions(Contract.class, conditions).size();
        } else {
            contracts = em.findWithPagination(Contract.class, recordsPerPage, offset);
            totalRecords = em.count(Contract.class);
        }

        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        request.setAttribute("contracts", contracts);
        request.setAttribute("count", totalRecords);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("recordsPerPage", recordsPerPage);
        request.setAttribute("contractIdSearch", contractIdParam);
        request.setAttribute("startDateSearch", startDateParam);

        request.getRequestDispatcher("/contract/view_contract_history.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}