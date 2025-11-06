package crm.task.service;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

import crm.common.model.Task;
import crm.common.model.Staff;
import crm.common.model.enums.TaskStatus;
import crm.core.config.TransactionManager;
import crm.core.utils.KeyGenerator;
import crm.service_request.repository.RequestRepository;
import crm.service_request.repository.persistence.query.common.ClauseBuilder;
import crm.service_request.repository.persistence.query.common.Page;
import crm.service_request.repository.persistence.query.common.PageRequest;
import crm.service_request.repository.persistence.query.common.Order;
import crm.task.dto.TaskFilter;
import crm.task.repository.StaffRepository;
import crm.task.repository.TaskRepository;

public class TaskService {
    private TaskRepository taskRepository = new TaskRepository();
    private RequestRepository requestRepository = new RequestRepository();
    private StaffRepository staffRepository = new StaffRepository();

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

    /**
     * Lấy danh sách Task được sắp xếp theo Deadline gần nhất (ASC).
     * Có thể lọc theo requestId nếu cung cấp (>0). Phân trang theo page &
     * recordsPerPage (1-indexed).
     */
    public Page<Task> getTasksOrderByNearestDeadline(Integer requestId, int page, int recordsPerPage) {
        ClauseBuilder builder = new ClauseBuilder();
        if (requestId != null && requestId > 0) {
            builder.equal(COL_REQUEST_ID, requestId);
        }
        // Sắp xếp theo Deadline tăng dần sử dụng API mới Order list
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
                // Không ai khớp -> trả về trang rỗng
                return new Page<>(0, PageRequest.of(page, size), java.util.List.of());
            }
        }

        LocalDateTime now = LocalDateTime.now();
        // Đổi logic sắp quá hạn theo ngày (nearDueDays) thay cho giờ
        int nearDueDays = (nearDueHours == null || nearDueHours <= 0) ? 1 : nearDueHours; // tái sử dụng field
                                                                                          // nearDueHours như days

        if (Boolean.TRUE.equals(overdue)) {
            builder.less(COL_DEADLINE, now); // deadline < now => quá hạn
        } else if (Boolean.TRUE.equals(nearDue)) {
            // deadline trong khoảng [today, today + nearDueDays]
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
