package crm.service_request.controller;

import java.io.IOException;

import crm.common.model.Request;
import crm.service_request.repository.persistence.query.common.Page;
import crm.service_request.service.RequestService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ViewListRequestController", urlPatterns = { "/supporter/requests/list" })
public class ViewListRequestController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        RequestService requestService = new RequestService();
        try {
            // Default values, magic numbers should be avoided in future
            int page = 1;
            int recordsPerPage = 15;
            if (req.getParameter("page") != null)
                page = Integer.parseInt(req.getParameter("page"));
            if (req.getParameter("recordsPerPage") != null)
                recordsPerPage = Integer.parseInt(req.getParameter("recordsPerPage"));
            String field = req.getParameter("field");
            String sort = req.getParameter("sort");

            String status = req.getParameter("status");
            String customerName = req.getParameter("customerName");
            String description = req.getParameter("description");

            Page<Request> requestPage = requestService.getRequests(customerName, field, sort, description, status, 0,
                    page, recordsPerPage);

            req.setAttribute("currentPage", page);
            req.setAttribute("recordsPerPage", recordsPerPage);
            req.setAttribute("totalPages", requestPage.getTotalPages());
            req.setAttribute("totalRecords", requestPage.getTotalElements());
            req.setAttribute("field", field);
            req.setAttribute("sort", sort);
            req.setAttribute("status", status);
            req.setAttribute("requests", requestPage.getContent());
            req.setAttribute("isFirstPage", requestPage.isFirst());
            req.setAttribute("isLastPage", requestPage.isLast());

        } catch (Exception e) {
            req.setAttribute("error", "Something went wrong while displaying requests!");
        }

        req.getRequestDispatcher("/service_request/view-request-list.jsp").forward(req, resp);
    }
}
