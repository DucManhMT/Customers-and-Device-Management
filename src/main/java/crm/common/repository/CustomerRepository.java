package crm.common.repository;

import crm.common.model.Customer;
import crm.core.repository.persistence.repository.AbstractRepository;

public class CustomerRepository extends AbstractRepository<Customer, Long> {
    public CustomerRepository() {
        super(Customer.class);
    }
}
