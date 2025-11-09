package crm.task.repository;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import crm.common.model.Task;
import crm.core.config.DBcontext;
import crm.service_request.repository.persistence.AbstractRepository;

public class TaskRepository extends AbstractRepository<Task, Integer> {
    public TaskRepository() {
        super(Task.class);
    }

    public int getNewId() {
        String sql = "SELECT MAX(TaskID) AS MaxID FROM Task";

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
