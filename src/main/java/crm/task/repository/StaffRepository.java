package crm.task.repository;

import crm.common.model.Staff;
import crm.service_request.repository.persistence.AbstractRepository;
import crm.service_request.repository.persistence.query.common.ClauseBuilder;

public class StaffRepository extends AbstractRepository<Staff, Integer> {
    public StaffRepository() {
        super(Staff.class);
    }

    public Staff findByUsername(String username) {
        return findWithCondition(ClauseBuilder.builder().equal("Username", username)).stream().findFirst().orElse(null);
    }

}
