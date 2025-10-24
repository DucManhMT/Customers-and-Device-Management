package crm.task.service;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import crm.common.model.AccountRequest;
import crm.common.model.Request;
import crm.common.model.Staff;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.service_request.repository.persistence.query.common.Page;
import crm.service_request.repository.persistence.query.common.PageRequest;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class SelectTechnicianService {
    private final int TECHEM_ROLE_ID = 6; 
    public void handleRequest(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {

       String[] selectedTaskIds = request.getParameterValues("selectedTasks");
       if (selectedTaskIds == null) {
           selectedTaskIds = (String[]) request.getSession().getAttribute("selectedTaskIds");
       }

       System.out.println("SelectTechnicianServlet: selectedTaskIds = " +
           (selectedTaskIds != null ? Arrays.toString(selectedTaskIds) : "null"));

       if (selectedTaskIds == null || selectedTaskIds.length == 0) {
           System.out.println("SelectTechnicianServlet: No tasks selected, sending error");
           response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No tasks selected");
           return;
       }

       int page = 1;
       int recordsPerPage = 10;
       String searchName = request.getParameter("searchName");
       String location = request.getParameter("location");
       String ageRange = request.getParameter("ageRange");

       try {
           if (request.getParameter("page") != null) {
               page = Integer.parseInt(request.getParameter("page"));
           }
           if (request.getParameter("recordsPerPage") != null) {
               recordsPerPage = Integer.parseInt(request.getParameter("recordsPerPage"));
           }
       } catch (NumberFormatException e) {
       }

       try (Connection connection = DBcontext.getConnection()) {
           EntityManager entityManager = new EntityManager(connection);

           List<Integer> taskIds = Arrays.stream(selectedTaskIds)
               .map(Integer::parseInt)
               .collect(Collectors.toList());

           List<Request> selectedRequests = taskIds.stream()
               .map(id -> entityManager.find(Request.class, id))
               .collect(Collectors.toList());

           Page<Staff> technicianPage;
           int totalCount;

           boolean hasFilters = (searchName != null && !searchName.trim().isEmpty()) ||
                   (location != null && !location.trim().isEmpty()) ||
                   (ageRange != null && !ageRange.trim().isEmpty());

           if (hasFilters) {
               technicianPage = getTechniciansWithFilters(entityManager, searchName, location, ageRange, page, recordsPerPage);
               totalCount = (int) technicianPage.getTotalElements();
           } else {
               technicianPage = getTechniciansPaginated(entityManager, page, recordsPerPage);
               totalCount = getTechnicianCount(entityManager);
           }

           List<String> availableLocations = getAvailableLocations(entityManager);

           System.out.println("SelectTechnicianServlet: Found " + technicianPage.getContent().size() + " technicians");
           System.out.println("SelectTechnicianServlet: Found " + selectedRequests.size() + " requests");

           request.setAttribute("technicians", technicianPage.getContent());
           request.setAttribute("selectedRequests", selectedRequests);
           request.setAttribute("selectedTaskIds", selectedTaskIds);
           request.setAttribute("currentPage", page);
           request.setAttribute("totalPages", technicianPage.getTotalPages());
           request.setAttribute("recordsPerPage", recordsPerPage);
           request.setAttribute("totalCount", totalCount);
           request.setAttribute("availableLocations", availableLocations);
           request.setAttribute("searchName", searchName);
           request.setAttribute("selectedLocation", location);
           request.setAttribute("selectedAgeRange", ageRange);

           request.getRequestDispatcher("/technician_leader/select_technician.jsp").forward(request, response);

       } catch (Exception e) {
           e.printStackTrace();
           response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
               "Error loading technicians: " + e.getMessage());
       }
   }

   private List<Staff> getAllTechnicians(EntityManager entityManager) throws SQLException {
       try {
           String sql = "SELECT s.* FROM Staff s " +
                       "INNER JOIN Account a ON s.Username = a.Username " +
                       "WHERE a.RoleID = ?";

           List<Object> params = new ArrayList<>();
           params.add(TECHEM_ROLE_ID);

           crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO sqlParams =
               new crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO(sql, params);

           List<Staff> allStaff = entityManager.executeQuery(sqlParams, Staff.class);
           System.out.println("[DEBUG] getAllTechnicians: Found " + (allStaff != null ? allStaff.size() : 0) + " technicians with roleId=" + TECHEM_ROLE_ID);
           return allStaff;
       } catch (Exception e) {
           e.printStackTrace();
           throw new SQLException("Failed to retrieve technicians", e);
       }
   }

   private Page<Staff> getTechniciansPaginated(EntityManager entityManager, int page, int size) throws SQLException {
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

           System.out.println("[DEBUG] getTechniciansPaginated: Page " + page + ", Size " + size + ", Found " + paginatedList.size() + " technicians");
           return pageResult;
       } catch (Exception e) {
           e.printStackTrace();
           throw new SQLException("Failed to retrieve paginated technicians", e);
       }
   }

   private int getTechnicianCount(EntityManager entityManager) throws SQLException {
       try {
           List<Staff> allTechnicians = getAllTechnicians(entityManager);
           return allTechnicians.size();
       } catch (Exception e) {
           e.printStackTrace();
           throw new SQLException("Failed to count technicians", e);
       }
   }

   private Page<Staff> getTechniciansWithFilters(EntityManager entityManager, String searchName, String location, String ageRange, int page, int size) throws SQLException {
       try {
           List<Staff> allTechnicians = getAllTechnicians(entityManager);
           List<Staff> filteredTechnicians = new ArrayList<>();

           for (Staff staff : allTechnicians) {
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

           System.out.println("[DEBUG] getTechniciansWithFilters: searchName='" + searchName + "', location='" + location + "', ageRange='" + ageRange + "', Page " + page + ", Size " + size + ", Found " + paginatedList.size() + " technicians");
           return pageResult;
       } catch (Exception e) {
           e.printStackTrace();
           throw new SQLException("Failed to retrieve filtered technicians", e);
       }
   }

   private List<String> getAvailableLocations(EntityManager entityManager) throws SQLException {
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

   private int calculateAge(LocalDate dateOfBirth) {
       if (dateOfBirth == null) return 0;

       LocalDate currentDate = LocalDate.now();
       long timeDiff = ChronoUnit.DAYS.between(dateOfBirth, currentDate);
       return (int) (timeDiff / 365.25);
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
