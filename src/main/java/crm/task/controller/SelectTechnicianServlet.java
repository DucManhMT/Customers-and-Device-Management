package crm.task.controller;

import crm.task.service.SelectTechnicianService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/task/selectTechnician")
public class SelectTechnicianServlet extends HttpServlet {
    SelectTechnicianService selectTechnicianService = new SelectTechnicianService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        selectTechnicianService.handleRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        selectTechnicianService.handleRequest(request, response);
    }

}
