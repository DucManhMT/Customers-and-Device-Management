package crm.common.model;

import crm.common.model.enums.TaskStatus;
import crm.core.repository.hibernate.annotation.*;
import crm.core.repository.hibernate.entitymanager.LazyReference;

import java.time.LocalDateTime;

@Entity(tableName = "Task")
public class Task {

    @Key
    @Column(name = "TaskID")
    private int taskID;

    @ManyToOne(joinColumn = "AssignBy")
    private LazyReference<Staff> assignBy;

    @ManyToOne(joinColumn = "AssignTo")
    private LazyReference<Staff> assignTo;

    @ManyToOne(joinColumn = "RequestID")
    private LazyReference<Request> request;

    @Column(name = "StartDate")
    private LocalDateTime startDate;

    @Column(name = "EndDate")
    private LocalDateTime endDate;

    @Column(name = "Deadline")
    private LocalDateTime deadline;

    @Column(name = "Description", length = 255)
    private String description;

    @Enumerated
    @Column(name = "Status")
    private TaskStatus status;

    @Column(name = "TaskNote", length = 255)
    private String taskNote;

    public String getTaskNote() {
        return taskNote;
    }

    public void setTaskNote(String taskNote) {
        this.taskNote = taskNote;
    }

    public Task() {
        // Initialize LazyReferences to prevent NPE during EntityMapper mapping
        this.assignBy = new LazyReference<>(Staff.class, null);
        this.assignTo = new LazyReference<>(Staff.class, null);
        this.request = new LazyReference<>(Request.class, null);
    }

    public Task(Staff assignBy, Staff assignTo, Request request,
            LocalDateTime startDate, LocalDateTime endDate, LocalDateTime deadline,
            String description, TaskStatus status) {
        this.assignBy = new LazyReference<>(Staff.class, assignBy.getStaffID());
        this.assignTo = new LazyReference<>(Staff.class, assignTo.getStaffID());
        this.request = new LazyReference<>(Request.class, request.getRequestID());
        this.startDate = startDate;
        this.endDate = endDate;
        this.deadline = deadline;
        this.description = description;
        this.status = status;
    }

    public int getTaskID() {
        return taskID;
    }

    public void setTaskID(int taskID) {
        this.taskID = taskID;
    }

    public Staff getAssignBy() {
        return assignBy.get();
    }

    public void setAssignBy(Staff assignBy) {
        this.assignBy = new LazyReference<>(Staff.class, assignBy.getStaffID());
    }

    public Staff getAssignTo() {
        return assignTo.get();
    }

    public void setAssignTo(Staff assignTo) {
        this.assignTo = new LazyReference<>(Staff.class, assignTo.getStaffID());
    }

    public Request getRequest() {
        return request.get();
    }

    public void setRequest(Request request) {
        this.request = new LazyReference<>(Request.class, request.getRequestID());
    }

    public LocalDateTime getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDateTime startDate) {
        this.startDate = startDate;
    }

    public LocalDateTime getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDateTime endDate) {
        this.endDate = endDate;
    }

    public LocalDateTime getDeadline() {
        return deadline;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setDeadline(LocalDateTime deadline) {
        this.deadline = deadline;
    }

    public TaskStatus getStatus() {
        return status;
    }

    public void setStatus(TaskStatus status) {
        this.status = status;
    }
}
