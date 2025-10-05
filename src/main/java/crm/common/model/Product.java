package crm.common.model;

import crm.core.repository.hibernate.annotation.*;
import crm.core.repository.hibernate.entitymanager.LazyReference;

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

    @ManyToOne(joinColumn = "TypeID")
    private LazyReference<Type> type;

    @OneToMany(mappedBy = "productID", joinColumn = "ProductID")
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

    public Type getType() {
        return type.get();
    }

    public void setType(Type type) {

        this.type = new LazyReference<>(Type.class,type.getTypeID());
    }

    public List<ProductSpecification> getProductSpecifications() {
        return productSpecifications;
    }

    public void setProductSpecifications(List<ProductSpecification> productSpecifications) {
        this.productSpecifications = productSpecifications;
    }
}
