package crm.tech.controller;

import crm.common.model.*;
import crm.common.model.enums.ProductRequestStatus;
import crm.common.repository.Request.RequestDAO;
import crm.common.repository.Warehouse.*;
import crm.core.service.IDGeneratorService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(urlPatterns = "/tech/employees/createProductRequests")
public class ProductRequestController extends HttpServlet {

    WarehouseDAO warehouseDAO = new WarehouseDAO();
    ProductWarehouseDAO productWarehouseDAO = new ProductWarehouseDAO();
    TypeDAO typeDAO = new TypeDAO();
    ProductDAO productDAO = new ProductDAO();
    RequestDAO requestDAO = new RequestDAO();
    ProductRequestDAO productRequestDAO = new ProductRequestDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        //Get list of warehouses for dropdown
        List<Warehouse> warehouses = warehouseDAO.findAll();

        req.setAttribute("warehouses", warehouses);

        String selectedWarehouseIDStr = req.getParameter("selectedWarehouseID");
        String requestIDStr = req.getParameter("requestIDStr");
        if (requestIDStr == null) {
            requestIDStr = req.getParameter("requestID");
        }
        req.setAttribute("requestIDStr", requestIDStr);

        if (req.getParameter("selectedWarehouseID") != null) {
            processRequest(req, resp, selectedWarehouseIDStr);
        }

        req.getRequestDispatcher("/technician_employee/create_product_request.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String allSelectedItemIDs = req.getParameter("allSelectedItemIDs");
        String allSelectedItemQuantities = req.getParameter("allSelectedItemQuantities");
        String selectedWarehouseIDStr = req.getParameter("selectedWarehouseID");
        String note = req.getParameter("note");
        String requestIDStr = req.getParameter("requestIDStr");

        if (allSelectedItemIDs == null || allSelectedItemIDs.length() == 0) {
            // Handle the case where no products are selected
            req.setAttribute("errorMessage", "Please select at least one product to request.");
            // Forward back to the page, possibly reloading necessary data from doGet
            doGet(req, resp);
            return;
        }

        if (allSelectedItemQuantities == null || allSelectedItemQuantities.length() == 0) {
            req.setAttribute("errorMessage", "Quantities for selected products are missing.");
            doGet(req, resp);
            return;
        }

        if (requestIDStr == null || requestIDStr.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Request ID is missing. Please start the process again.");
            doGet(req, resp);
            return;
        }

        String[] selectedProductIDs = allSelectedItemIDs.split(",");
        String[] selectedProductQuantitiesStr = allSelectedItemQuantities.split(",");

        int requestID = Integer.parseInt(requestIDStr);
        Request request = requestDAO.find(requestID);

        int selectedWarehouseID = Integer.parseInt(selectedWarehouseIDStr);
        Warehouse warehouse = warehouseDAO.find(selectedWarehouseID);

        try {
            for (int i = 0; i < selectedProductIDs.length; i++) {
                String productIdStr = selectedProductIDs[i];
                String quantityStr = selectedProductQuantitiesStr[i];

                if (quantityStr == null || quantityStr.trim().isEmpty()) {
                    req.setAttribute("errorMessage", "Please enter a quantity for all selected products.");
                    doGet(req, resp);
                    return;
                }

                int productID = Integer.parseInt(productIdStr);
                int quantity = Integer.parseInt(quantityStr);

                Product product = productDAO.find(productID);

                ProductRequest productRequest = new ProductRequest();

                productRequest.setProductRequestID(IDGeneratorService.generateID(ProductRequest.class));
                productRequest.setRequest(request);
                productRequest.setQuantity(quantity);
                productRequest.setRequestDate(LocalDate.now());
                productRequest.setDescription(note);
                productRequest.setStatus(ProductRequestStatus.Pending);
                productRequest.setProduct(product);
                productRequest.setWarehouse(warehouse);

                productRequestDAO.persist(productRequest);
            }

            resp.sendRedirect(req.getContextPath() + "/tech/employees/viewProductRequest");

        } catch (NumberFormatException e) {
            req.setAttribute("errorMessage", "Invalid data submitted. Please check product quantities.");
            doGet(req, resp);
        } catch (Exception e) {
            req.setAttribute("errorMessage", "An error occurred while creating the request.");
            doGet(req, resp);
        }
    }

    private void processRequest(HttpServletRequest req, HttpServletResponse resp, String selectedWarehouseIDStr) throws
            ServletException, IOException {
        // Filter parameters
        String productNameFilter = req.getParameter("productName");
        String productTypeFilter = req.getParameter("productType");

        //Take request ID
        String requestIDStr = req.getParameter("requestIDStr");

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

        int selectedWarehouseID;
        try {
            selectedWarehouseID = Integer.parseInt(selectedWarehouseIDStr);
        } catch (NumberFormatException e) {
            req.setAttribute("errorMessage", "Invalid warehouse ID.");
            return;
        }

        //Product in selected Warehouse
        List<Product> productsInSelectedWarehouse = warehouseDAO.getProductsInWarehouse(selectedWarehouseID);
        List<ProductWarehouse> pw = productWarehouseDAO.findAll();

        Map<Integer, Long> productCounts = pw.stream()
                .filter(pw1 -> pw1.getWarehouse().getWarehouseID() == selectedWarehouseID)
                .collect(Collectors.groupingBy(
                        pw1 -> pw1.getInventoryItem().getProduct().getProductID(),
                        Collectors.counting()
                ));


        //filter by product type
        List<Type> ProductTypes = typeDAO.findAll();

        if (productNameFilter != null && !productNameFilter.isEmpty()) {
            productsInSelectedWarehouse = productsInSelectedWarehouse.stream()
                    .filter(p -> p.getProductName().toLowerCase().contains(productNameFilter.toLowerCase()))
                    .collect(Collectors.toCollection(LinkedList::new));
        }

        if (productTypeFilter != null && !productTypeFilter.isEmpty()) {
            productsInSelectedWarehouse = productsInSelectedWarehouse.stream()
                    .filter(p -> p.getType().getTypeID() == Integer.parseInt(productTypeFilter))
                    .collect(Collectors.toCollection(LinkedList::new));
        }

        int totalProducts = productsInSelectedWarehouse.size();
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }

        int offset = (currentPage - 1) * pageSize;

        List<Product> paginatedProducts = productsInSelectedWarehouse.stream()
                .skip(offset)
                .limit(pageSize)
                .toList();

        //Warehouse attributes
        req.setAttribute("productsInSelectedWarehouse", paginatedProducts);
        req.setAttribute("productCounts", productCounts);
        req.setAttribute("uniqueProductTypes", ProductTypes);

        //Request ID attribute
        req.setAttribute("requestIDStr", requestIDStr);

        //Pagination attributes
        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("pageSize", pageSize);
        req.setAttribute("totalProducts", totalProducts);

        //Selected warehouse attribute
        req.setAttribute("selectedWarehouseID", selectedWarehouseIDStr);

        // Pass filter parameters for pagination links
        req.setAttribute("productName", productNameFilter);
        req.setAttribute("productType", productTypeFilter);
    }
}
