package crm.core.repository.persistence.config;

import crm.core.config.DBcontext;

import java.sql.Connection;
import java.sql.SQLException;

public class TransactionManager {
    // ThreadLocal to hold the connection for each thread
    private static ThreadLocal<Connection> connectionHolder = new ThreadLocal<>();
    // To keep track of transaction depth for nested transactions
    private static ThreadLocal<Integer> transactionDepthHolder = ThreadLocal.withInitial(() -> 0);

    /**
     * Begins a new transaction by setting auto-commit to false on the current
     * connection.
     * 
     * @throws SQLException if a database access error occurs
     */
    public static void beginTransaction() throws SQLException {

        if (transactionDepthHolder.get() < 1 || connectionHolder.get() == null) {
            Connection connection = getConnection();
            connection.setAutoCommit(false);
            connectionHolder.set(connection);
        }

        transactionDepthHolder.set(transactionDepthHolder.get() + 1);
    }

    /**
     * Commits the current transaction and closes the connection.
     * 
     * @throws SQLException
     */
    public static void commit() throws SQLException {
        int depth = transactionDepthHolder.get() - 1;
        transactionDepthHolder.set(depth);
        Connection connection = connectionHolder.get();
        if (connection == null) {
            throw new SQLException("No transaction to commit");
        }
        if (depth < 0) {
            throw new SQLException("No transaction to commit");
        } else if (depth == 0) {
            connection.commit();
            connectionHolder.remove();
        }

    }

    /**
     * Rolls back the current transaction and closes the connection.
     * 
     * @throws SQLException if a database access error occurs
     */
    public static void rollback() throws SQLException {
        int depth = transactionDepthHolder.get() - 1;
        transactionDepthHolder.set(depth);
        Connection connection = connectionHolder.get();
        if (connection == null) {
            throw new SQLException("No transaction to rollback");
        }
        if (depth < 0) {
            throw new SQLException("No transaction to rollback");
        } else if (depth == 0) {
            connection.rollback();
            connectionHolder.remove();
        }

    }

    /**
     * Retrieves the current connection associated with the thread.
     * If no connection exists, a new one is created.
     * 
     * @return the current Connection object
     */
    public static Connection getConnection() {
        Connection connection = connectionHolder.get();
        if (connection == null) {
            connection = DBcontext.getConnection();
            connectionHolder.set(connection);

        }
        return connection;
    }
}