package crm.task.service;

import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import crm.common.model.Task;
import crm.common.model.Request;
import crm.common.model.Staff;
import crm.common.model.enums.OldRequestStatus;
import crm.common.model.enums.RequestStatus;
import crm.common.model.enums.TaskStatus;
import crm.core.config.TransactionManager;
import crm.core.utils.DateTimeConverter;
import crm.service_request.repository.RequestRepository;
import crm.service_request.repository.persistence.query.common.ClauseBuilder;
import crm.service_request.repository.persistence.query.common.Page;
import crm.service_request.repository.persistence.query.common.PageRequest;
import crm.service_request.service.RequestLogService;
import crm.service_request.repository.persistence.query.common.Order;
import crm.task.dto.TaskFilter;
import crm.task.exception.TaskDeletionException;
import crm.task.repository.StaffRepository;
import crm.task.repository.TaskRepository;

public class TaskService {
    private TaskRepository taskRepository = new TaskRepository();
    private RequestRepository requestRepository = new RequestRepository();
    private StaffRepository staffRepository = new StaffRepository();
    RequestLogService requestLogService = new RequestLogService();

    // Column name constants to avoid duplication & magic strings
    private static final String COL_REQUEST_ID = "RequestID";
    private static final String COL_ASSIGN_TO = "AssignTo";
    private static final String COL_STATUS = "Status";
    private static final String COL_DEADLINE = "Deadline";

    public Page<Task> getTaskWithCondition(int requestId, int staffId, String status, int page, int recordsPerPage) {
        ClauseBuilder builder = new ClauseBuilder();
        if (requestId > 0) {
            builder.equal(COL_REQUEST_ID, requestId);
        }
        if (staffId > 0) {
            builder.equal(COL_ASSIGN_TO, staffId);
        }
        if (status != null && !status.isEmpty()) {
            builder.equal(COL_STATUS, status);
        }

        return taskRepository.findWithCondtion(builder, PageRequest.of(page, recordsPerPage));
    }

    public List<Task> getTasksByStaffId(int staffId) {
        ClauseBuilder builder = new ClauseBuilder();
        builder.equal(COL_ASSIGN_TO, staffId);
        return taskRepository.findWithCondition(builder);
    }

    public List<Task> getAllTasks() {
        return taskRepository.findAll();
    }

    public List<Task> getTasksByRequestId(int requestId) {
        ClauseBuilder builder = new ClauseBuilder();
        builder.equal(COL_REQUEST_ID, requestId);
        return taskRepository.findWithCondition(builder);
    }

    public Task getTaskById(int taskId) {
        return taskRepository.findById(taskId);
    }

    public Page<Task> getTasksOrderByNearestDeadline(Integer requestId, int page, int recordsPerPage) {
        ClauseBuilder builder = new ClauseBuilder();
        if (requestId != null && requestId > 0) {
            builder.equal(COL_REQUEST_ID, requestId);
        }
        return taskRepository.findWithCondtion(builder,
                PageRequest.of(page, recordsPerPage, java.util.List.of(Order.asc(COL_DEADLINE))));
    }

    public Page<Task> searchTasks(TaskFilter filter) {
        Integer requestId = filter.getRequestId();
        String status = filter.getStatus();
        String staffName = filter.getStaffName();
        Boolean nearDue = filter.getNearDue();
        Boolean overdue = filter.getOverdue();
        Integer nearDueHours = filter.getNearDueHours();
        String sortDir = filter.getSortDir();
        int page = filter.getPage();
        int size = filter.getSize();
        ClauseBuilder builder = new ClauseBuilder();

        if (requestId != null && requestId > 0) {
            builder.equal(COL_REQUEST_ID, requestId);
        }
        if (status != null && !status.isBlank()) {
            builder.equal(COL_STATUS, status);
        }

        // staffName LIKE -> lấy danh sách staffID rồi IN AssignTo
        if (staffName != null && !staffName.isBlank()) {
            ClauseBuilder staffClause = new ClauseBuilder().like("StaffName", "%" + staffName + "%");
            java.util.List<Staff> staffs = staffRepository.findWithCondition(staffClause);
            java.util.List<Integer> staffIds = new java.util.ArrayList<>();
            if (staffs != null) {
                for (Staff s : staffs) {
                    if (s != null && s.getStaffID() != null) {
                        staffIds.add(s.getStaffID());
                    }
                }
            }
            if (!staffIds.isEmpty()) {
                builder.in(COL_ASSIGN_TO, staffIds);
            } else {

                return new Page<>(0, PageRequest.of(page, size), java.util.List.of());
            }
        }

        LocalDateTime now = LocalDateTime.now();

        int nearDueDays = (nearDueHours == null || nearDueHours <= 0) ? 1 : nearDueHours; // tái sử dụng field

        if (Boolean.TRUE.equals(overdue)) {
            builder.less(COL_DEADLINE, now);
        } else if (Boolean.TRUE.equals(nearDue)) {

            LocalDateTime edge = now.plusDays(nearDueDays);
            builder.greaterOrEqual(COL_DEADLINE, now).and().lessOrEqual(COL_DEADLINE, edge);
        }

        boolean asc = (sortDir == null || sortDir.equalsIgnoreCase("asc"));
        var orders = java.util.List.of(asc ? Order.asc(COL_DEADLINE) : Order.desc(COL_DEADLINE));
        PageRequest pageRequest = PageRequest.of(page, size, orders);
        return taskRepository.findWithCondtion(builder, pageRequest);
    }

