package crm.warehousekeeper.controller;

import crm.common.URLConstants;
import crm.common.model.WarehouseRequest;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = URLConstants.WAREHOUSE_VIEW_WAREHOUSE_REQUEST)
public class WarehouseRequestViewController extends HttpServlet {
    EntityManager em = new EntityManager(DBcontext.getConnection());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        List<WarehouseRequest> warehouseRequests = em.findAll(WarehouseRequest.class);

        req.setAttribute("warehouseRequests", warehouseRequests);
        req.getRequestDispatcher("/warehouse_keeper/view_warehouse_request.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        super.doPost(req, resp);
    }
}
