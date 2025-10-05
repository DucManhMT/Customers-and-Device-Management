package crm.common.model;

<<<<<<< HEAD
import crm.core.repository.hibernate.annotation.*;
import crm.core.repository.hibernate.entitymanager.LazyReference;
=======
import crm.core.repository.persistence.annotation.*;
import crm.core.repository.persistence.entity.load.LazyReference;
import crm.core.repository.persistence.entity.relation.FetchMode;
>>>>>>> main

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

<<<<<<< HEAD
    @ManyToOne(joinColumn = "TypeID")
=======
    @Column(name = "TypeID", type = "BIGINT", nullable = false)
    private Long typeID;

    @ManyToOne(joinColumn = "TypeID", fetch = FetchMode.EAGER)
>>>>>>> main
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
