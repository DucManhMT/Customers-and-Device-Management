package crm.common.model;

import crm.common.model.enums.ProductRequestStatus;
import crm.core.repository.hibernate.annotation.*;
import crm.core.repository.hibernate.entitymanager.LazyReference;
import java.time.LocalDate;

@Entity(tableName = "ProductRequest")
public class ProductRequest {
    @Key
    @Column(name = "ProductRequestID", type = "INT")
    private Integer productRequestID;

    @Column(name = "Quantity", type = "INT", nullable = false)
    private Integer quantity;

    @Column(name = "RequestDate", type = "DATE", nullable = false)
    private LocalDate requestDate;

    @Enumerated
    @Column(name = "Status", length = 20)
    private ProductRequestStatus status;

    @Column(name = "Description", length = 255)
    private String description;

    @ManyToOne(joinColumn = "TaskID")
    private LazyReference<Task> task;

    @ManyToOne(joinColumn = "ProductID")
    private LazyReference<Product> product;

    @ManyToOne(joinColumn = "WarehouseID", nullable = true)
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

    public LocalDate getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(LocalDate requestDate) {
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

    public Task getTask() {
        return task.get();
    }

    public void setTask(Task task) {
        this.task = new LazyReference<>(Task.class, task.getTaskID());
    }

    public Product getProduct() {
        return product.get();
    }

    public void setProduct(Product product) {
        this.product = new LazyReference<>(Product.class, product.getProductID());
    }

    public Warehouse getWarehouse() {
        return (warehouse != null) ? warehouse.get() : null;
    }

    public void setWarehouse(Warehouse warehouse) {
        this.warehouse = new LazyReference<>(Warehouse.class, warehouse.getWarehouseID());
    }
}
