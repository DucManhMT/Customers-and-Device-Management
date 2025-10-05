package crm.common.model;

<<<<<<< HEAD
import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.hibernate.entitymanager.LazyReference;
=======
import crm.core.repository.persistence.annotation.*;
import crm.core.repository.persistence.entity.load.LazyReference;
import crm.core.repository.persistence.entity.relation.FetchMode;
>>>>>>> main

import java.sql.Date;

@Entity(tableName = "WarehouseLog")
public class WarehouseLog {
    @Key
    @Column(name = "WarehouseLogID", type = "INT")
    private Integer warehouseLogID;

    @Column(name = "LogDate", type = "DATE", nullable = false)
    private Date logDate;

    @Column(name = "Description", length = 255)
    private String description;

<<<<<<< HEAD
    @ManyToOne(joinColumn = "WarehouseID")
=======
    @Column(name = "WarehouseID", type = "BIGINT", nullable = false)
    private Long warehouseID;

    @Column(name = "ProductRequestID", type = "BIGINT", nullable = false)
    private Long productRequestID;

    @ManyToOne(joinColumn = "WarehouseID", fetch = FetchMode.EAGER)
>>>>>>> main
    private LazyReference<Warehouse> warehouse;

    @ManyToOne(joinColumn = "ProductRequestID", fetch = FetchMode.EAGER)
    private LazyReference<ProductRequest> productRequest;

    public Integer getWarehouseLogID() {
        return warehouseLogID;
    }

    public void setWarehouseLogID(Integer warehouseLogID) {
        this.warehouseLogID = warehouseLogID;
    }

    public Date getLogDate() {
        return logDate;
    }

    public void setLogDate(Date logDate) {
        this.logDate = logDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }


    public Warehouse getWarehouse() {
        return warehouse.get();
    }

    public void setWarehouse(Warehouse warehouse) {

        this.warehouse = new LazyReference<>(Warehouse.class,warehouse.getWarehouseID());
    }

    public ProductRequest getProductRequest() {
        return productRequest.get();
    }

    public void setProductRequest(ProductRequest productRequest) {

        this.productRequest = new LazyReference<>(ProductRequest.class,productRequest.getProductRequestID());
    }
}
