package crm.common.model;

import crm.core.repository.persistence.annotation.*;
import crm.core.repository.persistence.entity.load.LazyReference;
import crm.core.repository.persistence.entity.relation.FetchMode;

@Entity(tableName = "ProductContract")
public class ProductContract {
    @Key
    @Column(name = "ContractID", type = "INT", nullable = false)
    private Integer contractID;

    @Column(name = "ItemID", type = "INT", nullable = false)
    private Integer itemID;

    @ManyToOne(joinColumn = "ContractID", fetch = FetchMode.EAGER)
    private LazyReference<Contract> contract;

    @ManyToOne(joinColumn = "ItemID", fetch = FetchMode.EAGER)
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
