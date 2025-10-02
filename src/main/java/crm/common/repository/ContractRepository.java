package crm.common.repository;

import crm.common.model.Contract;
import crm.core.repository.persistence.repository.AbstractRepository;

public class ContractRepository extends AbstractRepository<Contract, Integer> {
    public ContractRepository() {
        super(Contract.class);
    }
}
