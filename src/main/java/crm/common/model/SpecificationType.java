package crm.common.model;

import crm.core.repository.hibernate.annotation.*;
import crm.core.repository.hibernate.entitymanager.LazyReference;

import java.util.List;

@Entity(tableName = "SpecificationType")
public class SpecificationType {
    @Key
    @Column(name = "SpecificationTypeID", type = "INT")
    private Integer specificationTypeID;

    @Column(name = "SpecificationTypeName", length = 100, nullable = false)
    private String specificationTypeName;

    @ManyToOne(joinColumn = "TypeID")
    private LazyReference<Type> type;

    @OneToMany(mappedBy = "specificationTypeID", joinColumn = "SpecificationTypeID")
    private List<Specification> specifications;

    public Integer getSpecificationTypeID() {
        return specificationTypeID;
    }

    public void setSpecificationTypeID(Integer specificationTypeID) {
        this.specificationTypeID = specificationTypeID;
    }

    public String getSpecificationTypeName() {
        return specificationTypeName;
    }

    public void setSpecificationTypeName(String specificationTypeName) {
        this.specificationTypeName = specificationTypeName;
    }


    public Type getType() {
        return type.get();
    }

    public void setType(Type type) {
        this.type = new LazyReference<>(Type.class, type.getTypeID());
    }

    public List<Specification> getSpecifications() {
        return specifications;
    }

    public void setSpecifications(List<Specification> specifications) {
        this.specifications = specifications;
    }
}
