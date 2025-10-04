package crm.common.model;

import crm.common.model.enums.TransactionStatus;
import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.persistence.entity.load.LazyReference;

import java.time.LocalDateTime;

@Entity(tableName = "ProductTransaction")
public class ProductTransaction {
    @Key
    @Column(name = "TransactionID", type = "BIGINT")
    private Long transactionID;

    @Column(name = "TransactionDate", type = "DATETIME", nullable = false)
    private LocalDateTime transactionDate;

    @Column(name = "SourceWarehouse", type = "BIGINT")
    private Long sourceWarehouseID;

    @Column(name = "DestinationWarehouse", type = "BIGINT")
    private Long destinationWarehouseID;

    @Column(name = "TransactionStatus", length = 20, nullable = false)
    private TransactionStatus transactionStatus;

    @Column(name = "ItemID", type = "BIGINT", nullable = false)
    private Long itemID;

    @Column(name = "Note", length = 255)
    private String note;

    @ManyToOne(joinColumn = "ItemID")
    private LazyReference<InventoryItem> inventoryItem;

    @ManyToOne(joinColumn = "SourceWarehouse")
    private LazyReference<Warehouse> sourceWarehouse;

    @ManyToOne(joinColumn = "DestinationWarehouse")
    private LazyReference<Warehouse> destinationWarehouse;

    public Long getTransactionID() {
        return transactionID;
    }

    public void setTransactionID(Long transactionID) {
        this.transactionID = transactionID;
    }

    public LocalDateTime getTransactionDate() {
        return transactionDate;
    }

    public void setTransactionDate(LocalDateTime transactionDate) {
        this.transactionDate = transactionDate;
    }

    public Long getDestinationWarehouseID() {
        return destinationWarehouseID;
    }

    public void setDestinationWarehouseID(Long destinationWarehouseID) {
        this.destinationWarehouseID = destinationWarehouseID;
    }

    public TransactionStatus getTransactionStatus() {
        return transactionStatus;
    }

    public void setTransactionStatus(TransactionStatus transactionStatus) {
        this.transactionStatus = transactionStatus;
    }

    public Long getItemID() {
        return itemID;
    }

    public void setItemID(Long itemID) {
        this.itemID = itemID;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
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

    public Warehouse getSourceWarehouseEntity() {
        if (sourceWarehouse == null) {
            return null;
        }
        return sourceWarehouse.get();
    }

    public void setSourceWarehouseEntity(Warehouse sourceWarehouse) {
        if (this.sourceWarehouse == null) {
            this.sourceWarehouse = new LazyReference<>(sourceWarehouse);
        } else {
            this.sourceWarehouse.setValue(sourceWarehouse);
        }
        // synchronize SourceWarehouseID
        if (this.sourceWarehouseID == null && sourceWarehouse != null) {
            this.sourceWarehouseID = sourceWarehouse.getWarehouseID();
        }
    }

    public Long getSourceWarehouseID() {
        return sourceWarehouseID;
    }

    public void setSourceWarehouseID(Long sourceWarehouseID) {
        this.sourceWarehouseID = sourceWarehouseID;
    }

    public Warehouse getDestinationWarehouseEntity() {
        if (destinationWarehouse == null) {
            return null;
        }
        return destinationWarehouse.get();
    }

    public void setDestinationWarehouseEntity(Warehouse destinationWarehouse) {
        if (this.destinationWarehouse == null) {
            this.destinationWarehouse = new LazyReference<>(destinationWarehouse);
        } else {
            this.destinationWarehouse.setValue(destinationWarehouse);
        }
        // synchronize DestinationWarehouseID
        if (this.destinationWarehouseID == null && destinationWarehouse != null) {
            this.destinationWarehouseID = destinationWarehouse.getWarehouseID();
        }
    }
}
