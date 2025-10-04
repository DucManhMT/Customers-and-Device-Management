package crm.common.model;

import crm.core.repository.hibernate.annotation.*;
import crm.core.repository.persistence.entity.load.LazyReference;

import java.util.List;

@Entity(tableName = "SpecificationType")
public class SpecificationType {
    @Key
    @Column(name = "SpecificationTypeID", type = "BIGINT")
    private Long specificationTypeID;

    @Column(name = "SpecificationTypeName", length = 100, nullable = false)
    private String specificationTypeName;

    @Column(name = "TypeID", type = "BIGINT", nullable = false)
    private Long typeID;

    @ManyToOne(joinColumn = "TypeID")
    private LazyReference<Type> type;

    @OneToMany(mappedBy = "specificationTypeID", joinColumn = "SpecificationTypeID")
    private List<Specification> specifications;

    public Long getSpecificationTypeID() {
        return specificationTypeID;
    }

    public void setSpecificationTypeID(Long specificationTypeID) {
        this.specificationTypeID = specificationTypeID;
    }

    public String getSpecificationTypeName() {
        return specificationTypeName;
    }

    public void setSpecificationTypeName(String specificationTypeName) {
        this.specificationTypeName = specificationTypeName;
    }

    public Long getTypeID() {
        return typeID;
    }

    public void setTypeID(Long typeID) {
        this.typeID = typeID;
    }

    public Type getType() {
        if (type == null) {
            return null;
        }
        return type.get();
    }

    public void setType(Type type) {
        if (this.type == null) {
            this.type = new LazyReference<>(type);
        } else {
            this.type.setValue(type);
        }
        // synchronize TypeID
        if (this.typeID == null && type != null) {
            this.typeID = type.getTypeID();
        }
    }

    public List<Specification> getSpecifications() {
        return specifications;
    }

    public void setSpecifications(List<Specification> specifications) {
        this.specifications = specifications;
    }
}
