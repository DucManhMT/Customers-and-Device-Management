package crm.admin;

import crm.common.URLConstants;
import crm.common.model.Role;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.service.IDGeneratorService;
import crm.core.validator.Validator;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "CreateRoleServlet", value = URLConstants.ADMIN_CREATE_ROLE)
public class CreateRoleServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy error từ session (nếu có) rồi xóa đi để tránh hiển thị lại
        HttpSession session = request.getSession();
        String error = (String) session.getAttribute("error");
        String success = (String) session.getAttribute("success");

        if (error != null) {
            request.setAttribute("error", error);
            session.removeAttribute("error");
        }
        if (success != null) {
            request.setAttribute("success", success);
            session.removeAttribute("success");
        }

        request.getRequestDispatcher("/admin/create_role.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        EntityManager em = new EntityManager(DBcontext.getConnection());

        String roleName = request.getParameter("roleName");
        if(!Validator.isValidName(roleName)){
            session.setAttribute("error", "Role name contains invalid characters.");
            response.sendRedirect(request.getContextPath() + URLConstants.ADMIN_CREATE_ROLE);
            return;
        }
        int roleID = IDGeneratorService.generateID(Role.class);

        // Kiểm tra rỗng
        if (roleName == null || roleName.trim().isEmpty()) {
            session.setAttribute("error", "Role name cannot be empty.");
            response.sendRedirect(request.getContextPath() + URLConstants.ADMIN_CREATE_ROLE);
            return;
        }

        // Kiểm tra trùng tên
        Map<String, Object> conditions = new HashMap<>();
        conditions.put("roleName", roleName);

        if (!em.findWithConditions(Role.class, conditions).isEmpty()) {
            session.setAttribute("error", "Role name already exists.");
            response.sendRedirect(request.getContextPath() + URLConstants.ADMIN_CREATE_ROLE);
            return;
        }





        // Tạo mới Role
        try {
            Role role = new Role();
            role.setRoleID(roleID);
            role.setRoleName(roleName);

            em.persist(role, Role.class);
            session.setAttribute("success", "Role created successfully.");
            response.sendRedirect(request.getContextPath() + URLConstants.ADMIN_VIEW_ROLE_LIST);
        } catch (Exception e) {
            session.setAttribute("error", "Error creating role: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + URLConstants.ADMIN_CREATE_ROLE);
        }
    }
}
