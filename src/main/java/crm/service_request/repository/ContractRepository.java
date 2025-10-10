package crm.service_request.repository;

import crm.common.model.Contract;
import crm.core.repository.persistence.repository.AbstractRepository;

public class ContractRepository extends AbstractRepository<Contract, Integer> {

    public ContractRepository() {
        super(Contract.class);
    }

    public Integer getNewKey() {
        int count = count() + 1;
        while (isExist(count)) {
            count++;
        }
        return count;
    }
}
