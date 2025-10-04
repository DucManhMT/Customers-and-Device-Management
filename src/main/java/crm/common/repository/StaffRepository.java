package crm.common.repository;

import crm.common.model.Staff;
import crm.core.repository.persistence.repository.AbstractRepository;

public class StaffRepository extends AbstractRepository<Staff, Long> {
    public StaffRepository() {
        super(Staff.class);
    }
}
