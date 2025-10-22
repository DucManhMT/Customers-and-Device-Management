package crm.router.warehousekeeper;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "toWarehouseKeeperActionCenter", value = "/warehouse_keeper/warehousekeeper_actioncenter")
public class toWarehouseKeeperActionCenter extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/warehouse_keeper/warehousekeeper_actioncenter.jsp").forward(req, resp);
    }
}
