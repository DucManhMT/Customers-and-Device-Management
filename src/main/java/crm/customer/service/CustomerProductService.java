package crm.customer.service;

import java.util.List;

import crm.common.model.Contract;
import crm.common.model.InventoryItem;
import crm.common.model.Product;
import crm.common.model.ProductContract;
import crm.contract.repository.ContractRepository;
import crm.contract.repository.ProductContractRepository;
import crm.service_request.repository.persistence.query.common.ClauseBuilder;

public class CustomerProductService {
    ProductContractRepository productContractRepository = new ProductContractRepository();
    ContractRepository contractRepository = new ContractRepository();

    public List<ProductContract> getProductContracts(String username, String productNameFilter, String serialFilter) {

        ClauseBuilder clauseBuilder = ClauseBuilder.builder();
        if (username != null && !username.isEmpty()) {
            List<Integer> contractIds = contractRepository.findByUsername(username).stream()
                    .map(Contract::getContractID)
                    .toList();
            clauseBuilder.in("ContractID", contractIds);
        }

        List<ProductContract> productContracts = productContractRepository.findWithCondition(clauseBuilder);

        if (productNameFilter != null && !productNameFilter.isEmpty()) {
            productContracts = productContracts.stream()
                    .filter((pc) -> {
                        InventoryItem item = pc.getInventoryItem();
                        if (item == null)
                            return false;
                        Product product = item.getProduct();
                        if (product == null)
                            return false;
                        String pName = product.getProductName();
                        return pName != null && pName.toLowerCase().contains(productNameFilter.toLowerCase());

                    }).toList();
        }

        if (serialFilter != null && !serialFilter.isEmpty()) {
            productContracts = productContracts.stream()
                    .filter((pc) -> {
                        InventoryItem item = pc.getInventoryItem();
                        if (item == null)
                            return false;
                        String serial = item.getSerialNumber();
                        return serial != null && serial.toLowerCase().contains(serialFilter.toLowerCase());
                    }).toList();
        }

        return productContracts;

    }
}
