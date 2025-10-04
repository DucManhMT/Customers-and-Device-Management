package crm.common.model;

import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.persistence.entity.load.LazyReference;

import java.sql.Date;

@Entity(tableName = "WarehouseLog")
public class WarehouseLog {
    @Key
    @Column(name = "WarehouseLogID", type = "INT")
    private Integer warehouseLogID;

    @Column(name = "LogDate", type = "DATE", nullable = false)
    private Date logDate;

    @Column(name = "Description", length = 255)
    private String description;

    @Column(name = "WarehouseID", type = "INT", nullable = false)
    private Integer warehouseID;

    @Column(name = "ProductRequestID", type = "INT", nullable = false)
    private Integer productRequestID;

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

    public Date getLogDate() {
        return logDate;
    }

    public void setLogDate(Date logDate) {
        this.logDate = logDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getWarehouseID() {
        return warehouseID;
    }

    public void setWarehouseID(Integer warehouseID) {
        this.warehouseID = warehouseID;
    }

    public Integer getProductRequestID() {
        return productRequestID;
    }

    public void setProductRequestID(Integer productRequestID) {
        this.productRequestID = productRequestID;
    }

    public Warehouse getWarehouse() {
        return warehouse.get();
    }

    public void setWarehouse(Warehouse warehouse) {
        this.warehouse.setValue(warehouse);
    }

    public ProductRequest getProductRequest() {
        return productRequest.get();
    }

    public void setProductRequest(ProductRequest productRequest) {
        this.productRequest.setValue(productRequest);
    }
}
