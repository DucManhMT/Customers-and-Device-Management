package crm.core.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import crm.core.config.RepositoryConfig;
/**
 * DBcontext class to manage database connections.
 */
public class DBcontext {
    private static Connection connection;

    /**
     * Get a connection, create one if it doesn't exist or is closed
     *
     * @return Connection use for readonly operations
     */
    public static Connection getConnection() {
        try {
            if (connection == null || connection.isClosed()) {
                connection = createConnection();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return connection;
    }

    public static void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Create a new database connection using the configuration parameters.
     *
     * @return a new Connection object use for transactional operations
     * @throws SQLException if a database access error occurs
     */
    public static Connection createConnection() throws SQLException {
        String url =  RepositoryConfig.DB_URL;
        String user = RepositoryConfig.USER;
        String password = RepositoryConfig.PASSWORD;
        try {
            Class.forName(RepositoryConfig.DRIVER);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        Connection conn = DriverManager.getConnection(url, user, password);
        return conn;
    }
}
