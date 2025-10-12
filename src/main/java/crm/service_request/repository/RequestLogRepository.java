package crm.service_request.repository;

import crm.core.config.DBcontext;
import crm.service_request.model.RequestLog;
import crm.service_request.repository.persistence.AbstractRepository;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class RequestLogRepository extends AbstractRepository<RequestLog, Integer> {

    public RequestLogRepository() {
        super(RequestLog.class);
    }

    public Integer getNewId() {
        String sql = "SELECT MAX(RequestLogID) AS MaxID FROM RequestLog";
        Connection connection = DBcontext.getConnection();
        try (Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(sql)) {
            if (resultSet.next()) {
                int maxId = resultSet.getInt("MaxID");
                return maxId + 1;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 1;
    }
}
