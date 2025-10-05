package crm.common.model;

import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.hibernate.entitymanager.LazyReference;

@Entity(tableName = "RoleFeature")
public class RoleFeature {
    // Surrogate key instead of composite
    @Key
    @Column(name = "RoleFeatureID", type = "INT")
    private Integer roleFeatureID;

    @ManyToOne(joinColumn = "RoleID")
    private LazyReference<Role> role;

    @ManyToOne(joinColumn = "FeatureID")
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
