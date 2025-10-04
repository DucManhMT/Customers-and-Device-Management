package crm.common.model;

import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.hibernate.annotation.OneToMany;
import crm.core.repository.persistence.entity.load.LazyReference;

import java.util.List;

@Entity(tableName = "Type")
public class Type {
    @Key
    @Column(name = "TypeID", type = "BIGINT")
    private Long typeID;

    @Column(name = "TypeName", length = 100, nullable = false)
    private String typeName;

    @Column(name = "TypeImage", length = 255)
    private String typeImage;

    @Column(name = "CategoryID", type = "BIGINT", nullable = false)
    private Long categoryID;

    @ManyToOne(joinColumn = "CategoryID")
    private LazyReference<Category> category;

    @OneToMany(mappedBy = "typeID", joinColumn = "TypeID")
    private List<Product> products;

    @OneToMany(mappedBy = "typeID", joinColumn = "TypeID")
    private List<SpecificationType> specificationTypes;

    public Long getTypeID() {
        return typeID;
    }

    public void setTypeID(Long typeID) {
        this.typeID = typeID;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public String getTypeImage() {
        return typeImage;
    }

    public void setTypeImage(String typeImage) {
        this.typeImage = typeImage;
    }

    public Long getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(Long categoryID) {
        this.categoryID = categoryID;
    }

    public Category getCategory() {
        if (category == null) {
            return null;
        }
        return category.get();
    }

    public void setCategory(Category category) {
        if (this.category == null) {
            this.category = new LazyReference<>(category);
        } else {
            this.category.setValue(category);
        }
        // synchronize CategoryID
        if (this.categoryID == null && category != null) {
            this.categoryID = category.getCategoryID();
        }
    }

    public List<Product> getProducts() {
        return products;
    }

    public void setProducts(List<Product> products) {
        this.products = products;
    }

    public List<SpecificationType> getSpecificationTypes() {
        return specificationTypes;
    }

    public void setSpecificationTypes(List<SpecificationType> specificationTypes) {
        this.specificationTypes = specificationTypes;
    }
}
