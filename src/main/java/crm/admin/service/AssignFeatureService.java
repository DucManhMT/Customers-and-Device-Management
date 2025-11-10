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

            em.persist(newRoleFeature, RoleFeature.class);

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
    public static void removeAllRoleFeatures(){
        EntityManager em = new EntityManager(DBcontext.getConnection());
        try{
            em.beginTransaction();
            em.deleteAll(RoleFeature.class);
            em.commit();
        } catch(Exception e){
            e.printStackTrace();
            em.rollback();
        }
    }
}
