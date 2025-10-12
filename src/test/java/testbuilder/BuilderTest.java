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
import crm.core.service.IDGeneratorService;
import crm.core.service.MailService;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BuilderTest {
    public static void main(String[] args) {
      EntityManager em  = new EntityManager(DBcontext.getConnection());

        UserOTP userOTP = new UserOTP();
        userOTP.setUserOTPID(IDGeneratorService.generateID(UserOTP.class));
        userOTP.setEmail("LOL");
        userOTP.setOtpCode("123456");
        userOTP.setExpiredTime(LocalDateTime.now().plusMinutes(1));
        boolean hasOTP = em.persist(userOTP, UserOTP.class);
        System.out.println(hasOTP);
    }

 }
