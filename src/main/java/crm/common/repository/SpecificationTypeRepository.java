package crm.common.repository;

import crm.common.model.SpecificationType;
import crm.core.repository.persistence.repository.AbstractRepository;

public class SpecificationTypeRepository extends AbstractRepository<SpecificationType, Long> {
    public SpecificationTypeRepository() {
        super(SpecificationType.class);
    }
}
