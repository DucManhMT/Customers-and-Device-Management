package crm.contract.service;

import java.util.List;

import crm.common.model.ProductContract;
import crm.contract.repository.ProductContractRepository;
import crm.service_request.repository.persistence.query.common.ClauseBuilder;

public class ProductContractService {
    ProductContractRepository productContractRepository = new ProductContractRepository();

    public List<ProductContract> findByContractId(int contractId) {

        return productContractRepository
                .findWithCondition(ClauseBuilder.builder().equal("ContractID", contractId));
    }
}
