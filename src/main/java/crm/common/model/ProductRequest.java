package crm.common.model;

import crm.common.model.enums.ProductRequestStatus;
import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.persistence.entity.load.LazyReference;

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

    @Column(name = "Status", length = 20)
    private ProductRequestStatus status;

    @Column(name = "Description", length = 255)
    private String description;

    @Column(name = "RequestID", type = "INT", nullable = false)
    private Integer requestID;

    @Column(name = "ProductID", type = "INT", nullable = false)
    private Integer productID;

    @Column(name = "WarehouseID", type = "INT", nullable = false)
    private Integer warehouseID;

    @ManyToOne(joinColumn = "RequestID")
    private LazyReference<Request> request;

    @ManyToOne(joinColumn = "ProductID")
    private LazyReference<Product> product;

    @ManyToOne(joinColumn = "WarehouseID")
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

    public Integer getRequestID() {
        return requestID;
    }

    public void setRequestID(Integer requestID) {
        this.requestID = requestID;
    }

    public Integer getProductID() {
        return productID;
    }

    public void setProductID(Integer productID) {
        this.productID = productID;
    }

    public Integer getWarehouseID() {
        return warehouseID;
    }

    public void setWarehouseID(Integer warehouseID) {
        this.warehouseID = warehouseID;
    }

    public Request getRequest() {
        return request.get();
    }

    public void setRequest(Request request) {
        this.request.setValue(request);
    }

    public Product getProduct() {
        return product.get();
    }

    public void setProduct(Product product) {
        this.product.setValue(product);
    }

    public Warehouse getWarehouse() {
        return warehouse.get();
    }

    public void setWarehouse(Warehouse warehouse) {
        this.warehouse.setValue(warehouse);
    }
}
