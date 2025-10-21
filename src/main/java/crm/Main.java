package crm;

import crm.service_request.repository.ContractRepository;
import crm.service_request.service.RequestService;

public class Main {
    public static void main(String[] args) {
        RequestService requestService = new RequestService();
        requestService.getRequestByUsername("nguyen.van.an", null, null, null, null, 13004, 1, 15).getContent()
                .forEach(request -> {
                    System.out.println("Request ID: " + request.getRequestID() + ", Description: "
                            + request.getRequestDescription());
                });
    }

}
