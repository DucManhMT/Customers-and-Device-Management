package test;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBconnection {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/crm?useSSL=false&serverTimezone=UTC";
        String user = "root";
        String password = "hunterskg2";

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            System.out.println("Kết nối thành công!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
