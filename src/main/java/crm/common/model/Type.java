package crm.common.model;

import crm.core.repository.persistence.annotation.Column;
import crm.core.repository.persistence.annotation.Entity;
import crm.core.repository.persistence.annotation.Key;
import crm.core.repository.persistence.annotation.ManyToOne;
import crm.core.repository.persistence.annotation.OneToMany;
import crm.core.repository.persistence.entity.load.LazyReference;
import crm.core.repository.persistence.entity.relation.FetchMode;
import java.util.List;

@Entity(tableName = "Type")
public class Type {
    @Key
    @Column(name = "TypeID", type = "INT")
    private Integer typeID;

    @Column(name = "TypeName", length = 100, nullable = false)
    private String typeName;

    @Column(name = "TypeImage", length = 255)
    private String typeImage;

    @Column(name = "CategoryID", type = "INT", nullable = false)
    private Integer categoryID;

    @ManyToOne(joinColumn = "CategoryID", fetch = FetchMode.EAGER)
    private LazyReference<Category> category;

    @OneToMany(mappedBy = "typeID", joinColumn = "TypeID", fetch = FetchMode.LAZY)
    private List<Product> products;

    @OneToMany(mappedBy = "typeID", joinColumn = "TypeID", fetch = FetchMode.LAZY)
    private List<SpecificationType> specificationTypes;

    public Integer getTypeID() {
        return typeID;
    }

    public void setTypeID(Integer typeID) {
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

    public Integer getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(Integer categoryID) {
        this.categoryID = categoryID;
    }

    public Category getCategory() {
        return category.get();
    }

    public void setCategory(Category category) {
        this.category.setValue(category);
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
