package crm.common.model;

import crm.core.repository.hibernate.annotation.*;
import crm.core.repository.persistence.entity.load.LazyReference;

import java.util.List;

@Entity(tableName = "SpecificationType")
public class SpecificationType {
    @Key
    @Column(name = "SpecificationTypeID", type = "INT")
    private Integer specificationTypeID;

    @Column(name = "SpecificationTypeName", length = 100, nullable = false)
    private String specificationTypeName;

    @Column(name = "TypeID", type = "INT", nullable = false)
    private Integer typeID;

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

    public Integer getTypeID() {
        return typeID;
    }

    public void setTypeID(Integer typeID) {
        this.typeID = typeID;
    }

    public Type getType() {
        return type.get();
    }

    public void setType(Type type) {
        this.type.setValue(type);
    }

    public List<Specification> getSpecifications() {
        return specifications;
    }

    public void setSpecifications(List<Specification> specifications) {
        this.specifications = specifications;
    }
}
