package crm.service_request.repository;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import crm.common.model.Contract;
import crm.common.model.Request;
import crm.core.config.DBcontext;
import crm.core.config.TransactionManager;
import crm.service_request.repository.persistence.AbstractRepository;
import crm.service_request.repository.persistence.query.common.ClauseBuilder;
import crm.service_request.repository.persistence.query.common.Page;
import crm.service_request.repository.persistence.query.common.PageRequest;

public class RequestRepository extends AbstractRepository<Request, Integer> {
    public RequestRepository() {
        super(Request.class);
    }

    public Integer getNewId() {
        String sql = "SELECT MAX(RequestID) AS MaxID FROM Request";
        Connection connection = DBcontext.getConnection();
        try (Statement statement = connection.createStatement();
             var resultSet = statement.executeQuery(sql)) {
            if (resultSet.next()) {
                int maxId = resultSet.getInt("MaxID");
                return maxId + 1;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 1;
    }


    public Page<Request> findByUsername(String username, PageRequest pageRequest) {
        if (username == null || username.isEmpty()) {
            return findAll(pageRequest);
        }

        ContractRepository contractRepository = new ContractRepository();
        List<Integer> contractIds = contractRepository.findByUsername(username).stream().map(c -> c.getContractID())
                .toList();

        return findWithCondtion(
                ClauseBuilder.builder().in("ContractID", contractIds), pageRequest);

    }

    public Page<Request> findByUsernameAndCondition(String username, ClauseBuilder clause, PageRequest pageRequest) {
        if (username == null || username.isEmpty()) {
            return findWithCondtion(clause, pageRequest);
        }

        ContractRepository contractRepository = new ContractRepository();
        List<Integer> contractIds = contractRepository.findByUsername(username).stream().map(c -> c.getContractID())
                .toList();

        clause.in("ContractID", contractIds);

        return findWithCondtion(clause, pageRequest);

    }

    public Page<Request> findByCustomerName(String customerName, ClauseBuilder clause, PageRequest pageRequest) {
        if (customerName == null || customerName.isEmpty()) {
            return findWithCondtion(clause, pageRequest);
        }

        ContractRepository contractRepository = new ContractRepository();
        List<Contract> contracts = contractRepository.findByCustomerName(customerName);
        if (contracts == null || contracts.isEmpty()) {
            return new Page<>(0, pageRequest, null);
        }
        List<Integer> contractIds = contracts.stream().map(c -> c.getContractID()).toList();

        clause.in("ContractID", contractIds);

        return findWithCondtion(clause, pageRequest);

    }

}
