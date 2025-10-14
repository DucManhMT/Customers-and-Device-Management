package crm.warehousekeeper.controller;

import crm.common.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Iterator;
import java.util.List;

@WebServlet(name = "ManageImportProductsServlet", value = "/warehousekeeper/manage_import_products")
public class ManageImportProductsServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("removeProduct".equals(action)) {
            handleRemoveProduct(req, resp);
        } else if ("clearAll".equals(action)) {
            handleClearAll(req, resp);
        }
    }

    private void handleRemoveProduct(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String productIdStr = req.getParameter("productId");

        if (productIdStr == null || productIdStr.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.setContentType("application/json");
            resp.getWriter().write("{\"success\": false, \"message\": \"Product ID is required\"}");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdStr);
            HttpSession session = req.getSession();

            @SuppressWarnings("unchecked")
            List<Product> importList = (List<Product>) session.getAttribute("importProductList");

            if (importList != null && !importList.isEmpty()) {

                // Remove product with matching ID
                Iterator<Product> iterator = importList.iterator();
                boolean removed = false;
                String removedProductName = "";

                while (iterator.hasNext()) {
                    Product product = iterator.next();
                    if (product.getProductID() == productId) {
                        removedProductName = product.getProductName();
                        iterator.remove();
                        removed = true;
                        break;
                    }
                }

                if (removed) {
                    // Update session attributes
                    session.setAttribute("importProductList", importList);
                    session.setAttribute("totalImportCount", importList.size());

                    // If the list becomes empty, reset count attributes
                    if (importList.isEmpty()) {
                        session.setAttribute("selectedProductCount", 0);
                    }
                    // Send success response
                    resp.setContentType("application/json");
                    resp.getWriter().write("{\"success\": true, \"message\": \"Product removed successfully\", \"remainingCount\": " + importList.size() + "}");

                } else {
                    resp.setContentType("application/json");
                    resp.getWriter().write("{\"success\": false, \"message\": \"Product not found in import list\"}");
                }
            } else {
                resp.setContentType("application/json");
                resp.getWriter().write("{\"success\": false, \"message\": \"Import list is empty\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void handleClearAll(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession();

            // Clear the import list and related attributes
            session.removeAttribute("importProductList");
            session.removeAttribute("selectedProductCount");
            session.removeAttribute("totalImportCount");
            // Also clear any serials map if you're storing it in session
            session.removeAttribute("serialsMap");

            // Set empty list to ensure consistency
            session.setAttribute("importProductList", new java.util.ArrayList<Product>());
            session.setAttribute("totalImportCount", 0);

            resp.setContentType("application/json");
            resp.getWriter().write("{\"success\": true, \"message\": \"All products cleared from import list\"}");

        } catch (Exception e) {
            e.printStackTrace();
            resp.setContentType("application/json");
            resp.getWriter().write("{\"success\": false, \"message\": \"Server error occurred: " + e.getMessage() + "\"}");
        }
    }

}
