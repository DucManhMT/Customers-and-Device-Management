package crm.common.model;

import crm.core.repository.persistence.annotation.*;
import crm.core.repository.persistence.entity.load.LazyReference;
import crm.core.repository.persistence.entity.relation.FetchMode;

import java.util.List;

@Entity(tableName = "Specification")
public class Specification {
    @Key
    @Column(name = "SpecificationID", type = "BIGINT")
    private Long specificationID;

    @Column(name = "SpecificationName", length = 100, nullable = false)
    private String specificationName;

    @Column(name = "SpecificationValue", length = 255, nullable = false)
    private String specificationValue;

    @Column(name = "SpecificationTypeID", type = "BIGINT", nullable = false)
    private Long specificationTypeID;

    @ManyToOne(joinColumn = "SpecificationTypeID", fetch = FetchMode.EAGER)
    private LazyReference<SpecificationType> specificationType;

    @OneToMany(mappedBy = "specificationID", joinColumn = "SpecificationID", fetch = FetchMode.LAZY)
    private List<ProductSpecification> productSpecifications;

    public Long getSpecificationID() {
        return specificationID;
    }

    public void setSpecificationID(Long specificationID) {
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

    public Long getSpecificationTypeID() {
        return specificationTypeID;
    }

    public void setSpecificationTypeID(Long specificationTypeID) {
        this.specificationTypeID = specificationTypeID;
    }

    public SpecificationType getSpecificationType() {
        if (specificationType == null) {
            return null;
        }
        return specificationType.get();
    }

    public void setSpecificationType(SpecificationType specificationType) {
        if (this.specificationType == null) {
            this.specificationType = new LazyReference<>(specificationType);
        } else {
            this.specificationType.setValue(specificationType);
        }
        // synchronize SpecificationTypeID
        if (this.specificationTypeID == null && specificationType != null) {
            this.specificationTypeID = specificationType.getSpecificationTypeID();
        }
    }

    public List<ProductSpecification> getProductSpecifications() {
        return productSpecifications;
    }

    public void setProductSpecifications(List<ProductSpecification> productSpecifications) {
        this.productSpecifications = productSpecifications;
    }
}
