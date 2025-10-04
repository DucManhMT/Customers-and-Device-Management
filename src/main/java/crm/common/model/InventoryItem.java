package crm.common.model;

import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.persistence.entity.load.LazyReference;

@Entity(tableName = "InventoryItem")
public class InventoryItem {
    @Key
    @Column(name = "Item_ID", type = "BIGINT")
    private Long itemId;

    @Column(name = "SerialNumber", length = 255, nullable = false, unique = true)
    private String serialNumber;

    @Column(name = "ProductID", type = "BIGINT", nullable = false)
    private Long productID;

    @ManyToOne(joinColumn = "ProductID")
    private LazyReference<Product> product;

    public Long getItemId() {
        return itemId;
    }

    public void setItemId(Long itemId) {
        this.itemId = itemId;
    }

    public String getSerialNumber() {
        return serialNumber;
    }

    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }

    public Long getProductID() {
        return productID;
    }

    public void setProductID(Long productID) {
        this.productID = productID;
    }

    public Product getProduct() {
        return product.get();
    }

    public void setProduct(Product product) {
        this.product.setValue(product);
    }
}
