package crm.tech.controller;

import crm.common.model.Staff;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.config.DBcontext;
import crm.service_request.repository.persistence.query.common.Page;
import crm.service_request.repository.persistence.query.common.PageRequest;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "TechEmployeeController", urlPatterns = { "/tech/employees", "/tech/employees/view" })
public class TechEmployeeController extends HttpServlet {

    private static final int TECH_ROLE_ID = 6;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = getAction(req);

        try {
            switch (action) {
                case "employees":
                    showTechEmployeesList(req, resp);
                    break;
                case "view":
                    showTechEmployeeDetail(req, resp);
                    break;
                default:
                    showTechEmployeesList(req, resp);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            req.getRequestDispatcher("/technician_leader/viewTechnicianList.jsp").forward(req, resp);
        }
    }

    
     @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = getAction(req);

        try {
            switch (action) {
                case "employees":
                    showTechEmployeesList(req, resp);
                    break;
                case "view":
                    showTechEmployeeDetail(req, resp);
                    break;
                default:
                    showTechEmployeesList(req, resp);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            req.getRequestDispatcher("/technician_leader/viewTechnicianList.jsp").forward(req, resp);
        }
    }

    private String getAction(HttpServletRequest req) {
        String pathInfo = req.getPathInfo();
        String servletPath = req.getServletPath();

        if (servletPath.contains("/tech/employees/")) {
            String action = servletPath.substring(servletPath.lastIndexOf("/") + 1);
            return action;
        }

        if (pathInfo == null || pathInfo.equals("/")) {
            return "employees";
        }

        return pathInfo.substring(1);
    }

    private void showTechEmployeesList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException, Exception {

        int page = 1;
        int recordsPerPage = 10;

        String searchName = req.getParameter("searchName");
        String location = req.getParameter("location");
        String ageRange = req.getParameter("ageRange");


        try {
            if (req.getParameter("page") != null) {
                page = Integer.parseInt(req.getParameter("page"));
            }
            if (req.getParameter("recordsPerPage") != null) {
                recordsPerPage = Integer.parseInt(req.getParameter("recordsPerPage"));
            }
        } catch (NumberFormatException e) {
        }


        try (Connection connection = DBcontext.getConnection()) {
            EntityManager entityManager = new EntityManager(connection);
            
            Page<Staff> techEmployeePage;
            int totalCount;

            boolean hasFilters = (searchName != null && !searchName.trim().isEmpty()) ||
                    (location != null && !location.trim().isEmpty()) ||
                    (ageRange != null && !ageRange.trim().isEmpty());

            if (hasFilters) {
                techEmployeePage = getTechEmployeesWithFilters(entityManager, searchName, location, ageRange, page, recordsPerPage);
                totalCount = (int) techEmployeePage.getTotalElements();
            } else {
                techEmployeePage = getTechEmployeesPaginated(entityManager, page, recordsPerPage);
                totalCount = getTechEmployeeCount(entityManager);
            }

            List<String> availableLocations = getAvailableLocations(entityManager);

            req.setAttribute("techEmployees", techEmployeePage.getContent());
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", techEmployeePage.getTotalPages());
            req.setAttribute("recordsPerPage", recordsPerPage);
            req.setAttribute("pageSize", recordsPerPage);
            req.setAttribute("totalRecords", techEmployeePage.getTotalElements());
            req.setAttribute("totalCount", totalCount);
            req.setAttribute("availableLocations", availableLocations);

            req.setAttribute("searchName", searchName);
            req.setAttribute("selectedLocation", location);
            req.setAttribute("selectedAgeRange", ageRange);
            req.getRequestDispatcher("/technician_leader/viewTechnicianList.jsp").forward(req, resp);

        } catch (SQLException e) {
            req.setAttribute("errorMessage", "Failed to load tech employees: " + e.getMessage());
        } catch (Exception e) {
            req.setAttribute("errorMessage", "Unexpected error: " + e.getMessage());
        }

        
    }

