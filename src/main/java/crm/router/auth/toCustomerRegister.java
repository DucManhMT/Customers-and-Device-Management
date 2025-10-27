package crm.router.auth;

import crm.common.URLConstants;
import crm.common.model.Province;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
@WebServlet(name = "toCustomerRegister", value = URLConstants.AUTH_CUSTOMER_REGISTER)
public class toCustomerRegister extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        req.setAttribute("provinces", em.findAll(Province.class));
        req.getRequestDispatcher("/auth/customer_register.jsp").forward(req, resp);
    }
}
