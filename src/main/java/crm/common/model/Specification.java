package crm.common.model;

import crm.core.repository.hibernate.annotation.*;
import crm.core.repository.persistence.entity.load.LazyReference;

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

    @Column(name = "SpecificationTypeID", type = "INT", nullable = false)
    private Integer specificationTypeID;

    @ManyToOne(joinColumn = "SpecificationTypeID")
    private LazyReference<SpecificationType> specificationType;

    @OneToMany(mappedBy = "specificationID", joinColumn = "SpecificationID")
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

    public Integer getSpecificationTypeID() {
        return specificationTypeID;
    }

    public void setSpecificationTypeID(Integer specificationTypeID) {
        this.specificationTypeID = specificationTypeID;
    }

    public SpecificationType getSpecificationType() {
        return specificationType.get();
    }

    public void setSpecificationType(SpecificationType specificationType) {
        this.specificationType.setValue(specificationType);
    }

    public List<ProductSpecification> getProductSpecifications() {
        return productSpecifications;
    }

    public void setProductSpecifications(List<ProductSpecification> productSpecifications) {
        this.productSpecifications = productSpecifications;
    }
}
