package crm.auth.service;

import crm.common.model.Account;
import crm.common.model.enums.AccountStatus;
import crm.common.repository.account.AccountDAO;

public class LoginService {
    public static Account login(String username, String password) {
        AccountDAO accountDAO = new AccountDAO();
        Account acc;
        acc = accountDAO.find(username);
        if (acc != null && acc.getPasswordHash().equals(Hasher.hashPassword(password)) && acc.getAccountStatus() == AccountStatus.Active && acc.getUsername().equals(username)) {

            return acc;
        }
        return null; // Placeholder return
    }
}
