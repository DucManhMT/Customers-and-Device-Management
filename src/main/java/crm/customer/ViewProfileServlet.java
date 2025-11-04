package crm.customer;

import crm.common.URLConstants;
import crm.common.model.Account;
import crm.common.model.Customer;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "ViewProfileServlet", value = URLConstants.CUSTOMER_VIEW_PROFILE)
public class ViewProfileServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        String username = request.getParameter("id");
        Account account = em.find(Account.class, username);
        Map<String,Object> cond = new HashMap();
        cond.put("account", username);
        Customer customer = em.findWithConditions(Customer.class, cond).get(0);
        request.setAttribute("account", account);
        request.setAttribute("customer", customer);

        request.getRequestDispatcher("/customer/view_profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}