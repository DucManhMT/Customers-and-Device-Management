package crm.common.repository.customer;

import crm.common.model.Customer;
import crm.common.repository.FuntionalityDAO;

public class CustomerDAO extends FuntionalityDAO<Customer> {
    public CustomerDAO(Class<Customer> entityClass) {
        super(entityClass);
    }
}
