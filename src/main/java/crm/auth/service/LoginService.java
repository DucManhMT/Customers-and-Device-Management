package crm.auth.service;

import crm.common.model.Account;
import crm.common.repository.account.AccountDAO;

public class LoginService {
    public static Account login(String username, String password) {
        AccountDAO accountDAO = new AccountDAO();
        Account acc;
        acc = accountDAO.find(username);
        if (acc != null && Hasher.hashPassword(acc.getPasswordHash()).equals(Hasher.hashPassword(password))) {
            return acc;
        }
        return null; // Placeholder return
    }
}
