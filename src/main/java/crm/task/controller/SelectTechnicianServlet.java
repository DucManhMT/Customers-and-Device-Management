package crm.task.controller;

import crm.common.URLConstants;
import crm.common.model.Staff;
import crm.common.model.Request;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.config.DBcontext;
import crm.service_request.repository.persistence.query.common.Page;
import crm.task.service.SelectTechnicianService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name="SelectTechnician", urlPatterns = { URLConstants.TECHLEAD_SELECT_TECHNICIAN})
public class SelectTechnicianServlet extends HttpServlet {

    SelectTechnicianService selectTechnicianService = new SelectTechnicianService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        handleRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        handleRequest(request, response);
    }

    private void handleRequest(HttpServletRequest request, HttpServletResponse response) 
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
                technicianPage = selectTechnicianService.getTechniciansWithFilters(entityManager, searchName, location, ageRange, page, recordsPerPage);
                totalCount = (int) technicianPage.getTotalElements();
            } else {
                technicianPage = selectTechnicianService.getTechniciansPaginated(entityManager, page, recordsPerPage);
                totalCount = selectTechnicianService.getTechnicianCount(entityManager);
            }

            List<String> availableLocations = selectTechnicianService.getAvailableLocations(entityManager);
            
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



}