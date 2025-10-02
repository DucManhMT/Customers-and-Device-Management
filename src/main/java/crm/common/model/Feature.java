package crm.common.model;

import crm.core.repository.persistence.annotation.Column;
import crm.core.repository.persistence.annotation.Entity;
import crm.core.repository.persistence.annotation.Key;

@Entity(tableName = "Feature")
public class Feature {
    @Key
    @Column(name = "FeatureID", type = "BIGINT")
    private Long featureID;

    @Column(name = "FeatureURL", length = 255, nullable = false)
    private String featureURL;

    @Column(name = "Description", length = 255)
    private String description;

    public Long getFeatureID() {
        return featureID;
    }

    public void setFeatureID(Long featureID) {
        this.featureID = featureID;
    }

    public String getFeatureURL() {
        return featureURL;
    }

    public void setFeatureURL(String featureURL) {
        this.featureURL = featureURL;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
