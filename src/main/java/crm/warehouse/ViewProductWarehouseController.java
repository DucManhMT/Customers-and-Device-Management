package crm.warehouse;

import crm.common.model.Product;
import crm.common.model.ProductSpecification;
import crm.common.model.ProductWarehouse;
import crm.common.model.Warehouse;
import crm.common.repository.Warehouse.ProductWarehouseDAO;
import crm.common.repository.Warehouse.WarehouseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(urlPatterns = "/viewProductWarehouse")
public class ViewProductWarehouseController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        WarehouseDAO warehouseDAO = new WarehouseDAO();
        ProductWarehouseDAO productWarehouseDAO = new ProductWarehouseDAO();
        Warehouse warehouse = warehouseDAO.find(1);

        HashSet<Product> products = warehouseDAO.getProductsInWarehouse(warehouse.getWarehouseID());
        System.out.println("Warehouse: " + warehouse.getWarehouseName());
        for (Product product : products) {
            System.out.print("Product: " + product.getProductName());
            System.out.println(" Specifications:");
            for (ProductSpecification spec : product.getProductSpecifications()) {
                System.out.println(" - " + spec.getSpecification().getSpecificationName() + ": " + spec.getSpecification().getSpecificationValue());
            }
        }

        List<ProductWarehouse> pw = productWarehouseDAO.findAll();

        Map<Integer, Long> productCounts = pw.stream()
                .filter(pw1 -> pw1.getWarehouse().getWarehouseID() == 1)
                .collect(Collectors.groupingBy(
                        pw1 -> pw1.getInventoryItem().getProduct().getProductID(),
                        Collectors.counting()
                ));

        req.setAttribute("products", products);
        req.setAttribute("productCounts", productCounts);


        req.getRequestDispatcher("/Warehouse/ViewProduct.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

    }
}
