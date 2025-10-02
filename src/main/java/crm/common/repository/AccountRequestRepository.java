package crm.common.repository;

import crm.common.model.AccountRequest;
import crm.core.repository.persistence.repository.AbstractRepository;

public class AccountRequestRepository extends AbstractRepository<AccountRequest, Long> {
    public AccountRequestRepository() {
        super(AccountRequest.class);
    }
}
