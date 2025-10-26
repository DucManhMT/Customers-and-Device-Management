package crm.router.warehousekeeper;

import crm.common.URLConstants;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "toWarehouseKeeperActionCenter", value = URLConstants.WAREHOUSE_ACTION_CENTER)
public class toWarehouseKeeperActionCenter extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/warehouse_keeper/warehousekeeper_actioncenter.jsp").forward(req, resp);
    }
}
