package crm.router.admin;


import crm.common.model.Role;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import crm.common.model.Province;

@WebServlet(name = "toAdminCreateAccount", value = "/admin/create_account")
public class toAdminCreateAccount extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        try{
            List<Role> roles = em.findAll(Role.class);
            List<Province> provinces = em.findAll(Province.class);
            for (Role r : roles) {
                String spaced = r.getRoleName().replaceAll("([a-z])([A-Z])", "$1 $2");
                r.setRoleName(spaced);
            }

            req.setAttribute("provinces", provinces);
            req.setAttribute("roles", roles);
            req.getRequestDispatcher("/admin/create_account.jsp").forward(req, resp);
            return;
        } catch (Exception e) {
            e.printStackTrace();
            req.getRequestDispatcher("/admin/create_account.jsp").forward(req, resp);
            return;
        }



    }
}
