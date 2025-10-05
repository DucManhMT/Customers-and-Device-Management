package crm.common.model;

<<<<<<< HEAD
import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.hibernate.entitymanager.LazyReference;
=======
import crm.core.repository.persistence.annotation.*;
import crm.core.repository.persistence.entity.load.LazyReference;
import crm.core.repository.persistence.entity.relation.FetchMode;
>>>>>>> main

@Entity(tableName = "ProductSpecification")
public class ProductSpecification {
    @Key
    @Column(name = "ProductSpecificationID", type = "INT")
    private Integer productSpecificationID;

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


    public Product getProduct() {
        return product.get();
    }
    public void setProduct(Product product) {
        this.product = new LazyReference<>(Product.class, product.getProductID());
    }

    public Specification getSpecification() {
        return specification.get();
    }

    public void setSpecification(Specification specification) {
        this.specification = new LazyReference<>(Specification.class, specification.getSpecificationID());
    }
}
