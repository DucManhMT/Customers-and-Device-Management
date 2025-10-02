package crm.common.model;

import crm.core.repository.persistence.annotation.*;
import crm.core.repository.persistence.entity.load.LazyReference;
import crm.core.repository.persistence.entity.relation.FetchMode;

@Entity(tableName = "ProductSpecification")
public class ProductSpecification {
    @Key
    @Column(name = "ProductSpecificationID", type = "INT")
    private Integer productSpecificationID;

    @Column(name = "ProductID", type = "INT", nullable = false)
    private Integer productID;

    @Column(name = "SpecificationID", type = "INT", nullable = false)
    private Integer specificationID;

    @ManyToOne(joinColumn = "ProductID", fetch = FetchMode.EAGER)
    private LazyReference<Product> product;

    @ManyToOne(joinColumn = "SpecificationID", fetch = FetchMode.EAGER)
    private LazyReference<Specification> specification;

    public Integer getProductSpecificationID() {
        return productSpecificationID;
    }

    public void setProductSpecificationID(Integer productSpecificationID) {
        this.productSpecificationID = productSpecificationID;
    }

    public Integer getProductID() {
        return productID;
    }

    public void setProductID(Integer productID) {
        this.productID = productID;
    }

    public Integer getSpecificationID() {
        return specificationID;
    }

    public void setSpecificationID(Integer specificationID) {
        this.specificationID = specificationID;
    }

    public Product getProduct() {
        return product.get();
    }

    public void setProduct(Product product) {
        this.product.setValue(product);
    }

    public Specification getSpecification() {
        return specification.get();
    }

    public void setSpecification(Specification specification) {
        this.specification.setValue(specification);
    }
}
