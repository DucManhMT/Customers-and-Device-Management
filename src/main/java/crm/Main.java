package crm;

import java.time.LocalDateTime;
import java.util.Map;

import crm.common.model.enums.RequestStatus;
import crm.service_request.repository.ContractRepository;
import crm.service_request.repository.RequestRepository;
import crm.service_request.service.RequestService;

public class Main {
    public static void main(String[] args) {

        // Inject fake repository vào service
        RequestService service = new RequestService();

        // Test 2: Có from/to
        System.out.println("=== TEST WITH DATE RANGE ===");
        LocalDateTime from = LocalDateTime.now().minusDays(70);
        LocalDateTime to = LocalDateTime.now();
        Map<String, Integer> result2 = service.statisticRequestsByStatus(from, to);
        System.out.println(result2);

    }
}
