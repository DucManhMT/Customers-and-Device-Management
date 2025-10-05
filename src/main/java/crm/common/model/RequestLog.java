package crm.common.model;

import crm.common.model.enums.OldRequestStatus;
import crm.common.model.enums.RequestStatus;
import crm.core.repository.hibernate.annotation.*;
import crm.core.repository.hibernate.entitymanager.LazyReference;

import java.sql.Date;

@Entity(tableName = "RequestLog")
public class RequestLog {
    @Key
    @Column(name = "RequestLogID", type = "INT")
    private Integer requestLogID;

    @Column(name = "ActionDate", type = "DATE")
    private Date actionDate;

    @Enumerated
    @Column(name = "OldStatus", length = 20)
    private OldRequestStatus oldStatus;

    @Enumerated
    @Column(name = "NewStatus", length = 20)
    private RequestStatus newStatus;


    @ManyToOne(joinColumn = "RequestID")
    private LazyReference<Request> request;

    @ManyToOne(joinColumn = "Username")
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


    public Request getRequest() {
        return request.get();
    }

    public void setRequest(Request request) {

        this.request = new LazyReference<>(Request.class, request.getRequestID());
    }

    public Account getAccount() {
        return account.get();
    }

    public void setAccount(Account account) {

        this.account = new LazyReference<>(Account.class, account.getUsername());
    }
}
