package crm.common.model;

import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.persistence.entity.load.LazyReference;

@Entity(tableName = "InventoryItem")
public class InventoryItem {
    @Key
    @Column(name = "Item_ID", type = "INT")
    private Integer itemId;

    @Column(name = "SerialNumber", length = 255, nullable = false, unique = true)
    private String serialNumber;

    @Column(name = "ProductID", type = "INT", nullable = false)
    private Integer productID;

    @ManyToOne(joinColumn = "ProductID")
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

    public Integer getProductID() {
        return productID;
    }

    public void setProductID(Integer productID) {
        this.productID = productID;
    }

    public Product getProduct() {
        return product.get();
    }

    public void setProduct(Product product) {
        this.product.setValue(product);
    }
}
