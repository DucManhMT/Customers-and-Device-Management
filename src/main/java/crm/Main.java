package crm;

import crm.common.model.Request;
import crm.common.model.enums.RequestStatus;
import crm.service_request.model.RequestLog;
import crm.service_request.repository.RequestRepository;
import crm.service_request.service.RequestLogService;
import crm.service_request.service.RequestService;

import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Map;

public class Main {
    public static void main(String[] args) {
        RequestService requestService = new RequestService();
        requestService.getRequestById(1).getLogs().forEach(log -> {
            System.out.println(log.getRequestLogID() + " - " + log.getActionDate() + " - " + log.getOldStatus() + " - " + log.getNewStatus() + " - " + log.getDescription());
        });
    }


}
