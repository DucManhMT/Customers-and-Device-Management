package crm.warehouse;

import crm.common.model.Product;
import crm.common.model.ProductWarehouse;
import crm.common.model.Type;
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
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(urlPatterns = "/warehouse/viewInventory")
public class ViewInventoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        // Filter parameters
//        String productNameFilter = req.getParameter("productName");
//        String productTypeFilter = req.getParameter("productType");
//
//        // Pagination parameters
//        int pageSize = 10; // Default items per page
//        int currentPage = 1; // Default page
//
//        // Get pagination parameters from request
//        String pageSizeParam = req.getParameter("pageSize");
//        String pageParam = req.getParameter("page");
//
//        if (pageSizeParam != null && !pageSizeParam.isEmpty()) {
//            try {
//                pageSize = Integer.parseInt(pageSizeParam);
//            } catch (NumberFormatException e) {
//                // Use default if invalid
//            }
//        }
//
//        if (pageParam != null && !pageParam.isEmpty()) {
//            try {
//                currentPage = Integer.parseInt(pageParam);
//                if (currentPage < 1) currentPage = 1;
//            } catch (NumberFormatException e) {
//                // Use default if invalid
//            }
//        }
//
//        //Find products in warehouse
//        WarehouseDAO warehouseDAO = new WarehouseDAO();
//        ProductWarehouseDAO productWarehouseDAO = new ProductWarehouseDAO();
//
//        List<ProductWarehouse> products = warehouseDAO.getInventory();
//
//        Map<Integer, Map<Integer, Long>> productCountsByWarehouse = products.stream()
//                .collect(Collectors.groupingBy(
//                        pw -> pw.getWarehouse().getWarehouseID(),
//                        Collectors.groupingBy(
//                                pw -> pw.getInventoryItem().getProduct().getProductID(),
//                                Collectors.counting()
//                        )
//                ));
//
//        // Get unique product types for filter dropdown
//        TypeDAO typeDAO = new TypeDAO();
//        List<Type> ProductTypes = typeDAO.findAll();
//
//
//        //Filter
//        if (productNameFilter != null && !productNameFilter.isEmpty()) {
//            products = products.stream()
//                    .filter(p -> p.getInventoryItem().getProduct().getProductName().toLowerCase().contains(productNameFilter.toLowerCase()))
//                    .collect(Collectors.toCollection(LinkedList::new));
//        }
//
//        if (productTypeFilter != null && !productTypeFilter.isEmpty()) {
//            products = products.stream()
//                    .filter(p -> p.getInventoryItem().getProduct().getType().getTypeName().equalsIgnoreCase(productTypeFilter))
//                    .collect(Collectors.toCollection(LinkedList::new));
//        }
//
//        // Pagination logic
//        int totalProducts = products.size();
//        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
//
//        if (currentPage > totalPages && totalPages > 0) {
//            currentPage = totalPages;
//        }
//
//        int offset = (currentPage - 1) * pageSize;
//
//        // Get products for current page
//        List<ProductWarehouse> pagedProductWarehouse = products.stream()
//                .skip((offset))
//                .limit(pageSize)
//                .collect(Collectors.toList());
//
//        // Send paged products to view instead of all products
//        req.setAttribute("products", pagedProductWarehouse);
//        req.setAttribute("productCountsByWarehouse", productCountsByWarehouse);
//        req.setAttribute("uniqueProductTypes", ProductTypes);
//
//        // Pagination metadata
//        req.setAttribute("currentPage", currentPage);
//        req.setAttribute("totalPages", totalPages);
//        req.setAttribute("pageSize", pageSize);
//        req.setAttribute("totalProducts", totalProducts);
//
//        // Pass filter parameters for pagination links
//        req.setAttribute("productName", productNameFilter);
//        req.setAttribute("productType", productTypeFilter);
//
//        req.getRequestDispatcher("/Warehouse/ViewInventory.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        super.doPost(req, resp);
    }
}
