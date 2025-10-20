package crm.service_request.controller;

import crm.common.MessageConst;
import crm.common.URLConstants;
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
import java.time.format.DateTimeParseException;
import java.util.Map;

@WebServlet(name = "RequestDashboardController", value = URLConstants.CUSTOMER_SUPPORTER_REQUEST_DASHBOARD)
public class RequestDashboardController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        RequestService requestService = new RequestService();
        try {
            String fromDateString = req.getParameter("fromDate");
            String toDateString = req.getParameter("toDate");
            LocalDateTime fromDate = null;
            LocalDateTime toDate = null;

            // if both fromDate and toDate are null or empty, get all requests
            if ((fromDateString == null || fromDateString.isEmpty())
                    && (toDateString == null || toDateString.isEmpty())) {

            } else if (fromDateString == null || fromDateString.isEmpty() || toDateString == null
                    || toDateString.isEmpty()) {
                // if one of them is null or empty, throw exception
                throw new DateTimeException(MessageConst.MSG21);
            } else {
                fromDate = LocalDate.parse(fromDateString).atStartOfDay();
                toDate = LocalDate.parse(toDateString).atStartOfDay();
                if (fromDate.isAfter(toDate)) {
                    throw new DateTimeException(MessageConst.MSG22);
                }
            }
            Map<String, Integer> map = requestService.statisticRequestsByStatus(fromDate, toDate);
            req.setAttribute("total", map.get("All"));
            req.setAttribute("stats", map);
            req.setAttribute("fromDate", fromDateString);
            req.setAttribute("toDate", toDateString);
        } catch (DateTimeParseException e) {
            req.setAttribute("error", MessageConst.MSG23);
        } catch (DateTimeException e) {
            req.setAttribute("error", e.getMessage());
        } catch (Exception e) {
            req.setAttribute("error", MessageConst.MSG15);
            e.printStackTrace();
        }

        req.getRequestDispatcher("/service_request/request-dashboard.jsp").forward(req, resp);
    }
}
