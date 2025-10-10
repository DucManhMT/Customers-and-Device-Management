package testbuilder;

import crm.auth.service.Hasher;
import crm.auth.service.LoginService;
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
import crm.core.service.MailService;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BuilderTest {
    public static void main(String[] args) {
      EntityManager em  = new EntityManager(DBcontext.getConnection());
//        Role r = em.find(Role.class, 3);
//        Account a = new Account();
//        a.setUsername("user1");
//        a.setPasswordHash("pass1");
//        a.setRole(r);
//        a.setAccountStatus(AccountStatus.Active);
//        em.persist(a,Account.class);
        AccountDAO accountDAO = new AccountDAO();

        Account newAcc = accountDAO.find("user1");


    }
 }
