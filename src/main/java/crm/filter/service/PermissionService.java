package crm.filter.service;

import crm.common.URLConstants;
import crm.common.model.Feature;
import crm.common.model.Role;
import crm.common.model.RoleFeature;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class PermissionService {
    private static Map<Role, List<Feature>> roleFeatureMap;

    public PermissionService(){
        EntityManager em = new EntityManager(DBcontext.getConnection());
        List<RoleFeature> roleFeatures = em.findAll(RoleFeature.class);
        for (RoleFeature rf : roleFeatures) {
            Role role = rf.getRole();
            Feature feature = rf.getFeature();
            roleFeatureMap.computeIfAbsent(role, k -> new ArrayList<>()).add(feature);
        }
    }

    public static boolean isPublicUrl(String uri){
        List<String> publicURLs = List.of(
                URLConstants.HOME,
                URLConstants.AUTH_CUSTOMER_LOGIN,
                URLConstants.AUTH_CUSTOMER_REGISTER,
                URLConstants.AUTH_STAFF_LOGIN,
                URLConstants.AUTH_FORGOT_PASSWORD,
                URLConstants.AUTH_LOGOUT
        );
        return publicURLs.contains(uri);
    }

    public static boolean isProtectedUrl(String uri){
        List<String> protectedURLs = URLConstants.getAllUrls().stream()
                .filter(url -> !isPublicUrl(url))
                .toList();
        return protectedURLs.contains(uri);
    }

    public static boolean hasAccess(Role role, String uri){
        List<Feature> features = roleFeatureMap.get(role);
        if (features != null) {
            for (Feature feature : features) {
                if (feature.getFeatureURL().equals(uri)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static void reloadPermissions(){
        EntityManager em = new EntityManager(DBcontext.getConnection());
        List<RoleFeature> roleFeatures = em.findAll(RoleFeature.class);
        roleFeatureMap.clear();
        for (RoleFeature rf : roleFeatures) {
            Role role = rf.getRole();
            Feature feature = rf.getFeature();
            roleFeatureMap.computeIfAbsent(role, k -> new ArrayList<>()).add(feature);
        }
    }

    public static Map<Role, List<Feature>> getRoleFeatureMap() {
        return roleFeatureMap;
    }
}
