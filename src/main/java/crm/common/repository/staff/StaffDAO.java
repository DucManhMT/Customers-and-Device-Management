package crm.common.repository.staff;

import crm.common.model.Staff;
import crm.common.repository.FuntionalityDAO;
import crm.core.repository.hibernate.entitymanager.EntityManager;

import java.util.List;

public class StaffDAO extends FuntionalityDAO<Staff> {

    public StaffDAO() {
        super(Staff.class);
    }

    public Staff findByUsername(String username) {
        List<Staff> staffs = findAll();

        for (Staff staff : staffs) {
            if (staff.getAccount().getUsername().equals(username)) {
                return staff;
            }
        }

        return null;
    }
}
