package crm.common.model;

import crm.common.model.enums.ProductStatus;
import crm.common.model.enums.converter.ProductStatusConverter;
import crm.core.repository.persistence.annotation.*;
import crm.core.repository.persistence.entity.convert.Convert;
import crm.core.repository.persistence.entity.load.LazyReference;
import crm.core.repository.persistence.entity.relation.FetchMode;

@Entity(tableName = "ProductWarehouse")
public class ProductWarehouse {
    @Key
    @Column(name = "ProductWarehouseID", type = "INT")
    private Integer productWarehouseID;

    @Column(name = "ProductStatus", length = 20)
    @Convert(converter = ProductStatusConverter.class)
    private ProductStatus productStatus;

    @Column(name = "WarehouseID", type = "INT", nullable = false)
    private Integer warehouseID;

    @Column(name = "ItemID", type = "INT", nullable = false)
    private Integer itemID;

    @ManyToOne(joinColumn = "WarehouseID", fetch = FetchMode.EAGER)
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

    public Integer getWarehouseID() {
        return warehouseID;
    }

    public void setWarehouseID(Integer warehouseID) {
        this.warehouseID = warehouseID;
    }

    public Integer getItemID() {
        return itemID;
    }

    public void setItemID(Integer itemID) {
        this.itemID = itemID;
    }

    public Warehouse getWarehouse() {
        return warehouse.get();
    }

    public void setWarehouse(Warehouse warehouse) {
        this.warehouse.setValue(warehouse);
    }

    public InventoryItem getInventoryItem() {
        return inventoryItem.get();
    }

    public void setInventoryItem(InventoryItem inventoryItem) {
        this.inventoryItem.setValue(inventoryItem);
    }

    public ProductExported getProductExported() {
        return productExported.get();
    }

    public void setProductExported(ProductExported productExported) {
        this.productExported.setValue(productExported);
    }
}
