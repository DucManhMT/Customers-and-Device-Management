package crm.service_request.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ViewListRequestController", urlPatterns = { "/requests/list" })
public class ViewListRequestController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int page = 1;
            int recordsPerPage = 15;
            if (req.getParameter("page") != null)
                page = Integer.parseInt(req.getParameter("page"));
            req.setAttribute("currentPage", page);

            req.getRequestDispatcher("/request-list.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Something went wrong while displaying requests!");
            req.getRequestDispatcher("/request-list.jsp").forward(req, resp);
        }
    }
}
