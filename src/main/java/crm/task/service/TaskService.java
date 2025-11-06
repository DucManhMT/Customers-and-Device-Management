package crm.task.service;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

import crm.common.model.Task;
import crm.common.model.enums.TaskStatus;
import crm.core.config.TransactionManager;
import crm.service_request.repository.RequestRepository;
import crm.service_request.repository.persistence.query.common.ClauseBuilder;
import crm.service_request.repository.persistence.query.common.Page;
import crm.service_request.repository.persistence.query.common.PageRequest;
import crm.task.repository.StaffRepository;
import crm.task.repository.TaskRepository;

public class TaskService {
    private TaskRepository taskRepository = new TaskRepository();
    private RequestRepository requestRepository = new RequestRepository();
    private StaffRepository staffRepository = new StaffRepository();

    public Page<Task> getTaskWithCondition(int requestId, int staffId, String status, int page, int recordsPerPage) {
        ClauseBuilder builder = new ClauseBuilder();
        if (requestId > 0) {
            builder.equal("RequestID", requestId);
        }
        if (staffId > 0) {
            builder.equal("StaffID", staffId);
        }
        if (status != null && !status.isEmpty()) {
            builder.equal("TaskStatus", status);
        }

        return taskRepository.findWithCondtion(builder, PageRequest.of(page, recordsPerPage));
    }

    public List<Task> getAllTasks() {
        return taskRepository.findAll();
    }

    public List<Task> getTasksByRequestId(int requestId) {
        ClauseBuilder builder = new ClauseBuilder();
        builder.equal("RequestID", requestId);
        return taskRepository.findWithCondition(builder);
    }

    public Task getTaskById(int taskId) {
        return taskRepository.findById(taskId);
    }

    public Task createTask(int assignBy, int assignTo, int requestId, LocalDateTime startDate, LocalDateTime deadline) {
        Task task = new Task();
        task.setAssignBy(staffRepository.findById(assignBy));
        task.setAssignTo(staffRepository.findById(assignTo));
        task.setRequest(requestRepository.findById(requestId));
        task.setStartDate(startDate);
        task.setDeadline(deadline);
        task.setStatus(TaskStatus.Pending);
        try {
            TransactionManager.beginTransaction();
            taskRepository.save(task);
            TransactionManager.commit();
        } catch (SQLException e) {

            e.printStackTrace();
            try {
                TransactionManager.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }
        }
        return task;
    }

}