    private void showTechEmployeeDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException, Exception {

        String staffIdStr = req.getParameter("id");
        System.out.println("=== TechEmployeeController Detail Debug ===");
        System.out.println("Staff ID parameter: " + staffIdStr);
        
        if (staffIdStr == null || staffIdStr.trim().isEmpty()) {
            System.out.println("Staff ID is null or empty, sending BAD_REQUEST");
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Staff ID is required");
            return;
        }

        try (Connection connection = DBcontext.getConnection()) {
            EntityManager entityManager = new EntityManager(connection);
            
            Integer staffId = Integer.parseInt(staffIdStr);
            System.out.println("Parsed staff ID: " + staffId);

            Staff techEmployee = getTechEmployeeById(entityManager, staffId);
            System.out.println("Retrieved tech employee: " + (techEmployee != null ? techEmployee.getStaffName() : "null"));
            
            if (techEmployee == null) {
                System.out.println("Tech employee not found, sending NOT_FOUND");
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Tech employee not found");
                return;
            }

            req.setAttribute("techEmployee", techEmployee);
            System.out.println("Forwarding to techEmployeeDetail.jsp");
            req.getRequestDispatcher("/tech/techEmployeeDetail.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            System.out.println("NumberFormatException: " + e.getMessage());
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid staff ID format");
        } catch (SQLException e) {
            System.out.println("SQLException: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("errorMessage", "Failed to load tech employee details: " + e.getMessage());
            req.getRequestDispatcher("/technician_leader/viewTechnicianList.jsp").forward(req, resp);
        }
        System.out.println("=== End TechEmployeeController Detail Debug ===");
    }

    private List<Staff> getAllTechEmployees(EntityManager entityManager) throws SQLException {
        try {
            String sql = "SELECT s.* FROM Staff s " +
                        "INNER JOIN Account a ON s.Username = a.Username " +
                        "WHERE a.RoleID = ?";
            
            List<Object> params = new ArrayList<>();
            params.add(TECH_ROLE_ID);
            
            crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO sqlParams = 
                new crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO(sql, params);
            
            List<Staff> allStaff = entityManager.executeQuery(sqlParams, Staff.class);
            System.out.println("[DEBUG] getAllTechEmployees: Found " + (allStaff != null ? allStaff.size() : 0) + " technicians with roleId=" + TECH_ROLE_ID);
            return allStaff;
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to retrieve tech employees", e);
        }
    }

    private Page<Staff> getTechEmployeesPaginated(EntityManager entityManager, int page, int size) throws SQLException {
        try {
            int offset = (page - 1) * size;
            
            List<Staff> allTechEmployees = getAllTechEmployees(entityManager);
            int totalCount = allTechEmployees.size();
            
            List<Staff> paginatedList = new ArrayList<>();
            int startIndex = offset;
            int endIndex = Math.min(startIndex + size, totalCount);
            
            for (int i = startIndex; i < endIndex; i++) {
                paginatedList.add(allTechEmployees.get(i));
            }
            
            PageRequest pageRequest = new PageRequest(page, size);
            Page<Staff> pageResult = new Page<>(totalCount, pageRequest, paginatedList);
            
            System.out.println("[DEBUG] getTechEmployeesPaginated: Page " + page + ", Size " + size + ", Found " + paginatedList.size() + " technicians");
            return pageResult;
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to retrieve paginated tech employees", e);
        }
    }

    private Staff getTechEmployeeById(EntityManager entityManager, int staffId) throws SQLException {
        try {
            String sql = "SELECT s.* FROM Staff s " +
                        "INNER JOIN Account a ON s.Username = a.Username " +
                        "WHERE s.StaffID = ? AND a.RoleID = ?";
            
            List<Object> params = new ArrayList<>();
            params.add(staffId);
            params.add(TECH_ROLE_ID);
            
            crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO sqlParams = 
                new crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO(sql, params);
            
            List<Staff> staffList = entityManager.executeQuery(sqlParams, Staff.class);
            if (staffList != null && !staffList.isEmpty()) {
                return staffList.get(0);
            }
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to retrieve tech employee by ID", e);
        }
    }

    private int getTechEmployeeCount(EntityManager entityManager) throws SQLException {
        try {
            List<Staff> allTechEmployees = getAllTechEmployees(entityManager);
            return allTechEmployees.size();
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to count tech employees", e);
        }
    }

    private Page<Staff> getTechEmployeesWithFilters(EntityManager entityManager, String searchName, String location, String ageRange, int page, int size) throws SQLException {
        try {
            List<Staff> allTechEmployees = getAllTechEmployees(entityManager);
            List<Staff> filteredEmployees = new ArrayList<>();
            
            for (Staff staff : allTechEmployees) {
                boolean matches = true;
                
                if (searchName != null && !searchName.trim().isEmpty()) {
                    if (staff.getStaffName() == null || !staff.getStaffName().toLowerCase().contains(searchName.toLowerCase())) {
                        matches = false;
                    }
                }

                if (location != null && !location.trim().isEmpty()) {
                    if (staff.getAddress() == null || !staff.getAddress().toLowerCase().contains(location.toLowerCase())) {
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
                    filteredEmployees.add(staff);
                }
            }
            
            int totalCount = filteredEmployees.size();
            int offset = (page - 1) * size;
            int startIndex = offset;
            int endIndex = Math.min(startIndex + size, totalCount);
            
            List<Staff> paginatedList = new ArrayList<>();
            for (int i = startIndex; i < endIndex; i++) {
                paginatedList.add(filteredEmployees.get(i));
            }
            
            PageRequest pageRequest = new PageRequest(page, size);
            Page<Staff> pageResult = new Page<>(totalCount, pageRequest, paginatedList);
            
            System.out.println("[DEBUG] getTechEmployeesWithFilters: searchName='" + searchName + "', location='" + location + "', ageRange='" + ageRange + "', Page " + page + ", Size " + size + ", Found " + paginatedList.size() + " technicians");
            return pageResult;
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to retrieve filtered tech employees", e);
        }
    }

    private List<String> getAvailableLocations(EntityManager entityManager) throws SQLException {
        try {
            List<Staff> allTechEmployees = getAllTechEmployees(entityManager);
            List<String> locations = new ArrayList<>();
            
            for (Staff staff : allTechEmployees) {
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

    private int calculateAge(java.sql.Date dateOfBirth) {
        if (dateOfBirth == null) return 0;
        
        java.util.Date currentDate = new java.util.Date();
        long timeDiff = currentDate.getTime() - dateOfBirth.getTime();
        return (int) (timeDiff / (365.25 * 24 * 60 * 60 * 1000));
    }

    private boolean matchesAgeRange(int age, String ageRange) {
        if (ageRange == null || ageRange.trim().isEmpty()) return true;
        
        switch (ageRange) {
            case "18-25":
                return age >= 18 && age <= 25;
            case "26-35":
                return age >= 26 && age <= 35;
            case "36-45":
                return age >= 36 && age <= 45;
            case "46+":
                return age >= 46;
            default:
                return true;
        }
    }
}