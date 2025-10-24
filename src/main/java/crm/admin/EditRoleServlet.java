package crm.admin;

import crm.common.URLConstants;
import crm.common.model.Account;
import crm.common.model.Feature;
import crm.common.model.Role;
import crm.common.model.RoleFeature;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.service.IDGeneratorService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.*;

@WebServlet(name = "EditRoleServlet", value = URLConstants.ADMIN_EDIT_ROLE)
public class EditRoleServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        int roleId = Integer.parseInt(request.getParameter("id"));
        Role role = em.find(Role.class, roleId);
        List<Feature> features = em.findAll(Feature.class);

        // Take all features of the role
        Map<String, Object> cond = new HashMap<>();
        cond.put("role", roleId);
        List<RoleFeature> roleFeatures = em.findWithConditions(RoleFeature.class, cond);

        // Tick feature
        Set<Integer> selectedFeatureIds = new HashSet<>();
        for (RoleFeature rf : roleFeatures) {
            selectedFeatureIds.add(rf.getFeature().getFeatureID());
        }

        Map<String, Object> condAcc = new HashMap<>();
        condAcc.put("role", roleId);
        List<Account> accounts = em.findWithConditions(Account.class, condAcc);
        int accountCount = accounts.size();


        request.setAttribute("accountCount", accountCount);
        request.setAttribute("accounts", accounts);
        request.setAttribute("role", role);
        request.setAttribute("features", features);
        request.setAttribute("selectedFeatureIds", selectedFeatureIds);
        request.getRequestDispatcher("/admin/edit_role.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        int roleId = Integer.parseInt(request.getParameter("roleID"));
        String roleName = request.getParameter("roleName");


        Role role = em.find(Role.class, roleId);
        System.out.println("role.getRoleName(): " + (role != null ? role.getRoleName() : "null"));
        System.out.println("roleName (from request): " + roleName);
        if (role != null && !role.getRoleName().equals(roleName)) {
            role.setRoleName(roleName);
            em.merge(role, Role.class);
        }

        String[] featureIdParams = request.getParameterValues("featureIds");
        Set<Integer> newFeatureIds = new HashSet<>();
        if (featureIdParams != null) {
            for (String fid : featureIdParams) {
                newFeatureIds.add(Integer.parseInt(fid));
            }
        }

        Map<String, Object> cond = new HashMap<>();
        cond.put("role", roleId);
        List<RoleFeature> oldRoleFeatures = em.findWithConditions(RoleFeature.class, cond);
        for (RoleFeature rf : oldRoleFeatures) {
            em.remove(rf, RoleFeature.class);
        }

        for (Integer fid : newFeatureIds) {
            Feature f = em.find(Feature.class, fid);
            if (f != null) {
                RoleFeature newRF = new RoleFeature();
                newRF.setRoleFeatureID(IDGeneratorService.generateID(RoleFeature.class));
                newRF.setRole(role);
                newRF.setFeature(f);
                em.persist(newRF, RoleFeature.class);
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/role_list/edit_role?id=" + roleId + "&success=1");
    }
}