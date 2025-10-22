package crm.contract.service;

import crm.core.utils.HashInfo;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class ContractCodeGenerator {
    public static String generateContractCode(String prefix, String contractId) {
        String datePart = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));

        // Lấy thời gian chính xác đến mili-giây để tránh trùng
        String timePart = LocalDateTime.now().format(DateTimeFormatter.ofPattern("HHmmssSSS"));

        // Ghép các thành phần để tạo chuỗi gốc cần hash
        String base = prefix + contractId + datePart + timePart;

        // Hash chuỗi gốc
        String hashed = HashInfo.hash(base);

        // Lấy 8 ký tự đầu trong chuỗi hash, viết hoa
        String hashPart = hashed.substring(0, 8).toUpperCase();

        // Format code theo chuẩn: CTR-20251020-A1B2C3D4
        return String.format("%s-%s-%s", prefix, datePart, hashPart);
    }

}
