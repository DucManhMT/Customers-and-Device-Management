package crm.common.model;

import crm.common.model.enums.TransactionStatus;
<<<<<<< HEAD
import crm.core.repository.hibernate.annotation.*;
import crm.core.repository.hibernate.entitymanager.LazyReference;
=======
import crm.core.repository.persistence.annotation.*;
import crm.core.repository.persistence.entity.load.LazyReference;
import crm.core.repository.persistence.entity.relation.FetchMode;
>>>>>>> main

import java.sql.Timestamp;

@Entity(tableName = "ProductTransaction")
public class ProductTransaction {
    @Key
    @Column(name = "TransactionID", type = "INT")
    private Integer transactionID;

    @Column(name = "TransactionDate", type = "DATETIME", nullable = false)
    private Timestamp transactionDate;

    @Enumerated
    @Column(name = "TransactionStatus", length = 20, nullable = false)
    private TransactionStatus transactionStatus;

    @Column(name = "Note", length = 255)
    private String note;

    @ManyToOne(joinColumn = "ItemID", fetch = FetchMode.EAGER)
    private LazyReference<InventoryItem> inventoryItem;

    @ManyToOne(joinColumn = "SourceWarehouse", fetch = FetchMode.EAGER)
    private LazyReference<Warehouse> sourceWarehouse;

    @ManyToOne(joinColumn = "DestinationWarehouse", fetch = FetchMode.EAGER)
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
