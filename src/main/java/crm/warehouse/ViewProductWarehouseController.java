package crm.warehouse;

import crm.common.model.Product;
import crm.common.model.ProductWarehouse;
import crm.common.model.enums.ProductStatus;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(urlPatterns = "/viewProductWarehouse")
public class ViewProductWarehouseController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = new EntityManager(DBcontext.getConnection());

        Map<String, Object> conditions = new HashMap<>();
        conditions.put("warehouse", 1);
        conditions.put("productStatus", ProductStatus.In_Stock.name());

        List<ProductWarehouse> pw = em.findWithConditions(ProductWarehouse.class, conditions);

        HashSet<Product> warehouse = pw.stream()
                .filter(pw1 -> pw1.getWarehouse().getWarehouseID() == 1)
                .map(pw1 -> pw1.getInventoryItem().getProduct())
                .collect(Collectors.toCollection(HashSet::new));



        Map<Integer, Long> productCounts = pw.stream()
                .filter(pw1 -> pw1.getWarehouse().getWarehouseID() == 1)
                .collect(Collectors.groupingBy(
                        pw1 -> pw1.getInventoryItem().getProduct().getProductID(),
                        Collectors.counting()
                ));

        req.setAttribute("warehouse", warehouse);
        req.setAttribute("productCounts", productCounts);


        req.getRequestDispatcher("/Warehouse/ViewProduct.jsp").forward(req, resp);
    }

}
