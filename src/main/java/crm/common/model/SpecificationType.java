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

@Entity(tableName = "SpecificationType")
public class SpecificationType {
    @Key
    @Column(name = "SpecificationTypeID", type = "INT")
    private Integer specificationTypeID;

    @Column(name = "SpecificationTypeName", length = 100, nullable = false)
    private String specificationTypeName;

<<<<<<< HEAD
    @ManyToOne(joinColumn = "TypeID")
=======
    @Column(name = "TypeID", type = "BIGINT", nullable = false)
    private Long typeID;

    @ManyToOne(joinColumn = "TypeID", fetch = FetchMode.EAGER)
>>>>>>> main
    private LazyReference<Type> type;

    @OneToMany(mappedBy = "specificationTypeID", joinColumn = "SpecificationTypeID", fetch = FetchMode.LAZY)
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
