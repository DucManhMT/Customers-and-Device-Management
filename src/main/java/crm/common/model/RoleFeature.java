package crm.common.model;

import crm.core.repository.persistence.annotation.Column;
import crm.core.repository.persistence.annotation.Entity;
import crm.core.repository.persistence.annotation.Key;
import crm.core.repository.persistence.annotation.ManyToOne;
import crm.core.repository.persistence.entity.load.LazyReference;
import crm.core.repository.persistence.entity.relation.FetchMode;

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
