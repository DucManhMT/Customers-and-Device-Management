package crm.auth.service;

import crm.common.model.Account;
import crm.common.model.Customer;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.service.MailService;

import java.util.HashMap;
import java.util.Map;
import java.util.List;

public class NewPasswordService {
    public static boolean sendNewPassword(String email){
        try{
            String newPassword = generateNewPassword();

            //Change password in database
            EntityManager em = new EntityManager(DBcontext.getConnection());
            Map<String, Object> conditions = new HashMap<>();
            conditions.put("email", email);
            List<Customer> customers = em.findWithConditions(Customer.class, conditions);
            if (customers == null || customers.isEmpty()) {
                return false; // Email not found
            }
            Customer customer = customers.get(0);
            customer.getAccount().setPasswordHash(newPassword);
            em.merge(customer.getAccount(), Account.class);

            String subject = "Your New Password";
            String body = "Here is your new password: " + newPassword;
            MailService.sendEmail(email, subject, body);
            return true;
        } catch (Exception e){
            e.printStackTrace();
            return false;
        }
    }
    private static String generateNewPassword() {
        int passwordLength= 6;
        StringBuilder newPass = new StringBuilder();
        for (int i = 0; i < passwordLength; i++) {
            int digit = (int) (Math.random() * 10);
            newPass.append(digit);
        }
        return newPass.toString();
    }

    public static boolean changePassword(String newPassword, Account account){
        EntityManager em = new EntityManager(DBcontext.getConnection());
        try{
            em.beginTransaction();
            account.setPasswordHash(newPassword);
            em.merge(account, Account.class);
            em.commit();
            return true;
        } catch (Exception e){
            e.printStackTrace();
            return false;
        }

    }
}
