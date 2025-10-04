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
    @Column(name = "ProductWarehouseID", type = "BIGINT")
    private Long productWarehouseID;

    @Column(name = "ProductStatus", length = 20)
    @Convert(converter = ProductStatusConverter.class)
    private ProductStatus productStatus;

    @Column(name = "WarehouseID", type = "BIGINT", nullable = false)
    private Long warehouseID;

    @Column(name = "ItemID", type = "BIGINT", nullable = false)
    private Long itemID;

    @ManyToOne(joinColumn = "WarehouseID", fetch = FetchMode.EAGER)
    private LazyReference<Warehouse> warehouse;

    @ManyToOne(joinColumn = "ItemID", fetch = FetchMode.EAGER)
    private LazyReference<InventoryItem> inventoryItem;

    @OneToOne(mappedBy = "productWarehouse", joinColumn = "ProductWarehouseID", fetch = FetchMode.LAZY)
    private LazyReference<ProductExported> productExported;

    public Long getProductWarehouseID() {
        return productWarehouseID;
    }

    public void setProductWarehouseID(Long productWarehouseID) {
        this.productWarehouseID = productWarehouseID;
    }

    public ProductStatus getProductStatus() {
        return productStatus;
    }

    public void setProductStatus(ProductStatus productStatus) {
        this.productStatus = productStatus;
    }

    public Long getWarehouseID() {
        return warehouseID;
    }

    public void setWarehouseID(Long warehouseID) {
        this.warehouseID = warehouseID;
    }

    public Long getItemID() {
        return itemID;
    }

    public void setItemID(Long itemID) {
        this.itemID = itemID;
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

    public InventoryItem getInventoryItem() {
        if (inventoryItem == null) {
            return null;
        }
        return inventoryItem.get();
    }

    public void setInventoryItem(InventoryItem inventoryItem) {
        if (this.inventoryItem == null) {
            this.inventoryItem = new LazyReference<>(inventoryItem);
        } else {
            this.inventoryItem.setValue(inventoryItem);
        }
        // synchronize ItemID
        if (this.itemID == null && inventoryItem != null) {
            this.itemID = inventoryItem.getItemId();
        }
    }

    public ProductExported getProductExported() {
        if (productExported == null) {
            return null;
        }
        return productExported.get();
    }

    public void setProductExported(ProductExported productExported) {
        if (this.productExported == null) {
            this.productExported = new LazyReference<>(productExported);
        } else {
            this.productExported.setValue(productExported);
        }

    }
}
