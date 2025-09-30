package crm.common.model;

import crm.core.repository.persistence.annotation.*;
import crm.core.repository.persistence.entity.load.LazyReference;
import crm.core.repository.persistence.entity.relation.FetchMode;

import java.util.List;

@Entity(tableName = "Product")
public class Product {
    @Key
    @Column(name = "ProductID", type = "INT")
    private Integer productID;

    @Column(name = "ProductName", length = 150, nullable = false)
    private String productName;

    @Column(name = "ProductImage", length = 255)
    private String productImage;

    @Column(name = "ProductDescription", length = 255)
    private String productDescription;

    @Column(name = "TypeID", type = "INT", nullable = false)
    private Integer typeID;

    @ManyToOne(joinColumn = "TypeID", fetch = FetchMode.EAGER)
    private LazyReference<Type> type;

    @OneToMany(mappedBy = "productID", joinColumn = "ProductID", fetch = FetchMode.LAZY)
    private List<ProductSpecification> productSpecifications;

    public Integer getProductID() {
        return productID;
    }

    public void setProductID(Integer productID) {
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

    public Integer getTypeID() {
        return typeID;
    }

    public void setTypeID(Integer typeID) {
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
