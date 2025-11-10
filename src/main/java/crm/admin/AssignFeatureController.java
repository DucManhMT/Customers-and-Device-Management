package crm.admin;

import crm.admin.service.AssignFeatureService;
import crm.common.model.Feature;
import crm.common.model.Role;
import crm.common.model.RoleFeature;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/assign_feature_controller")
public class AssignFeatureController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Lấy arrays từ request
        String[] roleIDs = req.getParameterValues("roleIDs");
        String[] featureIDs = req.getParameterValues("featureIDs");

        List<RoleFeature> roleFeatures = new ArrayList<>();

        // Parse thành List<RoleFeature>
        if (roleIDs != null && featureIDs != null && roleIDs.length == featureIDs.length) {
            for (int i = 0; i < roleIDs.length; i++) {
                Integer roleID = Integer.parseInt(roleIDs[i]);
                Integer featureID = Integer.parseInt(featureIDs[i]);

                RoleFeature rf = new RoleFeature();

                Role role = new Role();
                role.setRoleID(roleID);
                rf.setRole(role);

                Feature feature = new Feature();
                feature.setFeatureID(featureID);
                rf.setFeature(feature);

                roleFeatures.add(rf);
            }
        }

        // Bây giờ bạn có List<RoleFeature> để xử lý
        // ... your database logic here ...
        boolean success = true;
        AssignFeatureService.removeAllRoleFeatures();
        for(RoleFeature rf : roleFeatures){
            System.out.println("RoleID: " + rf.getRole().getRoleName() + ", FeatureID: " + rf.getFeature().getFeatureURL());
            success = success && AssignFeatureService.assignFeatureToRole(rf.getRole(), rf.getFeature());
            System.out.println("Assignment success: " + success);
        }
        if (success){
            req.setAttribute("successMessage", "");
            resp.sendRedirect(req.getContextPath() + "/admin/assign_feature");
        } else {
            req.setAttribute("errorMessage", "");
            resp.sendRedirect(req.getContextPath() + "/admin/assign_feature");
        }

    }
}