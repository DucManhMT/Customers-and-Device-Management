package crm.admin.service;

import crm.common.model.Feature;
import crm.common.model.Role;
import crm.common.model.RoleFeature;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.service.IDGeneratorService;

import java.util.List;
import java.util.Map;

public class AssignFeatureService {
    public static boolean assignFeatureToRole(Role role, Feature feature) {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        try{
            em.beginTransaction();
            RoleFeature newRoleFeature = new RoleFeature();
            newRoleFeature.setRoleFeatureID(IDGeneratorService.generateID(RoleFeature.class));
            newRoleFeature.setRole(role);
            newRoleFeature.setFeature(feature);


            //Find existing RoleFeature
            Map<String, Object> conditions = Map.of(
                "role", role.getRoleID(),
                "feature", feature.getFeatureID()
            );

            List<RoleFeature> roleFeature = em.findWithConditions(RoleFeature.class, conditions);

            boolean exists = !(roleFeature == null) && !roleFeature.isEmpty();

            if(!exists){
                em.persist(newRoleFeature, RoleFeature.class);
            }else{
                em.remove(roleFeature.get(0), RoleFeature.class);
            }
            System.out.println("Assigned Feature ID " + feature.getFeatureID() + " to Role ID " + role.getRoleID());
            em.commit();
            return true;
            // Tạo một RoleFeature mới
        } catch(Exception e){
            e.printStackTrace();
            em.rollback();
            return false;
        }


    }
}
