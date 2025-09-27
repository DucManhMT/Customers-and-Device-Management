package com.fpt.crm.common.model;
import java.sql.Date;

public class Staff {
    private int staffId;
    private String staffLastName;
    private String staffFirstName;
    private String staffPhone;
    private String staffAddress;
    private String staffEmail;
    private byte[] image;
    private Date dateOfBirth;
    private Account account;

    public Staff() {}
    public Staff(int staffId, String staffLastName, String staffFirstName, String staffPhone, String staffAddress, String staffEmail, byte[] image, Date dateOfBirth, Account account) {
        this.staffId = staffId;
        this.staffLastName = staffLastName;
        this.staffFirstName = staffFirstName;
        this.staffPhone = staffPhone;
        this.staffAddress = staffAddress;
        this.staffEmail = staffEmail;
        this.image = image;
        this.dateOfBirth = dateOfBirth;
        this.account = account;
    }
    public int getStaffId() { return staffId; }
    public void setStaffId(int staffId) { this.staffId = staffId; }
    public String getStaffLastName() { return staffLastName; }
    public void setStaffLastName(String staffLastName) { this.staffLastName = staffLastName; }
    public String getStaffFirstName() { return staffFirstName; }
    public void setStaffFirstName(String staffFirstName) { this.staffFirstName = staffFirstName; }
    public String getStaffPhone() { return staffPhone; }
    public void setStaffPhone(String staffPhone) { this.staffPhone = staffPhone; }
    public String getStaffAddress() { return staffAddress; }
    public void setStaffAddress(String staffAddress) { this.staffAddress = staffAddress; }
    public String getStaffEmail() { return staffEmail; }
    public void setStaffEmail(String staffEmail) { this.staffEmail = staffEmail; }
    public byte[] getImage() { return image; }
    public void setImage(byte[] image) { this.image = image; }
    public Date getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(Date dateOfBirth) { this.dateOfBirth = dateOfBirth; }
    public Account getAccount() { return account; }
    public void setAccount(Account account) { this.account = account; }
}

