package crm.common.model;

import crm.core.repository.hibernate.annotation.*;
import crm.core.repository.persistence.entity.load.LazyReference;

@Entity(tableName = "ProductExported")
public class ProductExported {
    @Key
    @Column(name = "ProductWarehouseID", type = "BIGINT", nullable = false)
    private Long productWarehouseID;

    @Column(name = "WarehouseLogID", type = "BIGINT", nullable = false)
    private Long warehouseLogID;

    @OneToOne(joinColumn = "ProductWarehouseID", mappedBy = "productWarehouseID")
    private LazyReference<ProductWarehouse> productWarehouse;

    @ManyToOne(joinColumn = "WarehouseLogID")
    private LazyReference<WarehouseLog> warehouseLog;

    public Long getProductWarehouseID() {
        return productWarehouseID;
    }

    public void setProductWarehouseID(Long productWarehouseID) {
        this.productWarehouseID = productWarehouseID;
    }

    public Long getWarehouseLogID() {
        return warehouseLogID;
    }

    public void setWarehouseLogID(Long warehouseLogID) {
        this.warehouseLogID = warehouseLogID;
    }

    public ProductWarehouse getProductWarehouse() {
        if (productWarehouse == null) {
            return null;
        }
        return productWarehouse.get();
    }

    public void setProductWarehouse(ProductWarehouse productWarehouse) {
        if (this.productWarehouse == null) {
            this.productWarehouse = new LazyReference<>(productWarehouse);
        } else {
            this.productWarehouse.setValue(productWarehouse);
        }
        // synchronize ProductWarehouseID
        if (this.productWarehouseID == null && productWarehouse != null) {
            this.productWarehouseID = productWarehouse.getProductWarehouseID();
        }
    }

    public WarehouseLog getWarehouseLog() {
        if (warehouseLog == null) {
            return null;
        }
        return warehouseLog.get();
    }

    public void setWarehouseLog(WarehouseLog warehouseLog) {
        if (this.warehouseLog == null) {
            this.warehouseLog = new LazyReference<>(warehouseLog);
        } else {
            this.warehouseLog.setValue(warehouseLog);
        }
        // synchronize WarehouseLogID
        if (this.warehouseLogID == null && warehouseLog != null) {
            this.warehouseLogID = warehouseLog.getWarehouseLogID();
        }
    }
}
