package crm.common.model;

import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.hibernate.entitymanager.LazyReference;

import java.time.LocalDate;

@Entity(tableName = "Staff")
public class Staff {
    @Key
    @Column(name = "StaffID", type = "INT")
    private Integer staffID;

    @Column(name = "StaffName", length = 150, nullable = false)
    private String staffName;

    @Column(name = "Phone", length = 50, nullable = false, unique = true)
    private String phone;

    @Column(name = "Address", length = 100)
    private String address;

    @Column(name = "Email", length = 150, nullable = false, unique = true)
    private String email;

    @Column(name = "Image", length = 255)
    private String image;

    @Column(name = "DateOfBirth", type = "DATE")
    private LocalDate dateOfBirth;


    @ManyToOne(joinColumn = "Username")
    private LazyReference<Account> account;

    public Integer getStaffID() {
        return staffID;
    }

    public void setStaffID(Integer staffID) {
        this.staffID = staffID;
    }

    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public Account getAccount() {
        return account.get();
    }

    public void setAccount(Account account) {

        this.account = new LazyReference<>(Account.class, account.getUsername());
    }

}
