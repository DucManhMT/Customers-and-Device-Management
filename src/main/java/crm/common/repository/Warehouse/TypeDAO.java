package crm.common.repository.Warehouse;

import crm.common.model.SpecificationType;
import crm.common.model.Type;
import crm.common.repository.FuntionalityDAO;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TypeDAO extends FuntionalityDAO<Type> {

    public TypeDAO() {
        super(Type.class);
    }

    public List<SpecificationType> getSpecificationTypes(int typeID) {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        Map<String, Object> conditions = new HashMap<>();
        conditions.put("type", typeID);
        return em.findWithConditions(SpecificationType.class, conditions);
    }

}
