package crm.common.model;

import crm.core.repository.hibernate.annotation.*;
import crm.core.repository.persistence.entity.load.LazyReference;

import java.util.List;

@Entity(tableName = "Product")
public class Product {
    @Key
    @Column(name = "ProductID", type = "BIGINT")
    private Long productID;

    @Column(name = "ProductName", length = 150, nullable = false)
    private String productName;

    @Column(name = "ProductImage", length = 255)
    private String productImage;

    @Column(name = "ProductDescription", length = 255)
    private String productDescription;

    @Column(name = "TypeID", type = "BIGINT", nullable = false)
    private Long typeID;

    @ManyToOne(joinColumn = "TypeID")
    private LazyReference<Type> type;

    @OneToMany(mappedBy = "productID", joinColumn = "ProductID")
    private List<ProductSpecification> productSpecifications;

    public Long getProductID() {
        return productID;
    }

    public void setProductID(Long productID) {
        this.productID = productID;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProductImage() {
        return productImage;
    }

    public void setProductImage(String productImage) {
        this.productImage = productImage;
    }

    public String getProductDescription() {
        return productDescription;
    }

    public void setProductDescription(String productDescription) {
        this.productDescription = productDescription;
    }

    public Long getTypeID() {
        return typeID;
    }

    public void setTypeID(Long typeID) {
        this.typeID = typeID;
    }

    public Type getType() {
        return type.get();
    }

    public void setType(Type type) {
        this.type.setValue(type);
    }

    public List<ProductSpecification> getProductSpecifications() {
        return productSpecifications;
    }

    public void setProductSpecifications(List<ProductSpecification> productSpecifications) {
        this.productSpecifications = productSpecifications;
    }
}
