package crm.contract.controller;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

import crm.common.URLConstants;
import crm.common.model.Contract;
import crm.contract.service.ContractService;
import crm.service_request.repository.persistence.query.common.Page;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = URLConstants.CUSTOMER_SUPPORTER_VIEW_CONTRACTS, name = "ViewSupporterContractListServlet")
public class ViewSupporterContractList extends HttpServlet {

    private static final int DEFAULT_PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ContractService contractService = new ContractService();

        String contractCodeFilter = trimOrNull(req.getParameter("contractCode"));
        String customerNameFilter = trimOrNull(req.getParameter("customerName"));
        int page = parsePositiveInt(req.getParameter("page"), 1); // 1-based page index
        int size = parsePositiveInt(req.getParameter("size"), DEFAULT_PAGE_SIZE);

        Page<Contract> contractPage = contractService.getContractsByPage(page, size, customerNameFilter,
                contractCodeFilter);
        List<Contract> pageData = (contractPage != null && contractPage.getContent() != null)
                ? contractPage.getContent()
                : Collections.emptyList();
        int totalRecords = contractPage != null ? (int) contractPage.getTotalElements() : 0;
        int totalPages = contractPage != null ? contractPage.getTotalPages() : 0;

        req.setAttribute("contracts", pageData);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalRecords", totalRecords);
        req.setAttribute("recordsPerPage", size);
        req.setAttribute("contractCode", contractCodeFilter);
        req.setAttribute("customerName", customerNameFilter);

        try {
            req.getRequestDispatcher("/customer_supporter/supporter_contract_list.jsp").forward(req, resp);
        } catch (ServletException | IOException e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private String trimOrNull(String s) {
        if (s == null)
            return null;
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }

    private int parsePositiveInt(String s, int defaultVal) {
        if (s == null || s.isBlank())
            return defaultVal;
        try {
            int v = Integer.parseInt(s.trim());
            return v > 0 ? v : defaultVal;
        } catch (NumberFormatException e) {
            return defaultVal;
        }
    }

}
