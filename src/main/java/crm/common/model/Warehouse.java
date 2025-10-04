package crm.common.model;

import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.persistence.entity.load.LazyReference;

@Entity(tableName = "Warehouse")
public class Warehouse {
    @Key
    @Column(name = "WarehouseID", type = "BIGINT")
    private Long warehouseID;

    @Column(name = "WarehouseName", length = 100, nullable = false)
    private String warehouseName;

    @Column(name = "Location", length = 255)
    private String location;

    @Column(name = "WarehouseManager", length = 255, nullable = false)
    private String warehouseManager;

    @ManyToOne(joinColumn = "WarehouseManager")
    private LazyReference<Account> managerAccount;

    public Long getWarehouseID() {
        return warehouseID;
    }

    public void setWarehouseID(Long warehouseID) {
        this.warehouseID = warehouseID;
    }

    public String getWarehouseName() {
        return warehouseName;
    }

    public void setWarehouseName(String warehouseName) {
        this.warehouseName = warehouseName;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getWarehouseManager() {
        return warehouseManager;
    }

    public void setWarehouseManager(String warehouseManager) {
        this.warehouseManager = warehouseManager;
    }

    public Account getManagerAccount() {
        if (managerAccount == null) {
            return null;
        }
        return managerAccount.get();
    }

    public void setManagerAccount(Account managerAccount) {
        if (this.managerAccount == null) {
            this.managerAccount = new LazyReference<>(managerAccount);
        } else {
            this.managerAccount.setValue(managerAccount);
        }
        // synchronize WarehouseManager (Username)
        if (this.warehouseManager == null && managerAccount != null) {
            this.warehouseManager = managerAccount.getUsername();
        }
    }
}
