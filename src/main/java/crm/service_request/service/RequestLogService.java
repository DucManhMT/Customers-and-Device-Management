package crm.service_request.service;

import crm.common.model.Account;
import crm.common.model.Request;
import crm.common.model.enums.OldRequestStatus;
import crm.common.model.enums.RequestStatus;
import crm.core.config.TransactionManager;
import crm.service_request.model.RequestLog;
import crm.service_request.repository.RequestLogRepository;
import crm.service_request.repository.persistence.query.common.ClauseBuilder;

import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

public class RequestLogService {
    RequestLogRepository requestLogRepository = new RequestLogRepository();

    public void createLog(Request request, String description, OldRequestStatus oldStatus, RequestStatus newStatus,
                          Account account) {
        RequestLog requestLog = new RequestLog();
        requestLog.setRequestLogID(requestLogRepository.getNewId());
        requestLog.setRequest(request);
        requestLog.setDescription(description);
        requestLog.setOldStatus(oldStatus);
        requestLog.setNewStatus(newStatus);
        requestLog.setActionDate(Date.valueOf(LocalDate.now()));
        requestLog.setAccount(account);

        try {
            TransactionManager.beginTransaction();
            requestLogRepository.save(requestLog);
            TransactionManager.commit();
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                TransactionManager.rollback();
            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        }
    }

    public List<RequestLog> getLogsByRequestId(int requestId) {
        return requestLogRepository.findWithCondition(ClauseBuilder.builder().equal("RequestID", requestId));
    }

}
