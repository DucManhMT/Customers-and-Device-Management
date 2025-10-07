package crm;

import java.sql.SQLException;
import java.util.List;

import crm.common.model.Request;
import crm.common.model.enums.RequestStatus;
import crm.common.repository.RequestRepository;
import crm.core.repository.persistence.config.TransactionManager;

public class Main {
    public static void main(String[] args) {
        RequestRepository requestRepository = new RequestRepository();
        Request request = requestRepository.findById(1);
        request.setRequestStatus(RequestStatus.Rejected);
        try {
            TransactionManager.beginTransaction();
            requestRepository.update(request);
            TransactionManager.commit();
        } catch (SQLException e) {
            try {
                TransactionManager.rollback();
            } catch (SQLException e1) {
                // TODO Auto-generated catch block
                e1.printStackTrace();
            }
            e.printStackTrace();
        }

        requestRepository.findAll().forEach((r) -> System.out.println(r.getRequestID() + " - " + r.getRequestStatus()));

    }

}
