package crm.admin;

import crm.common.model.Feature;
import crm.common.model.Role;
import crm.common.model.RoleFeature;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.*;

@WebServlet(name = "ViewRoleDetailServlet", value = "/ViewRoleDetail")
public class ViewRoleDetailServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        int roleId = Integer.parseInt(request.getParameter("id"));
        Role role = em.find(Role.class, roleId);
        Map<String, Object> cond = new HashMap<>();
        cond.put("role", roleId);
        List<RoleFeature> roleFeatures = em.findWithConditions(RoleFeature.class, cond);

        List<Feature> features = new ArrayList<>();
        Set<Integer> featureIdSet = new HashSet<>();
        for(RoleFeature rf : roleFeatures){
            Feature f = rf.getFeature();
            if (f != null && featureIdSet.add(f.getFeatureID())) {
                features.add(f);
            }
        }
        request.setAttribute("role", role);
        request.setAttribute("features", features);
        request.getRequestDispatcher("/admin/view_role_detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}