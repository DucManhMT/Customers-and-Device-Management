package crm.common.model;

import crm.common.model.enums.TaskStatus;
import crm.core.repository.hibernate.annotation.*;
import crm.core.repository.hibernate.entitymanager.LazyReference;

import java.util.Date;

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
    private Date startDate;

    @Column(name = "EndDate")
    private Date endDate;

    @Column(name = "Deadline")
    private Date deadline;

    @Enumerated
    @Column(name = "Status")
    private TaskStatus status;

    public Task() {
    }

    public Task(Staff assignBy, Staff assignTo, Request request,
                Date startDate, Date endDate, Date deadline, TaskStatus status) {
        this.assignBy = new LazyReference<>(Staff.class, assignBy.getStaffID());
        this.assignTo = new LazyReference<>(Staff.class, assignTo.getStaffID());
        this.request = new LazyReference<>(Request.class, request.getRequestID());
        this.startDate = startDate;
        this.endDate = endDate;
        this.deadline = deadline;
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

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public Date getDeadline() {
        return deadline;
    }

    public void setDeadline(Date deadline) {
        this.deadline = deadline;
    }

    public TaskStatus getStatus() {
        return status;
    }

    public void setStatus(TaskStatus status) {
        this.status = status;
    }
}
