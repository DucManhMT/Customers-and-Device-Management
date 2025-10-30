package crm.auth.service;

import crm.common.model.UserOTP;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO;
import crm.core.repository.hibernate.querybuilder.QueryOperation;

import java.sql.SQLException;
import java.time.LocalDateTime;

import crm.core.repository.hibernate.querybuilder.enums.SortDirection;
import crm.core.service.IDGeneratorService;
import crm.core.service.MailService;

public class OTPProvider {
    public static String generateOTP() {
        int otpLength = 6;
        StringBuilder otp = new StringBuilder();
        for (int i = 0; i < otpLength; i++) {
            int digit = (int) (Math.random() * 10);
            otp.append(digit);
        }
        return otp.toString();
    }

    public static boolean verifyOTP(String inputOtp, String userEmail) {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        try {
            deleteExpiredOtp(em);
            UserOTP userOTP = em.executeCustomQuery(UserOTP.class, QueryOperation.select(UserOTP.class).where("email", userEmail).orderBy("expiredTime", SortDirection.DESC).build()).get(0);
            if (userOTP == null || userOTP.getExpiredTime().isBefore(LocalDateTime.now())) {
                return false; // OTP not found or expired
            }
            if (!userOTP.getOtpCode().equals(inputOtp)) {
                return false; // OTP does not match
            } else {
                // OTP is valid, delete it after successful verification
                em.remove(userOTP, UserOTP.class);
                System.out.println("OTP verified and deleted successfully.");
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return true;
    }

    public static void deleteExpiredOtp(EntityManager entityManager) throws SQLException {
        String sql = "DELETE FROM UserOTP WHERE expiredTime < ?";
        String param = LocalDateTime.now().toString();
        SqlAndParamsDTO dto = new SqlAndParamsDTO(sql, param);
        entityManager.executeUpdate(dto);
    }

    public static boolean sendOTPEmail(String toEmail, String otp) {
        String subject = "Your OTP Code";
        String body = "Your verification code is " + otp + ". It expires in 3 minute.";
        EntityManager em = new EntityManager(DBcontext.getConnection());
        try {
            // Save OTP to database with 1 minute expiration
            deleteExpiredOtp(em);
            UserOTP userOTP = new UserOTP();
            userOTP.setUserOTPID(IDGeneratorService.generateID(UserOTP.class));
            userOTP.setEmail(toEmail);
            userOTP.setOtpCode(otp);
            userOTP.setExpiredTime(LocalDateTime.now().plusMinutes(3));
            em.persist(userOTP, UserOTP.class);
            MailService.sendEmail(toEmail, subject, body);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}
