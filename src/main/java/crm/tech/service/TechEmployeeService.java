package crm.tech.service;

import crm.common.model.Staff;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.service_request.repository.persistence.query.common.Page;
import crm.service_request.repository.persistence.query.common.PageRequest;
import crm.tech.dao.TechEmployeeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class TechEmployeeService {
    private final TechEmployeeDAO techEmployeeDAO = new TechEmployeeDAO();

    public void setEntityManager(EntityManager entityManager) {
        techEmployeeDAO.setEntityManager(entityManager);
    }

    public Page<Staff> getTechEmployeesPaginated(int page, int size) throws SQLException {
        try {
            List<Staff> allTechEmployees = techEmployeeDAO.findAllActiveTechEmployees();
            int totalCount = allTechEmployees.size();

            int offset = (page - 1) * size;
            int startIndex = offset;
            int endIndex = Math.min(startIndex + size, totalCount);

            List<Staff> paginatedList = new ArrayList<>();
            for (int i = startIndex; i < endIndex; i++) {
                paginatedList.add(allTechEmployees.get(i));
            }

            PageRequest pageRequest = new PageRequest(page, size);
            Page<Staff> pageResult = new Page<>(totalCount, pageRequest, paginatedList);

            System.out.println("[Service] getTechEmployeesPaginated: Page " + page + "/" + 
                    pageResult.getTotalPages() + ", Size " + size + ", Total " + totalCount);

            return pageResult;
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to retrieve paginated tech employees", e);
        }
    }

    public Staff getTechEmployeeById(int staffId) throws SQLException {
        return techEmployeeDAO.findTechEmployeeById(staffId);
    }


    public int getTechEmployeeCount() throws SQLException {
        return techEmployeeDAO.countActiveTechEmployees();
    }

    public Page<Staff> getTechEmployeesWithFilters(String searchName, String location,
            String ageRange, int page, int size) throws SQLException {
        try {
            List<Staff> allTechEmployees = techEmployeeDAO.findAllActiveTechEmployees();
            List<Staff> filteredEmployees = applyFilters(allTechEmployees, searchName, location, ageRange);

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

            System.out.println("[Service] getTechEmployeesWithFilters: Filtered " + totalCount + 
                    " from " + allTechEmployees.size() + " total");

            return pageResult;
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to retrieve filtered tech employees", e);
        }
    }

    private List<Staff> applyFilters(List<Staff> staffList, String searchName, String location, String ageRange) {
        List<Staff> filteredEmployees = new ArrayList<>();

        for (Staff staff : staffList) {
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
                filteredEmployees.add(staff);
            }
        }

        return filteredEmployees;
    }


    public List<String> getAvailableLocations() throws SQLException {
        return techEmployeeDAO.findAllLocations();
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

    public void showTechEmployeesList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int page = parseIntParam(req.getParameter("page"), 1);
        int recordsPerPage = parseIntParam(req.getParameter("recordsPerPage"), 10);

        String searchName = req.getParameter("searchName");
        String location = req.getParameter("location");
        String ageRange = req.getParameter("ageRange");

        try {
            boolean hasFilterApplied = hasFilters(searchName, location, ageRange);

            Page<Staff> techEmployeePage;
            int totalCount;

            if (hasFilterApplied) {
                techEmployeePage = getTechEmployeesWithFilters(searchName, location, ageRange, page,
                        recordsPerPage);
                totalCount = (int) techEmployeePage.getTotalElements();
            } else {
                techEmployeePage = getTechEmployeesPaginated(page, recordsPerPage);
                totalCount = getTechEmployeeCount();
            }

            List<String> availableLocations = getAvailableLocations();

            setListAttributes(req, techEmployeePage, page, recordsPerPage, totalCount, availableLocations,
                    searchName, location, ageRange);

            req.getRequestDispatcher("/technician_leader/view_technician_list.jsp").forward(req, resp);

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Failed to load tech employees: " + e.getMessage());
            req.getRequestDispatcher("/technician_leader/view_technician_list.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Unexpected error: " + e.getMessage());
            req.getRequestDispatcher("/technician_leader/view_technician_list.jsp").forward(req, resp);
        }
    }

    public void showTechEmployeeDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException, Exception {

        String staffIdStr = req.getParameter("id");
        System.out.println("=== TechEmployeeController Detail Debug ===");
        System.out.println("Staff ID parameter: " + staffIdStr);

        if (staffIdStr == null || staffIdStr.trim().isEmpty()) {
            System.out.println("Staff ID is null or empty, sending BAD_REQUEST");
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Staff ID is required");
            return;
        }

        try {
            Integer staffId = Integer.parseInt(staffIdStr);
            System.out.println("Parsed staff ID: " + staffId);

            Staff techEmployee = getTechEmployeeById(staffId);
            System.out.println(
                    "Retrieved tech employee: " + (techEmployee != null ? techEmployee.getStaffName() : "null"));

            if (techEmployee == null) {
                System.out.println("Tech employee not found, sending NOT_FOUND");
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Tech employee not found");
                return;
            }

            req.setAttribute("techEmployee", techEmployee);
            req.getRequestDispatcher("/technician_leader/tech_employee_detail.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            System.out.println("NumberFormatException: " + e.getMessage());
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid staff ID format");
        } catch (SQLException e) {
            System.out.println("SQLException: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("errorMessage", "Failed to load tech employee details: " + e.getMessage());
            req.getRequestDispatcher("/technician_leader/view_technician_list.jsp").forward(req, resp);
        }
        System.out.println("=== End TechEmployeeController Detail Debug ===");
    }

    private int parseIntParam(String param, int defaultValue) {
        if (param == null || param.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(param);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private boolean hasFilters(String searchName, String location, String ageRange) {
        return (searchName != null && !searchName.trim().isEmpty()) ||
                (location != null && !location.trim().isEmpty()) ||
                (ageRange != null && !ageRange.trim().isEmpty());
    }

    private void setListAttributes(HttpServletRequest req, Page<Staff> techEmployeePage, int page,
            int recordsPerPage, int totalCount, List<String> availableLocations,
            String searchName, String location, String ageRange) {

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
    }
}