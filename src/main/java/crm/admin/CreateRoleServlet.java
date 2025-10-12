package crm.admin;

import crm.common.model.Role;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CreateRoleServlet", value = "/CreateRole")
public class CreateRoleServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        request.getRequestDispatcher("/admin/CreateRole.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        String roleName = request.getParameter("roleName");
        List<Role> allRoles = em.findAll(Role.class);
        int maxId = 0;
        for (Role role : allRoles) {
            if (role.getRoleID() != null && role.getRoleID() > maxId) {
                maxId = role.getRoleID();
            }
        }
        int roleID = maxId + 1;


        if (roleName == null || roleName.trim().isEmpty()) {
            request.setAttribute("error", "Role name cannot be empty.");
            request.setAttribute("roleName", roleName);
            request.setAttribute("roleId", roleID);
            request.getRequestDispatcher("/admin/CreateRole.jsp").forward(request, response);
            return;
        }
        // check if role name already exists
        Map<String, Object> conditions = new HashMap<String, Object>();

            conditions.put("roleName", roleName);

        if (em.findWithConditions(Role.class, conditions).size() > 0) {
            request.setAttribute("error", "Role name already exists.");
            request.setAttribute("roleName", roleName);
            request.getRequestDispatcher("/admin/CreateRole.jsp").forward(request, response);
            return;
        }


        Role role = new Role();
        role.setRoleID(roleID);
        role.setRoleName(roleName);
        try {
            em.persist(role, Role.class);
            response.sendRedirect(request.getContextPath() + "/ViewRoleList");
        } catch (Exception e) {
            request.setAttribute("error", "Error creating role: " + e.getMessage());
            request.getRequestDispatcher("/admin/CreateRole.jsp").forward(request, response);
        }
    }
}