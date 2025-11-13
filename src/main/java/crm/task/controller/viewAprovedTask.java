package crm.task.controller;

import crm.common.MessageConst;
import crm.common.URLConstants;
import crm.service_request.repository.persistence.query.common.Page;
import crm.service_request.service.RequestService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.DateTimeException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import crm.common.model.Request;
import crm.common.model.enums.RequestStatus;

@WebServlet(name = "viewAprovedTask", urlPatterns = {URLConstants.TECHLEAD_VIEW_APROVED_TASK})
public class viewAprovedTask extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final RequestService requestService = new RequestService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processRequest(req, resp);
    }

    private void processRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String phone = req.getParameter("phoneFilter");
        String customerName = req.getParameter("customerFilter");
        String statusFilter = req.getParameter("statusFilter");
        String fromDateString = req.getParameter("fromDate");
        String toDateString = req.getParameter("toDate");
        String pageSizeParam = req.getParameter("pageSize");
        String pageNumberParam = req.getParameter("page");

        int pageSize = 15;
        int pageNumber = 1;
        try {
            if (pageSizeParam != null && !pageSizeParam.isEmpty())
                pageSize = Integer.parseInt(pageSizeParam);
            if (pageNumberParam != null && !pageNumberParam.isEmpty())
                pageNumber = Integer.parseInt(pageNumberParam);
        } catch (NumberFormatException e) {
        }

        LocalDateTime fromDate = null;
        LocalDateTime toDate = null;

        try {
            if ((fromDateString != null && !fromDateString.isEmpty()) ||
                    (toDateString != null && !toDateString.isEmpty())) {

                if (fromDateString == null || fromDateString.isEmpty() ||
                        toDateString == null || toDateString.isEmpty()) {
                    throw new DateTimeException(MessageConst.MSG21);
                }

                fromDate = LocalDate.parse(fromDateString).atStartOfDay();
                toDate = LocalDate.parse(toDateString).atTime(23, 59, 59);

                LocalDateTime today = LocalDate.now().atStartOfDay();
                if (toDate.isAfter(today.plusDays(1))) {
                    throw new DateTimeException("Time travel is not allowed!");
                }
                if (fromDate.isAfter(toDate)) {
                    throw new DateTimeException(MessageConst.MSG22);
                }
            }

            // Determine statuses based on filter
            List<String> statuses;
            if (statusFilter != null && !statusFilter.isEmpty()) {
                // Filter by specific status
                statuses = List.of(statusFilter);
            } else {
                // Show all approved, processing, and finished requests
                statuses = List.of(RequestStatus.Approved.toString(),
                        RequestStatus.Processing.toString(), RequestStatus.Finished.toString(), RequestStatus.Tech_Finished.toString());
            }

            // Fetch approved requests with filters and pagination
            Page<Request> approvedRequests = requestService.getRequestWithCondition(
                    customerName, fromDate, toDate, phone, statuses,
                    pageNumber, pageSize);

            int totalCount = (int) approvedRequests.getTotalElements();

            int totalPages = (int) Math.ceil((double) totalCount / pageSize);
            if (pageNumber > totalPages && totalPages > 0)
                pageNumber = totalPages;

            int startItem = (pageNumber - 1) * pageSize + 1;
            int endItem = Math.min(startItem + pageSize - 1, totalCount);

            // Set attributes to JSP
            req.setAttribute("approvedRequests", approvedRequests.getContent());
            req.setAttribute("totalCount", totalCount);
            req.setAttribute("currentPage", pageNumber);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("startItem", totalCount == 0 ? 0 : startItem);
            req.setAttribute("endItem", totalCount == 0 ? 0 : endItem);
            req.setAttribute("pageSize", pageSize);

            // Giữ giá trị filter trong form
            req.setAttribute("phoneFilter", phone);
            req.setAttribute("customerFilter", customerName);
            req.setAttribute("statusFilter", statusFilter);
            req.setAttribute("fromDate", fromDateString);
            req.setAttribute("toDate", toDateString);

            req.getRequestDispatcher("/technician_leader/view_aproved_task.jsp").forward(req, resp);

        } catch (DateTimeException e) {
            req.setAttribute("errorMessage", e.getMessage());
            req.getRequestDispatcher("/technician_leader/view_aproved_task.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "An error occurred while processing your request.");
            req.getRequestDispatcher("/technician_leader/view_aproved_task.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processRequest(req, resp);
    }


}
