package crm.common.repository.Warehouse;

import crm.common.model.ProductTransaction;
import crm.common.model.WarehouseRequest;
import crm.common.model.enums.TransactionStatus;
import crm.common.repository.FuntionalityDAO;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class WarehouseRequestDAO extends FuntionalityDAO<WarehouseRequest> {

    public WarehouseRequestDAO() {
        super(WarehouseRequest.class);
    }

    public List<WarehouseRequest> findWithProductTransactions() {
        EntityManager em = new EntityManager(DBcontext.getConnection());

        List<WarehouseRequest> warehouseRequests = em.findAll(WarehouseRequest.class);


        for (WarehouseRequest warehouseRequest : warehouseRequests) {
            Map<String, Object> conditions = new HashMap<>();
            conditions.put("warehouseRequest", warehouseRequest.getWarehouseRequestID());
            conditions.put("transactionStatus", TransactionStatus.Export.name());

            List<ProductTransaction> productTransactions = em.findWithConditions(ProductTransaction.class, conditions);

            warehouseRequest.setProductTransactions(productTransactions);
        }

        return warehouseRequests;
    }

    public WarehouseRequest findWithProductTransactionsById(int warehouseRequestID) {
        EntityManager em = new EntityManager(DBcontext.getConnection());

        WarehouseRequest warehouseRequest = em.find(WarehouseRequest.class, warehouseRequestID);

        if (warehouseRequest != null) {
            Map<String, Object> conditions = new HashMap<>();
            conditions.put("warehouseRequest", warehouseRequest.getWarehouseRequestID());
            conditions.put("transactionStatus", TransactionStatus.Export.name());

            List<ProductTransaction> productTransactions = em.findWithConditions(ProductTransaction.class, conditions);

            warehouseRequest.setProductTransactions(productTransactions);
        }
        return warehouseRequest;
    }

}
