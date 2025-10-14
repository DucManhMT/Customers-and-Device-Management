package crm.router.warehousekeeper;

import crm.common.model.Product;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "toImportProduct", value = "/warehousekeeper/import_product")
public class toImportProduct extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // Ensure session has import list initialized
        HttpSession session = req.getSession();
        if (session.getAttribute("importProductList") == null) {
            session.setAttribute("importProductList", new ArrayList<Product>());
            session.setAttribute("totalImportCount", 0);
        }

        // Just forward to the JSP - it will read from session
        req.getRequestDispatcher("/warehousekeeper/import_product.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String[] productIds = req.getParameterValues("productIds");

        // ONLY handle addProducts action when it equals "addProducts" AND has product IDs
        if ("addProducts".equals(action) && productIds != null && productIds.length > 0) {
            handleAddProducts(req, resp);
        }
        // Forward to JSP to display current state
        resp.sendRedirect(req.getContextPath() + "/warehousekeeper/import_product");
    }

    // Handle adding products to the import list
    private void handleAddProducts(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Get the selected product IDs from the form
        String[] productIds = req.getParameterValues("productIds");

        if (productIds == null || productIds.length == 0) {
            System.out.println("No product IDs provided for addition");
            return;
        }

        EntityManager em = new EntityManager(DBcontext.getConnection());

        try {
            // Fetch the complete product data for selected IDs
            List<Product> selectedProducts = new ArrayList<>();

            for (String productId : productIds) {
                int id = Integer.parseInt(productId);
                Product product = em.find(Product.class, id);
                if (product != null) {
                    selectedProducts.add(product);
                }
            }

            // Store the selected products in session
            HttpSession session = req.getSession();

            // Get existing import list from session or create new one
            @SuppressWarnings("unchecked")
            List<Product> importList = (List<Product>) session.getAttribute("importProductList");
            if (importList == null) {
                importList = new ArrayList<>();
            }
            // Add new products to import list (avoid duplicates)
            int addedCount = 0;
            for (Product newProduct : selectedProducts) {
                boolean alreadyExists = importList.stream()
                        .anyMatch(p -> p.getProductID() == newProduct.getProductID());

                if (!alreadyExists) {
                    importList.add(newProduct);
                    addedCount++;
                }
            }

            // Update session with the complete import list
            session.setAttribute("importProductList", importList);
            session.setAttribute("selectedProductCount", addedCount);
            session.setAttribute("totalImportCount", importList.size());

            // Store success message
            if (addedCount > 0) {
                session.setAttribute("successMessage",
                        "Successfully added " + addedCount + " products to import list.");
            } else {
                session.setAttribute("successMessage",
                        "All selected products were already in the import list.");
            }
            // Final logging

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage",
                    "An error occurred while adding products: " + e.getMessage());
        }
    }
}
