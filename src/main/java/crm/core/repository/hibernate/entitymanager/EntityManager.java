<<<<<<< HEAD
package crm.core.repository.hibernate.entitymanager;

import java.sql.Connection;
import java.util.List;
import crm.core.repository.hibernate.querybuilder.enums.SortDirection;
import crm.core.repository.hibernate.querybuilder.EntityFieldMapper;
import crm.core.repository.hibernate.querybuilder.QueryUtils;
import crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO;

import java.sql.*;
import java.util.ArrayList;
import java.util.Map;

/**
 * Lightweight EntityManager implementation
 */
public class EntityManager implements IEntityManager {

    private final Connection connection;
    private final QueryUtils queryUtils = new QueryUtils();

    private boolean inTransaction = false;

    public EntityManager(Connection connection) {
        this.connection = connection;
    }

    // ---------- PERSIST ----------
    @Override
    public <T> void persist(T entity, Class<T> entityClass) {
        try {
            SqlAndParamsDTO sqlParams = queryUtils.buildInsert(entity);
            try (PreparedStatement ps = connection.prepareStatement(sqlParams.getSql())) {
                setParams(ps, sqlParams.getParams());
                ps.executeUpdate();
            }
        } catch (Exception e) {
            throw new RuntimeException("Error persisting entity " + entityClass.getName(), e);
        }
    }

    // ---------- MERGE (UPDATE) ----------
    @Override
    public <T> T merge(T entity, Class<T> entityClass) {
        try {
            SqlAndParamsDTO sqlParams = queryUtils.buildUpdate(entity);
            try (PreparedStatement ps = connection.prepareStatement(sqlParams.getSql())) {
                setParams(ps, sqlParams.getParams());
                ps.executeUpdate();
            }
            return entity;
        } catch (Exception e) {
            throw new RuntimeException("Error merging entity " + entityClass.getName(), e);
        }
    }

    // ---------- REMOVE ----------
    @Override
    public <T> void remove(T entity, Class<T> entityClass) {
        try {
            SqlAndParamsDTO sqlParams = queryUtils.buildDelete(entity);
            try (PreparedStatement ps = connection.prepareStatement(sqlParams.getSql())) {
                setParams(ps, sqlParams.getParams());
                ps.executeUpdate();
            }
        } catch (Exception e) {
            throw new RuntimeException("Error removing entity " + entityClass.getName(), e);
        }
    }

    // ---------- FIND ----------
    @Override
    public <T> T find(Class<T> entityClass, Object primaryKey) {
        try {
            SqlAndParamsDTO sqlParams = queryUtils.buildSelectById(entityClass, primaryKey);
            try (PreparedStatement ps = connection.prepareStatement(sqlParams.getSql())) {
                ps.setObject(1, sqlParams.getParams().get(0));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()){
                        return EntityFieldMapper.mapEntity(rs, entityClass);
                    }
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Error finding entity " + entityClass.getName(), e);
        }
        return null;
    }

