package crm.warehouse;

import crm.common.model.*;
import crm.common.repository.Warehouse.ProductWarehouseDAO;
import crm.common.repository.Warehouse.TypeDAO;
import crm.common.repository.Warehouse.WarehouseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(urlPatterns = "/warehouse/viewProductWarehouse")
public class ViewProductWarehouseController extends HttpServlet {

    private final String ERROR_MESSAGE = "You currently do not have a warehouse assigned. Please contact the administrator.";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Filter parameters
        String productNameFilter = req.getParameter("productName");
        String productTypeFilter = req.getParameter("productType");

        Account account = (Account) req.getSession().getAttribute("account");

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


        //Find products in warehouse
        WarehouseDAO warehouseDAO = new WarehouseDAO();
        ProductWarehouseDAO productWarehouseDAO = new ProductWarehouseDAO();

        Warehouse warehouse = warehouseDAO.getWarehouseByUsername(account.getUsername());

        if (warehouse == null) {
            req.setAttribute("warehouseError", warehouse);
            req.setAttribute("errorMessage", ERROR_MESSAGE);
            req.getRequestDispatcher("/Warehouse/ViewProduct.jsp").forward(req, resp);
            return;
        }

        final int warehouseID = warehouse.getWarehouseID();

        List<Product> products = warehouseDAO.getProductsInWarehouse(warehouse.getWarehouseID());

        List<ProductWarehouse> pw = productWarehouseDAO.findAll();

        Map<Integer, Long> productCounts = pw.stream()
                .filter(pw1 -> pw1.getWarehouse().getWarehouseID() == warehouseID)
                .collect(Collectors.groupingBy(
                        pw1 -> pw1.getInventoryItem().getProduct().getProductID(),
                        Collectors.counting()
                ));

        // Get unique product types for filter dropdown
        TypeDAO typeDAO = new TypeDAO();
        List<Type> ProductTypes = typeDAO.findAll();


        //Filter
        if (productNameFilter != null && !productNameFilter.isEmpty()) {
            products = products.stream()
                    .filter(p -> p.getProductName().toLowerCase().contains(productNameFilter.toLowerCase()))
                    .collect(Collectors.toCollection(LinkedList::new));
        }

        if (productTypeFilter != null && !productTypeFilter.isEmpty()) {
            products = products.stream()
                    .filter(p -> p.getType().getTypeName().equalsIgnoreCase(productTypeFilter))
                    .collect(Collectors.toCollection(LinkedList::new));
        }

        // Pagination logic
        int totalProducts = products.size();
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }

        int offset = (currentPage - 1) * pageSize;

        // Get products for current page
        List<Product> pagedProducts = products.stream()
                .skip((offset))
                .limit(pageSize)
                .collect(Collectors.toList());

        // Send paged products to view instead of all products
        req.setAttribute("products", pagedProducts);
        req.setAttribute("productCounts", productCounts);
        req.setAttribute("uniqueProductTypes", ProductTypes);

        // Pagination metadata
        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("pageSize", pageSize);
        req.setAttribute("totalProducts", totalProducts);

        // Pass filter parameters for pagination links
        req.setAttribute("productName", productNameFilter);
        req.setAttribute("productType", productTypeFilter);

        req.getRequestDispatcher("/Warehouse/ViewProduct.jsp").forward(req, resp);
    }

}
