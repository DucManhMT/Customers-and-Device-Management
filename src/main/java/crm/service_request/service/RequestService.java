package crm.service_request.service;

import java.sql.SQLException;

import java.time.LocalDateTime;

import crm.common.model.Account;
import crm.common.model.Contract;
import crm.common.model.Request;
import crm.common.model.enums.OldRequestStatus;
import crm.common.model.enums.RequestStatus;
import crm.core.config.TransactionManager;
import crm.service_request.repository.ContractRepository;
import crm.service_request.repository.RequestRepository;
import crm.service_request.repository.persistence.query.common.ClauseBuilder;
import crm.service_request.repository.persistence.query.common.Order;
import crm.service_request.repository.persistence.query.common.Page;
import crm.service_request.repository.persistence.query.common.PageRequest;
import crm.service_request.repository.persistence.query.common.Sort;

public class RequestService {
    RequestRepository requestRepository = new RequestRepository();
    RequestLogService requestLogService = new RequestLogService();
    ContractRepository contractRepository = new ContractRepository();

    public Request createServiceRequest(String description, int contractId) throws SQLException {
        LocalDateTime currentTimestamp = LocalDateTime.now();
        Contract contract = contractRepository.findById(contractId);
        Request request = new Request();
        request.setRequestID(requestRepository.getNewId());
        request.setRequestDescription(description);
        request.setRequestStatus(RequestStatus.Pending);
        request.setStartDate(currentTimestamp);
        request.setContract(contract);
        try {
            TransactionManager.beginTransaction();
            requestRepository.save(request);
            requestLogService.createLog(request, "Service request created", null, RequestStatus.Pending, contract.getCustomer().getAccount().getUsername());
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

    public Request getRequestById(int requestId) {
        return requestRepository.findById(requestId);
    }

    public boolean isRequestOwner(Request request, String username) {
        Account account = request.getContract().getCustomer().getAccount();
        return account.getUsername().equals(username);
    }

    public boolean isExist(int requestId) {
        return requestRepository.isExist(requestId);
    }

    public void updateRequestStatus(int requestId, RequestStatus requestStatus, String note, String username) throws IllegalArgumentException {
        Request request = getRequestById(requestId);
        if (request == null) {
            throw new IllegalArgumentException("Request not found");
        }
        OldRequestStatus oldStatus = Request.toOldStatus(request.getRequestStatus());
        request.setRequestStatus(requestStatus);
        if (note != null && !note.isEmpty()) {
            request.setNote(note);
        }

        StringBuilder logNote = new StringBuilder();
        logNote.append("Process request: changed status from ").append(oldStatus).append(" to ").append(requestStatus).append(".");
        if (note != null && !note.isEmpty()) {
            logNote.append(" Note: ").append(note);
        }
        if (requestStatus == RequestStatus.Finished) {
            request.setFinishedDate(LocalDateTime.now());
        }
        try {
            TransactionManager.beginTransaction();
            requestRepository.update(request);
            requestLogService.createLog(request, logNote.toString(), oldStatus, requestStatus, username);
            TransactionManager.commit();
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                TransactionManager.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
                throw new RuntimeException(ex);
            }
        }
    }

}
