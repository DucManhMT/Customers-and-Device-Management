package crm.common.model;


import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.persistence.entity.load.LazyReference;

@Entity(tableName = "ProductContract")
public class ProductContract {
    @Key
    @Column(name = "ContractID", type = "INT", nullable = false)
    private Integer contractID;

    @Column(name = "ItemID", type = "INT", nullable = false)
    private Integer itemID;

    @ManyToOne(joinColumn = "ContractID")
    private LazyReference<Contract> contract;

    @ManyToOne(joinColumn = "ItemID")
    private LazyReference<InventoryItem> inventoryItem;

    public Integer getContractID() {
        return contractID;
    }

    public void setContractID(Integer contractID) {
        this.contractID = contractID;
    }

    public Integer getItemID() {
        return itemID;
    }

    public void setItemID(Integer itemID) {
        this.itemID = itemID;
    }

    public Contract getContract() {
        return contract.get();
    }

    public void setContract(Contract contract) {
        this.contract.setValue(contract);
    }

    public InventoryItem getInventoryItem() {
        return inventoryItem.get();
    }

    public void setInventoryItem(InventoryItem inventoryItem) {
        this.inventoryItem.setValue(inventoryItem);
    }
}
