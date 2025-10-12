package crm.router.warehousekeeper;

import crm.common.model.Product;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "toAddImportProduct", value = "/warehouse/add_import_product")
public class toAddImportProduct extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em =  new EntityManager(DBcontext.getConnection());
        req.setAttribute("availableProducts", em.findAll(Product.class));
        req.getRequestDispatcher("/warehouse/add_import_product.jsp").forward(req, resp);
    }
}
