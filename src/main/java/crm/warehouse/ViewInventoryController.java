package crm.warehouse;

import crm.common.model.Product;
import crm.common.model.ProductWarehouse;
import crm.common.model.Warehouse;
import crm.common.repository.Warehouse.ProductWarehouseDAO;
import crm.common.repository.Warehouse.TypeDAO;
import crm.common.repository.Warehouse.WarehouseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.lang.reflect.Type;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(urlPatterns = "/warehouse/viewInventory")
public class ViewInventoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Filter parameters
        String productNameFilter = req.getParameter("productName");
        String productTypeFilter = req.getParameter("productType");
        String warehouseFilter = req.getParameter("warehouse");

        // Pagination parameters
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

        // Get product types for filter dropdown
        TypeDAO typeDAO = new TypeDAO();
        List<Type> ProductTypes = typeDAO.findAll();

        //Find products in warehouse
        WarehouseDAO warehouseDAO = new WarehouseDAO();
        List<Map<String, Object>> inventorySummary = warehouseDAO.getInventorySummary();

        //Get warehouse for filter dropdown
        List<Warehouse> warehouses = warehouseDAO.findAll();


        // Apply filters
        if (productNameFilter != null && !productNameFilter.isEmpty()) {
            inventorySummary = inventorySummary.stream()
                    .filter(item -> {
                        Product product = (Product) item.get("product");
                        return product.getProductName().toLowerCase().contains(productNameFilter.toLowerCase());
                    })
                    .collect(Collectors.toList());
        }

        if (productTypeFilter != null && !productTypeFilter.isEmpty()) {
            inventorySummary = inventorySummary.stream()
                    .filter(item -> {
                        Product product = (Product) item.get("product");
                        return product.getType().getTypeName().equalsIgnoreCase(productTypeFilter);
                    })
                    .collect(Collectors.toList());
        }

        if(warehouseFilter != null && !warehouseFilter.isEmpty()) {
            inventorySummary = inventorySummary.stream()
                    .filter(item -> {
                        Warehouse warehouse = (Warehouse) item.get("warehouse");
                        return warehouse.getWarehouseName().equalsIgnoreCase(warehouseFilter);
                    })
                    .collect(Collectors.toList());
        }

        // Pagination logic
        int totalProducts = inventorySummary.size();
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }

        int offset = (currentPage - 1) * pageSize;


        // Get inventory items for current page
        List<Map<String, Object>> pagedInventory = inventorySummary.stream()
                .skip(offset)
                .limit(pageSize)
                .collect(Collectors.toList());

        // Send paged products to view instead of all products
        req.setAttribute("inventorySummary", pagedInventory);
        req.setAttribute("uniqueProductTypes", ProductTypes);
        req.setAttribute("warehouses", warehouses);

        // Pagination metadata
        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("pageSize", pageSize);
        req.setAttribute("totalProducts", totalProducts);

        // Pass filter parameters for pagination links
        req.setAttribute("productName", productNameFilter);
        req.setAttribute("productType", productTypeFilter);
        req.setAttribute("warehouse", warehouseFilter);

        req.getRequestDispatcher("/Warehouse/ViewInventory.jsp").forward(req, resp);
    }


}
