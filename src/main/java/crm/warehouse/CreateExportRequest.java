package crm.warehouse;

import crm.common.model.*;
import crm.common.model.enums.TransactionStatus;
import crm.common.repository.Warehouse.ProductTransactionDAO;
import crm.common.repository.Warehouse.ProductWarehouseDAO;
import crm.common.repository.Warehouse.TypeDAO;
import crm.common.repository.Warehouse.WarehouseDAO;
import crm.core.repository.hibernate.querybuilder.QueryOperation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;


@WebServlet(urlPatterns = "/warehouse/createExportRequest")
public class CreateExportRequest extends HttpServlet {
    //DAOs
    WarehouseDAO warehouseDAO = new WarehouseDAO();
    ProductWarehouseDAO productWarehouseDAO = new ProductWarehouseDAO();
    ProductTransactionDAO productTransactionDAO = new ProductTransactionDAO();
    TypeDAO typeDAO = new TypeDAO();

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


        req.getRequestDispatcher("/warehouseKeeper/createExportInternal.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String[] selectedProductWarehouseIDs = req.getParameterValues("allSelectedItemIDs");
        String selectedWarehouseIDStr = req.getParameter("selectedWarehouseID");
        int selectedWarehouseID = Integer.parseInt(selectedWarehouseIDStr);

        Account account = (Account) req.getSession().getAttribute("account");

        Warehouse managerWarehouse = warehouseDAO.getWarehouseByUsername(account.getUsername());
        Warehouse destinationWarehouse = warehouseDAO.find(selectedWarehouseID);

        List<ProductWarehouse> productWarehouse = new ArrayList<>();
        List<ProductTransaction> productTransactions;

        for (String productWarehouseIDStr : selectedProductWarehouseIDs) {
            int productWarehouseID = Integer.parseInt(productWarehouseIDStr);
            ProductWarehouse pw1 = productWarehouseDAO.find(productWarehouseID);
        }

        for (ProductWarehouse pw : productWarehouse) {
            LocalDateTime now = LocalDateTime.now();
            productTransactions = productTransactionDAO.findAll();
            ProductTransaction productTransaction = new ProductTransaction();

            productTransaction.setTransactionID();
            productTransaction.setInventoryItem(pw.getInventoryItem());
            productTransaction.setTransactionDate(now);
            productTransaction.setTransactionStatus(TransactionStatus.Request_Export);
            productTransaction.setNote(req.getParameter("note"));
            productTransaction.setSourceWarehouseEntity(destinationWarehouse);
            productTransaction.setDestinationWarehouseEntity(managerWarehouse);

            productTransactionDAO.persist(productTransaction);
        }


        req.getRequestDispatcher("/warehouseKeeper/createExportInternal.jsp").forward(req, resp);
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
        List<ProductWarehouse> productsInSelectedWarehouse = productWarehouseDAO.getAvailableProductsByWarehouse(selectedWarehouseID);

        //filter by product type
        List<Type> ProductTypes = typeDAO.findAll();

        if (productNameFilter != null && !productNameFilter.isEmpty()) {
            productsInSelectedWarehouse = productsInSelectedWarehouse.stream()
                    .filter(p -> p.getInventoryItem().getProduct().getProductName().toLowerCase().contains(productNameFilter.toLowerCase()))
                    .collect(Collectors.toCollection(LinkedList::new));
        }

        if (productTypeFilter != null && !productTypeFilter.isEmpty()) {
            productsInSelectedWarehouse = productsInSelectedWarehouse.stream()
                    .filter(p -> p.getInventoryItem().getProduct().getType().getTypeID() == Integer.parseInt(productTypeFilter))
                    .collect(Collectors.toCollection(LinkedList::new));
        }

        int totalProducts = productsInSelectedWarehouse.size();
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }

        int offset = (currentPage - 1) * pageSize;

        List<ProductWarehouse> paginatedProducts = productsInSelectedWarehouse.stream()
                .skip(offset)
                .limit(pageSize)
                .toList();

        //Warehouse attributes
        req.setAttribute("productsInSelectedWarehouse", paginatedProducts);
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
