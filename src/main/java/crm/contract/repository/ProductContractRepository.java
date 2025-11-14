package crm.contract.repository;

import crm.common.model.ProductContract;
import crm.service_request.repository.persistence.AbstractRepository;

public class ProductContractRepository extends AbstractRepository<ProductContract, Integer> {

    public ProductContractRepository() {
        super(ProductContract.class);
    }

}
