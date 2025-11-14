package crm.common.model;

import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.hibernate.entitymanager.LazyReference;
import crm.warehousekeeper.service.SerialGenerator;

@Entity(tableName = "InventoryItem")
public class InventoryItem {
    @Key
    @Column(name = "ItemID", type = "INT")
    private Integer itemId;

    @Column(name = "SerialNumber", length = 255, nullable = false, unique = true)
    private String serialNumber;

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

        this.serialNumber = SerialGenerator.generateSerial(String.valueOf(this.product.get().getProductID()),
                serialNumber);
    }

    public Product getProduct() {
        return product.get();
    }

    public void setProduct(Product product) {
        this.product = new LazyReference<>(Product.class, product.getProductID());
    }
}
