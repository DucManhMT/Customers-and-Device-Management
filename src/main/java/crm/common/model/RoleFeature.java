package crm.common.model;

<<<<<<< HEAD
import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.hibernate.entitymanager.LazyReference;
=======
import crm.core.repository.persistence.annotation.Column;
import crm.core.repository.persistence.annotation.Entity;
import crm.core.repository.persistence.annotation.Key;
import crm.core.repository.persistence.annotation.ManyToOne;
import crm.core.repository.persistence.entity.load.LazyReference;
import crm.core.repository.persistence.entity.relation.FetchMode;
>>>>>>> main

@Entity(tableName = "RoleFeature")
public class RoleFeature {
    // Surrogate key instead of composite
    @Key
    @Column(name = "RoleFeatureID", type = "INT")
    private Integer roleFeatureID;

    @ManyToOne(joinColumn = "RoleID", fetch = FetchMode.LAZY)
    private LazyReference<Role> role;

    @ManyToOne(joinColumn = "FeatureID", fetch = FetchMode.LAZY)
    private LazyReference<Feature> feature;

    public Integer getRoleFeatureID() {
        return roleFeatureID;
    }

    public void setRoleFeatureID(Integer roleFeatureID) {
        this.roleFeatureID = roleFeatureID;
    }

    public Role getRole() {
        return role.get();
    }

    public void setRole(Role role) {

        this.role = new LazyReference<>(Role.class,role.getRoleID());
    }

    public Feature getFeature() {
        return feature.get();
    }

    public void setFeature(Feature feature) {

        this.feature = new LazyReference<>(Feature.class,feature.getFeatureID());
    }
}
