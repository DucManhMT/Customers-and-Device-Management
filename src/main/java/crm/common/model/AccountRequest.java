package crm.common.model;

import crm.core.repository.persistence.annotation.*;
import crm.core.repository.persistence.entity.load.LazyReference;
import crm.core.repository.persistence.entity.relation.FetchMode;

@Entity(tableName = "AccountRequest")
public class AccountRequest {
    @Key
    @Column(name = "AccountRequestID", type = "INT")
    private Integer accountRequestID; // surrogate key

    @Column(name = "Username", length = 100, nullable = false)
    private String username;

    @Column(name = "RequestID", type = "INT", nullable = false)
    private Integer requestID;

    @ManyToOne(joinColumn = "Username", fetch = FetchMode.EAGER)
    private LazyReference<Account> account;

    @ManyToOne(joinColumn = "RequestID", fetch = FetchMode.EAGER)
    private LazyReference<Request> request;

    public Integer getAccountRequestID() {
        return accountRequestID;
    }

    public void setAccountRequestID(Integer accountRequestID) {
        this.accountRequestID = accountRequestID;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public Integer getRequestID() {
        return requestID;
    }

    public void setRequestID(Integer requestID) {
        this.requestID = requestID;
    }

    public Account getAccount() {
        return account.get();
    }

    public void setAccount(Account account) {
        this.account.setValue(account);
    }

    public Request getRequest() {
        return request.get();
    }

    public void setRequest(Request request) {
        this.request.setValue(request);
    }
}
