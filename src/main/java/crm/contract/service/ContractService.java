package crm.contract.service;

import java.util.List;

import crm.common.model.Contract;
import crm.contract.repository.ContractRepository;
import crm.service_request.repository.CustomerRepository;
import crm.service_request.repository.persistence.query.common.ClauseBuilder;
import crm.service_request.repository.persistence.query.common.PageRequest;
import crm.service_request.repository.persistence.query.common.Page;

public class ContractService {
    public Contract getContractById(int contractId) {
        ContractRepository contractRepository = new ContractRepository();
        return contractRepository.findById(contractId);
    }

    public List<Contract> getAllContracts() {
        ContractRepository contractRepository = new ContractRepository();
        return contractRepository.findAll();
    }

    public Page<Contract> getContractsByPage(int pageNumber, int pageSize, String customerName, String contractCode) {
        ContractRepository contractRepository = new ContractRepository();
        PageRequest pageRequest = PageRequest.of(pageNumber, pageSize);

        boolean hasFilter = (customerName != null && !customerName.isBlank()) || (contractCode != null && !contractCode.isBlank());
        if (!hasFilter) {
            return contractRepository.findAll(pageRequest);
        }

        ClauseBuilder clause = ClauseBuilder.builder();
        if (contractCode != null && !contractCode.isBlank()) {
            clause.like("ContractCode", "%" + contractCode + "%");
        }
        if (customerName != null && !customerName.isBlank()) {
            CustomerRepository customerRepository = new CustomerRepository();
            var customers = customerRepository.findWithCondition(ClauseBuilder.builder().like("CustomerName", "%" + customerName + "%"));
            if (customers == null || customers.isEmpty()) {
                // return empty page quickly
                return new Page<>(0, pageRequest, java.util.List.of());
            }
            var ids = customers.stream().map(c -> c.getCustomerID()).toList();
            clause.in("CustomerID", ids);
        }
        return contractRepository.findWithCondtion(clause, pageRequest);
    }
}
