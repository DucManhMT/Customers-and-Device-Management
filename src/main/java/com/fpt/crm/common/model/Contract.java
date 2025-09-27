package com.fpt.crm.common.model;
import java.sql.Date;

public class Contract {
    private int contractId;
    private byte[] contractImage;
    private Date startDate;
    private Date expiredDate;
    private Request request;
    private Customer customer;

    public Contract() {}
    public Contract(int contractId, byte[] contractImage, Date startDate, Date expiredDate, Request request, Customer customer) {
        this.contractId = contractId;
        this.contractImage = contractImage;
        this.startDate = startDate;
        this.expiredDate = expiredDate;
        this.request = request;
        this.customer = customer;
    }
    public int getContractId() { return contractId; }
    public void setContractId(int contractId) { this.contractId = contractId; }
    public byte[] getContractImage() { return contractImage; }
    public void setContractImage(byte[] contractImage) { this.contractImage = contractImage; }
    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }
    public Date getExpiredDate() { return expiredDate; }
    public void setExpiredDate(Date expiredDate) { this.expiredDate = expiredDate; }
    public Request getRequest() { return request; }
    public void setRequest(Request request) { this.request = request; }
    public Customer getCustomer() { return customer; }
    public void setCustomer(Customer customer) { this.customer = customer; }
}
