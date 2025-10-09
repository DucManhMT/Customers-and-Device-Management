package crm.service_request.repository;

import crm.common.model.Customer;
import crm.core.repository.persistence.query.clause.ClauseBuilder;
import crm.core.repository.persistence.repository.AbstractRepository;

import java.util.List;

public class CustomerRepository extends AbstractRepository<Customer, Integer> {
    public CustomerRepository() {
        super(Customer.class);
    }

    public Customer findByUsername(String username) {
        List<Customer> customers = findWithCondition(ClauseBuilder.builder().equal("Username", username));
        return customers.isEmpty() ? null : customers.get(0);
    }
}
