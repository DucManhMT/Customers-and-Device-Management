package crm.service_request.repository;

import java.sql.SQLException;
import java.util.Collection;
import java.util.List;

import crm.common.model.Contract;
import crm.common.model.Customer;
import crm.common.model.Request;
import crm.core.repository.persistence.query.clause.ClauseBuilder;
import crm.core.repository.persistence.query.common.Page;
import crm.core.repository.persistence.query.common.PageRequest;
import crm.core.repository.persistence.repository.AbstractRepository;

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
}
