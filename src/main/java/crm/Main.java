package crm;

import crm.common.model.Request;
import crm.common.model.enums.RequestStatus;
import crm.service_request.repository.RequestRepository;
import crm.service_request.service.RequestLogService;
import crm.service_request.service.RequestService;

import java.sql.SQLException;

public class Main {
    public static void main(String[] args) {
        RequestLogService requestLogService = new RequestLogService();
        try {
            requestLogService.getLogsByRequestId(1).forEach(log -> {
                System.out.println(log.getRequestLogID() + " - " + log.getOldStatus() + " - " + log.getNewStatus());
            });
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public static void testUpdate() {
        RequestService requestService = new RequestService();
        requestService.updateRequestStatus(1, RequestStatus.Rejected, "Test 363636", "admin");
        Request request = requestService.getRequestById(1);
        System.out.println(request.getRequestID() + " - " + request.getRequestStatus() + " - " + request.getNote());
    }

}
