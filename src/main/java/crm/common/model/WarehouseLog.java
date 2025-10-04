package crm.common.model;

import crm.core.repository.persistence.annotation.*;
import crm.core.repository.persistence.entity.load.LazyReference;
import crm.core.repository.persistence.entity.relation.FetchMode;

import java.sql.Date;

@Entity(tableName = "WarehouseLog")
public class WarehouseLog {
    @Key
    @Column(name = "WarehouseLogID", type = "BIGINT")
    private Long warehouseLogID;

    @Column(name = "LogDate", type = "DATE", nullable = false)
    private Date logDate;

    @Column(name = "Description", length = 255)
    private String description;

    @Column(name = "WarehouseID", type = "BIGINT", nullable = false)
    private Long warehouseID;

    @Column(name = "ProductRequestID", type = "BIGINT", nullable = false)
    private Long productRequestID;

    @ManyToOne(joinColumn = "WarehouseID", fetch = FetchMode.EAGER)
    private LazyReference<Warehouse> warehouse;

    @ManyToOne(joinColumn = "ProductRequestID", fetch = FetchMode.EAGER)
    private LazyReference<ProductRequest> productRequest;

    public Long getWarehouseLogID() {
        return warehouseLogID;
    }

    public void setWarehouseLogID(Long warehouseLogID) {
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

    public Long getWarehouseID() {
        return warehouseID;
    }

    public void setWarehouseID(Long warehouseID) {
        this.warehouseID = warehouseID;
    }

    public Long getProductRequestID() {
        return productRequestID;
    }

    public void setProductRequestID(Long productRequestID) {
        this.productRequestID = productRequestID;
    }

    public Warehouse getWarehouse() {
        if (warehouse == null) {
            return null;
        }
        return warehouse.get();
    }

    public void setWarehouse(Warehouse warehouse) {
        if (this.warehouse == null) {
            this.warehouse = new LazyReference<>(warehouse);
        } else {
            this.warehouse.setValue(warehouse);
        }
        // synchronize WarehouseID
        if (this.warehouseID == null && warehouse != null) {
            this.warehouseID = warehouse.getWarehouseID();
        }
    }

    public ProductRequest getProductRequest() {
        if (productRequest == null) {
            return null;
        }
        return productRequest.get();
    }

    public void setProductRequest(ProductRequest productRequest) {
        if (this.productRequest == null) {
            this.productRequest = new LazyReference<>(productRequest);
        } else {
            this.productRequest.setValue(productRequest);
        }
        // synchronize ProductRequestID
        if (this.productRequestID == null && productRequest != null) {
            this.productRequestID = productRequest.getProductRequestID();
        }
    }
}
