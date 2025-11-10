package crm.service_request.service;

import java.sql.SQLException;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import crm.common.model.Account;
import crm.common.model.Contract;
import crm.common.model.Request;
import crm.common.model.Task;
import crm.common.model.enums.OldRequestStatus;
import crm.common.model.enums.RequestStatus;
import crm.common.model.enums.TaskStatus;
import crm.core.config.TransactionManager;
import crm.service_request.repository.ContractRepository;
import crm.service_request.repository.RequestRepository;
import crm.service_request.repository.persistence.query.common.ClauseBuilder;
import crm.service_request.repository.persistence.query.common.Order;
import crm.service_request.repository.persistence.query.common.Page;
import crm.service_request.repository.persistence.query.common.PageRequest;
import crm.service_request.repository.persistence.query.common.Sort;
import crm.task.repository.TaskRepository;

public class RequestService {
    RequestRepository requestRepository = new RequestRepository();
    RequestLogService requestLogService = new RequestLogService();
    ContractRepository contractRepository = new ContractRepository();
    TaskRepository taskRepository = new TaskRepository();

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
            requestLogService.createLog(request, "Service request created", null, RequestStatus.Pending,
                    contract.getCustomer().getAccount());
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
            builder.equal("ContractID", contractId);
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

    public void updateRequestStatus(int requestId, RequestStatus requestStatus, String note, Account account)
            throws IllegalArgumentException {
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
        logNote.append("Process request: changed status from ").append(oldStatus).append(" to ").append(requestStatus)
                .append(".");
        if (note != null && !note.isEmpty()) {
            logNote.append(" Note: ").append(note);
        }
        if (requestStatus == RequestStatus.Finished) {
            request.setFinishedDate(LocalDateTime.now());
        }
        try {
            TransactionManager.beginTransaction();
            requestRepository.update(request);
            requestLogService.createLog(request, logNote.toString(), oldStatus, requestStatus, account);
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

    public Map<String, Integer> statisticRequestsByStatus(LocalDateTime from, LocalDateTime to) {
        Map<String, Integer> map = new HashMap<>();
        int total = 0;
        if (from == null || to == null) {
            for (RequestStatus status : RequestStatus.values()) {
                int tempCount = requestRepository.countRequestByStatus(status);
                total += tempCount;
                map.put(status.toString(), tempCount);
            }
        } else {
            for (RequestStatus status : RequestStatus.values()) {
                int tempCount = requestRepository.countRequestByStatus(status, from, to);
                total += tempCount;
                map.put(status.toString(), tempCount);
            }
        }
        map.put("All", total);

        return map;
    }

    public Page<Request> getRequestWithCondition(String customerName, LocalDateTime from, LocalDateTime to,
            String phone, List<String> status, int page, int size) {
        ClauseBuilder requestClause = new ClauseBuilder();
        ClauseBuilder customerClause = new ClauseBuilder();
        if (from != null) {
            requestClause.greaterOrEqual("StartDate", from);
        }
        if (to != null) {
            requestClause.lessOrEqual("StartDate", to);
        }

        if (phone != null && !phone.isEmpty()) {
            customerClause.equal("Phone", phone);
        }
        if (customerName != null && !customerName.isEmpty()) {
            customerClause.like("CustomerName", "%" + customerName + "%");
        }
        if (status != null && !status.isEmpty()) {
            requestClause.in("RequestStatus", status);
        }

        PageRequest pageRequest = PageRequest.of(page, size, List.of(Order.desc("StartDate")));

        return requestRepository.getByCustomerConditionAndCondition(customerClause, requestClause, pageRequest);

    }

    public void finishRequest(int requestId, Account account) throws IllegalArgumentException {
        Request request = getRequestById(requestId);
        if (request == null) {
            throw new IllegalArgumentException("Request not found");
        }
        List<Task> tasks = taskRepository.findWithCondition(ClauseBuilder.builder().equal("RequestID", requestId));
        for (Task task : tasks) {
            if (task.getStatus() == TaskStatus.Pending || task.getStatus() == TaskStatus.Processing) {
                throw new IllegalArgumentException("Cannot finish request with incomplete tasks.");
            }
        }

        try {
            TransactionManager.beginTransaction();

            request.setRequestStatus(RequestStatus.Finished);
            request.setFinishedDate(LocalDateTime.now());
            requestRepository.update(request);
            requestLogService.createLog(request, "Request finished.", OldRequestStatus.Processing,
                    RequestStatus.Finished, account);
            TransactionManager.commit();
        } catch (Exception e) {
            try {
                TransactionManager.rollback();
            } catch (SQLException e1) {
                // TODO Auto-generated catch block
                e1.printStackTrace();
            }
        }
    }

}
