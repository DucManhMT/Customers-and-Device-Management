package crm.task.dto;

public class TaskFilter {
    private Integer requestId;
    private String status;
    private String staffName;
    private Boolean nearDue;
    private Boolean overdue;
    private Integer nearDueHours;
    private String sortDir;
    private int page = 1;
    private int size = 15;

    public Integer getRequestId() {
        return requestId;
    }

    public void setRequestId(Integer requestId) {
        this.requestId = requestId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }

    public Boolean getNearDue() {
        return nearDue;
    }

    public void setNearDue(Boolean nearDue) {
        this.nearDue = nearDue;
    }

    public Boolean getOverdue() {
        return overdue;
    }

    public void setOverdue(Boolean overdue) {
        this.overdue = overdue;
    }

    public Integer getNearDueHours() {
        return nearDueHours;
    }

    public void setNearDueHours(Integer nearDueHours) {
        this.nearDueHours = nearDueHours;
    }

    public String getSortDir() {
        return sortDir;
    }

    public void setSortDir(String sortDir) {
        this.sortDir = sortDir;
    }

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }
}