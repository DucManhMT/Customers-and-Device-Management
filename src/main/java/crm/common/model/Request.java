package crm.common.model;

import crm.common.model.enums.RequestStatus;
import crm.core.repository.hibernate.annotation.*;
import crm.core.repository.persistence.entity.load.LazyReference;

import java.time.LocalDateTime;
import java.util.List;

@Entity(tableName = "Request")
public class Request {
    @Key
    @Column(name = "RequestID", type = "BIGINT")
    private Long requestID;

    @Column(name = "RequestDescription", length = 255)
    private String requestDescription;

    @Column(name = "RequestStatus")
    private RequestStatus requestStatus;

    @Column(name = "StartDate", type = "DATETIME", nullable = false)
    private LocalDateTime startDate;

    @Column(name = "FinishedDate", type = "DATETIME")
    private LocalDateTime finishedDate;

    @Column(name = "Note", length = 255)
    private String note;

    @Column(name = "ContractID", type = "BIGINT", nullable = false)
    private Long contractID; // corrected relationship to ContractID

    @ManyToOne(joinColumn = "ContractID")
    private LazyReference<Contract> contract;

    @OneToMany(mappedBy = "requestID", joinColumn = "RequestID")
    private List<RequestLog> logs;

    public Request() {
    }

    public Request(Long requestID, String requestDescription, RequestStatus requestStatus, LocalDateTime startDate,
            Long contractID) {
        this.requestID = requestID;
        this.requestDescription = requestDescription;
        this.requestStatus = requestStatus;
        this.startDate = startDate;
        this.contractID = contractID;
    }

    public Long getRequestID() {
        return requestID;
    }

    public void setRequestID(Long requestID) {
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

    public Long getContractID() {
        return contractID;
    }

    public void setContractID(Long contractID) {
        this.contractID = contractID;
    }

    public Contract getContract() {
        if (contract == null) {
            return null;
        }
        return contract.get();
    }

    public void setContract(Contract contract) {
        if (this.contract == null) {
            this.contract = new LazyReference<>(contract);
        } else {
            this.contract.setValue(contract);
        }
        // synchronize ContractID
        if (this.contractID == null && contract != null) {
            this.contractID = contract.getContractID();
        }
    }

    public List<RequestLog> getLogs() {
        return logs;
    }

    public void setLogs(List<RequestLog> logs) {
        this.logs = logs;
    }
}
