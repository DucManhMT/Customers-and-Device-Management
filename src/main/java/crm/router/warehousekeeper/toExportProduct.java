package crm.router.warehousekeeper;

import crm.common.model.ProductRequest;
import crm.common.model.ProductWarehouse;
import crm.common.model.Request;
import crm.common.model.enums.ProductStatus;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "toExportProduct", value = "/warehouse_keeper/export_product")
public class toExportProduct extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        String productRequestID = req.getParameter("productRequestID") ;
        if ( productRequestID != null ) {
            ProductRequest productRequests = em.find(ProductRequest.class, Integer.parseInt(productRequestID));
            Map<String, Object> conditions = new HashMap<>();
            conditions.put("warehouse", productRequests.getWarehouse().getWarehouseID());
            List<ProductWarehouse> warehouseProducts =  em.findWithConditions(ProductWarehouse.class, conditions);
            req.setAttribute("productRequests", productRequests);
            req.setAttribute("warehouseProducts", warehouseProducts);
            req.getRequestDispatcher("/warehouse_keeper/export_product.jsp").forward(req, resp);
            return;
        }
        req.getRequestDispatcher("/warehouse_keeper/export_product.jsp").forward(req, resp);
    }
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();

        int productRequestID = Integer.parseInt(req.getParameter("productRequestID")) ;
        EntityManager em = new EntityManager(DBcontext.getConnection());
        ProductRequest productRequests = em.find(ProductRequest.class, productRequestID);

        Map<String, Object> conditions = new HashMap<>();
        conditions.put("warehouse", productRequests.getWarehouse().getWarehouseID());
//        conditions.put("productStatus", ProductStatus.In_Stock.name());

        List<ProductWarehouse> warehouseProducts =  em.findWithConditions(ProductWarehouse.class, conditions);

        session.setAttribute("productRequests", productRequests);
        session.setAttribute("warehouseProducts", warehouseProducts);

        resp.sendRedirect(req.getContextPath() + "/warehouse_keeper/export_product");
    }
}
