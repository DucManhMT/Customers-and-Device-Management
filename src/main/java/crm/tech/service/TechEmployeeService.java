package crm.tech.service;

import crm.common.model.Staff;
import crm.common.repository.staff.TechEmployeeDAO;
import crm.core.repository.persistence.config.TransactionManager;
import crm.core.repository.persistence.query.common.Page;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TechEmployeeService {
    
    private static final int TECH_ROLE_ID = 5;
    private TechEmployeeDAO techEmployeeDAO;
    
    public TechEmployeeService() {
        this.techEmployeeDAO = new TechEmployeeDAO();
    }
    
    public List<Staff> getAllTechEmployees() throws SQLException {
        try {
            TransactionManager.beginTransaction();
            List<Staff> techEmployees = techEmployeeDAO.findTechEmployeesByRoleId(TECH_ROLE_ID);
            TransactionManager.commit();
            return techEmployees;
        } catch (SQLException e) {
            TransactionManager.rollback();
            e.printStackTrace();
            throw new SQLException("Failed to retrieve tech employees", e);
        }
    }
    
    public Page<Staff> getTechEmployeesPaginated(int page, int size) throws SQLException {
        try {
            TransactionManager.beginTransaction();
            Page<Staff> techEmployeePage = techEmployeeDAO.findTechEmployeesPaginated(TECH_ROLE_ID, page, size);
            TransactionManager.commit();
            return techEmployeePage;
        } catch (SQLException e) {
            TransactionManager.rollback();
            e.printStackTrace();
            throw new SQLException("Failed to retrieve paginated tech employees", e);
        }
    }
    
    public Staff getTechEmployeeById(int staffId) throws SQLException {
        try {
            TransactionManager.beginTransaction();
            Staff techEmployee = techEmployeeDAO.findTechEmployeeById(staffId);
            TransactionManager.commit();
            return techEmployee;
        } catch (SQLException e) {
            TransactionManager.rollback();
            e.printStackTrace();
            throw new SQLException("Failed to retrieve tech employee by ID", e);
        }
    }
    
    public int getTechEmployeeCount() throws SQLException {
        try {
            TransactionManager.beginTransaction();
            List<Staff> allTechEmployees = techEmployeeDAO.findTechEmployeesByRoleId(TECH_ROLE_ID);
            TransactionManager.commit();
            return allTechEmployees.size();
        } catch (SQLException e) {
            TransactionManager.rollback();
            e.printStackTrace();
            throw new SQLException("Failed to count tech employees", e);
        }
    }
    
    public boolean isTechEmployee(String username) throws SQLException {
        try {
            TransactionManager.beginTransaction();
            List<Staff> techEmployees = techEmployeeDAO.findTechEmployeesByRoleId(TECH_ROLE_ID);
            TransactionManager.commit();
            
            return techEmployees.stream()
                    .anyMatch(staff -> username.equals(staff.getAccount().getUsername()));
        } catch (SQLException e) {
            TransactionManager.rollback();
            e.printStackTrace();
            throw new SQLException("Failed to check if user is tech employee", e);
        }
    }
    
    public Page<Staff> getTechEmployeesWithFilters(String searchName, String location, 
                                                  String ageRange, int page, int size) throws SQLException {
        try {
            TransactionManager.beginTransaction();
            Page<Staff> filteredTechEmployees = techEmployeeDAO.findTechEmployeesWithFilters(
                TECH_ROLE_ID, searchName, location, ageRange, page, size);
            TransactionManager.commit();
            return filteredTechEmployees;
        } catch (SQLException e) {
            TransactionManager.rollback();
            e.printStackTrace();
            throw new SQLException("Failed to retrieve filtered tech employees", e);
        }
    }
    
    public List<String> getAvailableLocations() throws SQLException {
        try {
            TransactionManager.beginTransaction();
            List<String> locations = techEmployeeDAO.getDistinctLocations(TECH_ROLE_ID);
            TransactionManager.commit();
            return locations;
        } catch (SQLException e) {
            TransactionManager.rollback();
            e.printStackTrace();
            throw new SQLException("Failed to retrieve available locations", e);
        }
    }
    
    public List<Staff> searchTechEmployees(String searchTerm) throws SQLException {
        try {
            TransactionManager.beginTransaction();
            Page<Staff> searchResults = techEmployeeDAO.findTechEmployeesWithFilters(
                TECH_ROLE_ID, searchTerm, null, null, 1, 10); 
            TransactionManager.commit();
            
            List<Staff> resultList = new ArrayList<Staff>();
            for (Staff staff : searchResults.getContent()) {
                resultList.add(staff);
            }
            return resultList;
        } catch (SQLException e) {
            TransactionManager.rollback();
            e.printStackTrace();
            throw new SQLException("Failed to search tech employees", e);
        }
    }
}