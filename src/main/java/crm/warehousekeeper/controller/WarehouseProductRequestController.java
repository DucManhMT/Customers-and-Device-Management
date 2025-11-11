package crm.warehousekeeper.controller;

import crm.common.URLConstants;
import crm.common.model.Account;
import crm.common.model.ProductRequest;
import crm.common.model.Warehouse;
import crm.common.model.enums.ProductRequestStatus;
import crm.common.repository.Warehouse.ProductRequestDAO;
import crm.common.repository.Warehouse.WarehouseDAO;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(urlPatterns = URLConstants.WAREHOUSE_VIEW_PRODUCT_REQUESTS)
public class WarehouseProductRequestController extends HttpServlet {

    EntityManager em;
    ProductRequestDAO productRequestDAO;
    WarehouseDAO warehouseDAO;

    @Override
    public void init(ServletConfig config) throws ServletException {
        em = new EntityManager(DBcontext.getConnection());
        productRequestDAO = new ProductRequestDAO();
        warehouseDAO = new WarehouseDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        int pageSize = 10; // Default items per page
        int currentPage = 1; // Default page

        // Get pagination parameters from request
        String pageSizeParam = req.getParameter("pageSize");
        String pageParam = req.getParameter("page");

        if (pageSizeParam != null && !pageSizeParam.isEmpty()) {
            try {
                pageSize = Integer.parseInt(pageSizeParam);
            } catch (NumberFormatException e) {
                // Use default if invalid
            }
        }

        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) currentPage = 1;
            } catch (NumberFormatException e) {
                // Use default if invalid
            }
        }

        Account account = (Account) req.getSession().getAttribute("account");

        if (account == null) {
            req.getSession().setAttribute("errorMessage", "You haven't logged in yet");
            req.getRequestDispatcher("/warehouse_keeper/view_product_request.jsp").forward(req, resp);
            return;
        }

        Warehouse warehouse = warehouseDAO.getWarehouseByUsername(account.getUsername());

        if (warehouse == null) {
            req.getSession().setAttribute("errorMessage", "You must be assigned to a warehouse to view product requests.");
            req.getRequestDispatcher("/warehouse_keeper/view_product_request.jsp").forward(req, resp);
            return;
        }

        Map<String, Object> conditions = new HashMap<>();
        conditions.put("warehouse", warehouse.getWarehouseID());

        List<ProductRequest> productRequests = productRequestDAO.findWithCondition(conditions);

        if (productRequests.isEmpty()) {
            req.setAttribute("errorMessage", "No product requests found for your warehouse.");
            req.getRequestDispatcher("/warehouse_keeper/view_product_request.jsp").forward(req, resp);
            return;
        }

        int totalRequests = productRequests.size();
        int totalPages = (int) Math.ceil((double) totalRequests / pageSize);

        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }

        int offset = (currentPage - 1) * pageSize;

        productRequests = productRequests.stream()
                .skip(offset)
                .limit(pageSize)
                .collect(Collectors.toList());

        req.setAttribute("productRequests", productRequests);

        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("pageSize", pageSize);
        req.setAttribute("totalRequests", totalRequests);

        req.getRequestDispatcher("/warehouse_keeper/view_product_request.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String productRequestIDStr = req.getParameter("productRequestID");
        String action = req.getParameter("action");

        try {
            em.beginTransaction();
            int productRequestID = Integer.parseInt(productRequestIDStr);

            ProductRequest productRequest = productRequestDAO.findById(productRequestID);

            productRequest.setStatus(action.equals("accept") ? ProductRequestStatus.Accepted : ProductRequestStatus.Rejected);

            productRequestDAO.merge(productRequest);
            em.commit();

            req.getSession().setAttribute("successMessage", "Product request has been " + (action.equals("accept") ? "accepted." : "rejected."));
            resp.sendRedirect(req.getContextPath() + URLConstants.WAREHOUSE_VIEW_PRODUCT_REQUESTS);
        } catch (Exception e) {
            em.rollback();
            req.getSession().setAttribute("errorMessage", "An error occurred while processing the product request.");
            resp.sendRedirect(req.getContextPath() + URLConstants.WAREHOUSE_VIEW_PRODUCT_REQUESTS);
            return;
        }


    }
}
