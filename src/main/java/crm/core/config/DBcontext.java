package crm.core.config;

import java.sql.Connection;
import java.sql.SQLException;

public class DBcontext {
    /**
     * Get a connection
     *
     * @return Connection use for readonly operations
     */
    public static Connection conn;
    public static Connection getConnection(){
        try {
            conn = DatabaseConfig.getDataSource().getConnection();
            return conn;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }



}

