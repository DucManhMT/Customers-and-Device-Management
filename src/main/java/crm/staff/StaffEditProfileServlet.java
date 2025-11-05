package crm.staff;

import crm.common.model.Account;
import crm.common.model.Customer;
import crm.common.model.Staff;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.validator.Validator;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "StaffEditProfileServlet", value = "/staff/profile/edit")
public class StaffEditProfileServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        EntityManager em = new EntityManager(DBcontext.getConnection());
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/auth/staff_login");
            return;
        }
        Map<String, Object> cond = new HashMap<>();
        cond.put("account", account.getUsername());
        Staff staff = em.findWithConditions(Staff.class, cond).get(0);
        request.setAttribute("staff", staff);
        request.getRequestDispatcher("/staff/staff_edit_profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        String accountName = request.getParameter("accountName");
        if (!Validator.isValidName(accountName)) {
            request.getSession().setAttribute("error", "Account name contains invalid characters.");
            response.sendRedirect(request.getContextPath() + "/staff/profile/edit");
            return;
        }
        String accountEmail = request.getParameter("accountEmail");
        if (!Validator.isValidEmail(accountEmail)) {
            request.getSession().setAttribute("error", "Invalid email format.");
            response.sendRedirect(request.getContextPath() + "/staff/profile/edit");
            return;
        }
        String accountPhone = request.getParameter("accountPhone");
        if (!Validator.isValidPhone(accountPhone)) {
            request.getSession().setAttribute("error", "Invalid phone number format.");
            response.sendRedirect(request.getContextPath() + "/staff/profile/edit");
            return;
        }



        String accountAddress = request.getParameter("accountAddress");
        Map<String, Object> cond = new HashMap<>();
        cond.put("account", account.getUsername());
        Staff currentStaff = em.findWithConditions(Staff.class, cond).get(0);
        List<Staff> existingPhones = em.findWithConditions(Staff.class, Map.of("phone", accountPhone))
                .stream()
                .filter(s -> !s.getStaffID().equals(currentStaff.getStaffID()))
                .toList();
        if (!existingPhones.isEmpty()) {
            request.getSession().setAttribute("error", "Phone number already in use by another customer.");
            response.sendRedirect(request.getContextPath() + "/staff/profile/edit");
            return;
        }
        currentStaff.setStaffName(accountName);
        currentStaff.setEmail(accountEmail);
        currentStaff.setPhone(accountPhone);
        currentStaff.setAddress(accountAddress);
        em.merge(currentStaff,Staff.class);


        request.getSession().setAttribute("success", "Account updated successfully.");
        response.sendRedirect(request.getContextPath() + "/staff/profile/edit");
    }
}