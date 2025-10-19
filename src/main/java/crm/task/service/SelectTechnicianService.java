package crm.task.service;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import crm.common.model.AccountRequest;
import crm.common.model.Staff;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.service_request.repository.persistence.query.common.Page;
import crm.service_request.repository.persistence.query.common.PageRequest;

public class SelectTechnicianService {
    private final int TECHEM_ROLE_ID = 6; 
    public List<Staff> getAllTechnicians(EntityManager entityManager) throws SQLException {
        try {
            String sql = "SELECT s.* FROM Staff s " +
                    "INNER JOIN Account a ON s.Username = a.Username " +
                    "WHERE a.RoleID = ?";

            List<Object> params = new ArrayList<>();
            params.add(TECHEM_ROLE_ID);

            crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO sqlParams = new crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO(
                    sql, params);

            List<Staff> allStaff = entityManager.executeQuery(sqlParams, Staff.class);
            System.out.println("[DEBUG] getAllTechnicians: Found " + (allStaff != null ? allStaff.size() : 0)
                    + " technicians with roleId=" + TECHEM_ROLE_ID);
            return allStaff;
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to retrieve technicians", e);
        }
    }

    public Page<Staff> getTechniciansPaginated(EntityManager entityManager, int page, int size) throws SQLException {
        try {
            int offset = (page - 1) * size;

            List<Staff> allTechnicians = getAllTechnicians(entityManager);
            int totalCount = allTechnicians.size();

            List<Staff> paginatedList = new ArrayList<>();
            int startIndex = offset;
            int endIndex = Math.min(startIndex + size, totalCount);

            for (int i = startIndex; i < endIndex; i++) {
                paginatedList.add(allTechnicians.get(i));
            }

            PageRequest pageRequest = new PageRequest(page, size);
            Page<Staff> pageResult = new Page<>(totalCount, pageRequest, paginatedList);

            return pageResult;
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to retrieve paginated technicians", e);
        }
    }

    public int getTechnicianCount(EntityManager entityManager) throws SQLException {
        try {
            List<Staff> allTechnicians = getAllTechnicians(entityManager);
            return allTechnicians.size();
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to count technicians", e);
        }
    }

    public Page<Staff> getTechniciansWithFilters(EntityManager entityManager, String searchName, String location,
            String ageRange, int page, int size) throws SQLException {
        try {
            List<Staff> allTechnicians = getAllTechnicians(entityManager);
            List<Staff> filteredTechnicians = new ArrayList<>();

            for (Staff staff : allTechnicians) {
                boolean matches = true;

                if (searchName != null && !searchName.trim().isEmpty()) {
                    if (staff.getStaffName() == null
                            || !staff.getStaffName().toLowerCase().contains(searchName.toLowerCase())) {
                        matches = false;
                    }
                }

                if (location != null && !location.trim().isEmpty()) {
                    if (staff.getAddress() == null
                            || !staff.getAddress().toLowerCase().contains(location.toLowerCase())) {
                        matches = false;
                    }
                }

                if (ageRange != null && !ageRange.trim().isEmpty() && staff.getDateOfBirth() != null) {
                    int age = calculateAge(staff.getDateOfBirth());
                    if (!matchesAgeRange(age, ageRange)) {
                        matches = false;
                    }
                }

                if (matches) {
                    filteredTechnicians.add(staff);
                }
            }

            int totalCount = filteredTechnicians.size();
            int offset = (page - 1) * size;
            int startIndex = offset;
            int endIndex = Math.min(startIndex + size, totalCount);

            List<Staff> paginatedList = new ArrayList<>();
            for (int i = startIndex; i < endIndex; i++) {
                paginatedList.add(filteredTechnicians.get(i));
            }

            PageRequest pageRequest = new PageRequest(page, size);
            Page<Staff> pageResult = new Page<>(totalCount, pageRequest, paginatedList);

            return pageResult;
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to retrieve filtered technicians", e);
        }
    }

    public List<String> getAvailableLocations(EntityManager entityManager) throws SQLException {
        try {
            List<Staff> allTechnicians = getAllTechnicians(entityManager);
            List<String> locations = new ArrayList<>();

            for (Staff staff : allTechnicians) {
                if (staff.getAddress() != null && !staff.getAddress().trim().isEmpty()) {
                    String location = staff.getAddress().trim();
                    if (!locations.contains(location)) {
                        locations.add(location);
                    }
                }
            }

            return locations;
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to retrieve available locations", e);
        }
    }

    public int calculateAge(LocalDate dateOfBirth) {
        if (dateOfBirth == null)
            return 0;

        LocalDate currentDate = LocalDate.now();
        long timeDiff = currentDate.getYear() - dateOfBirth.getYear();
        return (int) timeDiff;
    }

    public boolean matchesAgeRange(int age, String ageRange) {
        if (ageRange == null || ageRange.trim().isEmpty())
            return true;

        switch (ageRange) {
            case "18-25":
                return age >= 18 && age <= 25;
            case "26-35":
                return age >= 26 && age <= 35;
            case "36-45":
                return age >= 36 && age <= 45;
            case "46-55":
                return age >= 46 && age <= 55;
            case "56+":
                return age >= 56;
            default:
                return true;
        }
    }

    public Integer getNextAccountRequestId(EntityManager entityManager) throws Exception {
        List<AccountRequest> allRequests = entityManager.findAll(AccountRequest.class);
        if (allRequests.isEmpty()) {
            return 1;
        }
        
        Integer maxId = allRequests.stream()
            .map(AccountRequest::getAccountRequestID)
            .filter(id -> id != null)
            .max(Integer::compareTo)
            .orElse(0);
            
        return maxId + 1;
    }
}
