package crm.common.model;


import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.persistence.entity.load.LazyReference;

@Entity(tableName = "ProductContract")
public class ProductContract {
    @Key
    @Column(name = "ContractID", type = "BIGINT", nullable = false)
    private Long contractID;

    @Column(name = "ItemID", type = "BIGINT", nullable = false)
    private Long itemID;

    @ManyToOne(joinColumn = "ContractID")
    private LazyReference<Contract> contract;

    @ManyToOne(joinColumn = "ItemID")
    private LazyReference<InventoryItem> inventoryItem;

    public Long getContractID() {
        return contractID;
    }

    public void setContractID(Long contractID) {
        this.contractID = contractID;
    }

    public Long getItemID() {
        return itemID;
    }

    public void setItemID(Long itemID) {
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
