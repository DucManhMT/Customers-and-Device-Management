package crm.common.repository;

import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import java.util.List;
import java.sql.Connection;

import crm.core.repository.hibernate.querybuilder.QueryOperation;
import crm.core.repository.hibernate.querybuilder.enums.SortDirection;

import java.util.Map;

public class FuntionalityDAO<T> {
    private final EntityManager entityManager;
    private final Class<T> entityClass;

    public FuntionalityDAO(Class<T> entityClass) {
        Connection connection = DBcontext.getConnection();
        this.entityManager = new EntityManager(connection);
        this.entityClass = entityClass;
    }

    // Insert
    public void persist(T entity) {
        entityManager.persist(entity, entityClass);
    }

    // Select
    public T find(Object primaryKey) {
        return entityManager.find(entityClass, primaryKey);
    }

    // Update
    public T merge(T entity) {
        entityManager.merge(entity, entityClass);
        return entity;
    }

    // Delete
    public void remove(T entity) {
        entityManager.remove(entity, entityClass);
    }

    // Count
    public int count() {
        return entityManager.count(entityClass);
    }

    // Find by ID
    public T findById(Object id) {
        return entityManager.find(entityClass, id);
    }

    // Find all
    public List<T> findAll() {
        return entityManager.findAll(entityClass);
    }

    // Find with condition
    public List<T> findWithCondition(Map<String, Object> conditions) {
        return entityManager.findWithConditions(entityClass, conditions);
    }

    // Find with condition and sorting
    public List<T> findWithOrder(Map<String, Object> conditions, Map<String, SortDirection> sorting) {
        return entityManager.findWithOrder(entityClass, sorting);
    }

    // Find with pagination
    public List<T> findWithPagination(int limit, int offset) {
        return entityManager.findWithPagination(entityClass, limit, offset);
    }

    // Find with condition, sorting and pagination
    public List<T> findWithAll(Map<String, Object> conditions, Map<String, SortDirection> sorting, int limit,
            int offset) {
        return entityManager.findWithConditionsOrderAndPagination(entityClass, conditions, sorting, limit, offset);
    }

    // Execute custom query
    public List<T> executeCustomQuery(QueryOperation queryOperation) {
        return entityManager.executeCustomQuery(entityClass, queryOperation);
    }

}
