package crm.common.model;

import crm.common.model.enums.TransactionStatus;
import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.persistence.entity.load.LazyReference;

import java.sql.Timestamp;

@Entity(tableName = "ProductTransaction")
public class ProductTransaction {
    @Key
    @Column(name = "TransactionID", type = "INT")
    private Integer transactionID;

    @Column(name = "TransactionDate", type = "DATETIME", nullable = false)
    private Timestamp transactionDate;

    @Column(name = "SourceWarehouse", type = "INT")
    private Integer sourceWarehouseID;

    @Column(name = "DestinationWarehouse", type = "INT")
    private Integer destinationWarehouseID;

    @Column(name = "TransactionStatus", length = 20, nullable = false)
    private TransactionStatus transactionStatus;

    @Column(name = "ItemID", type = "INT", nullable = false)
    private Integer itemID;

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

    public Timestamp getTransactionDate() {
        return transactionDate;
    }

    public void setTransactionDate(Timestamp transactionDate) {
        this.transactionDate = transactionDate;
    }

    public Integer getDestinationWarehouseID() {
        return destinationWarehouseID;
    }

    public void setDestinationWarehouseID(Integer destinationWarehouseID) {
        this.destinationWarehouseID = destinationWarehouseID;
    }

    public TransactionStatus getTransactionStatus() {
        return transactionStatus;
    }

    public void setTransactionStatus(TransactionStatus transactionStatus) {
        this.transactionStatus = transactionStatus;
    }

    public Integer getItemID() {
        return itemID;
    }

    public void setItemID(Integer itemID) {
        this.itemID = itemID;
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
        this.inventoryItem.setValue(inventoryItem);
    }

    public Warehouse getSourceWarehouseEntity() {
        return sourceWarehouse.get();
    }

    public void setSourceWarehouseEntity(Warehouse sourceWarehouse) {
        this.sourceWarehouse.setValue(sourceWarehouse);
    }

    public Integer getSourceWarehouseID() {
        return sourceWarehouseID;
    }

    public void setSourceWarehouseID(Integer sourceWarehouseID) {
        this.sourceWarehouseID = sourceWarehouseID;
    }

    public Warehouse getDestinationWarehouseEntity() {
        return destinationWarehouse.get();
    }

    public void setDestinationWarehouseEntity(Warehouse destinationWarehouse) {
        this.destinationWarehouse.setValue(destinationWarehouse);
    }
}
