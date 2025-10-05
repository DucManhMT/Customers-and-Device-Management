package crm.common.model;

import crm.common.model.enums.ProductStatus;
<<<<<<< HEAD

import crm.core.repository.hibernate.annotation.*;
import crm.core.repository.hibernate.entitymanager.LazyReference;
=======
import crm.common.model.enums.converter.ProductStatusConverter;
import crm.core.repository.persistence.annotation.*;
import crm.core.repository.persistence.entity.convert.Convert;
import crm.core.repository.persistence.entity.load.LazyReference;
import crm.core.repository.persistence.entity.relation.FetchMode;
>>>>>>> main

@Entity(tableName = "ProductWarehouse")
public class ProductWarehouse {
    @Key
    @Column(name = "ProductWarehouseID", type = "INT")
    private Integer productWarehouseID;

    @Enumerated
    @Column(name = "ProductStatus", length = 20)
    private ProductStatus productStatus;

<<<<<<< HEAD
    @ManyToOne(joinColumn = "WarehouseID")
=======
    @Column(name = "WarehouseID", type = "BIGINT", nullable = false)
    private Long warehouseID;

    @Column(name = "ItemID", type = "BIGINT", nullable = false)
    private Long itemID;

    @ManyToOne(joinColumn = "WarehouseID", fetch = FetchMode.EAGER)
>>>>>>> main
    private LazyReference<Warehouse> warehouse;

    @ManyToOne(joinColumn = "ItemID", fetch = FetchMode.EAGER)
    private LazyReference<InventoryItem> inventoryItem;

    // Inverse side of one-to-one to ProductExported (optional / may be null until
    // exported)
    @OneToOne(mappedBy = "productWarehouse", joinColumn = "ProductWarehouseID", fetch = FetchMode.LAZY)
    private LazyReference<ProductExported> productExported;

    public Integer getProductWarehouseID() {
        return productWarehouseID;
    }

    public void setProductWarehouseID(Integer productWarehouseID) {
        this.productWarehouseID = productWarehouseID;
    }

    public ProductStatus getProductStatus() {
        return productStatus;
    }

    public void setProductStatus(ProductStatus productStatus) {
        this.productStatus = productStatus;
    }


    public Warehouse getWarehouse() {
        return warehouse.get();
    }

    public void setWarehouse(Warehouse warehouse) {

        this.warehouse = new LazyReference<>(Warehouse.class, warehouse.getWarehouseID());
    }

    public InventoryItem getInventoryItem() {
        return inventoryItem.get();
    }

    public void setInventoryItem(InventoryItem inventoryItem) {

        this.inventoryItem = new LazyReference<>(InventoryItem.class, inventoryItem.getItemId());
    }

    public ProductExported getProductExported() {
        return productExported.get();
    }

    public void setProductExported(ProductExported productExported) {

        this.productExported = new LazyReference<>(ProductExported.class, productExported);
    }
}
