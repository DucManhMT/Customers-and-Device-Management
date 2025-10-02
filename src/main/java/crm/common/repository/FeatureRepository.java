package crm.common.repository;

import crm.common.model.Feature;
import crm.core.repository.persistence.repository.AbstractRepository;

public class FeatureRepository extends AbstractRepository<Feature, Integer> {
    public FeatureRepository() {
        super(Feature.class);
    }
}
