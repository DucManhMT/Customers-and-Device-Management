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
        try {
            System.out.println("=== STARTING DEBUG TEST ===");

            EntityManager entityManager = new EntityManager(DBcontext.getConnection());
            String statusFilter = "approved"; // Example filter
            String sortBy = "newest"; // Example sort
            Integer currentPage = 1;
            Integer pageSize = 6;

            System.out.println("Status Filter: " + statusFilter);
            System.out.println("Sort By: " + sortBy);
            System.out.println("Current Page: " + currentPage);
            System.out.println("Page Size: " + pageSize);

            Map<String, Object> conditions = new HashMap<>();

            if (statusFilter != null && !statusFilter.isEmpty()) {
                if ("approved".equals(statusFilter)) {
                    conditions.put("requestStatus", RequestStatus.Approved.name());
                } else if ("finished".equals(statusFilter)) {
                    conditions.put("requestStatus", RequestStatus.Finished.name());
                }
            } else {
                conditions.put("requestStatus", RequestStatus.Approved.name()   );
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
