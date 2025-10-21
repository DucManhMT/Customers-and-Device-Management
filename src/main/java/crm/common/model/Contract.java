package crm.common.model;

import crm.core.repository.hibernate.annotation.*;
import crm.core.repository.hibernate.entitymanager.LazyReference;

import java.time.LocalDate;
import java.util.List;

@Entity(tableName = "Contract")
public class Contract {
    @Key
    @Column(name = "ContractID", type = "INT")
    private Integer contractID;

    @Column(name="ContractCode", length=255, nullable=false, unique=true)
    private String contractCode;



    @Column(name = "ContractImage", length = 255, nullable = false)
    private String contractImage;

    @Column(name = "StartDate", type = "DATE", nullable = false)
    private LocalDate startDate;

    @Column(name = "ExpiredDate", type = "DATE", nullable = false)
    private LocalDate expiredDate;

    @ManyToOne(joinColumn = "CustomerID")
    private LazyReference<Customer> customer;

    @OneToMany(mappedBy = "contractID", joinColumn = "ContractID", targetEntity = Request.class)
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


    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public void setCustomer(LazyReference<Customer> customer) {
        this.customer = customer;
    }

    public LocalDate getExpiredDate() {
        return expiredDate;
    }

    public void setExpiredDate(LocalDate expiredDate) {
        this.expiredDate = expiredDate;
    }

    public Customer getCustomer() {
        return this.customer.get();
    }
    public String getContractCode() {
        return contractCode;
    }

    public void setContractCode(String contractCode) {
        this.contractCode = contractCode;
    }

    public void setCustomer(Customer customer) {
        this.customer = new LazyReference<>(Customer.class, customer.getCustomerID());
    }

    public List<Request> getRequests() {
        return requests;
    }

    public void setRequests(List<Request> requests) {
        this.requests = requests;
    }
}
