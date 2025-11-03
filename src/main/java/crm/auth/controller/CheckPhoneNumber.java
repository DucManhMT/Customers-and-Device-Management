package crm.auth.controller;

import crm.common.model.Customer;
import crm.common.model.Staff;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Map;

@WebServlet(name="CheckPhoneNumber", value="/api/check_phonenumber")
public class CheckPhoneNumber extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String phoneNumber = req.getParameter("phoneNumber");
        EntityManager em = new EntityManager(DBcontext.getConnection());
        try {
            Map<String, Object> conditions = Map.of("phone", phoneNumber);
            boolean exists = !em.findWithConditions(Customer.class, conditions).isEmpty() || !em.findWithConditions(Staff.class, conditions).isEmpty();

            if (exists) {
                String jsonResponse = String.format("{\"exists\": true}");
                resp.getWriter().write(jsonResponse);
            } else {
                String jsonResponse = String.format("{\"exists\": false}");
                resp.getWriter().write(jsonResponse);
            }
        } catch (Exception e){
            e.printStackTrace();
            String jsonResponse = String.format("{\"exists\": false}");
            resp.getWriter().write(jsonResponse);
        }

    }
}
