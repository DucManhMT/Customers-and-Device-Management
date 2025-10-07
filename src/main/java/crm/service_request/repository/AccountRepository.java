package crm.service_request.repository;

import crm.common.model.Account;
import crm.core.repository.persistence.repository.AbstractRepository;

public class AccountRepository extends AbstractRepository<Account, String> {
    public AccountRepository() {
        super(Account.class);
    }
}
