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
import crm.warehousekeeper.service.SerialGenerator;

import java.sql.Connection;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BuilderTest {
    public static void main(String[] args) {
        EntityManager em = new EntityManager(DBcontext.getConnection());

        String generated = SerialGenerator.generateSerial("1", "qwe");
        System.out.println("Generated serial = " + generated);

        Map<String, Object> cond = new HashMap<>();
        cond.put("serialNumber", "4BFAACA8B280");

        List<InventoryItem> existing = em.findWithConditions(InventoryItem.class, cond);

        if (existing == null || existing.isEmpty()) {
            System.out.println("❌ Serial DOES NOT exist in DB");
        } else {
            System.out.println("✅ Serial EXISTS");
            for (InventoryItem item : existing) {
                System.out.println("Found serial = " + item.getSerialNumber());
            }
        }
    }
}





