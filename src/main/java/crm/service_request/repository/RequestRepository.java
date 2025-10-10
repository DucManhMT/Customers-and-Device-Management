package crm.service_request.repository;

import java.util.List;

import crm.common.model.Contract;
import crm.common.model.Request;
import crm.service_request.repository.persistence.query.common.ClauseBuilder;
import crm.service_request.repository.persistence.query.common.Page;
import crm.service_request.repository.persistence.query.common.PageRequest;
import crm.service_request.repository.persistence.repository.AbstractRepository;

public class RequestRepository extends AbstractRepository<Request, Integer> {
    public RequestRepository() {
        super(Request.class);
    }

    public Page<Request> findByUsername(String username, PageRequest pageRequest) {
        if (username == null || username.isEmpty()) {
            return findAll(pageRequest);
        }

        ContractRepository contractRepository = new ContractRepository();
        List<Integer> contractIds = contractRepository.findByUsername(username).stream().map(c -> c.getContractID())
                .toList();

        return findWithCondtion(
                ClauseBuilder.builder().in("ContractID", contractIds), pageRequest);

    }

    public Page<Request> findByUsernameAndCondition(String username, ClauseBuilder clause, PageRequest pageRequest) {
        if (username == null || username.isEmpty()) {
            return findWithCondtion(clause, pageRequest);
        }

        ContractRepository contractRepository = new ContractRepository();
        List<Integer> contractIds = contractRepository.findByUsername(username).stream().map(c -> c.getContractID())
                .toList();

        clause.in("ContractID", contractIds);

        return findWithCondtion(clause, pageRequest);

    }

    public Page<Request> findByCustomerName(String customerName, ClauseBuilder clause, PageRequest pageRequest) {
        if (customerName == null || customerName.isEmpty()) {
            return findWithCondtion(clause, pageRequest);
        }

        ContractRepository contractRepository = new ContractRepository();
        List<Contract> contracts = contractRepository.findByCustomerName(customerName);
        if (contracts == null || contracts.isEmpty()) {
            return new Page<>(0, pageRequest, null);
        }
        List<Integer> contractIds = contracts.stream().map(c -> c.getContractID()).toList();

        clause.in("ContractID", contractIds);

        return findWithCondtion(clause, pageRequest);

    }

}
