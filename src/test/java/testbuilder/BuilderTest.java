package testbuilder;

import crm.common.model.Account;
import crm.common.model.Feedback;
import crm.common.model.Role;
import crm.common.model.enums.AccountStatus;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.repository.hibernate.querybuilder.*;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO;
import crm.core.repository.hibernate.querybuilder.enums.SortDirection;
import java.time.LocalDateTime;
public class BuilderTest {
    public static void main(String[] args) {
        EntityManager em = new EntityManager(DBcontext.getConnection());
//        QueryUtils queryUtils = new QueryUtils();
        //Role
        Role role = new Role();
        role.setRoleID(1);
        role.setRoleName("Customer");
//        //Account
        Account acc = new Account();
        acc.setUsername("john_doneeer");
        acc.setPasswordHash("hashed_primaryied");
        acc.setAccountStatus(AccountStatus.Active);
        acc.setRole(role);


        //persist
        em.beginTransaction();
         em.persist(acc,Account.class);
         em.commit();
        //em.remove(acc,Account.class);
        // em.merge(acc, Account.class);



        // em.executeSelect(sqlAndParams, Account.class);

       /* Feedback feedback = new Feedback();*/
//        feedback.setFeedbackID(1);
//        feedback.setContent("Great service!");
//        feedback.setAccount(acc);
//        feedback.setRating(5);
//        feedback.setResponse("Thank you for your feedback!");
//        feedback.setFeedbackDate(LocalDateTime.now());
        System.out.println(role.getRoleName());
    }
}
