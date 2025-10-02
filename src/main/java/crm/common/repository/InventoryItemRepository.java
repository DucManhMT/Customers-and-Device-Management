package crm.common.repository;

import crm.common.model.InventoryItem;
import crm.core.repository.persistence.repository.AbstractRepository;

public class InventoryItemRepository extends AbstractRepository<InventoryItem, Integer> {
    public InventoryItemRepository() {
        super(InventoryItem.class);
    }
}
