package crm;

import java.lang.reflect.Field;
import java.sql.SQLException;
import java.util.List;

import crm.common.model.*;
import crm.common.model.enums.AccountStatus;
import crm.core.repository.persistence.config.DBcontext;
import crm.core.repository.persistence.entity.EntityRegistry;
import crm.core.repository.persistence.entity.SchemaGenerator;
import crm.core.repository.persistence.repository.SimpleRepository;
import crm.core.repository.hibernate.entitymanager.EntityManager;
public class Main {
    public static void main(String[] args) {
        // testInsert();
        EntityManager entityManager = new EntityManager(DBcontext.getConnection());
        Account acc = new Account();
        acc.setUsername("masterlong");
        acc.setPasswordHash("hashed_password");
        acc.setAccountStatus(AccountStatus.Active);
        acc.setRoleID(1); // Assuming role with ID 1 exists

        entityManager.beginTransaction();
        System.out.println(entityManager.find(Account.class, 1));

        entityManager.commit();
    }

    public static void testSelect() {
        SimpleRepository<Account, Integer> accountRepo = new SimpleRepository<>(Account.class);
        accountRepo.findAll().forEach(acc -> {
            System.out.println("Username: " + acc.getUsername());
            System.out.println("Status: " + acc.getAccountStatus());
            System.out.println("Role ID: " + acc.getRoleID());
            System.out.println("-----------------------");
        });
    }

    public static void testInsert() {
        SimpleRepository<Account, Integer> accountRepo = new SimpleRepository<>(Account.class);
        Account acc = new Account();
        acc.setUsername("john_doe");
        acc.setPasswordHash("hashed_password");
        acc.setAccountStatus(AccountStatus.Active);
        acc.setRoleID(1); // Assuming role with ID 1 exists
        try {
            accountRepo.save(acc);
            System.out.println("Inserted account with username: " + acc.getUsername());
        } catch (SQLException e) {
            e.printStackTrace();

        }
    }

    public static void testSchemaGeneration() {
        try {
            // Initialize DB connection (side-effect: ensure driver loaded)
            DBcontext.getConnection();

            // 1. Register all entity classes (add new ones here when created)
            Class<?>[] entities = new Class<?>[] {
                    Account.class,
                    Role.class,
                    Feature.class,
                    RoleFeature.class,
                    Category.class,
                    Type.class,
                    SpecificationType.class,
                    Specification.class,
                    Product.class,
                    ProductSpecification.class,
                    ProductWarehouse.class,
                    Warehouse.class,
                    WarehouseLog.class,
                    InventoryItem.class,
                    ProductTransaction.class,
                    ProductRequest.class,
                    ProductExported.class,
                    Staff.class,
                    Customer.class,
                    Contract.class,
                    Request.class,
                    RequestLog.class,
                    Feedback.class,
                    ProductContract.class
            };
            for (Class<?> c : entities) {
                @SuppressWarnings("unchecked")
                Class<Object> cls = (Class<Object>) c;
                EntityRegistry.register(cls);
            }

            // 2. Generate schema (DDL) for all registered entities
            SchemaGenerator.withDefault().generateAll();

            System.out.println("Schema generation completed successfully.");
        } catch (Exception e) {
            System.err.println("Schema generation failed: " + e.getMessage());
            e.printStackTrace();
        }
    }

}
