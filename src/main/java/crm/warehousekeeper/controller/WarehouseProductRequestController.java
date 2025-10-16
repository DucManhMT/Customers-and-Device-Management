package crm.warehousekeeper.controller;

import crm.common.model.Account;
import crm.common.model.ProductRequest;
import crm.common.model.Warehouse;
import crm.common.repository.Warehouse.ProductRequestDAO;
import crm.common.repository.Warehouse.WarehouseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = "/warehouse/viewProductRequests")
public class WarehouseProductRequestController extends HttpServlet {

    ProductRequestDAO productRequestDAO = new ProductRequestDAO();
    WarehouseDAO warehouseDAO = new WarehouseDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        Account account = (Account) req.getSession().getAttribute("account");

        Warehouse warehouse = warehouseDAO.getWarehouseByUsername(account.getUsername());

        List<ProductRequest> productRequests = productRequestDAO.findAll();

        productRequests = productRequests.stream()
                .filter(pr -> pr.getWarehouse().getWarehouseID().equals(warehouse.getWarehouseID()))
                .toList();

        req.setAttribute("productRequests", productRequests);

        req.getRequestDispatcher("/warehouse_keeper/view_product_request.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        super.doPost(req, resp);
    }
}
