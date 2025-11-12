package crm.contract.repository;

import java.time.LocalDate;
import java.util.List;

import crm.common.model.Contract;
import crm.common.model.Customer;
import crm.service_request.repository.CustomerRepository;
import crm.service_request.repository.persistence.AbstractRepository;
import crm.service_request.repository.persistence.query.common.ClauseBuilder;
import crm.service_request.repository.persistence.query.common.Page;
import crm.service_request.repository.persistence.query.common.PageRequest;

public class ContractRepository extends AbstractRepository<Contract, Integer> {

    public ContractRepository() {
        super(Contract.class);
    }

    public Page<Contract> findByUsername(String username, PageRequest pageRequest) {
        if (username == null || username.isEmpty()) {
            return findAll(pageRequest);
        }
        CustomerRepository customerRepository = new CustomerRepository();
        List<Customer> customers = customerRepository
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
        List<Customer> customers = customerRepository
                .findWithCondition(ClauseBuilder.builder().equal("Username", username));
        if (customers == null || customers.isEmpty()) {
            return List.of();
        }

        return findWithCondition(
                ClauseBuilder.builder().in("CustomerID",
                        customers.stream().map(c -> c.getCustomerID()).toList()));

    }

    public List<Contract> findNotExpiredByUserName(String username) {
        if (username == null || username.isEmpty()) {
            return findAll();
        }
        CustomerRepository customerRepository = new CustomerRepository();
        List<Customer> customers = customerRepository
                .findWithCondition(ClauseBuilder.builder().equal("Username", username));
        if (customers == null || customers.isEmpty()) {
            return List.of();
        }

        return findWithCondition(
                ClauseBuilder.builder().in("CustomerID",
                        customers.stream().map(c -> c.getCustomerID()).toList())
                        .greaterOrEqual("ExpiredDate", LocalDate.now()));
    }

    public List<Contract> findByCustomerName(String customerName) {
        if (customerName == null || customerName.isEmpty()) {
            return findAll();
        }
        CustomerRepository customerRepository = new CustomerRepository();
        List<Customer> customers = customerRepository
                .findWithCondition(ClauseBuilder.builder().like("CustomerName", "%" + customerName + "%"));
        if (customers == null || customers.isEmpty()) {
            return List.of();
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
