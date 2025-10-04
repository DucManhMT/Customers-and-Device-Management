package crm.common.model;

import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.persistence.entity.load.LazyReference;

@Entity(tableName = "RoleFeature")
public class RoleFeature {
    // Surrogate key instead of composite
    @Key
    @Column(name = "RoleFeatureID", type = "INT")
    private Integer roleFeatureID;

    @Column(name = "RoleID", type = "INT", nullable = false)
    private Integer roleID;

    @Column(name = "FeatureID", type = "INT", nullable = false)
    private Integer featureID;

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

    public Integer getRoleID() {
        return roleID;
    }

    public void setRoleID(Integer roleID) {
        this.roleID = roleID;
    }

    public Integer getFeatureID() {
        return featureID;
    }

    public void setFeatureID(Integer featureID) {
        this.featureID = featureID;
    }

    public Role getRole() {
        return role.get();
    }

    public void setRole(Role role) {
        this.role.setValue(role);
    }

    public Feature getFeature() {
        return feature.get();
    }

    public void setFeature(Feature feature) {
        this.feature.setValue(feature);
    }
}
