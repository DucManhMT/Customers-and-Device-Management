package crm.contract.service;

import crm.common.model.Contract;
import crm.contract.repository.ContractRepository;

public class ContractService {
    public Contract getContractById(int contractId) {
        ContractRepository contractRepository = new ContractRepository();
        return contractRepository.findById(contractId);
    }
}
