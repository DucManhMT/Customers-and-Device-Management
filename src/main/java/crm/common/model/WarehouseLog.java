package crm.common.model;

import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.hibernate.entitymanager.LazyReference;

import java.time.LocalDate;

@Entity(tableName = "WarehouseLog")
public class WarehouseLog {
    @Key
    @Column(name = "WarehouseLogID", type = "INT")
    private Integer warehouseLogID;

    @Column(name = "LogDate", type = "DATE", nullable = false)
    private LocalDate logDate;

    @Column(name = "Description", length = 255)
    private String description;

    @ManyToOne(joinColumn = "WarehouseID")
    private LazyReference<Warehouse> warehouse;

    @ManyToOne(joinColumn = "ProductRequestID")
    private LazyReference<ProductRequest> productRequest;

    public Integer getWarehouseLogID() {
        return warehouseLogID;
    }

    public void setWarehouseLogID(Integer warehouseLogID) {
        this.warehouseLogID = warehouseLogID;
    }

    public LocalDate getLogDate() {
        return logDate;
    }

    public void setLogDate(LocalDate logDate) {
        this.logDate = logDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }


    public Warehouse getWarehouse() {
        return warehouse.get();
    }

    public void setWarehouse(Warehouse warehouse) {

        this.warehouse = new LazyReference<>(Warehouse.class,warehouse.getWarehouseID());
    }

    public ProductRequest getProductRequest() {
        return productRequest.get();
    }

    public void setProductRequest(ProductRequest productRequest) {

        this.productRequest = new LazyReference<>(ProductRequest.class,productRequest.getProductRequestID());
    }
}
