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

@Entity(tableName = "Specification")
public class Specification {
    @Key
    @Column(name = "SpecificationID", type = "INT")
    private Integer specificationID;

    @Column(name = "SpecificationName", length = 100, nullable = false)
    private String specificationName;

    @Column(name = "SpecificationValue", length = 255, nullable = false)
    private String specificationValue;

<<<<<<< HEAD
    @ManyToOne(joinColumn = "SpecificationTypeID")
=======
    @Column(name = "SpecificationTypeID", type = "BIGINT", nullable = false)
    private Long specificationTypeID;

    @ManyToOne(joinColumn = "SpecificationTypeID", fetch = FetchMode.EAGER)
>>>>>>> main
    private LazyReference<SpecificationType> specificationType;

    @OneToMany(mappedBy = "specificationID", joinColumn = "SpecificationID", fetch = FetchMode.LAZY)
    private List<ProductSpecification> productSpecifications;

    public Integer getSpecificationID() {
        return specificationID;
    }

    public void setSpecificationID(Integer specificationID) {
        this.specificationID = specificationID;
    }

    public String getSpecificationName() {
        return specificationName;
    }

    public void setSpecificationName(String specificationName) {
        this.specificationName = specificationName;
    }

    public String getSpecificationValue() {
        return specificationValue;
    }

    public void setSpecificationValue(String specificationValue) {
        this.specificationValue = specificationValue;
    }


    public SpecificationType getSpecificationType() {
        return specificationType.get();
    }

    public void setSpecificationType(SpecificationType specificationType) {
        this.specificationType = new LazyReference<>(SpecificationType.class ,specificationType.getSpecificationTypeID());
    }

    public List<ProductSpecification> getProductSpecifications() {
        return productSpecifications;
    }

    public void setProductSpecifications(List<ProductSpecification> productSpecifications) {
        this.productSpecifications = productSpecifications;
    }
}
