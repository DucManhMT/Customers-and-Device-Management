package crm;

import java.security.Key;
import java.sql.SQLException;

import crm.common.model.*;
import crm.core.repository.persistence.config.DBcontext;
import crm.core.repository.persistence.config.TransactionManager;
import crm.core.repository.persistence.query.common.Page;
import crm.core.utils.KeyGenerator;
import crm.service_request.service.RequestService;

public class Main {
    public static void main(String[] args) {
        Account account = new Account();
        Role role = new Role();
        role.setRoleID(1L);
        role.setRoleName("Admin");
        account.setRole(role);
        System.out.println(account.getRole().getRoleName());
    }

    public static void test() {
        RequestService requestService = new RequestService();
        Page<Request> pageResult = null;
        try {
            pageResult = requestService.getRequests(1, 10, "StartDate", "desc",
                    "Approved", null);
        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        pageResult.getContent().forEach(r -> {
            System.out.println(r.getRequestID() + " - " + r.getRequestDescription() + " - " + r.getRequestStatus()
                    + " - " + r.getStartDate());
        });
    }

}
