package crm.service_request.repository;

import crm.common.model.Customer;
import crm.service_request.repository.persistence.AbstractRepository;
import crm.service_request.repository.persistence.query.common.ClauseBuilder;

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
