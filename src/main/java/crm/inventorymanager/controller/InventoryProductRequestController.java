package crm.inventorymanager.controller;

import crm.common.URLConstants;
import crm.common.model.ProductRequest;
import crm.common.model.enums.ProductRequestStatus;
import crm.common.repository.Warehouse.WarehouseDAO;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.inventorymanager.service.AssignWarehouseService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = URLConstants.INVENTORY_VIEW_PRODUCT_REQUESTS)
public class InventoryProductRequestController extends HttpServlet {

    EntityManager em = new EntityManager(DBcontext.getConnection());
    WarehouseDAO warehouseDAO = new WarehouseDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        Map<String, Object> conditions = new HashMap<>();
        conditions.put("status", ProductRequestStatus.Pending.name());

        List<ProductRequest> productRequests = em.findWithConditions(ProductRequest.class, conditions);
        List<Map<String, Object>> inventorySummary = warehouseDAO.getInventorySummary();

        if (productRequests.isEmpty()) {
            req.getSession().setAttribute("errorMessage", "No product requests found.");
            req.getRequestDispatcher("/inventory_manager/view_product_requests.jsp").forward(req, resp);
            return;
        }

        req.setAttribute("productRequests", productRequests);
        req.setAttribute("inventorySummary", inventorySummary);
        req.getRequestDispatcher("/inventory_manager/view_product_requests.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String productRequestIdStr = req.getParameter("productRequestID");
        String warehouseIdStr = req.getParameter("warehouseID");

        if (productRequestIdStr == null || productRequestIdStr.isEmpty() ||
                warehouseIdStr == null || warehouseIdStr.isEmpty()) {
            req.getSession().setAttribute("errorMessage", "Invalid product request or warehouse ID.");
            resp.sendRedirect(req.getContextPath() + URLConstants.INVENTORY_VIEW_PRODUCT_REQUESTS);
            return;
        } else {
            try {
                int productRequestId = Integer.parseInt(productRequestIdStr);
                int warehouseId = Integer.parseInt(warehouseIdStr);

                boolean isAssigned = AssignWarehouseService.AssignWarehouseToRequest(productRequestId, warehouseId);

                if (!isAssigned) {
                    req.getSession().setAttribute("errorMessage", "Failed to assign warehouse to product request.");
                    resp.sendRedirect(req.getContextPath() + URLConstants.INVENTORY_VIEW_PRODUCT_REQUESTS);
                    return;
                } else {
                    req.getSession().setAttribute("successMessage",
                            "Warehouse assigned to product request successfully.");
                    resp.sendRedirect(req.getContextPath() + URLConstants.INVENTORY_VIEW_PRODUCT_REQUESTS);
                    return;
                }
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        }
    }
}
