package crm.task.repository;

import crm.common.model.Task;
import crm.service_request.repository.persistence.AbstractRepository;

public class TaskRepository extends AbstractRepository<Task, Integer> {
    public TaskRepository() {
        super(Task.class);
    }
}
