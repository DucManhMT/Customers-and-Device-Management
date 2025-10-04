package testbuilder;
import crm.common.model.enums.AccountStatus;
import crm.core.repository.hibernate.querybuilder.*;
import crm.common.model.*;
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

    }
}
