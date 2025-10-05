package crm.common.model;

<<<<<<< HEAD
import crm.core.repository.hibernate.annotation.*;
import crm.core.repository.hibernate.entitymanager.LazyReference;
=======
import crm.core.repository.persistence.annotation.*;
import crm.core.repository.persistence.entity.load.LazyReference;
import crm.core.repository.persistence.entity.relation.FetchMode;
>>>>>>> main

@Entity(tableName = "ProductExported")
public class ProductExported {
    @Key
<<<<<<< HEAD
    @OneToOne(joinColumn = "ProductWarehouseID", mappedBy = "productWarehouseID")
=======
    @Column(name = "ProductWarehouseID", type = "BIGINT", nullable = false)
    private Long productWarehouseID;

    @Column(name = "WarehouseLogID", type = "BIGINT", nullable = false)
    private Long warehouseLogID;

    @OneToOne(joinColumn = "ProductWarehouseID", fetch = FetchMode.EAGER, mappedBy = "productWarehouseID")
>>>>>>> main
    private LazyReference<ProductWarehouse> productWarehouse;

    @ManyToOne(joinColumn = "WarehouseLogID", fetch = FetchMode.EAGER)
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
