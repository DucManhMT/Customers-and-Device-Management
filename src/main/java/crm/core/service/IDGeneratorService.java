package crm.core.service;

import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;

public class IDGeneratorService {

    public static int generateID(Class<?> clazz) {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        em.findAll(clazz);
        int count = em.count(clazz);
        while (true) {
            int id = count + 1;
            Object existingEntity = em.find(clazz, id);
            if (existingEntity == null) {
                return id;
            }
            count++;
        }
    }
}
