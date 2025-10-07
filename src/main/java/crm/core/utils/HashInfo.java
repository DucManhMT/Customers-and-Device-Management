package crm.core.utils;

import java.security.MessageDigest;

public class HashInfo {

    public static String hash(String info) {

        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = digest.digest(info.getBytes("UTF-8"));

            // Convert byte array into hex string
            StringBuilder hexString = new StringBuilder();
            for (byte b : hashBytes) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }

            return hexString.toString();
        } catch (Exception e) {
            throw new RuntimeException("Error when hash SHA-256", e);
        }

    }

}