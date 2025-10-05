package crm;

import java.security.Key;
import java.sql.SQLException;

import crm.common.model.*;
import crm.common.model.enums.AccountStatus;
import crm.core.repository.persistence.config.DBcontext;
import crm.core.repository.persistence.config.TransactionManager;
import crm.core.repository.persistence.entity.EntityRegistry;
import crm.core.repository.persistence.entity.SchemaGenerator;
import crm.core.repository.persistence.query.common.Page;
import crm.core.utils.KeyGenerator;
import crm.service_request.service.RequestService;

public class Main {
    public static void main(String[] args) {

    }

    public static void test() {
        RequestService requestService = new RequestService();
        Page<Request> pageResult = null;
        try {
            pageResult = requestService.getRequests(1, 10, "StartDate", "desc", "Approved", null);
        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        pageResult.getContent().forEach(r -> {
            System.out.println(r.getRequestID() + " - " + r.getRequestDescription() + " - " + r.getRequestStatus()
                    + " - " + r.getStartDate());
        });
    }

    public static void generateAll() {
        try {
            TransactionManager.beginTransaction();
            // Ensure schema exists then load sample data
            System.out.println("Generating all database schemas...");
            testSchemaGeneration();
            System.out.println("Loading sample data into the database...");
            SampleDataLoader.loadAll();
            TransactionManager.commit();
            System.out.println("Sample data loaded successfully.");
        } catch (SQLException e) {
            try {
                TransactionManager.rollback();
            } catch (SQLException e1) {
                // TODO Auto-generated catch block
                e1.printStackTrace();
            }
            System.err.println("Failed to load sample data: " + e.getMessage());
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
                    AccountRequest.class,
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
