package crm.common.repository;

import crm.common.model.Type;
import crm.core.repository.persistence.repository.AbstractRepository;

public class TypeRepository extends AbstractRepository<Type, Integer> {
    public TypeRepository() {
        super(Type.class);
    }
}
