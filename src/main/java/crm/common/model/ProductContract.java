package crm.common.model;

<<<<<<< HEAD

import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.hibernate.entitymanager.LazyReference;

import java.security.PrivateKey;
=======
import crm.core.repository.persistence.annotation.*;
import crm.core.repository.persistence.entity.load.LazyReference;
import crm.core.repository.persistence.entity.relation.FetchMode;
>>>>>>> main

@Entity(tableName = "ProductContract")
public class ProductContract {
    @Key
    @Column(name = "ProductContractID", type = "INT")
    private Integer ProductContractID;


    @ManyToOne(joinColumn = "ContractID", fetch = FetchMode.EAGER)
    private LazyReference<Contract> contract;

    @ManyToOne(joinColumn = "ItemID", fetch = FetchMode.EAGER)
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
