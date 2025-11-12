package crm.router.inventorymanager;

import crm.common.URLConstants;
import crm.common.model.Product;
import crm.common.model.ProductRequest;
import crm.common.model.ProductWarehouse;
import crm.common.model.WarehouseRequest;
import crm.common.model.enums.ProductRequestStatus;
import crm.common.model.enums.WarehouseRequestStatus;
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

@WebServlet(URLConstants.INVENTORY_DASHBOARD)
public class toInventoryManagerDashboard extends HttpServlet {
    EntityManager em;

    @Override
    public void init(ServletConfig config) throws ServletException {
        em = new EntityManager(DBcontext.getConnection());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Get Warehouse Request statistics
        Map<String, Integer> warehouseRequestStats = new HashMap<>();
        List<WarehouseRequest> warehouseRequests = em.findAll(WarehouseRequest.class);
        for (WarehouseRequestStatus status : WarehouseRequestStatus.values()) {
            long count = warehouseRequests.stream()
                    .filter(wr -> wr.getWarehouseRequestStatus() == status)
                    .count();
            warehouseRequestStats.put(status.name(), (int) count);
        }

        // Get Product Request statistics
        Map<String, Integer> productRequestStats = new HashMap<>();
        List<ProductRequest> productRequests = em.findAll(ProductRequest.class);
        for (ProductRequestStatus status : ProductRequestStatus.values()) {
            long count = productRequests.stream()
                    .filter(pr -> pr.getStatus() == status)
                    .count();
            productRequestStats.put(status.name(), (int) count);
        }

        // Get total products
        int totalProducts = em.findAll(Product.class).size();

        // Get total product stock in warehouse
        int totalProductStock = em.findAll(ProductWarehouse.class).size();

        req.setAttribute("warehouseRequestStats", warehouseRequestStats);
        req.setAttribute("productRequestStats", productRequestStats);
        req.setAttribute("totalProducts", totalProducts);
        req.setAttribute("totalProductStock", totalProductStock);

        req.setAttribute("timelineData", prepareTimelineData(warehouseRequests, productRequests));
        req.getRequestDispatcher("/inventory_manager/inventorymanager_dashboard.jsp").forward(req, resp);
    }

    // Add this method to prepare timeline data
    private Map<String, Object> prepareTimelineData(List<WarehouseRequest> warehouseRequests, List<ProductRequest> productRequests) {
        Map<String, Object> timelineData = new HashMap<>();

        // Group by date for warehouse requests
        Map<String, Long> warehouseDateCounts = warehouseRequests.stream()
                .collect(Collectors.groupingBy(
                        wr -> wr.getDate().toLocalDate().toString(),
                        Collectors.counting()
                ));

        // Group by date for product requests
        Map<String, Long> productDateCounts = productRequests.stream()
                .collect(Collectors.groupingBy(
                        pr -> pr.getRequestDate().toString(),
                        Collectors.counting()
                ));

        timelineData.put("warehouse", warehouseDateCounts);
        timelineData.put("product", productDateCounts);

        return timelineData;
    }
}
