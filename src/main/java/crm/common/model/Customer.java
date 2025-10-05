package crm.common.model;

<<<<<<< HEAD
import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.hibernate.entitymanager.LazyReference;
=======
import crm.core.repository.persistence.annotation.Column;
import crm.core.repository.persistence.annotation.Entity;
import crm.core.repository.persistence.annotation.Key;
import crm.core.repository.persistence.annotation.ManyToOne;
import crm.core.repository.persistence.entity.load.LazyReference;
import crm.core.repository.persistence.entity.relation.FetchMode;
>>>>>>> main

@Entity(tableName = "Customer")
public class Customer {
    @Key
    @Column(name = "CustomerID", type = "INT")
    private Integer customerID;

    @Column(name = "CustomerName", length = 150, nullable = false)
    private String customerName;

    @Column(name = "Address", length = 255, nullable = false)
    private String address;

    @Column(name = "Phone", length = 50, nullable = false, unique = true)
    private String phone;

    @Column(name = "Email", length = 150, nullable = false, unique = true)
    private String email;

<<<<<<< HEAD
    @ManyToOne(joinColumn = "Username")
=======
    @Column(name = "Username", length = 100)
    private String username;

    @ManyToOne(joinColumn = "Username", fetch = FetchMode.EAGER)
>>>>>>> main
    private LazyReference<Account> account;

    public Integer getCustomerID() {
        return customerID;
    }

    public void setCustomerID(Integer customerID) {
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

    public Account getAccount() {
        return account.get();
    }

    public void setAccount(Account account) {
        this.account = new LazyReference<>(Account.class, account.getUsername());
    }
}
