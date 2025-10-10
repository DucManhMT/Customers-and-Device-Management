package crm.service_request.service;

import java.sql.SQLException;

import java.time.LocalDateTime;

import crm.common.model.Contract;
import crm.common.model.Request;
import crm.common.model.enums.RequestStatus;
import crm.common.repository.RequestRepository;
import crm.core.repository.persistence.config.TransactionManager;
import crm.core.repository.persistence.query.clause.ClauseBuilder;
import crm.core.repository.persistence.query.common.Order;
import crm.core.repository.persistence.query.common.Page;
import crm.core.repository.persistence.query.common.PageRequest;
import crm.core.repository.persistence.query.common.Sort;

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

    public Page<Request> getRequestByUser(String username, String field, String sort, String status, int contractId,
            int page, int recordsPerPage) throws SQLException {
        ClauseBuilder builder = new ClauseBuilder();
        if (field == null || field.isEmpty()) {
            field = "StartDate";
        }
        if (sort == null || sort.isEmpty() || (!sort.equals("asc") && !sort.equals("desc"))) {
            sort = "desc";
        }

        if (username != null && !username.isEmpty()) {
            builder.equal("Contract.Customer.UserName", username);
        }

        if (status != null && !status.isEmpty()) {
            builder.equal("RequestStatus", status);
        }

        if (contractId > 0) {
            builder.equal("Contract.ContractID", contractId);
        }

        RequestRepository requestRepository = new RequestRepository();
        Order order = sort.equals("asc") ? Order.asc(field) : Order.desc(field);

        Page<Request> pageResult = null;
        try {
            TransactionManager.beginTransaction();
            pageResult = requestRepository.findWithCondtion(builder,
                    PageRequest.of(page, recordsPerPage, Sort.by(order)));
            TransactionManager.commit();
        } catch (Exception e) {
            e.printStackTrace();
            TransactionManager.rollback();
            return null;
        }

        return pageResult;
    }

    public Page<Request> getRequests(int page, int recordsPerPage, String field, String sort, String status,
            String description) throws SQLException {
        ClauseBuilder builder = new ClauseBuilder();

        if (field == null || field.isEmpty()) {
            field = "StartDate";
        }
        if (sort == null || sort.isEmpty() || (!sort.equals("asc") && !sort.equals("desc"))) {
            sort = "desc";
        }

        if (status != null && !status.isEmpty()) {
            builder.equal("RequestStatus", status);
        }

        if (description != null && !description.isEmpty()) {
            builder.like("RequestDescription", "%" + description + "%");
        }
        RequestRepository requestRepository = new RequestRepository();
        Order order = sort.equals("asc") ? Order.asc(field) : Order.desc(field);

        Page<Request> pageResult = null;
        try {
            TransactionManager.beginTransaction();
            pageResult = requestRepository.findWithCondtion(builder,
                    PageRequest.of(page, recordsPerPage, Sort.by(order)));
            TransactionManager.commit();
        } catch (Exception e) {
            e.printStackTrace();
            TransactionManager.rollback();
            return null;
        }

        return pageResult;
    }

}
