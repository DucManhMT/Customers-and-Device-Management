package crm.common.model;

<<<<<<< HEAD
import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.hibernate.entitymanager.LazyReference;
=======
import crm.core.repository.persistence.annotation.*;
import crm.core.repository.persistence.entity.load.LazyReference;
import crm.core.repository.persistence.entity.relation.FetchMode;
>>>>>>> main

@Entity(tableName = "AccountRequest")
public class AccountRequest {
    @Key
    @Column(name = "AccountRequestID", type = "INT")
    private Integer accountRequestID;

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

    public Account getAccount() {
        return account.get();
    }

    public void setAccount(Account acc) {
            this.account = new LazyReference<>(Account.class, acc.getUsername());
    }

    public Request getRequest() {
        return request == null ? null : request.get();
    }

    public void setRequest(Request req) {
            this.request = new LazyReference<>(Request.class, req.getRequestID());
    }
}
