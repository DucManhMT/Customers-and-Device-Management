package com.fpt.crm.common.model;

public class Customer {
    private int customerId;
    private String customerName;
    private String customerAddress;
    private String customerPhone;
    private String customerMail;
    private Account account;

    public Customer() {}
    public Customer(int customerId, String customerName, String customerAddress, String customerPhone, String customerMail, Account account) {
        this.customerId = customerId;
        this.customerName = customerName;
        this.customerAddress = customerAddress;
        this.customerPhone = customerPhone;
        this.customerMail = customerMail;
        this.account = account;
    }
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public String getCustomerAddress() { return customerAddress; }
    public void setCustomerAddress(String customerAddress) { this.customerAddress = customerAddress; }
    public String getCustomerPhone() { return customerPhone; }
    public void setCustomerPhone(String customerPhone) { this.customerPhone = customerPhone; }
    public String getCustomerMail() { return customerMail; }
    public void setCustomerMail(String customerMail) { this.customerMail = customerMail; }
    public Account getAccount() { return account; }
    public void setAccount(Account account) { this.account = account; }
}

