package crm.common.model;

import crm.common.model.enums.TransactionStatus;
import crm.core.repository.hibernate.annotation.*;
import crm.core.repository.hibernate.entitymanager.LazyReference;

import java.time.LocalDateTime;

@Entity(tableName = "ProductTransaction")
public class ProductTransaction {
    @Key
    @Column(name = "TransactionID", type = "INT")
    private Integer transactionID;

    @Column(name = "TransactionDate", type = "DATETIME", nullable = false)
    private LocalDateTime transactionDate;

    @Enumerated
    @Column(name = "TransactionStatus", length = 20, nullable = false)
    private TransactionStatus transactionStatus;

    @Column(name = "Note", length = 255)
    private String note;

    @ManyToOne(joinColumn = "ItemID")
    private LazyReference<InventoryItem> inventoryItem;

    @ManyToOne(joinColumn = "SourceWarehouse")
    private LazyReference<Warehouse> sourceWarehouse;

    @ManyToOne(joinColumn = "DestinationWarehouse")
    private LazyReference<Warehouse> destinationWarehouse;

    public Integer getTransactionID() {
        return transactionID;
    }

    public void setTransactionID(Integer transactionID) {
        this.transactionID = transactionID;
    }

    public LocalDateTime getTransactionDate() {
        return transactionDate;
    }

    public void setTransactionDate(LocalDateTime transactionDate) {
        this.transactionDate = transactionDate;
    }

    public TransactionStatus getTransactionStatus() {
        return transactionStatus;
    }

    public void setTransactionStatus(TransactionStatus transactionStatus) {
        this.transactionStatus = transactionStatus;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public InventoryItem getInventoryItem() {
        return inventoryItem.get();
    }

    public void setInventoryItem(InventoryItem inventoryItem) {

        this.inventoryItem = new LazyReference<>(InventoryItem.class, inventoryItem.getItemId());
    }

    public Warehouse getSourceWarehouseEntity() {
        return sourceWarehouse.get();
    }

    public void setSourceWarehouseEntity(Warehouse sourceWarehouse) {
        this.sourceWarehouse = new LazyReference<>(Warehouse.class, sourceWarehouse.getWarehouseID());
    }

    public Warehouse getDestinationWarehouseEntity() {
        return destinationWarehouse.get();
    }

    public void setDestinationWarehouseEntity(Warehouse destinationWarehouse) {
        this.destinationWarehouse = new LazyReference<>(Warehouse.class, destinationWarehouse.getWarehouseID());
    }
}
