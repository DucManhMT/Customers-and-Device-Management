package crm.warehousekeeper.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import crm.common.model.InventoryItem;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.warehousekeeper.service.SerialGenerator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "CheckSerialDuplicate", value = "/warehousekeeper/check_serial_duplicate")
public class CheckSerialDuplicate extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String serial = req.getParameter("serial");
        String productID = req.getParameter("productId");

        String serialToCheck = SerialGenerator.generateSerial(productID , serial);

        EntityManager em = new EntityManager(DBcontext.getConnection());
        Map<String, Object> conditions = new HashMap<>();

        conditions.put("serialNumber", serialToCheck);
        List<InventoryItem> it = em.findWithConditions(InventoryItem.class, conditions);
        if(it == null || it.isEmpty()) {
            resp.setContentType("application/json");
            resp.getWriter().write("{\"exists\": false}");

        } else {
            resp.setContentType("application/json");
            resp.getWriter().write("{\"exists\": true}");
        }
    }
}
