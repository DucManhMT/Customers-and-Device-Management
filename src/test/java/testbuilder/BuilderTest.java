package testbuilder;

import crm.common.model.Account;
import crm.common.model.Contract;
import crm.common.model.Feedback;
import crm.common.model.Request;
import crm.common.model.Role;
import crm.common.model.enums.AccountStatus;
import crm.common.model.enums.RequestStatus;
import crm.common.repository.account.AccountDAO;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.repository.hibernate.querybuilder.*;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO;
import crm.core.repository.hibernate.querybuilder.enums.SortDirection;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BuilderTest {
    public static void main(String[] args) {
        AccountDAO accountDAO = new AccountDAO();
        Account account = new Account("user1", "password123", AccountStatus.Active, new Role(1, "Admin"));

        EntityManager em = new EntityManager(DBcontext.getConnection());
        List<Contract> contracts;
    }
}