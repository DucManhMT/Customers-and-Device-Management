package crm.common.model;

import crm.core.repository.persistence.annotation.Column;
import crm.core.repository.persistence.annotation.Entity;
import crm.core.repository.persistence.annotation.Key;
import crm.core.repository.persistence.annotation.ManyToOne;
import crm.core.repository.persistence.entity.load.LazyReference;
import crm.core.repository.persistence.entity.relation.FetchMode;

import java.sql.Date;

@Entity(tableName = "Staff")
public class Staff {
    @Key
    @Column(name = "StaffID", type = "BIGINT")
    private Long staffID;

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
    private Date dateOfBirth;

    @Column(name = "Username", length = 100)
    private String username;

    @ManyToOne(joinColumn = "Username", fetch = FetchMode.EAGER)
    private LazyReference<Account> account;

    public Long getStaffID() {
        return staffID;
    }

    public void setStaffID(Long staffID) {
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

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
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
