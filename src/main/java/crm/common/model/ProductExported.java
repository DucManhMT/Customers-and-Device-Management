package crm.common.model;

import crm.core.repository.hibernate.annotation.*;
import crm.core.repository.hibernate.entitymanager.LazyReference;

@Entity(tableName = "ProductExported")
public class ProductExported {
    @Key
    @OneToOne(joinColumn = "ProductWarehouseID", mappedBy = "productWarehouseID")
    private LazyReference<ProductWarehouse> productWarehouse;

    @ManyToOne(joinColumn = "WarehouseLogID")
    private LazyReference<WarehouseLog> warehouseLog;


    public ProductWarehouse getProductWarehouse() {
        return productWarehouse.get();
    }

    public void setProductWarehouse(ProductWarehouse productWarehouse) {
        this.productWarehouse = new LazyReference<>(ProductWarehouse.class, productWarehouse.getProductWarehouseID());
    }

    public WarehouseLog getWarehouseLog() {
        return warehouseLog.get();
    }

    public void setWarehouseLog(WarehouseLog warehouseLog) {

        this.warehouseLog = new LazyReference<>(WarehouseLog.class, warehouseLog.getWarehouseLogID());
    }
}
