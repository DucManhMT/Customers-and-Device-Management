package crm.common.model;

import crm.core.repository.persistence.annotation.*;
import crm.core.repository.persistence.entity.load.LazyReference;
import crm.core.repository.persistence.entity.relation.FetchMode;

import java.sql.Date;
import java.util.List;

@Entity(tableName = "Contract")
public class Contract {
    @Key
    @Column(name = "ContractID", type = "INT")
    private Integer contractID;

    @Column(name = "ContractImage", length = 255, nullable = false)
    private String contractImage;

    @Column(name = "StartDate", type = "DATE", nullable = false)
    private Date startDate;

    @Column(name = "ExpiredDate", type = "DATE", nullable = false)
    private Date expiredDate;

    @Column(name = "CustomerID", type = "INT", nullable = false)
    private Integer customerID;

    @ManyToOne(joinColumn = "CustomerID", fetch = FetchMode.EAGER)
    private LazyReference<Customer> customer;

    @OneToMany(mappedBy = "contractID", joinColumn = "ContractID", fetch = FetchMode.LAZY)
    private List<Request> requests;

    public Integer getContractID() {
        return contractID;
    }

    public void setContractID(Integer contractID) {
        this.contractID = contractID;
    }

    public String getContractImage() {
        return contractImage;
    }

    public void setContractImage(String contractImage) {
        this.contractImage = contractImage;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getExpiredDate() {
        return expiredDate;
    }

    public void setExpiredDate(Date expiredDate) {
        this.expiredDate = expiredDate;
    }

    public Integer getCustomerID() {
        return customerID;
    }

    public void setCustomerID(Integer customerID) {
        this.customerID = customerID;
    }

    public Customer getCustomer() {
        return customer.get();
    }

    public void setCustomer(Customer customer) {
        this.customer.setValue(customer);
    }

    public List<Request> getRequests() {
        return requests;
    }

    public void setRequests(List<Request> requests) {
        this.requests = requests;
    }
}
