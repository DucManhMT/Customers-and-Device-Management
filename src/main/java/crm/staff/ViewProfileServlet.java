package crm.staff;

import crm.common.URLConstants;
import crm.common.model.Account;
import crm.common.model.Staff;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "StaffProfileServlet", value = "/staff/profile")
public class ViewProfileServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        EntityManager em = new EntityManager(DBcontext.getConnection());
        Account account = (Account) session.getAttribute("account");

        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/auth/staff_login");
            return;
        }
        Map<String,Object> cond = new HashMap<>();
        cond.put("account", account.getUsername());
        Staff staff = em.findWithConditions(Staff.class, cond).get(0);
        request.setAttribute("staff", staff);
        request.setAttribute("accountImage", staff.getImage());
        request.setAttribute("account", account);
        request.getRequestDispatcher("/staff/view_profile.jsp").forward(request, response);


    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}