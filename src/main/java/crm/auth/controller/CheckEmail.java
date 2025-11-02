package crm.auth.controller;

import crm.common.model.Customer;
import crm.common.model.Staff;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.ServletException;
import java.io.IOException;
import java.util.Map;

@WebServlet(name = "CheckEmail", value = "/api/check_email")
public class CheckEmail extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        EntityManager em = new EntityManager(DBcontext.getConnection());
        // Simulate email existence check
        String email = req.getParameter("email");
        Map<String, Object> params = Map.of("email", email);

        try{
            boolean exists = !em.findWithConditions(Customer.class, params).isEmpty() || !em.findWithConditions(Staff.class, params).isEmpty();
            if (exists) {
                String jsonResponse = String.format("{\"exists\": true}");
                resp.getWriter().write(jsonResponse);
            } else {
                String jsonResponse = String.format("{\"exists\": false}");
                resp.getWriter().write(jsonResponse);
            }
        }catch (Exception e){
            e.printStackTrace();
            String jsonResponse = String.format("{\"exists\": false}");
            resp.getWriter().write(jsonResponse);
        }
    }
}
