package testbuilder;

import crm.common.model.Account;
import crm.common.model.Feedback;
import crm.common.model.Request;
import crm.common.model.Role;
import crm.common.model.enums.AccountStatus;
import crm.common.model.enums.RequestStatus;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.repository.hibernate.querybuilder.*;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO;
import crm.core.repository.hibernate.querybuilder.enums.SortDirection;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BuilderTest {
    public static void main(String[] args) {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        List<Contract> contracts;
        Map<String, Object> conditions = new HashMap<>();
        conditions.put("contractID", 1);
        contracts = em.findWithConditions(Contract.class, conditions);

        for (Contract contract : contracts) {
            System.out.println("Contract ID: " + contract.getContractID());
            System.out.println("Contract Image: " + contract.getContractImage());
            System.out.println("Start Date: " + contract.getStartDate());
            System.out.println("Expired Date: " + contract.getExpiredDate());
            System.out.println("Customer ID: " + contract.getCustomerID());
            System.out.println("-----------------------");
        }

            int offset = (currentPage - 1) * pageSize;

            List<Request> assignedRequests;

            if (sortBy != null && !sortBy.isEmpty()) {
                Map<String, SortDirection> orderConditions = new HashMap<>();

                if ("newest".equals(sortBy)) {
                    orderConditions.put("startDate", SortDirection.DESC);
                } else if ("oldest".equals(sortBy)) {
                    orderConditions.put("startDate", SortDirection.ASC);
                }

                System.out.println("alo1");
                QueryUtils q = new QueryUtils();
                SqlAndParamsDTO dto = q.buildSelectWithAll(Request.class, conditions, orderConditions, pageSize, offset);
                System.out.println("Generated SQL: " + dto.getSql());
                System.out.println("Parameters: " + dto.getParams());
                assignedRequests = entityManager.findWithConditionsOrderAndPagination(
                        Request.class, conditions, orderConditions, pageSize, offset);
            } else {
                System.out.println("alo2");
                assignedRequests = entityManager.findWithConditionsAndPagination(
                        Request.class, conditions, pageSize, offset);
            }
            for (Request r: assignedRequests){
                System.out.println("Request ID: " + r.getRequestID() + ", Start Date: " + r.getStartDate() + ", Status: " + r.getRequestStatus());
            }

            System.out.println("=== TEST COMPLETED SUCCESSFULLY ===");

        } catch (Exception e) {
            System.err.println("=== ERROR IN TEST ===");
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
            System.err.println("====================");
        }
    }
}
