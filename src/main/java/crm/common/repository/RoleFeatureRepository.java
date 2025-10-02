package crm.common.repository;

import crm.common.model.RoleFeature;
import crm.core.repository.persistence.repository.AbstractRepository;

public class RoleFeatureRepository extends AbstractRepository<RoleFeature, Integer> {
    public RoleFeatureRepository() {
        super(RoleFeature.class);
    }
}
