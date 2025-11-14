package crm.warehousekeeper.controller;

import crm.common.model.Account;
import crm.common.model.InventoryItem;
import crm.common.model.Product;
import crm.common.model.Warehouse;
import crm.common.repository.Warehouse.WarehouseDAO;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.service.IDGeneratorService;
import crm.warehousekeeper.service.ImportProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "ProcessImportServlet", value = "/warehouse_keeper/process_import")
public class ProcessImportServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // A map to hold product IDs and their corresponding list of serial numbers.
        Map<String, String[]> productSerialsMap = new HashMap<>();

        // Get all unique product IDs from the form submission.
        // The form sends a 'productIds' parameter for each product in the list.
        String[] productIds = req.getParameterValues("productIds");

        if (productIds != null) {
            for (String productId : productIds) {
                // For each productId, get its associated serial numbers.
                // The input name for serials is dynamically created as "serials-<productId>".
                String paramName = "serials-" + productId;
                String[] serials = req.getParameterValues(paramName);

                // Store the product ID and its serials in the map.
                // It might be null if a product was added but had no serials.
                productSerialsMap.put(productId, serials != null ? serials : new String[0]);
            }
        }

        Account acc = (Account) req.getSession().getAttribute("account");
        WarehouseDAO warehouseDAO = new WarehouseDAO();
        Warehouse warehouse = warehouseDAO.getWarehouseByUsername(acc.getUsername());

        boolean importSuccess = true;
        EntityManager em = new EntityManager(DBcontext.getConnection());
        try {
            em.beginTransaction();
            for (Map.Entry<String, String[]> entry : productSerialsMap.entrySet()) {
                String productId = entry.getKey();
                String[] serials = entry.getValue();

                // Fetch the product entity
                Product product = em.find(Product.class, productId);

                for (String serial : serials) {
                    if (serial != null && !serial.trim().isEmpty()) {
                        InventoryItem item = new InventoryItem();
                        item.setProduct(product);
                        item.setSerialNumber(serial.trim());
                        item.setItemId(IDGeneratorService.generateID(InventoryItem.class));
                        importSuccess = importSuccess && ImportProductService.importProducts(item, warehouse);
                    }
                }
            }
            // Process each product and its serial numbers.
            em.commit();
        } catch (Exception e) {
            importSuccess = false;
            em.rollback();
            e.printStackTrace();
        }

        // Redirect to a success page or back to the import page with a message.
        if (!importSuccess) {
            req.getSession().setAttribute("errorMessage", "There was an error processing the import.");
            resp.sendRedirect(req.getContextPath() + "/warehouse_keeper/import_product");
            return;
        }
        req.getSession().setAttribute("successMessage", "Import processed successfully!");
        resp.sendRedirect(req.getContextPath() + "/warehouse_keeper/import_product");
    }
}
