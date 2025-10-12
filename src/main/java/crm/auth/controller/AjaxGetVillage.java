package crm.auth.controller;

import crm.common.model.Province;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "AjaxGetVillage", value = "/api/get_villages")
public class AjaxGetVillage extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        int provinceID = Integer.parseInt(req.getParameter("provinceID"));
        EntityManager em = new EntityManager(DBcontext.getConnection());
        var province = em.find(Province.class, provinceID);
        var villages = province.getVillages();
        StringBuilder json = new StringBuilder();
        json.append("[");
        for (int i = 0; i < villages.size(); i++) {
            json.append("{");
            json.append("\"villageID\":").append(villages.get(i).getVillageID()).append(",");
            json.append("\"villageName\":\"").append(villages.get(i).getVillageName()).append("\"");
            json.append("}");
            if (i != villages.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");
        resp.getWriter().write(json.toString());
    }
}
