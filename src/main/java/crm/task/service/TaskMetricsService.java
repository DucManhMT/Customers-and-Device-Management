package crm.task.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import crm.common.model.Task;
import crm.common.model.enums.TaskStatus;
import crm.task.dto.TaskMetrics;
import crm.task.repository.TaskRepository;

public class TaskMetricsService {

    private final TaskRepository taskRepository = new TaskRepository();

    public TaskMetrics getMetrics() {
        List<Task> tasks = taskRepository.findAll();
        if (tasks == null) {
            tasks = List.of();
        }

        LocalDateTime now = LocalDateTime.now();

        // Group by status
        Map<TaskStatus, Long> byStatus = tasks.stream()
                .collect(Collectors.groupingBy(Task::getStatus, Collectors.counting()));

        long overdue = tasks.stream()
                .filter(t -> t.getDeadline() != null && t.getDeadline().isBefore(now)
                        && (t.getStatus() == TaskStatus.Pending || t.getStatus() == TaskStatus.Processing))
                .count();

        TaskMetrics metrics = new TaskMetrics();
        metrics.setPending(byStatus.getOrDefault(TaskStatus.Pending, 0L));
        metrics.setProcessing(byStatus.getOrDefault(TaskStatus.Processing, 0L));
        metrics.setFinished(byStatus.getOrDefault(TaskStatus.Finished, 0L));
        metrics.setRejected(byStatus.getOrDefault(TaskStatus.Reject, 0L));
        metrics.setDeactivated(byStatus.getOrDefault(TaskStatus.DeActived, 0L));
        metrics.setOverdue(overdue);
        metrics.setTotal(tasks.size());
        return metrics;
    }

    // DTO for metrics

}
