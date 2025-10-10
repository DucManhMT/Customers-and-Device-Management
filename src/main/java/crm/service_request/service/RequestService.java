package crm.service_request.service;

import java.sql.SQLException;

import java.time.LocalDateTime;

import crm.common.model.Contract;
import crm.common.model.Request;
import crm.common.model.enums.RequestStatus;
import crm.core.config.TransactionManager;
import crm.service_request.repository.RequestRepository;
import crm.service_request.repository.persistence.query.common.ClauseBuilder;
import crm.service_request.repository.persistence.query.common.Order;
import crm.service_request.repository.persistence.query.common.Page;
import crm.service_request.repository.persistence.query.common.PageRequest;
import crm.service_request.repository.persistence.query.common.Sort;

public class RequestService {
    public Request createServiceRequest(String description, int contractId) throws SQLException {
        LocalDateTime currentTimestamp = LocalDateTime.now();
        Contract contract = new Contract();
        contract.setContractID(contractId);
        Request request = new Request();
        request.setRequestID(10);
        request.setRequestDescription(description);
        request.setRequestStatus(RequestStatus.Pending);
        request.setStartDate(currentTimestamp);
        request.setContract(contract);
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

    public Page<Request> getRequests(String customerName, String field, String sort, String description,
            String status, int contractId,
            int page, int recordsPerPage) {
        RequestRepository requestRepository = new RequestRepository();
        ClauseBuilder builder = new ClauseBuilder();
        if (field == null || field.isEmpty()) {
            field = "StartDate";
        }

        if (description != null && !description.isEmpty()) {
            builder.like("RequestDescription", "%" + description + "%");
        }

        if (sort == null || sort.isEmpty() || (!sort.equals("asc") && !sort.equals("desc"))) {
            sort = "desc";
        }

        if (status != null && !status.isEmpty()) {
            builder.equal("RequestStatus", status);
        }

        if (contractId > 0) {
            builder.equal("Contract.ContractID", contractId);
        }

        Order order = sort.equals("asc") ? Order.asc(field) : Order.desc(field);

        PageRequest request = PageRequest.of(page, recordsPerPage, Sort.by(order));
        if (customerName == null || customerName.isEmpty()) {
            return requestRepository.findWithCondtion(builder, request);

        }
        return requestRepository.findByCustomerName(customerName, builder, request);
    }

    public Page<Request> getRequestByUsername(String username, String field, String sort, String description,
            String status, int contractId,
            int page, int recordsPerPage) {
        RequestRepository requestRepository = new RequestRepository();
        ClauseBuilder builder = new ClauseBuilder();
        if (field == null || field.isEmpty()) {
            field = "StartDate";
        }

        if (description != null && !description.isEmpty()) {
            builder.like("RequestDescription", "%" + description + "%");

        }

        if (sort == null || sort.isEmpty() || (!sort.equals("asc") && !sort.equals("desc"))) {
            sort = "desc";
        }

        if (status != null && !status.isEmpty()) {
            builder.equal("RequestStatus", status);
        }

        if (contractId > 0) {
            builder.equal("Contract.ContractID", contractId);
        }

        Order order = sort.equals("asc") ? Order.asc(field) : Order.desc(field);

        PageRequest request = PageRequest.of(page, recordsPerPage, Sort.by(order));
        if (username == null || username.isEmpty()) {
            return requestRepository.findWithCondtion(builder, request);

        }

        return requestRepository.findByUsernameAndCondition(username, builder, request);
    }

}
