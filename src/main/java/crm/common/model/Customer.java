package crm.common.model;

import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.persistence.entity.load.LazyReference;

@Entity(tableName = "Customer")
public class Customer {
    @Key
    @Column(name = "CustomerID", type = "BIGINT")
    private Long customerID;

    @Column(name = "CustomerName", length = 150, nullable = false)
    private String customerName;

    @Column(name = "Address", length = 255, nullable = false)
    private String address;

    @Column(name = "Phone", length = 50, nullable = false, unique = true)
    private String phone;

    @Column(name = "Email", length = 150, nullable = false, unique = true)
    private String email;

    @Column(name = "Username", length = 100)
    private String username;

    @ManyToOne(joinColumn = "Username")
    private LazyReference<Account> account;

    public Long getCustomerID() {
        return customerID;
    }

    public void setCustomerID(Long customerID) {
        this.customerID = customerID;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public Account getAccount() {
        return account.get();
    }

    public void setAccount(Account account) {
        this.account.setValue(account);
    }
}
