package crm.task.service;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.DayOfWeek;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import java.util.HashMap;
import java.util.Map;

import crm.common.model.AccountRequest;
import crm.common.model.Request;
import crm.common.model.Staff;
import crm.common.model.Task;
import crm.common.model.enums.TaskStatus;
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
        int recordsPerPage = 5;
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

            // --- build weekly schedule data for calendar (after technicianPage is known) ---
            // weekStart param (yyyy-MM-dd) optional; default to current week's Monday
            LocalDate weekStartDate;
            String weekStartParam = request.getParameter("weekStart");
            if (weekStartParam != null && !weekStartParam.isEmpty()) {
                try {
                    weekStartDate = LocalDate.parse(weekStartParam);
                } catch (Exception ex) {
                    weekStartDate = LocalDate.now().with(DayOfWeek.MONDAY);
                }
            } else {
                weekStartDate = LocalDate.now().with(DayOfWeek.MONDAY);
            }

            LocalDate weekEndDate = weekStartDate.plusDays(6);
            LocalDateTime weekStartDateTime = weekStartDate.atStartOfDay();
            LocalDateTime weekEndDateTime = weekEndDate.plusDays(1).atStartOfDay(); // exclusive end

            DateTimeFormatter headerFmt = DateTimeFormatter.ofPattern("EEE dd-MM");
            List<String> weekDays = new ArrayList<>();
            for (int i = 0; i < 7; i++) {
                weekDays.add(weekStartDate.plusDays(i).format(headerFmt));
            }

            // Fetch all tasks within the week (startDate or deadline inside range)
            List<Task> weekTasks = getTasksForWeek(entityManager, weekStartDateTime, weekEndDateTime).stream().filter((t) ->
                    t.getStatus().equals(TaskStatus.Pending) || t.getStatus().equals(TaskStatus.Processing)
            ).collect(Collectors.toList());

            // Build map username -> List<String>(7) for each day cell
            Map<String, List<String>> techSchedules = new HashMap<>();
            // initialize map entries for current page technicians
            List<Staff> pageTechs = technicianPage.getContent();
            for (Staff s : pageTechs) {
                List<String> cells = new ArrayList<>();
                for (int i = 0; i < 7; i++) cells.add(null);
                String username = (s.getAccount() != null) ? s.getAccount().getUsername() : String.valueOf(s.getStaffID());
                techSchedules.put(username, cells);
            }

            DateTimeFormatter timeFmt = DateTimeFormatter.ofPattern("HH:mm");
            for (Task t : weekTasks) {
                Staff assigned = t.getAssignTo();
                if (assigned == null) continue;
                String username = (assigned.getAccount() != null) ? assigned.getAccount().getUsername() : String.valueOf(assigned.getStaffID());
                if (!techSchedules.containsKey(username)) {
                    List<String> cells = new ArrayList<>();
                    for (int i = 0; i < 7; i++) cells.add(null);
                    techSchedules.put(username, cells);
                }

                List<String> cells = techSchedules.get(username);

                // If task has a start date, put a start badge into the corresponding day cell
                if (t.getStartDate() != null) {
                    LocalDateTime sdt = t.getStartDate();
                    long sOffset = ChronoUnit.DAYS.between(weekStartDate, sdt.toLocalDate());
                    if (sOffset >= 0 && sOffset <= 6) {
                        int idx = (int) sOffset;
                        String existing = cells.get(idx);
                        String sTime = sdt.toLocalTime() != null ? sdt.toLocalTime().format(timeFmt) : "";
                        String sBadge = "<span class=\"schedule-badge schedule-start\">Start " + sTime + " - Task #" + t.getTaskID() + "</span>";
                        StringBuilder sb = new StringBuilder(existing != null ? existing : "");
                        if (sb.length() > 0) sb.append("<br/>");
                        sb.append(sBadge);
                        cells.set(idx, sb.toString());
                    }
                }

                // If task has a deadline, put a deadline badge into the corresponding day cell
                if (t.getDeadline() != null) {
                    LocalDateTime ddt = t.getDeadline();
                    long dOffset = ChronoUnit.DAYS.between(weekStartDate, ddt.toLocalDate());
                    if (dOffset >= 0 && dOffset <= 6) {
                        int idx = (int) dOffset;
                        String existing = cells.get(idx);
                        String dTime = ddt.toLocalTime() != null ? ddt.toLocalTime().format(timeFmt) : "";
                        String dBadge = "<span class=\"schedule-badge schedule-deadline\">Deadline " + dTime + " - Task #" + t.getTaskID() + "</span>";
                        StringBuilder sb = new StringBuilder(existing != null ? existing : "");
                        if (sb.length() > 0) sb.append("<br/>");
                        sb.append(dBadge);
                        cells.set(idx, sb.toString());
                    }
                }
            }

            // prev/next week params (iso date)
            String prevWeekStart = weekStartDate.minusDays(7).toString();
            String nextWeekStart = weekStartDate.plusDays(7).toString();

            System.out.println("SelectTechnicianServlet: Found " + technicianPage.getContent().size() + " technicians");
            System.out.println("SelectTechnicianServlet: Found " + selectedRequests.size() + " requests");

            request.setAttribute("technicians", technicianPage.getContent());
            request.setAttribute("selectedRequests", selectedRequests);
            request.setAttribute("selectedTaskIds", selectedTaskIds);
            request.setAttribute("weekDays", weekDays);
            request.setAttribute("techSchedules", techSchedules);
            request.setAttribute("prevWeekStart", prevWeekStart);
            request.setAttribute("nextWeekStart", nextWeekStart);
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

    private List<crm.common.model.Task> getTasksForWeek(EntityManager entityManager, LocalDateTime start, LocalDateTime end) throws SQLException {
        try {
            String sql = "SELECT t.* FROM Task t WHERE (t.StartDate >= ? AND t.StartDate < ?) OR (t.Deadline >= ? AND t.Deadline < ?)";
            List<Object> params = new ArrayList<>();
            params.add(start);
            params.add(end);
            params.add(start);
            params.add(end);

            crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO sqlParams = new crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO(sql, params);
            List<crm.common.model.Task> tasks = entityManager.executeQuery(sqlParams, crm.common.model.Task.class);
            return tasks != null ? tasks : new ArrayList<>();
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Failed to retrieve tasks for week", e);
        }
    }
}
