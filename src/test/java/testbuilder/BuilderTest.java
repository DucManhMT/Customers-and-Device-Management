package testbuilder;
import crm.common.model.enums.AccountStatus;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.repository.hibernate.querybuilder.*;
import crm.common.model.*;
import crm.core.config.DBcontext;

public class BuilderTest {
    public static void main(String[] args) {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        QueryUtils queryUtils = new QueryUtils();
        //Role
        Role role = new Role();
        role.setRoleID(1);
        role.setRoleName("Customer");
        //Account
        Account acc = new Account();
        acc.setUsername("john_doe");
        acc.setPasswordHash("hashed_primaryied");
        acc.setAccountStatus(AccountStatus.Active);
        acc.setRole(role);

        //persist


   //    em.persist(acc,Account.class);

//       em.remove(acc,Account.class);
///em.merge(acc, Account.class);
        Account newAcc = em.find(Account.class, "john_doe");
        System.out.println(em.count(Account.class));


    }
}
