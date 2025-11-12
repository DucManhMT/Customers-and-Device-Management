package crm.router.warehousekeeper;

import crm.common.URLConstants;
import crm.common.model.*;
import crm.common.repository.Warehouse.WarehouseDAO;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "toWarehouseKeeperDashboard", value = URLConstants.WAREHOUSE_DASHBOARD)
public class toWarehouseKeeperDashboard extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        HttpSession session = req.getSession();
        Account acc = (Account) session.getAttribute("account");
        Role role = acc.getRole();
        WarehouseDAO warehouseDAO = new WarehouseDAO();
        Warehouse warehouse = warehouseDAO.getWarehouseByUsername(acc.getUsername());

        List<ProductImportedLog> productsImported = em.findAll(ProductImportedLog.class);
        List<ProductExported> productExporteds = em.findAll(ProductExported.class);
        List<ProductWarehouse> productWarehouses = em.findAll(ProductWarehouse.class);
        List<Product> products = em.findAll(Product.class);
        List<ProductRequest> allProductRequests = em.findAll(ProductRequest.class);
        List<ProductRequest> myProductRequests = allProductRequests.stream()
                .filter(pr -> pr.getWarehouse() != null)
                .filter(pr -> pr.getWarehouse().getWarehouseID().equals(warehouse.getWarehouseID()))
                .toList();

        List<WarehouseLog> warehouseLogs = em.findAll(WarehouseLog.class);

        req.setAttribute("productsImported", productsImported);
        req.setAttribute("productExporteds", productExporteds);
        req.setAttribute("productWarehouses", productWarehouses);
        req.setAttribute("products", products);
        req.setAttribute("productRequests", myProductRequests);
        req.setAttribute("warehouseLogs", warehouseLogs);

        req.getRequestDispatcher("/warehouse_keeper/warehousekeeper_dashboard.jsp").forward(req, resp);
    }
}
