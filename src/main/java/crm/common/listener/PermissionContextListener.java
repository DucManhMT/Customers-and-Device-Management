package crm.common.listener;


import crm.common.model.Feature;
import crm.filter.service.PermissionService;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.List;
import java.util.Map;

@WebListener
public class PermissionContextListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            PermissionService.reloadPermissions();
            Map<Integer, List<Feature>> roleFeatureMap = PermissionService.getRoleFeatureMap();

            // Store in application scope
            sce.getServletContext().setAttribute("roleFeatureMap", roleFeatureMap);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        sce.getServletContext().removeAttribute("roleFeatureMap");
    }
}
