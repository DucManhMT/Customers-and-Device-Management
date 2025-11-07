package crm.warehousekeeper.controller;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;

import crm.common.URLConstants;
import crm.common.model.Account;
import crm.common.model.Product;
import crm.common.model.Type;
import crm.common.model.Warehouse;
import crm.common.model.WarehouseRequest;
import crm.common.model.enums.WarehouseRequestStatus;
import crm.common.repository.Warehouse.ProductDAO;
import crm.common.repository.Warehouse.ProductWarehouseDAO;
import crm.common.repository.Warehouse.TypeDAO;
import crm.common.repository.Warehouse.WarehouseDAO;
import crm.common.repository.Warehouse.WarehouseRequestDAO;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.service.IDGeneratorService;
import crm.core.validator.Validator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet(urlPatterns = URLConstants.WAREHOUSE_CREATE_TRANSFER_REQUEST)
public class TransferRequestCreateController extends HttpServlet {
    //DAOs
    WarehouseDAO warehouseDAO = new WarehouseDAO();
    ProductWarehouseDAO productWarehouseDAO = new ProductWarehouseDAO();
    TypeDAO typeDAO = new TypeDAO();
    ProductDAO productDAO = new ProductDAO();
    WarehouseRequestDAO warehouseRequestDAO = new WarehouseRequestDAO();
    EntityManager entityManager = new EntityManager(DBcontext.getConnection());


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        //Get warehouse keeper account
        Account account = (Account) req.getSession().getAttribute("account");

        if(account == null){
            req.setAttribute("errorMessage", "You haven't logged in yet");
            req.getRequestDispatcher("/warehouse_keeper/create_transfer_request.jsp").forward(req, resp);
            return;
        }
        processRequest(req, resp);

        req.getRequestDispatcher("/warehouse_keeper/create_transfer_request.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String allSelectedItemIDs = req.getParameter("allSelectedItemIDs");
        String allSelectedItemQuantities = req.getParameter("allSelectedItemQuantities");
        String note = req.getParameter("note");

        if (!Validator.isValidText(note)) {
            req.setAttribute("errorMessage", "Note contains invalid characters or exceed limit.");
            doGet(req, resp);
            return;
        }

        if (allSelectedItemIDs == null || allSelectedItemIDs.length() == 0) {
            req.setAttribute("errorMessage", "Please select at least one product to export.");
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

        Account account = (Account) req.getSession().getAttribute("account");

        Warehouse managerWarehouse = warehouseDAO.getWarehouseByUsername(account.getUsername());

        try {
            entityManager.beginTransaction();
            for (int i = 0; i < selectedProductIDs.length; i++) {
                String productIdStr = selectedProductIDs[i];
                String quantityStr = selectedProductQuantitiesStr[i];

                if (quantityStr == null || quantityStr.trim().isEmpty()) {
                    req.setAttribute("errorMessage", "Please enter a quantity for all selected products.");
                    entityManager.rollback();
                    doGet(req, resp);
                    return;
                }

                int productID = Integer.parseInt(productIdStr);
                int quantity = Integer.parseInt(quantityStr);

                Product product = productDAO.find(productID);

                WarehouseRequest warehouseRequest = new WarehouseRequest();

                warehouseRequest.setWarehouseRequestID(IDGeneratorService.generateID(WarehouseRequest.class));
                warehouseRequest.setDate(LocalDateTime.now());
                warehouseRequest.setNote(note);
                warehouseRequest.setDestinationWarehouse(managerWarehouse);
                warehouseRequest.setWarehouseRequestStatus(WarehouseRequestStatus.Pending);
                warehouseRequest.setProduct(product);
                warehouseRequest.setQuantity(quantity);

                warehouseRequestDAO.persist(warehouseRequest);
            }
            entityManager.commit();

            req.setAttribute("successMessage", "Warehouse request has been successfully created.");

            resp.sendRedirect(req.getContextPath() + URLConstants.WAREHOUSE_VIEW_WAREHOUSE_REQUEST);

        } catch (NumberFormatException e) {
            req.setAttribute("errorMessage", "Invalid data submitted. Please check product quantities.");
            entityManager.rollback();
            doGet(req, resp);
        } catch (Exception e) {
            req.setAttribute("errorMessage", "An error occurred while creating the request.");
            entityManager.rollback();
            doGet(req, resp);
        }
    }

    private void processRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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

        List<Product> products = productDAO.findAllIncludeSpec();

        //filter by product type
        List<Type> ProductTypes = typeDAO.findAll();

        if (productNameFilter != null && !productNameFilter.isEmpty()) {
            products = products.stream()
                    .filter(p -> p.getProductName().toLowerCase().contains(productNameFilter.toLowerCase()))
                    .collect(Collectors.toCollection(LinkedList::new));
        }

        if (productTypeFilter != null && !productTypeFilter.isEmpty()) {
            products = products.stream()
                    .filter(p -> p.getType().getTypeID() == Integer.parseInt(productTypeFilter))
                    .collect(Collectors.toCollection(LinkedList::new));
        }

        int totalProducts = products.size();
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }

        int offset = (currentPage - 1) * pageSize;

//        List<Product> paginatedProducts = products.stream()
//                .skip(offset)
//                .limit(pageSize)
//                .toList();

        //Warehouse attributes
        req.setAttribute("products", products);
        req.setAttribute("uniqueProductTypes", ProductTypes);

        //Pagination attributes
        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("pageSize", pageSize);
        req.setAttribute("totalProducts", totalProducts);

        // Pass filter parameters for pagination links
        req.setAttribute("productName", productNameFilter);
        req.setAttribute("productType", productTypeFilter);
    }
}
