package crm.task.repository;

import crm.common.model.Staff;
import crm.service_request.repository.persistence.AbstractRepository;

public class StaffRepository extends AbstractRepository<Staff, Integer> {
    public StaffRepository() {
        super(Staff.class);
    }

}
