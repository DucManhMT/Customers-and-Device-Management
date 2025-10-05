package testbuilder;
import crm.common.model.enums.AccountStatus;
import crm.core.repository.hibernate.querybuilder.*;
import crm.common.model.*;
<<<<<<< HEAD
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

=======
public class BuilderTest {
    public static void main(String[] args) {
        QueryBuilder queryBuilder = new QueryBuilder();
        Account acc = new Account();
        acc.setUsername("john_doe");
        acc.setPasswordHash("hashed_password");
        acc.setAccountStatus(AccountStatus.Active);
        acc.setRoleID(1);
        try {
            System.out.println(queryBuilder.buildInsert(acc).getSql());
            System.out.println(queryBuilder.buildInsert(acc).getParams());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
>>>>>>> main

    }
}
