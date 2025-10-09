package crm.service_request.repository;

import java.util.List;

import crm.common.model.Contract;
import crm.common.model.Customer;
import crm.core.repository.persistence.query.clause.ClauseBuilder;
import crm.core.repository.persistence.query.common.Page;
import crm.core.repository.persistence.query.common.PageRequest;
import crm.core.repository.persistence.repository.AbstractRepository;
import crm.customer.repository.CustomerRepository;

public class ContractRepository extends AbstractRepository<Contract, Integer> {

    public ContractRepository() {
        super(Contract.class);
    }

    public Page<Contract> findByUsername(String username, PageRequest pageRequest) {
        if (username == null || username.isEmpty()) {
            return findAll(pageRequest);
        }
        CustomerRepository customerRepository = new CustomerRepository();
        List<Customer> customers = (List<Customer>) customerRepository
                .findWithCondition(ClauseBuilder.builder().equal("Username", username));
        if (customers == null || customers.isEmpty()) {
            return new Page<>(0, pageRequest, null);
        }
        return findWithCondtion(
                ClauseBuilder.builder().in("CustomerID",
                        customers.stream().map(c -> c.getCustomerID()).toList()),
                pageRequest);
    }

    public List<Contract> findByUsername(String username) {
        if (username == null || username.isEmpty()) {
            return findAll();
        }
        CustomerRepository customerRepository = new CustomerRepository();
        List<Customer> customers = (List<Customer>) customerRepository
                .findWithCondition(ClauseBuilder.builder().equal("Username", username));
        if (customers == null || customers.isEmpty()) {
            return null;
        }

        return findWithCondition(
                ClauseBuilder.builder().in("CustomerID",
                        customers.stream().map(c -> c.getCustomerID()).toList()));

    }

    public List<Contract> findByCustomerName(String customerName) {
        if (customerName == null || customerName.isEmpty()) {
            return findAll();
        }
        CustomerRepository customerRepository = new CustomerRepository();
        List<Customer> customers = (List<Customer>) customerRepository
                .findWithCondition(ClauseBuilder.builder().like("CustomerName", "%" + customerName + "%"));
        if (customers == null || customers.isEmpty()) {
            return null;
        }

        return findWithCondition(
                ClauseBuilder.builder().in("CustomerID",
                        customers.stream().map(c -> c.getCustomerID()).toList()));

    }

    public Integer getNewKey() {
        int count = count() + 1;
        while (isExist(count)) {
            count++;
        }
        return count;
    }
}
