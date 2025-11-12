package crm.router.warehousekeeper;

import crm.common.model.*;
import crm.common.model.enums.ProductStatus;
import crm.common.repository.Warehouse.WarehouseDAO;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.mail.Session;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet(name = "toViewExportedProduct", value = "/warehouse_keeper/view_exported_product")
public class toViewExportedProduct extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        HttpSession session = req.getSession();
        Account acc = (Account) session.getAttribute("account");
        WarehouseDAO warehouseDAO = new WarehouseDAO();
        Warehouse warehouse = warehouseDAO.getWarehouseByUsername(acc.getUsername());

        Map<String, Object> conditions = Map.of(
                "productStatus", ProductStatus.Exported.name()
        );
        List<ProductWarehouse> exportedProducts = em.findWithConditions(ProductWarehouse.class, conditions);
        List<ProductExported> productExporteds = new ArrayList<>();
        for (ProductWarehouse pw : exportedProducts) {
            ProductExported pe = em.findWithConditions(ProductExported.class, Map.of(
                    "productWarehouse", pw.getProductWarehouseID())).stream().findFirst().orElse(null);
            if (pe != null) {
                productExporteds.add(pe);
            }
        }
        req.setAttribute("productExporteds", productExporteds);
        req.getRequestDispatcher("/warehouse_keeper/view_exported_product.jsp").forward(req, resp);
    }

}
