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

@Entity(tableName = "InventoryItem")
public class InventoryItem {
    @Key
    @Column(name = "Item_ID", type = "INT")
    private Integer itemId;

    @Column(name = "SerialNumber", length = 255, nullable = false, unique = true)
    private String serialNumber;

<<<<<<< HEAD
    @ManyToOne(joinColumn = "ProductID")
=======
    @Column(name = "ProductID", type = "BIGINT", nullable = false)
    private Long productID;

    @ManyToOne(joinColumn = "ProductID", fetch = FetchMode.EAGER)
>>>>>>> main
    private LazyReference<Product> product;

    public Integer getItemId() {
        return itemId;
    }

    public void setItemId(Integer itemId) {
        this.itemId = itemId;
    }

    public String getSerialNumber() {
        return serialNumber;
    }

    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }

    public Product getProduct() {
        return product.get();
    }

    public void setProduct(Product product) {
        this.product = new LazyReference<>(Product.class,product.getProductID());
    }
}
