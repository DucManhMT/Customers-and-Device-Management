package crm.common.model;

import crm.common.model.enums.OldRequestStatus;
import crm.common.model.enums.RequestStatus;
import crm.common.model.enums.converter.OldRequestStatusConverter;
import crm.common.model.enums.converter.RequestStatusConverter;
import crm.core.repository.persistence.annotation.*;
import crm.core.repository.persistence.entity.convert.Convert;
import crm.core.repository.persistence.entity.load.LazyReference;
import crm.core.repository.persistence.entity.relation.FetchMode;

import java.sql.Date;

@Entity(tableName = "RequestLog")
public class RequestLog {
    @Key
    @Column(name = "RequestLogID", type = "BIGINT")
    private Long requestLogID;

    @Column(name = "ActionDate", type = "DATE")
    private Date actionDate;

    @Column(name = "OldStatus", length = 20)
    @Convert(converter = OldRequestStatusConverter.class)
    private OldRequestStatus oldStatus;

    @Column(name = "NewStatus", length = 20)
    @Convert(converter = RequestStatusConverter.class)
    private RequestStatus newStatus;

    @Column(name = "RequestID", type = "BIGINT", nullable = false)
    private Long requestID;

    @Column(name = "Username", length = 100)
    private String username;

    @ManyToOne(joinColumn = "RequestID", fetch = FetchMode.EAGER)
    private LazyReference<Request> request;

    @ManyToOne(joinColumn = "Username", fetch = FetchMode.EAGER)
    private LazyReference<Account> account;

    public Long getRequestLogID() {
        return requestLogID;
    }

    public void setRequestLogID(Long requestLogID) {
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

    public Long getRequestID() {
        return requestID;
    }

    public void setRequestID(Long requestID) {
        this.requestID = requestID;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public Request getRequest() {
        if (request == null) {
            return null;
        }
        return request.get();
    }

    public void setRequest(Request request) {
        if (this.request == null) {
            this.request = new LazyReference<>(request);
        } else {
            this.request.setValue(request);
        }
        // synchronize RequestID
        if (this.requestID == null && request != null) {
            this.requestID = request.getRequestID();
        }
    }

    public Account getAccount() {
        if (account == null) {
            return null;
        }
        return account.get();
    }

    public void setAccount(Account account) {
        if (this.account == null) {
            this.account = new LazyReference<>(account);
        } else {
            this.account.setValue(account);
        }
        // synchronize Username
        if (this.username == null && account != null) {
            this.username = account.getUsername();
        }
    }
}
