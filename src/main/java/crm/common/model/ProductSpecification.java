package crm.common.model;

import crm.core.repository.persistence.annotation.*;
import crm.core.repository.persistence.entity.load.LazyReference;
import crm.core.repository.persistence.entity.relation.FetchMode;

@Entity(tableName = "ProductSpecification")
public class ProductSpecification {
    @Key
    @Column(name = "ProductSpecificationID", type = "BIGINT")
    private Long productSpecificationID;

    @Column(name = "ProductID", type = "BIGINT", nullable = false)
    private Long productID;

    @Column(name = "SpecificationID", type = "BIGINT", nullable = false)
    private Long specificationID;

    @ManyToOne(joinColumn = "ProductID", fetch = FetchMode.EAGER)
    private LazyReference<Product> product;

    @ManyToOne(joinColumn = "SpecificationID", fetch = FetchMode.EAGER)
    private LazyReference<Specification> specification;

    public Long getProductSpecificationID() {
        return productSpecificationID;
    }

    public void setProductSpecificationID(Long productSpecificationID) {
        this.productSpecificationID = productSpecificationID;
    }

    public Long getProductID() {
        return productID;
    }

    public void setProductID(Long productID) {
        this.productID = productID;
    }

    public Long getSpecificationID() {
        return specificationID;
    }

    public void setSpecificationID(Long specificationID) {
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
