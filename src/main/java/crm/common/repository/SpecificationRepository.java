package crm.common.repository;

import crm.common.model.Specification;
import crm.core.repository.persistence.repository.AbstractRepository;

public class SpecificationRepository extends AbstractRepository<Specification, Long> {
    public SpecificationRepository() {
        super(Specification.class);
    }
}
