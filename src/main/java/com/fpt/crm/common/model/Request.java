package com.fpt.crm.common.model;
import java.sql.Date;

public class Request {
    private int requestId;
    private String requestDescription;
    private int requestStatus;
    private Date createdDate;
    private Date finishedDate;
    private String note;

    public Request() {}
    public Request(int requestId, String requestDescription, int requestStatus, Date createdDate, Date finishedDate, String note) {
        this.requestId = requestId;
        this.requestDescription = requestDescription;
        this.requestStatus = requestStatus;
        this.createdDate = createdDate;
        this.finishedDate = finishedDate;
        this.note = note;
    }
    public int getRequestId() { return requestId; }
    public void setRequestId(int requestId) { this.requestId = requestId; }
    public String getRequestDescription() { return requestDescription; }
    public void setRequestDescription(String requestDescription) { this.requestDescription = requestDescription; }
    public int getRequestStatus() { return requestStatus; }
    public void setRequestStatus(int requestStatus) { this.requestStatus = requestStatus; }
    public Date getCreatedDate() { return createdDate; }
    public void setCreatedDate(Date createdDate) { this.createdDate = createdDate; }
    public Date getFinishedDate() { return finishedDate; }
    public void setFinishedDate(Date finishedDate) { this.finishedDate = finishedDate; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
}

