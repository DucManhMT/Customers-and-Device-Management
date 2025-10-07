package crm.common.model;

import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.hibernate.annotation.OneToMany;
import crm.core.repository.hibernate.entitymanager.LazyReference;

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

    @ManyToOne(joinColumn = "CategoryID")
    private LazyReference<Category> category;

    @OneToMany(mappedBy = "typeID", joinColumn = "TypeID", targetEntity = Product.class)
    private List<Product> products;

    @OneToMany(mappedBy = "typeID", joinColumn = "TypeID", targetEntity = SpecificationType.class)
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

    public Category getCategory() {
        return category.get();
    }

    public void setCategory(Category category) {
        this.category = new LazyReference<>(Category.class, category.getCategoryID());
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
