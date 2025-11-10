package crm.common.model;

import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.hibernate.entitymanager.LazyReference;

import java.time.LocalDateTime;

@Entity(tableName = "ProductImportedLog")
public class ProductImportedLog {
    @Key
    @Column(name = "ProductImportedLogID")
    private int productImportedLogID;

    @Column(name = "ImportedDate")
    private LocalDateTime importedDate;

    @ManyToOne(joinColumn = "WarehouseID")
    private LazyReference<Warehouse> warehouse;

    @ManyToOne(joinColumn = "ItemID")
    private LazyReference<InventoryItem> inventoryItem;

    public int getProductImportedLogID() {
        return productImportedLogID;
    }

    public void setProductImportedLogID(int productImportedLogID) {
        this.productImportedLogID = productImportedLogID;
    }

    public LocalDateTime getImportedDate() {
        return importedDate;
    }

    public void setImportedDate(LocalDateTime importedDate) {
        this.importedDate = importedDate;
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
}
