package crm.common.model;

import crm.common.model.enums.WarehouseRequestStatus;
import crm.core.repository.hibernate.annotation.*;
import crm.core.repository.hibernate.entitymanager.LazyReference;

import java.time.LocalDateTime;

@Entity(tableName = "WarehouseRequest")
public class WarehouseRequest {

    @Key
    @Column(name = "WarehouseRequestID", type = "INT")
    private Integer warehouseRequestID;

    @Column(name = "Date", type = "DATETIME")
    private LocalDateTime date;

    @Enumerated
    @Column(name = "WarehouseRequestStatus", length = 20, nullable = false)
    private WarehouseRequestStatus warehouseRequestStatus;

    @Column(name = "Note", length = 255)
    private String note;

    @ManyToOne(joinColumn = "SourceWarehouse")
    private LazyReference<Warehouse> sourceWarehouse;

    @ManyToOne(joinColumn = "DestinationWarehouse")
    private LazyReference<Warehouse> destinationWarehouse;

    public Integer getWarehouseRequestID() {
        return warehouseRequestID;
    }

    public void setWarehouseRequestID(Integer warehouseRequestID) {
        this.warehouseRequestID = warehouseRequestID;
    }

    public LocalDateTime getDate() {
        return date;
    }

    public void setDate(LocalDateTime date) {
        this.date = date;
    }

    public WarehouseRequestStatus getWarehouseRequestStatus() {
        return warehouseRequestStatus;
    }

    public void setWarehouseRequestStatus(WarehouseRequestStatus warehouseRequestStatus) {
        this.warehouseRequestStatus = warehouseRequestStatus;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Warehouse getSourceWarehouse() {
        return sourceWarehouse.get();
    }

    public void setSourceWarehouse(Warehouse sourceWarehouse) {
        this.sourceWarehouse = new LazyReference<>(Warehouse.class, sourceWarehouse.getWarehouseID());
    }

    public Warehouse getDestinationWarehouse() {
        return destinationWarehouse.get();
    }

    public void setDestinationWarehouse(Warehouse destinationWarehouse) {
        this.destinationWarehouse = new LazyReference<>(Warehouse.class, destinationWarehouse.getWarehouseID());
    }
}
