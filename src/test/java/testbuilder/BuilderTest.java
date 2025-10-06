package testbuilder;

import crm.common.model.Account;
import crm.common.model.Feedback;
import crm.common.model.Role;
import crm.common.model.enums.AccountStatus;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.repository.hibernate.querybuilder.*;
import crm.common.model.*;
import crm.core.repository.persistence.config.DBcontext;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BuilderTest {
    public static void main(String[] args) {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        List<Contract> contracts;
        Map<String, Object> conditions = new HashMap<>();
        conditions.put("contractID", 1);
        contracts = em.findWithConditions(Contract.class, conditions);

        for (Contract contract : contracts) {
            System.out.println("Contract ID: " + contract.getContractID());
            System.out.println("Contract Image: " + contract.getContractImage());
            System.out.println("Start Date: " + contract.getStartDate());
            System.out.println("Expired Date: " + contract.getExpiredDate());
            System.out.println("Customer ID: " + contract.getCustomerID());
            System.out.println("-----------------------");
        }

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
