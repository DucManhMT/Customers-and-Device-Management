package crm.warehousekeeper.controller;

import java.io.IOException;

import crm.common.model.Product;
import crm.common.repository.Warehouse.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = "/warehouse/viewProductDetail")
public class ProductDetailController extends HttpServlet {

    ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        int productId = Integer.parseInt(req.getParameter("productId"));

        Product product = productDAO.findIncludeSpec(productId);

        req.setAttribute("product", product);

        req.getRequestDispatcher("/warehouse_keeper/view_product_detail.jsp").forward(req, resp);


    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        super.doPost(req, resp);
    }
}
