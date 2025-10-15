package crm.warehouse;

import crm.common.model.Account;
import crm.common.model.Warehouse;
import crm.common.repository.Warehouse.WarehouseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(urlPatterns = "/warehouse/viewWarehouseDetail")
public class WarehouseDetailController extends HttpServlet {

    WarehouseDAO warehouseDAO = new WarehouseDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        Account account = (Account) req.getSession().getAttribute("account");

        Warehouse warehouse = warehouseDAO.getWarehouseByUsername(account.getUsername());

        req.setAttribute("warehouse", warehouse);

        req.getRequestDispatcher("/warehouse_keeper/view_warehouse_detail.jsp").forward(req, resp);

    }
}
