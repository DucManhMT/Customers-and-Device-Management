package crm.auth.service;

import crm.common.model.UserOTP;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO;
import crm.core.repository.hibernate.querybuilder.QueryOperation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDateTime;

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

    public static boolean verifyOTP(String inputOtp, String actualOtp, String userEmail) {
        try (EntityManager em = new EntityManager(DBcontext.getConnection())) {
            deleteExpiredOtp(em);
            UserOTP userOTP = em.executeCustomQuery(UserOTP.class, QueryOperation.select(UserOTP.class).where("userEmail", userEmail).and("otpCode", actualOtp).build()).get(0);
            if (userOTP == null || userOTP.getExpiredTime().isBefore(LocalDateTime.now())) {
                return false; // OTP not found or expired
            }
            if (!userOTP.getOtpCode().equals(inputOtp)) {
                return false; // OTP does not match
            } else {
                // OTP is valid, delete it after successful verification
                em.remove(userOTP, UserOTP.class);
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
        // Simulate sending email
        System.out.println("Sending OTP " + otp + " to email: " + toEmail);
        return true; // Assume email sent successfully
    }

}
