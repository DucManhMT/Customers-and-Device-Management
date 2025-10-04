package crm.common.model;

import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.persistence.entity.load.LazyReference;

@Entity(tableName = "ProductSpecification")
public class ProductSpecification {
    @Key
    @Column(name = "ProductSpecificationID", type = "BIGINT")
    private Long productSpecificationID;

    @Column(name = "ProductID", type = "BIGINT", nullable = false)
    private Long productID;

    @Column(name = "SpecificationID", type = "BIGINT", nullable = false)
    private Long specificationID;

    @ManyToOne(joinColumn = "ProductID")
    private LazyReference<Product> product;

    @ManyToOne(joinColumn = "SpecificationID")
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
        if (product == null) {
            return null;
        }
        return product.get();
    }

    public void setProduct(Product product) {
        if (this.product == null) {
            this.product = new LazyReference<>(product);
        } else {
            this.product.setValue(product);
        }
        // synchronize ProductID
        if (this.productID == null && product != null) {
            this.productID = product.getProductID();
        }
    }

    public Specification getSpecification() {
        if (specification == null) {
            return null;
        }
        return specification.get();
    }

    public void setSpecification(Specification specification) {
        if (this.specification == null) {
            this.specification = new LazyReference<>(specification);
        } else {
            this.specification.setValue(specification);
        }
        // synchronize SpecificationID
        if (this.specificationID == null && specification != null) {
            this.specificationID = specification.getSpecificationID();
        }
    }
}
