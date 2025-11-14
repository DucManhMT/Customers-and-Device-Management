package crm.tech.repository;

import crm.common.model.Staff;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TechEmployeeDAO {
    private static final int TECHEM_ROLE_ID = 6;
    private EntityManager entityManager;

    public void setEntityManager(EntityManager entityManager) {
        this.entityManager = entityManager;
    }

    public List<Staff> findAllActiveTechEmployees() throws SQLException {
        try {
            String sql = "SELECT s.* FROM Staff s " +
                    "INNER JOIN Account a ON s.Username = a.Username " +
                    "WHERE a.RoleID = ? AND a.AccountStatus = 'Active'";

            List<Object> params = new ArrayList<>();
            params.add(TECHEM_ROLE_ID);

            SqlAndParamsDTO sqlParams = new SqlAndParamsDTO(sql, params);
            List<Staff> staffList = entityManager.executeQuery(sqlParams, Staff.class);

            System.out.println("[DAO] findAllActiveTechEmployees: Found " +
                    (staffList != null ? staffList.size() : 0) + " active technicians");

            return staffList != null ? staffList : new ArrayList<>();
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to retrieve active tech employees", e);
        }
    }

    public Staff findTechEmployeeById(int staffId) throws SQLException {
        try {
            String sql = "SELECT s.* FROM Staff s " +
                    "INNER JOIN Account a ON s.Username = a.Username " +
                    "WHERE s.StaffID = ? AND a.RoleID = ?";

            List<Object> params = new ArrayList<>();
            params.add(staffId);
            params.add(TECHEM_ROLE_ID);

            SqlAndParamsDTO sqlParams = new SqlAndParamsDTO(sql, params);
            List<Staff> staffList = entityManager.executeQuery(sqlParams, Staff.class);

            System.out.println("[DAO] findTechEmployeeById: StaffID=" + staffId +
                    ", Found=" + (staffList != null && !staffList.isEmpty()));

            return (staffList != null && !staffList.isEmpty()) ? staffList.get(0) : null;
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to retrieve tech employee by ID", e);
        }
    }

    public int countActiveTechEmployees() throws SQLException {
        try {
            List<Staff> allTechEmployees = findAllActiveTechEmployees();
            return allTechEmployees.size();
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to count tech employees", e);
        }
    }

    public List<String> findAllLocations() throws SQLException {
        try {
            List<Staff> allTechEmployees = findAllActiveTechEmployees();
            List<String> locations = new ArrayList<>();

            for (Staff staff : allTechEmployees) {
                if (staff.getAddress() != null && !staff.getAddress().trim().isEmpty()) {
                    String location = staff.getAddress().trim();
                    if (!locations.contains(location)) {
                        locations.add(location);
                    }
                }
            }

            System.out.println("[DAO] findAllLocations: Found " + locations.size() + " unique locations");
            return locations;
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to retrieve available locations", e);
        }
    }
}
