package testbuilder;

import crm.auth.service.Hasher;
import crm.auth.service.LoginService;
import crm.common.model.*;
import crm.common.model.enums.AccountStatus;
import crm.common.model.enums.RequestStatus;
import crm.common.repository.account.AccountDAO;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.repository.hibernate.querybuilder.*;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO;
import crm.core.repository.hibernate.querybuilder.enums.SortDirection;
import crm.core.service.MailService;

import java.time.LocalDateTime;
import java.util.*;

public class BuilderTest {
    public static void main(String[] args) {
        EntityManager em = new EntityManager(DBcontext.getConnection());
//      Role role = new Role();
//        role.setRoleID(4);
//        role.setRoleName("Warehouse Keeper");
//        em.persist(role,Role.class);
//
//        em.remove(role,Role.class);


//      cac feature cua role
        int roleId = 3;
//        Map<String, Object> conditions = new HashMap<>();
//        conditions.put("role",roleId);
//        List<RoleFeature> roleFeatures = em.findWithConditions(RoleFeature.class, conditions);
//
//        System.out.println("Các feature của role có roleID=" + roleId + ":");
//        for (RoleFeature rf : roleFeatures) {
//            Feature f = rf.getFeature();
//            System.out.println("FeatureID: " + f.getFeatureID() + ", URL: " + f.getFeatureURL() + ", Desc: " + f.getDescription());
//        }
//
//        int featureId = 3; // Đổi lại cho phù hợp dữ liệu thật
//        Map<String, Object> condFeature = new HashMap<>();
//        condFeature.put("feature", featureId);
//
//        List<RoleFeature> featureRoles = em.findWithConditions(RoleFeature.class, condFeature);
//
//        System.out.println("Các role có featureID=" + featureId + ":");
//        for (RoleFeature rf : featureRoles) {
//            Role r = rf.getRole();
//            System.out.println("RoleID: " + r.getRoleID() + ", RoleName: " + r.getRoleName());
//        }

//        Map<String, Object> cond = new HashMap<>();
//        cond.put("role", roleId);
//        List<RoleFeature> roleFeature = em.findWithConditions(RoleFeature.class, cond);
//
//        // Lấy set featureID mà role này có
//        Set<Integer> selectedFeatureIds = new HashSet<>();
//        for (RoleFeature rf : roleFeature) {
//            selectedFeatureIds.add(rf.getFeature().getFeatureID());
//        }
//        System.out.println(selectedFeatureIds);

//        Map<String, Object> cond = new HashMap<>();
//        cond.put("role", roleId);
//        List<Account> accounts = em.findWithConditions(Account.class, cond);
        Role role = em.find(Role.class, roleId);
        Map<String, Object> condAcc = new HashMap<>();
        condAcc.put("role", roleId);
        List<Account> accounts = em.findWithConditions(Account.class, condAcc);
        int accountCount = accounts.size();
        System.out.println("Các tài khoản có role: " + role.getRoleName());
        for (Account acc : accounts) {
            System.out.println("Username: " + acc.getUsername()
                    + ", Status: " + acc.getAccountStatus()
                    + ", Role: " + acc.getRole().getRoleName());
        }



    }
}
