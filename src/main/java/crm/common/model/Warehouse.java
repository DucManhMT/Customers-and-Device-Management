package crm.common.model;

import crm.core.repository.hibernate.annotation.*;
import crm.core.repository.hibernate.entitymanager.LazyReference;

@Entity(tableName = "Warehouse")
public class Warehouse {
    @Key
    @Column(name = "WarehouseID", type = "INT")
    private Integer warehouseID;

    @Column(name = "WarehouseName", length = 100, nullable = false)
    private String warehouseName;

    @Column(name = "Location", length = 255)
    private String location;

    @ManyToOne(joinColumn = "WarehouseManager")
    private LazyReference<Account> managerAccount;

    public Integer getWarehouseID() {
        return warehouseID;
    }

    public void setWarehouseID(Integer warehouseID) {
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

    public Account getManagerAccount() {
        return managerAccount.get();
    }

    public void setManagerAccount(Account managerAccount) {
        this.managerAccount = new LazyReference<>(Account.class, managerAccount.getUsername());
    }

}
