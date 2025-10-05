package crm.common.model;

import crm.common.model.enums.ProductRequestStatus;
<<<<<<< HEAD
import crm.core.repository.hibernate.annotation.*;
import crm.core.repository.hibernate.entitymanager.LazyReference;
=======
import crm.common.model.enums.converter.ProductRequestStatusConverter;
import crm.core.repository.persistence.annotation.*;
import crm.core.repository.persistence.entity.convert.Convert;
import crm.core.repository.persistence.entity.load.LazyReference;
import crm.core.repository.persistence.entity.relation.FetchMode;
>>>>>>> main

import java.sql.Date;

@Entity(tableName = "ProductRequest")
public class ProductRequest {
    @Key
    @Column(name = "ProductRequestID", type = "INT")
    private Integer productRequestID;

    @Column(name = "Quantity", type = "INT", nullable = false)
    private Integer quantity;

    @Column(name = "RequestDate", type = "DATE", nullable = false)
    private Date requestDate;

    @Enumerated
    @Column(name = "Status", length = 20)
    @Convert(converter = ProductRequestStatusConverter.class)
    private ProductRequestStatus status;

    @Column(name = "Description", length = 255)
    private String description;

<<<<<<< HEAD
    @ManyToOne(joinColumn = "RequestID")
=======
    @Column(name = "RequestID", type = "BIGINT", nullable = false)
    private Long requestID;

    @Column(name = "ProductID", type = "BIGINT", nullable = false)
    private Long productID;

    @Column(name = "WarehouseID", type = "BIGINT", nullable = false)
    private Long warehouseID;

    @ManyToOne(joinColumn = "RequestID", fetch = FetchMode.EAGER)
>>>>>>> main
    private LazyReference<Request> request;

    @ManyToOne(joinColumn = "ProductID", fetch = FetchMode.EAGER)
    private LazyReference<Product> product;

    @ManyToOne(joinColumn = "WarehouseID", fetch = FetchMode.EAGER)
    private LazyReference<Warehouse> warehouse;

    public Integer getProductRequestID() {
        return productRequestID;
    }

    public void setProductRequestID(Integer productRequestID) {
        this.productRequestID = productRequestID;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public Date getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(Date requestDate) {
        this.requestDate = requestDate;
    }

    public ProductRequestStatus getStatus() {
        return status;
    }

    public void setStatus(ProductRequestStatus status) {
        this.status = status;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Request getRequest() {
        return request.get();
    }

    public void setRequest(Request request) {

        this.request = new LazyReference<>(Request.class, request.getRequestID());
    }

    public Product getProduct() {
        return product.get();
    }

    public void setProduct(Product product) {

        this.product = new LazyReference<>(Product.class, product.getProductID());
    }

    public Warehouse getWarehouse() {
        return warehouse.get();
    }

    public void setWarehouse(Warehouse warehouse) {

        this.warehouse = new LazyReference<>(Warehouse.class, warehouse.getWarehouseID());
    }
}
