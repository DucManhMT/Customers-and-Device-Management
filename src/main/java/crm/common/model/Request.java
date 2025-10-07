package crm.common.model;

import crm.common.model.enums.RequestStatus;
import crm.core.repository.hibernate.annotation.*;
import crm.core.repository.hibernate.entitymanager.LazyReference;

import java.time.LocalDateTime;
import java.util.List;

@Entity(tableName = "Request")
public class Request {
    @Key
    @Column(name = "RequestID", type = "INT")
    private Integer requestID;

    @Column(name = "RequestDescription", length = 255)
    private String requestDescription;

    @Enumerated
    @Column(name = "RequestStatus")
    private RequestStatus requestStatus;

    @Column(name = "StartDate", type = "DATETIME", nullable = false)
    private LocalDateTime startDate;

    @Column(name = "FinishedDate", type = "DATETIME")
    private LocalDateTime finishedDate;

    @Column(name = "Note", length = 255)
    private String note;

    @ManyToOne(joinColumn = "ContractID")
    private LazyReference<Contract> contract;

    @OneToMany(mappedBy = "requestID", joinColumn = "RequestID")
    private List<RequestLog> logs;

    public Integer getRequestID() {
        return requestID;
    }

    public void setRequestID(Integer requestID) {
        this.requestID = requestID;
    }

    public String getRequestDescription() {
        return requestDescription;
    }

    public void setRequestDescription(String requestDescription) {
        this.requestDescription = requestDescription;
    }

    public RequestStatus getRequestStatus() {
        return requestStatus;
    }

    public void setRequestStatus(RequestStatus requestStatus) {
        this.requestStatus = requestStatus;
    }

    public LocalDateTime getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDateTime startDate) {
        this.startDate = startDate;
    }

    public LocalDateTime getFinishedDate() {
        return finishedDate;
    }

    public void setFinishedDate(LocalDateTime finishedDate) {
        this.finishedDate = finishedDate;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Contract getContract() {
        return contract.get();
    }

    public void setContract(Contract contract) {
        this.contract = new LazyReference<>(Contract.class, contract);
    }

    public List<RequestLog> getLogs() {
        return logs;
    }

    public void setLogs(List<RequestLog> logs) {
        this.logs = logs;
    }
}
