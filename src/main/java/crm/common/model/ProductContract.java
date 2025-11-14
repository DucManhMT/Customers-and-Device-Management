package crm.common.model;


import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.hibernate.entitymanager.LazyReference;

import java.security.PrivateKey;

@Entity(tableName = "ProductContract")
public class ProductContract {


    @ManyToOne(joinColumn = "ContractID")
    private LazyReference<Contract> contract;

    @ManyToOne(joinColumn = "ItemID")
    private LazyReference<InventoryItem> inventoryItem;





    public Contract getContract() {
        return contract.get();
    }

    public void setContract(Contract contract) {

        this.contract = new LazyReference<>(Contract.class, contract.getContractID());
    }

    public InventoryItem getInventoryItem() {
        return inventoryItem.get();
    }

    public void setInventoryItem(InventoryItem inventoryItem) {
        this.inventoryItem = new LazyReference<>(InventoryItem.class, inventoryItem.getItemId());
    }
}
