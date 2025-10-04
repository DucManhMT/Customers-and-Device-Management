package testbuilder;
import crm.common.model.enums.AccountStatus;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.repository.hibernate.querybuilder.*;
import crm.common.model.*;
import crm.core.repository.persistence.config.DBcontext;

public class BuilderTest {
    public static void main(String[] args) {
        EntityManager em = new EntityManager(DBcontext.getConnection());

        QueryBuilder queryBuilder = new QueryBuilder();
        Role role = new Role();
        role.setRoleID(1);
        role.setRoleName("Customer");

        Account acc = new Account();
        acc.setUsername("john_doe");
        acc.setPasswordHash("hashed_passworded");
        acc.setAccountStatus(AccountStatus.Active);
        acc.setRole(role);


        em.merge(acc, Account.class);


    }
}
