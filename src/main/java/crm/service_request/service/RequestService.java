package crm.service_request.service;

import java.sql.SQLException;

import java.sql.Timestamp;

import crm.common.model.Request;
import crm.common.model.enums.RequestStatus;
import crm.common.repository.RequestRepository;
import crm.core.repository.persistence.config.TransactionManager;
import crm.core.utils.KeyGenerator;

public class RequestService {
    public Request createServiceRequest(String description, Long contractId) throws SQLException {
        Timestamp currentTimestamp = new Timestamp(System.currentTimeMillis());
        Request request = new Request(KeyGenerator.nextId(), description, RequestStatus.Pending, currentTimestamp,
                contractId);
        RequestRepository requestRepository = new RequestRepository();
        try {
            TransactionManager.beginTransaction();
            requestRepository.save(request);
            TransactionManager.commit();
        } catch (Exception e) {
            e.printStackTrace();
            TransactionManager.rollback();
            return null;
        }

        return request;
    }
}
