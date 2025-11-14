package crm.router.admin;

import crm.common.model.Feature;
import crm.common.model.Role;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.filter.service.PermissionService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import static crm.filter.service.PermissionService.isPublicUrl;

@WebServlet(name = "toAssignFeature", value = "/admin/assign_feature")
public class toAssignFeature extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager entityManager = new EntityManager(DBcontext.getConnection());
        List<Role> roles = entityManager.findAll(Role.class);
        req.setAttribute("roles", roles);

        List<Feature> allFeatures = entityManager.findAll(Feature.class);

        List<Feature> features = allFeatures.stream().filter(f -> !isPublicUrl(f.getFeatureURL())).toList();

        req.setAttribute("features", features);
        PermissionService.reloadPermissions();

        Map<Integer, List<Feature>> roleFeatureMap = PermissionService.getRoleFeatureMap();
        req.setAttribute("roleFeatureMap", roleFeatureMap);

        req.getRequestDispatcher("/admin/assign_feature.jsp").forward(req, resp);
    }
}