    public Task createTask(int assignBy, int assignTo, int requestId, LocalDateTime startDate, LocalDateTime deadline,
            String description) {
        Task task = new Task();
        Request request = requestRepository.findById(requestId);
        // return null if request not found
        task.setTaskID(taskRepository.getNewId());
        task.setAssignBy(staffRepository.findById(assignBy));
        task.setAssignTo(staffRepository.findById(assignTo));
        task.setRequest(requestRepository.findById(requestId));
        task.setStartDate(startDate);
        task.setDeadline(deadline);
        task.setDescription(description);
        task.setStatus(TaskStatus.Pending);

        try {
            TransactionManager.beginTransaction();
            taskRepository.save(task);
            if (request.getRequestStatus().equals(RequestStatus.Approved)) {
                request.setRequestStatus(RequestStatus.Processing);

                requestRepository.update(request);
            }
            requestLogService.createLog(request, "Request has been assigned to tech employee.",
                    OldRequestStatus.Approved,
                    RequestStatus.Processing, task.getAssignBy().getAccount());
            TransactionManager.commit();
        } catch (SQLException e) {

            e.printStackTrace();
            try {
                TransactionManager.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }
            // bubble up failure via null return to let controller show proper message
            return null;
        }
        return task;
    }

    /**
     * Delete a task only if its status is Pending or Processing.
     * Returns true if deleted, false if not allowed.
     * Throws IllegalArgumentException if task not found.
     */
    public boolean deleteTaskIfAllowed(int taskId) {
        Task task = taskRepository.findById(taskId);
        if (task == null) {
            throw new IllegalArgumentException("Task not found");
        }
        TaskStatus status = task.getStatus();
        boolean allowed = (status == TaskStatus.Pending || status == TaskStatus.Processing);

        if (!allowed) {
            return false;
        }
        try {
            TransactionManager.beginTransaction();
            task.setStatus(TaskStatus.DeActived);
            taskRepository.update(task);
            TransactionManager.commit();
            return true;
        } catch (SQLException e) {
            try {
                TransactionManager.rollback();
            } catch (SQLException ignored) {
                // rollback failure intentionally ignored; original exception preserved
            }
            throw new TaskDeletionException("Failed to delete task with id=" + taskId, e);
        }
    }

    public boolean hasTimeConflict(int staffId, LocalDate startDate, LocalDate deadline) {
        if (staffId <= 0 || startDate == null || deadline == null) {
            return false;
        }
        LocalDateTime newStart = DateTimeConverter.toStartOfDay(startDate);
        LocalDateTime newEnd = DateTimeConverter.toEndOfDay(deadline);
        List<Task> existing = getTasksByStaffId(staffId);
        if (existing == null || existing.isEmpty()) {
            return false;
        }
        for (Task t : existing) {
            if (t != null) {
                TaskStatus st = t.getStatus();
                if (!(st == TaskStatus.DeActived || st == TaskStatus.Finished || st == TaskStatus.Reject)) {
                    LocalDateTime tStart = t.getStartDate();
                    LocalDateTime tEnd = t.getDeadline();
                    if (tStart != null && tEnd != null) {
                        boolean overlap = !(tEnd.isBefore(newStart) || tStart.isAfter(newEnd));
                        if (overlap) {
                            return true;
                        }
                    }
                }
            }
        }
        return false;
    }

}
