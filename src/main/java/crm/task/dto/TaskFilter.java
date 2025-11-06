package crm.task.dto;

/**
 * Tìm kiếm & lọc Task với các điều kiện nâng cao.
 * 
 * @param requestId    lọc theo requestId (nullable)
 * @param status       lọc theo trạng thái (nullable)
 * @param staffName    tìm theo tên nhân viên được giao (LIKE, nullable)
 * @param nearDue      chỉ lấy task có deadline trong khoảng tới (nearDueHours)
 *                     tới
 * @param overdue      chỉ lấy task có deadline quá hạn (deadline < now)
 * @param nearDueHours số giờ xét "sắp quá hạn" (mặc định 24 nếu null)
 * @param sortDir      hướng sắp xếp deadline: "asc" hoặc "desc" (mặc định asc)
 * @param page         trang (1-index)
 * @param size         số bản ghi mỗi trang
 */
/**
 * Wrapper tiện lợi gom nhóm các tham số filter nâng cao.
 */
public class TaskFilter {
    private Integer requestId;
    private String status;
    private String staffName;
    private Boolean nearDue;
    private Boolean overdue;
    private Integer nearDueHours; // TÁI DỤNG: coi như "nearDueDays" theo yêu cầu mới
    private String sortDir; // asc | desc
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