package crm.common.model;

import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.hibernate.entitymanager.LazyReference;

@Entity(tableName = "WarehouseRequestProduct")
public class WarehouseRequestProduct {

    @Key
    @Column(name = "WarehouseRequestProductID")
    private Integer warehouseRequestProductID;

    @Column(name = "Quantity", type = "INT", nullable = false)
    private Integer quantity;

    @ManyToOne(joinColumn = "WarehouseRequestID")
    private LazyReference<WarehouseRequest> warehouseRequest;

    @ManyToOne(joinColumn = "ProductID")
    private LazyReference<Product> product;

    public Integer getWarehouseRequestProductID() {
        return warehouseRequestProductID;
    }

    public void setWarehouseRequestProductID(Integer warehouseRequestProductID) {
        this.warehouseRequestProductID = warehouseRequestProductID;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public WarehouseRequest getWarehouseRequestID() {
        return warehouseRequest.get();
    }

    public void setWarehouseRequest(WarehouseRequest warehouseRequest) {
        this.warehouseRequest = new LazyReference<>(WarehouseRequest.class, warehouseRequest.getWarehouseRequestID());
    }

    public Product getProduct() {
        return product.get();
    }

    public void setProduct(Product product) {
        this.product = new LazyReference<>(Product.class, product.getProductID());
    }
}
