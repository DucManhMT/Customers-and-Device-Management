// java
// File: `src/main/java/crm/warehousekeeper/controller/ExportProductController.java`
package crm.warehousekeeper.controller;

import crm.common.model.ProductRequest;
import crm.common.model.ProductWarehouse;
import crm.common.model.Request;
import crm.common.model.enums.ProductRequestStatus;
import crm.common.model.enums.ProductStatus;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebServlet(name = "ExportProductController", value = "/warehouse_keeper/export_product_controller")
public class ExportProductController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        String productRequestID = req.getParameter("productRequestID");
        if (productRequestID == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "productRequestID required");
            return;
        }

        ProductRequest productRequest = em.find(ProductRequest.class, Integer.parseInt(productRequestID));
        Request request = productRequest.getRequest();
        int requestID = request.getRequestID(); // adjust method name if your model uses different casing

        String[] itemIdsArray = req.getParameterValues("itemIds");
        List<String> itemIds = (itemIdsArray == null) ? List.of() : Arrays.stream(itemIdsArray).toList();
        int numberOfItems = itemIds.size();

        try {
            em.beginTransaction();

            if (numberOfItems == productRequest.getQuantity()) {
                productRequest.setStatus(ProductRequestStatus.Finished);
                productRequest.setQuantity(0);
                em.merge(productRequest, ProductRequest.class);
            } else if (productRequest.getQuantity() > numberOfItems) {
                productRequest.setQuantity(productRequest.getQuantity() - numberOfItems);
                em.merge(productRequest, ProductRequest.class);
            }

            for (String itemId : itemIds) {
                try {
                    int id = Integer.parseInt(itemId);
                    ProductWarehouse item = em.find(ProductWarehouse.class, id);
                    if (item != null) {
                        item.setProductStatus(ProductStatus.Exported);
                        em.merge(item, ProductWarehouse.class);
                    }
                } catch (NumberFormatException ignored) {
                    // skip invalid id
                }
            }

            em.commit();
        } catch (Exception e) {
            em.rollback();
            throw new RuntimeException(e);
        }

        resp.sendRedirect(req.getContextPath() + "/warehouse_keeper/export_product?productRequestID=" + productRequestID + "&requestID=" + requestID);
    }
}
