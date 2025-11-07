package crm.router.inventorymanager;

import crm.common.URLConstants;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(URLConstants.INVENTORY_ACTION_CENTER)
public class toInventoryManagerActionCenter extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/inventory_manager/inventorymanager_actioncenter.jsp").forward(req, resp);
    }
}
