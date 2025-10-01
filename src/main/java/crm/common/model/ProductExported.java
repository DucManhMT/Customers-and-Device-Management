package crm.common.model;

import crm.core.repository.persistence.annotation.*;
import crm.core.repository.persistence.entity.load.LazyReference;
import crm.core.repository.persistence.entity.relation.FetchMode;

@Entity(tableName = "ProductExported")
public class ProductExported {
    @Key
    @Column(name = "ProductWarehouseID", type = "INT", nullable = false)
    private Integer productWarehouseID;

    @Column(name = "WarehouseLogID", type = "INT", nullable = false)
    private Integer warehouseLogID;

    @OneToOne(joinColumn = "ProductWarehouseID", fetch = FetchMode.EAGER, mappedBy = "productWarehouseID")
    private LazyReference<ProductWarehouse> productWarehouse;

    @ManyToOne(joinColumn = "WarehouseLogID", fetch = FetchMode.EAGER)
    private LazyReference<WarehouseLog> warehouseLog;

    public Integer getProductWarehouseID() {
        return productWarehouseID;
    }

    public void setProductWarehouseID(Integer productWarehouseID) {
        this.productWarehouseID = productWarehouseID;
    }

    public Integer getWarehouseLogID() {
        return warehouseLogID;
    }

    public void setWarehouseLogID(Integer warehouseLogID) {
        this.warehouseLogID = warehouseLogID;
    }

    public ProductWarehouse getProductWarehouse() {
        return productWarehouse.get();
    }

    public void setProductWarehouse(ProductWarehouse productWarehouse) {
        this.productWarehouse.setValue(productWarehouse);
    }

    public WarehouseLog getWarehouseLog() {
        return warehouseLog.get();
    }

    public void setWarehouseLog(WarehouseLog warehouseLog) {
        this.warehouseLog.setValue(warehouseLog);
    }
}
