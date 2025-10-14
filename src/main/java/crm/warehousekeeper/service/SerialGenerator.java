package crm.warehousekeeper.service;

import crm.core.utils.HashInfo;

public class SerialGenerator {
    public static String generateSerial(String prefix, String serialNumber) {
        String serial = HashInfo.hash(prefix + serialNumber);
        return serial.substring(0, 12).toUpperCase();
    }
}
