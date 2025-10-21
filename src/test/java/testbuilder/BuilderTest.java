// //package testbuilder;
// //
// //import crm.auth.service.Hasher;
// //import crm.auth.service.LoginService;
// //import crm.common.model.*;
// //import crm.common.model.enums.AccountStatus;
// //import crm.common.model.enums.RequestStatus;
// //import crm.common.repository.account.AccountDAO;
// //import crm.core.repository.hibernate.entitymanager.EntityManager;
// //import crm.core.repository.hibernate.entitymanager.LazyReference;
// //import crm.core.repository.hibernate.querybuilder.*;
// //import crm.core.config.DBcontext;
// //import crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO;
// //import crm.core.repository.hibernate.querybuilder.enums.SortDirection;
// //import crm.core.service.IDGeneratorService;
// //import crm.core.service.MailService;
// //import crm.core.utils.HashInfo;
// //
// //import java.time.LocalDateTime;
// //import java.util.HashMap;
// //import java.util.List;
// //import java.util.Map;
// //
// //public class BuilderTest {
// // public static void main(String[] args) {
// // EntityManager em = new EntityManager(DBcontext.getConnection());
// //
// /// / Product product = new Product();
// /// / Type type = new Type();
// /// / for ( int i=1; i<=10; i++){
// /// / type.setTypeID(IDGeneratorService.generateID(Type.class));
// /// / type.setTypeName("Type " + i);
// /// / em.persist(type, Type.class);
// /// / }
// /// / for ( int i =1 ; i<=100 ; i++){
// /// / product.setProductID(IDGeneratorService.generateID(Product.class));
// /// / product.setProductName("Product " + i);
// /// / product.setProductDescription("Description " + i);
// /// / product.setType(em.find(Type.class,(i%10 +1)));
// /// / em.persist(product, Product.class);
// /// / }
// //
// package testbuilder;

// import crm.auth.service.Hasher;
// import crm.auth.service.LoginService;
// import crm.common.model.*;
// import crm.common.model.enums.AccountStatus;
// import crm.common.model.enums.RequestStatus;
// import crm.common.repository.account.AccountDAO;
// import crm.core.repository.hibernate.entitymanager.EntityManager;
// import crm.core.repository.hibernate.entitymanager.LazyReference;
// import crm.core.repository.hibernate.querybuilder.*;
// import crm.core.config.DBcontext;
// import crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO;
// import crm.core.repository.hibernate.querybuilder.enums.SortDirection;
// import crm.core.service.IDGeneratorService;
// import crm.core.service.MailService;
// import crm.core.utils.HashInfo;
// import crm.core.validator.Validator;
// import org.glassfish.json.JsonUtil;

// import java.time.LocalDateTime;
// import java.util.HashMap;
// import java.util.List;
// import java.util.Map;

// public class BuilderTest {
// public static void main(String[] args) {

// // Product product = new Product();
// // Type type = new Type();
// // for ( int i=1; i<=10; i++){
// // type.setTypeID(IDGeneratorService.generateID(Type.class));
// // type.setTypeName("Type " + i);
// // em.persist(type, Type.class);
// // }
// // for ( int i =1 ; i<=100 ; i++){
// // product.setProductID(IDGeneratorService.generateID(Product.class));
// // product.setProductName("Product " + i);
// // product.setProductDescription("Description " + i);
// // product.setType(em.find(Type.class,(i%10 +1)));
// // em.persist(product, Product.class);
// // }

// //
// // String username = account.getUsername();
// // String email = null;
// //
// // // Tìm email trong Customer
// // Map<String, Object> condCustomer = new HashMap<>();
// // condCustomer.put("account", username);
// // List<Customer> customers = em.findWithConditions(Customer.class,
// condCustomer);
// // if (!customers.isEmpty()) {
// // email = customers.get(0).getEmail();
// // } else {
// // // Tìm email trong Staff
// // Map<String, Object> condStaff = new HashMap<>();
// // condStaff.put("account", username);
// // List<Staff> staffs = em.findWithConditions(Staff.class, condStaff);
// // if (!staffs.isEmpty()) {
// // email = staffs.get(0).getEmail();
// // }
// // }
// //
// // System.out.println("account: " + username + " | email: " + (email != null
// ? email : "Không có email"));
// // }
// // }
// //
// //
