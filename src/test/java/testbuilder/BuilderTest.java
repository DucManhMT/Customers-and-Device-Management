package testbuilder;

import crm.auth.service.Hasher;
import crm.auth.service.LoginService;
import crm.common.model.*;
import crm.common.model.enums.AccountStatus;
import crm.common.model.enums.RequestStatus;
import crm.common.repository.account.AccountDAO;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.repository.hibernate.entitymanager.LazyReference;
import crm.core.repository.hibernate.querybuilder.*;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO;
import crm.core.repository.hibernate.querybuilder.enums.SortDirection;
import crm.core.service.IDGeneratorService;
import crm.core.service.MailService;
import crm.core.utils.HashInfo;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BuilderTest {
    public static void main(String[] args) {
        EntityManager em = new EntityManager(DBcontext.getConnection());

//      Product product = new Product();
//      Type type = new Type();
//      for ( int i=1; i<=10; i++){
//          type.setTypeID(IDGeneratorService.generateID(Type.class));
//          type.setTypeName("Type " + i);
//          em.persist(type, Type.class);
//      }
//      for ( int i =1 ; i<=100 ; i++){
//            product.setProductID(IDGeneratorService.generateID(Product.class));
//            product.setProductName("Product " + i);
//            product.setProductDescription("Description " + i);
//            product.setType(em.find(Type.class,(i%10 +1)));
//            em.persist(product, Product.class);
//      }

//        List<Account> accounts = em.findAll(Account.class); // hoặc em.findWithOrderAndPagination(...)
//        if (accounts != null) {
//            for (Account account : accounts) {
//                if (account == null) continue;
//
//                String username = account.getUsername();
//                String email = null;
//
//                if (username != null && !username.trim().isEmpty()) {
//                    username = username.trim();
//
//                    // Tìm email trong Customer (take first non-null element)
//                    Map<String, Object> condCustomer = new HashMap<>();
//                    condCustomer.put("account", username);
//                    List<Customer> customers = em.findWithConditions(Customer.class, condCustomer);
//
//                    Customer firstCustomer = null;
//                    if (customers != null && !customers.isEmpty()) {
//                        for (Customer c : customers) {
//                            if (c != null) {
//                                firstCustomer = c;
//                                break;
//                            }
//                        }
//                    }
//
//                    if (firstCustomer != null && firstCustomer.getEmail() != null && !firstCustomer.getEmail().isEmpty()) {
//                        email = firstCustomer.getEmail();
//                    } else {
//                        // Nếu không có Customer hợp lệ, tìm trong Staff
//                        Map<String, Object> condStaff = new HashMap<>();
//                        condStaff.put("account", username);
//                        List<Staff> staffs = em.findWithConditions(Staff.class, condStaff);
//
//                        Staff firstStaff = null;
//                        if (staffs != null && !staffs.isEmpty()) {
//                            for (Staff s : staffs) {
//                                if (s != null) {
//                                    firstStaff = s;
//                                    break;
//                                }
//                            }
//                        }
//
//                        if (firstStaff != null && firstStaff.getEmail() != null && !firstStaff.getEmail().isEmpty()) {
//                            email = firstStaff.getEmail();
//                        }
//                    }
//                }
//
//                System.out.println("account: " + username + " | email: " + (email != null ? email : "Không có email"));
//            }
//        }
//        Contract contract = new Contract();
//        Customer customer = em.find(Customer.class, 1);
//        contract.setContractID(IDGeneratorService.generateID(Contract.class));
//        contract.setContractCode("HD-001");
//        contract.setContractImage("contract_image.jpg");
//        contract.setStartDate(LocalDate.now());
//        contract.setExpiredDate(LocalDate.now().plusYears(1));
//        contract.setCustomer(customer);
//        em.persist(contract,Contract.class);
        String customerUsername = "cust1";
        Customer customer = null;
        if (customerUsername != null && !customerUsername.isEmpty()) {
            Map<String, Object> cond = new HashMap<>();
            // Lưu ý: key "username" phải khớp với tên field trong Customer.java (tên property)
            cond.put("account", customerUsername);
            List<Customer> found = em.findWithConditions(Customer.class, cond);
            if (found != null && !found.isEmpty()) {
                customer = found.get(0);
                int customerId = customer.getCustomerID();
                System.out.println("Customer ID: " + customerId);
            }
        }

    }
}


