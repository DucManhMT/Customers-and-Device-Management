package crm.common.repository.Warehouse;

import crm.common.model.WarehouseRequest;
import crm.common.repository.FuntionalityDAO;

public class WarehouseRequestDAO extends FuntionalityDAO<WarehouseRequest> {

    public WarehouseRequestDAO() {
        super(WarehouseRequest.class);
    }
}
