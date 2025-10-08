package crm.core.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
/**
 * Cấu hình kết nối database sử dụng HikariCP
 */

public class DatabaseConfig {
    private static final HikariDataSource dataSource;

    static {
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(RepositoryConfig.DB_URL);
        config.setUsername(RepositoryConfig.USER);
        config.setPassword(RepositoryConfig.PASSWORD);

        // Tuỳ chọn tối ưu
        config.setMaximumPoolSize(10);     // số connection tối đa trong pool
        config.setMinimumIdle(2);          // số connection rảnh giữ sẵn
        config.setIdleTimeout(60000);      // ms – connection rảnh bao lâu thì trả
        config.setMaxLifetime(1800000);    // ms – connection tồn tại tối đa
        config.setConnectionTimeout(30000);// ms – chờ tối đa khi xin connection

        dataSource = new HikariDataSource(config);
    }

    public static HikariDataSource getDataSource() {
        return dataSource;
    }
}
