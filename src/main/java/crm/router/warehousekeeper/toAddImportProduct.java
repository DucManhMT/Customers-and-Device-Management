package crm.router.warehousekeeper;

import crm.common.model.Product;
import crm.common.model.Type;
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
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet(name = "toAddImportProduct", value = "/warehousekeeper/add_import_product")
public class toAddImportProduct extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = new EntityManager(DBcontext.getConnection());

        try {
            // Get all products
            List<Product> products = em.findAll(Product.class);

            // Get all types for filtering
            List<Type> types = em.findAll(Type.class);

            // Ensure session has import list initialized and get current imported product IDs
            HttpSession session = req.getSession();
            @SuppressWarnings("unchecked")
            List<Product> importProductList = (List<Product>) session.getAttribute("importProductList");

            if (importProductList == null) {
                importProductList = new ArrayList<>();
                session.setAttribute("importProductList", importProductList);
                session.setAttribute("totalImportCount", 0);
            }

            // Create a fresh set of already imported product IDs for easy lookup
            Set<Integer> importedProductIds = new HashSet<>();
            for (Product p : importProductList) {
                importedProductIds.add(p.getProductID());
            }

            // Set request attributes - this will override any cached data
            req.setAttribute("availableProducts", products);
            req.setAttribute("types", types);
            req.setAttribute("importedProductIds", importedProductIds);

            // Debug logging
            System.out.println("=== Add Import Product Page Load ===");
            System.out.println("Available products: " + products.size());
            System.out.println("Current import list size: " + importProductList.size());
            System.out.println("Imported product IDs: " + importedProductIds);

            // Log individual imported products for debugging
            for (Product p : importProductList) {
                System.out.println("- Imported Product: ID=" + p.getProductID() + ", Name=" + p.getProductName());
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Error loading products: " + e.getMessage());
        }

        req.getRequestDispatcher("/warehousekeeper/add_import_product.jsp").forward(req, resp);
    }
}
