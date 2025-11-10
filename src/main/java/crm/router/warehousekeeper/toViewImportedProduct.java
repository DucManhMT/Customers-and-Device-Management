package crm.router.warehousekeeper;

import crm.common.URLConstants;
import crm.common.model.ProductImportedLog;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "toViewImportedProduct", value = URLConstants.WAREHOUSE_VIEW_IMPORTED_PRODUCT)
public class toViewImportedProduct extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        List<ProductImportedLog> importedProducts = em.findAll(ProductImportedLog.class);
        req.setAttribute("importedProducts", importedProducts);
        req.getRequestDispatcher("/warehouse_keeper/view_imported_product.jsp").forward(req, resp);
    }
}