    //---------- FIND ALL----------
    public <T> List<T> findAll(Class<T> entityClass) {
        try {
            SqlAndParamsDTO sqlParams = queryUtils.buildSelectAll(entityClass);
            List<T> results = new ArrayList<>();
            try (PreparedStatement ps = connection.prepareStatement(sqlParams.getSql());
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()){
                    T entity = EntityFieldMapper.mapEntity(rs, entityClass);
                    results.add(entity);
                }
            }
            return results;
        } catch (Exception e) {
            throw new RuntimeException("Error finding all entities of type " + entityClass.getName(), e);
        }
    }
    // ---------- FIND WITH CONDITIONS ----------
    public <T> List<T> findWithConditions(Class<T> entityClass, Map<String, Object> conditions) {
        try {
            SqlAndParamsDTO sqlParams = queryUtils.buildSelectWithConditions(entityClass, conditions);
            List<T> results = new ArrayList<>();
            try (PreparedStatement ps = connection.prepareStatement(sqlParams.getSql())) {
                setParams(ps, sqlParams.getParams());
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()){
                        T entity = EntityFieldMapper.mapEntity(rs, entityClass);
                        results.add(entity);
                    }
                }
            }
            return results;
        } catch (Exception e) {
            throw new RuntimeException("Error finding entities of type " + entityClass.getName() + " with conditions", e);
        }
    }
    // ---------- FIND WITH ORDER ----------
    public <T> List<T> findWithOrder(Class<T> entityClass, Map<String, SortDirection> orderConditions) {
        try {
            SqlAndParamsDTO sqlParams = queryUtils.buildSelectWithOrder(entityClass, orderConditions);
            List<T> results = new ArrayList<>();
            try (PreparedStatement ps = connection.prepareStatement(sqlParams.getSql());
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()){
                    T entity = EntityFieldMapper.mapEntity(rs, entityClass);
                    results.add(entity);
                }
            }
            return results;
        } catch (Exception e) {
            throw new RuntimeException("Error finding entities of type " + entityClass.getName() + " with order conditions", e);
        }
    }
    // ---------- FIND WITH PAGINATION ----------
    public <T> List<T> findWithPagination(Class<T> entityClass, int limit, int offset) {
        try {
            SqlAndParamsDTO sqlParams = queryUtils.buildSelectWithLimitOffset(entityClass, limit, offset);
            List<T> results = new ArrayList<>();
            try (PreparedStatement ps = connection.prepareStatement(sqlParams.getSql())) {
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()){
                        T entity = EntityFieldMapper.mapEntity(rs, entityClass);
                        results.add(entity);
                    }
                }
            }
            return results;
        } catch (Exception e) {
            throw new RuntimeException("Error finding entities of type " + entityClass.getName() + " with pagination", e);
        }
    }

    // ---------- FIND WITH CONDITIONS AND ORDER ----------
    public <T> List<T> findWithConditionsAndOrder(Class<T> entityClass, Map<String, Object> conditions, Map<String, SortDirection> orderConditions) {
        try {
            SqlAndParamsDTO sqlParams = queryUtils.buildSelectWithConditionsAndOrder(entityClass, conditions, orderConditions);
            List<T> results = new ArrayList<>();
            try (PreparedStatement ps = connection.prepareStatement(sqlParams.getSql())) {
                setParams(ps, sqlParams.getParams());
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()){
                        T entity = EntityFieldMapper.mapEntity(rs, entityClass);
                        results.add(entity);
                    }
                }
            }
            return results;
        } catch (Exception e) {
            throw new RuntimeException("Error finding entities of type " + entityClass.getName() + " with conditions and order", e);
        }
    }
    // ---------- FIND WITH CONDITIONS AND PAGINATION ----------
    public <T> List<T> findWithConditionsAndPagination(Class<T> entityClass, Map<String, Object> conditions, int limit, int offset) {
        try {
            SqlAndParamsDTO sqlParams = queryUtils.buildSelectWithConditionsAndLimitOffset(entityClass, conditions, limit, offset);
            List<T> results = new ArrayList<>();
            try (PreparedStatement ps = connection.prepareStatement(sqlParams.getSql())) {
                setParams(ps, sqlParams.getParams());
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()){
                        T entity = EntityFieldMapper.mapEntity(rs, entityClass);
                        results.add(entity);
                    }
                }
            }
            return results;
        } catch (Exception e) {
            throw new RuntimeException("Error finding entities of type " + entityClass.getName() + " with conditions and pagination", e);
        }
    }
    // ---------- FIND WITH ORDER AND PAGINATION ----------
    public <T> List<T> findWithOrderAndPagination(Class<T> entityClass, Map<String, SortDirection> orderConditions, int limit, int offset) {
        try {
            SqlAndParamsDTO sqlParams = queryUtils.buildSelectWithOrderAndLimitOffset(entityClass, orderConditions, limit, offset);
            List<T> results = new ArrayList<>();
            try (PreparedStatement ps = connection.prepareStatement(sqlParams.getSql())) {
                setParams(ps, sqlParams.getParams());
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()){
                        T entity = EntityFieldMapper.mapEntity(rs, entityClass);
                        results.add(entity);
                    }
                }
            }
            return results;
        } catch (Exception e) {
            throw new RuntimeException("Error finding entities of type " + entityClass.getName() + " with order and pagination", e);
        }
    }
    // ---------- FIND WITH CONDITIONS, ORDER AND PAGINATION ----------
    public <T> List<T> findWithConditionsOrderAndPagination(Class<T> entityClass, Map<String, Object> conditions, Map<String, SortDirection> orderConditions, int limit, int offset) {
        try {
            SqlAndParamsDTO sqlParams = queryUtils.buildSelectWithAll(entityClass, conditions, orderConditions, limit, offset);
            List<T> results = new ArrayList<>();
            try (PreparedStatement ps = connection.prepareStatement(sqlParams.getSql())) {
                setParams(ps, sqlParams.getParams());
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()){
                        T entity = EntityFieldMapper.mapEntity(rs, entityClass);
                        results.add(entity);
                    }
                }
            }
            return results;
        } catch (Exception e) {
            throw new RuntimeException("Error finding entities of type " + entityClass.getName() + " with conditions, order and pagination", e);
        }
    }


    // ---------- QUERY ----------
    @Override
    public <T> List<T> createQuery(String sql, Class<T> resultClass) {
        try {
            List<T> results = new ArrayList<>();
            try (PreparedStatement ps = connection.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
            }
            return results;
        } catch (Exception e) {
            throw new RuntimeException("Error executing query for " + resultClass.getName(), e);
        }
    }

    //-------------COUNT-------------
    public <T> int count(Class<T> entityClass) {
        try {
            SqlAndParamsDTO sqlParams = queryUtils.buildCount(entityClass);
            try (PreparedStatement ps = connection.prepareStatement(sqlParams.getSql());
                    ResultSet rs = ps.executeQuery()) {
                if (rs.next()){
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Error counting entities of type " + entityClass.getName(), e);
        }
        return 0;
    }

    // ---------- TRANSACTION ----------
    @Override
    public void beginTransaction() {
        try {
            if (!inTransaction) {
                connection.setAutoCommit(false);
                inTransaction = true;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to begin transaction", e);
        }
    }

    @Override
    public void commit() {
        try {
            if (inTransaction) {
                connection.commit();
                connection.setAutoCommit(true);
                inTransaction = false;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to commit transaction", e);
        }
    }

    @Override
    public void rollback() {
        try {
            if (inTransaction) {
                connection.rollback();
                connection.setAutoCommit(true);
                inTransaction = false;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to rollback transaction", e);
        }
    }



    // ---------- UTILITIES ----------

    private void setParams(PreparedStatement ps, List<Object> params) throws SQLException {
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
    }
}
=======
//package crm.core.repository.hibernate.entitymanager;
//
//import crm.core.repository.hibernate.annotation.Column;
//import crm.core.repository.hibernate.querybuilder.QueryBuilder;
//import crm.core.repository.hibernate.querybuilder.SqlAndParamsDTO;
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//import java.lang.reflect.Field;
//
//
//public class EntityManager implements IEntityManager {
//    private final Connection connection;
//    private boolean inTransaction = false;
//    public EntityManager(Connection connection) {
//        this.connection = connection;
//    }
//// CRUD operations
//
//    @Override
//    public <T> void persist(T entity, Class<T> entityClass) {
//        checkTransaction();
//        try {
//            QueryBuilder<T> qb = new QueryBuilder<>(entityClass);
//            SqlAndParamsDTO sp = qb.buildInsert(entity);
//            try (PreparedStatement ps = connection.prepareStatement(sp.getSql())) {
//                bindParams(ps, sp);
//                ps.executeUpdate();
//            }
//        } catch (Exception e) {
//            throw new RuntimeException("Error persisting entity", e);
//        }
//    }
//
//    @Override
//    public <T> T find(Class<T> entityClass, Object primaryKey) {
//        checkTransaction();
//        try {
//            QueryBuilder<T> qb = new QueryBuilder<>(entityClass);
//            SqlAndParamsDTO sp = qb.buildSelectById(primaryKey);
//
//            try (PreparedStatement ps = connection.prepareStatement(sp.getSql())) {
//                bindParams(ps, sp);
//                try (ResultSet rs = ps.executeQuery()) {
//                    if (rs.next()) {
//                        return mapResultSetToEntity(rs, entityClass);
//                    }
//                }
//            }
//        } catch (Exception e) {
//            throw new RuntimeException("Error finding entity", e);
//        }
//        return null;
//    }
//
//    @Override
//    public <T> T merge(T entity, Class<T> entityClass) {
//        checkTransaction();
//        try {
//            QueryBuilder<T> qb = new QueryBuilder<>(entityClass);
//            SqlAndParamsDTO sp = qb.buildUpdate(entity);
//            try (PreparedStatement ps = connection.prepareStatement(sp.getSql())) {
//                bindParams(ps, sp);
//                ps.executeUpdate();
//            }
//            return entity;
//        } catch (Exception e) {
//            throw new RuntimeException("Error merging entity", e);
//        }
//    }
//
//    @Override
//    public <T> void remove(T entity, Class<T> entityClass) {
//        checkTransaction();
//        try {
//            QueryBuilder<T> qb = new QueryBuilder<>(entityClass);
//
//            // Extract primary key value
//            Object idValue = null;
//            for (Field field : entity.getClass().getDeclaredFields()) {
//                Column col = field.getAnnotation(Column.class);
//                if (col != null && col.id()) {
//                    field.setAccessible(true);
//                    idValue = field.get(entity);
//                    break;
//                }
//            }
//            if (idValue == null) throw new RuntimeException("Entity has no primary key value");
//
//            SqlAndParamsDTO sp = qb.buildDelete(idValue);
//            try (PreparedStatement ps = connection.prepareStatement(sp.getSql())) {
//                bindParams(ps, sp);
//                ps.executeUpdate();
//            }
//        } catch (Exception e) {
//            throw new RuntimeException("Error removing entity", e);
//        }
//    }
//
//    // Transaction handling
//    @Override
//    public void beginTransaction() {
//        if (inTransaction) {
//            throw new RuntimeException("Transaction already in progress");
//        }
//        inTransaction = true;
//        try {
//            connection.setAutoCommit(false);
//        } catch (SQLException e) {
//            throw new RuntimeException("Error starting transaction", e);
//        }
//    }
//
//    @Override
//    public void commit() {
//        checkTransaction();
//        try {
//            connection.commit();
//            connection.setAutoCommit(true);
//            inTransaction = false;
//        } catch (SQLException e) {
//            throw new RuntimeException("Error committing transaction", e);
//        }
//    }
//
//    @Override
//    public void rollback() {
//        checkTransaction();
//        try {
//            connection.rollback();
//            inTransaction = false;
//        } catch (SQLException e) {
//            throw new RuntimeException("Error rolling back transaction", e);
//        }
//    }
//
//    @Override
//    public <T> List<T> createQuery(String sql, Class<T> resultClass) {
//        List<T> results = new ArrayList<>();
//        try (PreparedStatement ps = connection.prepareStatement(sql);
//             ResultSet rs = ps.executeQuery()) {
//            while (rs.next()) {
//                results.add(mapResultSetToEntity(rs, resultClass));
//            }
//        } catch (Exception e) {
//            throw new RuntimeException("Error executing query", e);
//        }
//        return results;
//    }
//
//    // --- Helpers ---
//    private void bindParams(PreparedStatement ps, SqlAndParamsDTO sp) throws Exception {
//        for (int i = 0; i < sp.getParams().size(); i++) {
//            ps.setObject(i + 1, sp.getParams().get(i));
//        }
//    }
//
//    private <T> T mapResultSetToEntity(ResultSet rs, Class<T> entityClass) throws Exception {
//        T entity = entityClass.getDeclaredConstructor().newInstance();
//        for (Field field : entityClass.getDeclaredFields()) {
//            Column col = field.getAnnotation(Column.class);
//            if (col != null) {
//                Object value = rs.getObject(col.name());
//                field.setAccessible(true);
//                field.set(entity, value);
//            }
//        }
//        return entity;
//    }
//    private void checkTransaction() {
//        if (!inTransaction) {
//            throw new IllegalStateException("No active transaction. Call beginTransaction() first.");
//        }
//    }
//}
>>>>>>> main
