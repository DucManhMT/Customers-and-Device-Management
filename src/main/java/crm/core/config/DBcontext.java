package crm.core.config;

import crm.core.repository.persistence.config.RepositoryConfig;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBcontext {
    // Deprecated: previously cached a single static connection leading to inconsistent autocommit state
    // private static Connection connection;

    /**
     * Always returns a new connection. Caller is responsible for closing it when finished.
     */
    public static Connection getConnection() {
        try {
            return createConnection();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to obtain connection", e);
        }
    }

    /**
     * Explicit factory method for new connection (alias of getConnection for clarity)
     */
    public static Connection newConnection() { return getConnection(); }

    /**
     * Create a new database connection using the configuration parameters.
     *
     * @return a new Connection object use for transactional operations
     * @throws SQLException if a database access error occurs
     */
    public static Connection createConnection() throws SQLException {
        String url = crm.core.repository.persistence.config.RepositoryConfig.DB_URL;
        String user = crm.core.repository.persistence.config.RepositoryConfig.USER;
        String password = crm.core.repository.persistence.config.RepositoryConfig.PASSWORD;
        try {
            Class.forName(RepositoryConfig.DRIVER);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Driver not found", e);
        }
        return DriverManager.getConnection(url, user, password);
    }

    // No-op retained for backward compatibility; each call returns fresh connection now so close externally.
    public static void closeConnection(Connection c) {
        if (c != null) {
            try { c.close(); } catch (Exception ignored) {}
        }
    }
}
