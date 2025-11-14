package testbuilder;// //package testbuilder;
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
//
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

import crm.common.URLConstants;
import crm.common.model.*;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.filter.service.PermissionService;

import java.sql.Connection;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BuilderTest {
    public static void main(String[] args) {
       EntityManager em = new EntityManager(DBcontext.getConnection());
        Contract contract = em.find(Contract.class, 1);
        InventoryItem item = em.find(InventoryItem.class, 5);
        if (item != null) {
            ProductContract pc = new ProductContract();
            pc.setContract(contract);
            pc.setInventoryItem(item);
            em.persist(pc, ProductContract.class);
        }
    }
}





