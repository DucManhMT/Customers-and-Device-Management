package crm.warehousekeeper.controller;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import crm.common.URLConstants;
import crm.common.model.Account;
import crm.common.model.Product;
import crm.common.model.ProductWarehouse;
import crm.common.model.Type;
import crm.common.model.Warehouse;
import crm.common.model.WarehouseRequest;
import crm.common.model.WarehouseRequestProduct;
import crm.common.model.enums.WarehouseRequestStatus;
import crm.common.repository.Warehouse.ProductDAO;
import crm.common.repository.Warehouse.ProductWarehouseDAO;
import crm.common.repository.Warehouse.TypeDAO;
import crm.common.repository.Warehouse.WarehouseDAO;
import crm.common.repository.Warehouse.WarehouseRequestDAO;
import crm.common.repository.Warehouse.WarehouseRequestProductDAO;
import crm.core.service.IDGeneratorService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet(urlPatterns = URLConstants.WAREHOUSE_CREATE_EXPORT_REQUEST)
public class ExportRequestCreateController extends HttpServlet {
    //DAOs
    WarehouseDAO warehouseDAO = new WarehouseDAO();
    ProductWarehouseDAO productWarehouseDAO = new ProductWarehouseDAO();
    TypeDAO typeDAO = new TypeDAO();
    ProductDAO productDAO = new ProductDAO();
    WarehouseRequestDAO warehouseRequestDAO = new WarehouseRequestDAO();
    WarehouseRequestProductDAO warehouseRequestProductDAO = new WarehouseRequestProductDAO();


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        //Get warehouse keeper account
        Account account = (Account) req.getSession().getAttribute("account");

        //Get current login warehouseKeeper's warehouse
        Warehouse managerWarehouse = warehouseDAO.getWarehouseByUsername(account.getUsername());

        //Get list of warehouses for dropdown
        List<Warehouse> warehouses = warehouseDAO.findAll();
        warehouses = warehouses.stream()
                .filter(w -> !w.getWarehouseID().equals(managerWarehouse.getWarehouseID()))
                .collect(Collectors.toList());

        req.setAttribute("warehouses", warehouses);

        req.setAttribute("managerWarehouse", managerWarehouse);

        String selectedWarehouseIDStr = req.getParameter("selectedWarehouseID");

        if (req.getParameter("selectedWarehouseID") != null) {
            processRequest(req, resp, selectedWarehouseIDStr);
        }


        req.getRequestDispatcher("/warehouse_keeper/create_export_internal.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String allSelectedItemIDs = req.getParameter("allSelectedItemIDs");
        String allSelectedItemQuantities = req.getParameter("allSelectedItemQuantities");
        String selectedWarehouseIDStr = req.getParameter("selectedWarehouseID");
        String note = req.getParameter("note");

        if (allSelectedItemIDs == null || allSelectedItemIDs.length() == 0) {
            // Handle the case where no products are selected
            req.setAttribute("errorMessage", "Please select at least one product to export.");
            // Forward back to the page, possibly reloading necessary data from doGet
            doGet(req, resp);
            return;
        }

        if (allSelectedItemQuantities == null || allSelectedItemQuantities.length() == 0) {
            req.setAttribute("errorMessage", "Quantities for selected products are missing.");
            doGet(req, resp);
            return;
        }

        String[] selectedProductIDs = allSelectedItemIDs.split(",");
        String[] selectedProductQuantitiesStr = allSelectedItemQuantities.split(",");

        int selectedWarehouseID = Integer.parseInt(selectedWarehouseIDStr);

        Account account = (Account) req.getSession().getAttribute("account");

        Warehouse managerWarehouse = warehouseDAO.getWarehouseByUsername(account.getUsername());
        Warehouse sourceWarehouse = warehouseDAO.find(selectedWarehouseID);

        WarehouseRequest warehouseRequest = new WarehouseRequest();

        warehouseRequest.setWarehouseRequestID(IDGeneratorService.generateID(WarehouseRequest.class));
        warehouseRequest.setDate(LocalDateTime.now());
        warehouseRequest.setNote(note);
        warehouseRequest.setSourceWarehouse(sourceWarehouse);
        warehouseRequest.setDestinationWarehouse(managerWarehouse);
        warehouseRequest.setWarehouseRequestStatus(WarehouseRequestStatus.Pending);

        warehouseRequestDAO.persist(warehouseRequest);

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

                WarehouseRequestProduct warehouseRequestProduct = new WarehouseRequestProduct();

                warehouseRequestProduct.setWarehouseRequestProductID(IDGeneratorService.generateID(WarehouseRequestProduct.class));
                warehouseRequestProduct.setProduct(product);
                warehouseRequestProduct.setQuantity(quantity);
                warehouseRequestProduct.setWarehouseRequest(warehouseRequest);

                boolean checking = warehouseRequestProductDAO.persist(warehouseRequestProduct);
            }

            resp.sendRedirect(req.getContextPath() + URLConstants.WAREHOUSE_CREATE_EXPORT_REQUEST); // Redirect to a success or listing page

        } catch (NumberFormatException e) {
            req.setAttribute("errorMessage", "Invalid data submitted. Please check product quantities.");
            doGet(req, resp);
        } catch (Exception e) {
            req.setAttribute("errorMessage", "An error occurred while creating the request.");
            doGet(req, resp);
        }
    }

    private void processRequest(HttpServletRequest req, HttpServletResponse resp, String selectedWarehouseIDStr) throws ServletException, IOException {
        // Filter parameters
        String productNameFilter = req.getParameter("productName");
        String productTypeFilter = req.getParameter("productType");

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
