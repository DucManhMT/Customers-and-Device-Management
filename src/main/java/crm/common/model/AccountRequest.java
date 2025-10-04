package crm.common.model;

import crm.core.repository.persistence.annotation.*;
import crm.core.repository.persistence.entity.load.LazyReference;
import crm.core.repository.persistence.entity.relation.FetchMode;

@Entity(tableName = "AccountRequest")
public class AccountRequest {
    @Key
    @Column(name = "AccountRequestID", type = "BIGINT")
    private Long accountRequestID;

    @Column(name = "Username", length = 100, nullable = false)
    private String username;

    @Column(name = "RequestID", type = "BIGINT", nullable = false)
    private Long requestID;

    @ManyToOne(joinColumn = "Username", fetch = FetchMode.EAGER)
    private LazyReference<Account> account;

    @ManyToOne(joinColumn = "RequestID", fetch = FetchMode.EAGER)
    private LazyReference<Request> request;

    public Long getAccountRequestID() {
        return accountRequestID;
    }

    public void setAccountRequestID(Long accountRequestID) {
        this.accountRequestID = accountRequestID;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public Long getRequestID() {
        return requestID;
    }

    public void setRequestID(Long requestID) {
        this.requestID = requestID;
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
}
