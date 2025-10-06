package crm.common.repository.account;

import crm.common.model.Account;
import crm.common.repository.FuntionalityDAO;

public class AccountDAO extends FuntionalityDAO<Account> {
    public AccountDAO() {
        super(Account.class);
    }

}
