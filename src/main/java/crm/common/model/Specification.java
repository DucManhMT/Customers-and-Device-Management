package crm.common.model;

import crm.core.config.DBcontext;
import crm.core.repository.hibernate.annotation.*;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.repository.hibernate.entitymanager.LazyReference;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Entity(tableName = "Specification")
public class Specification {
    @Key
    @Column(name = "SpecificationID", type = "INT")
    private Integer specificationID;

    @Column(name = "SpecificationName", length = 100, nullable = false)
    private String specificationName;

    @Column(name = "SpecificationValue", length = 255, nullable = false)
    private String specificationValue;

    @ManyToOne(joinColumn = "SpecificationTypeID")
    private LazyReference<SpecificationType> specificationType;

    @OneToMany(mappedBy = "specificationID", joinColumn = "SpecificationID", targetEntity = ProductSpecification.class)
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
        this.specificationType = new LazyReference<>(SpecificationType.class,
                specificationType.getSpecificationTypeID());
    }


    public List<ProductSpecification> getProductSpecifications(Integer specificationID) {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        Map<String, Object> conditions = new HashMap<>();
        conditions.put("SpecificationID", specificationID);
        return em.findWithConditions(ProductSpecification.class, conditions);
    }
    public void setProductSpecifications(List<ProductSpecification> productSpecifications) {
        this.productSpecifications = productSpecifications;
    }
}
