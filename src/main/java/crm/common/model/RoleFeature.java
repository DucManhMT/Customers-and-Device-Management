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
    @Column(name = "RoleFeatureID", type = "BIGINT")
    private Long roleFeatureID;

    @Column(name = "RoleID", type = "BIGINT", nullable = false)
    private Long roleID;

    @Column(name = "FeatureID", type = "BIGINT", nullable = false)
    private Long featureID;

    @ManyToOne(joinColumn = "RoleID")
    private LazyReference<Role> role;

    @ManyToOne(joinColumn = "FeatureID")
    private LazyReference<Feature> feature;

    public Long getRoleFeatureID() {
        return roleFeatureID;
    }

    public void setRoleFeatureID(Long roleFeatureID) {
        this.roleFeatureID = roleFeatureID;
    }

    public Long getRoleID() {
        return roleID;
    }

    public void setRoleID(Long roleID) {
        this.roleID = roleID;
    }

    public Long getFeatureID() {
        return featureID;
    }

    public void setFeatureID(Long featureID) {
        this.featureID = featureID;
    }

    public Role getRole() {
        if (role == null) {
            return null;
        }
        return role.get();
    }

    public void setRole(Role role) {
        if (this.role == null) {
            this.role = new LazyReference<>(role);
        } else {
            this.role.setValue(role);
        }
        // synchronize RoleID
        if (this.roleID == null && role != null) {
            this.roleID = role.getRoleID();
        }
    }

    public Feature getFeature() {
        if (feature == null) {
            return null;
        }
        return feature.get();
    }

    public void setFeature(Feature feature) {
        if (this.feature == null) {
            this.feature = new LazyReference<>(feature);
        } else {
            this.feature.setValue(feature);
        }
        // synchronize FeatureID
        if (this.featureID == null && feature != null) {
            this.featureID = feature.getFeatureID();
        }
    }
}
