package crm.tech.controller;

import crm.common.URLConstants;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.tech.service.TechEmployeeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;

@WebServlet(name = "ViewTechEmployeeList", urlPatterns = { URLConstants.TECHLEAD_VIEW_TECHEM_LIST })
public class ViewTechEmployeeList extends HttpServlet {
    private final TechEmployeeService techEmployeeService = new TechEmployeeService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        try (Connection connection = DBcontext.getConnection()) {
            EntityManager entityManager = new EntityManager(connection);
            techEmployeeService.setEntityManager(entityManager);
            
            techEmployeeService.showTechEmployeesList(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            req.getRequestDispatcher("/technician_leader/view_technician_list.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        try (Connection connection = DBcontext.getConnection()) {
            EntityManager entityManager = new EntityManager(connection);
            techEmployeeService.setEntityManager(entityManager);
            
            techEmployeeService.showTechEmployeesList(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            req.getRequestDispatcher("/technician_leader/view_technician_list.jsp").forward(req, resp);
        }
    }
}