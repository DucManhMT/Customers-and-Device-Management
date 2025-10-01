package crm.common.model;

import crm.common.model.enums.OldRequestStatus;
import crm.common.model.enums.RequestStatus;
import crm.common.model.enums.converter.OldRequestStatusConverter;
import crm.core.repository.persistence.annotation.*;
import crm.core.repository.persistence.entity.convert.Convert;
import crm.core.repository.persistence.entity.load.LazyReference;
import crm.core.repository.persistence.entity.relation.FetchMode;

import java.sql.Date;

@Entity(tableName = "RequestLog")
public class RequestLog {
    @Key
    @Column(name = "RequestLogID", type = "INT")
    private Integer requestLogID;

    @Column(name = "ActionDate", type = "DATE")
    private Date actionDate;

    @Column(name = "OldStatus", length = 20)
    @Convert(converter = OldRequestStatusConverter.class)
    private OldRequestStatus oldStatus;

    @Column(name = "NewStatus", length = 20)
    private RequestStatus newStatus;

    @Column(name = "RequestID", type = "INT", nullable = false)
    private Integer requestID;

    @Column(name = "Username", length = 100)
    private String username;

    @ManyToOne(joinColumn = "RequestID", fetch = FetchMode.EAGER)
    private LazyReference<Request> request;

    @ManyToOne(joinColumn = "Username", fetch = FetchMode.EAGER)
    private LazyReference<Account> account;

    public Integer getRequestLogID() {
        return requestLogID;
    }

    public void setRequestLogID(Integer requestLogID) {
        this.requestLogID = requestLogID;
    }

    public Date getActionDate() {
        return actionDate;
    }

    public void setActionDate(Date actionDate) {
        this.actionDate = actionDate;
    }

    public OldRequestStatus getOldStatus() {
        return oldStatus;
    }

    public void setOldStatus(OldRequestStatus oldStatus) {
        this.oldStatus = oldStatus;
    }

    public RequestStatus getNewStatus() {
        return newStatus;
    }

    public void setNewStatus(RequestStatus newStatus) {
        this.newStatus = newStatus;
    }

    public Integer getRequestID() {
        return requestID;
    }

    public void setRequestID(Integer requestID) {
        this.requestID = requestID;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public Request getRequest() {
        return request.get();
    }

    public void setRequest(Request request) {
        this.request.setValue(request);
    }

    public Account getAccount() {
        return account.get();
    }

    public void setAccount(Account account) {
        this.account.setValue(account);
    }
}
