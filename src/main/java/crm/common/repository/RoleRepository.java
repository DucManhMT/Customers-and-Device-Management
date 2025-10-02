package crm.common.repository;

import crm.common.model.Role;
import crm.core.repository.persistence.repository.AbstractRepository;

public class RoleRepository extends AbstractRepository<Role, Integer> {
    public RoleRepository() {
        super(Role.class);
    }
}
