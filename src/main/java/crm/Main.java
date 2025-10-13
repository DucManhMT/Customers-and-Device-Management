package crm;

import crm.common.model.Request;
import crm.common.model.enums.RequestStatus;
import crm.service_request.repository.RequestRepository;
import crm.service_request.service.RequestLogService;
import crm.service_request.service.RequestService;

import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Map;

public class Main {
    public static void main(String[] args) {
        System.out.println(LocalDate.parse("2025-10-19").atStartOfDay());

    }

    public static void testUpdate() {
        RequestService requestService = new RequestService();
        requestService.updateRequestStatus(1, RequestStatus.Rejected, "Test 363636", "admin");
        Request request = requestService.getRequestById(1);
        System.out.println(request.getRequestID() + " - " + request.getRequestStatus() + " - " + request.getNote());
    }

}
