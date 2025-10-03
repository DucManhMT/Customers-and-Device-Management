package crm.core.repository.hibernate.entitymanager;

import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.querybuilder.QueryBuilder;
import crm.core.repository.hibernate.querybuilder.SqlAndParamsDTO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.lang.reflect.Field;


public class EntityManager implements IEntityManager {
    private final Connection connection;
    private boolean inTransaction = false;
    public EntityManager(Connection connection) {
        this.connection = connection;
    }
// CRUD operations

    @Override
    public <T> void persist(T entity, Class<T> entityClass) {
        checkTransaction();
        try {
            QueryBuilder<T> qb = new QueryBuilder<>(entityClass);
            SqlAndParamsDTO sp = qb.buildInsert(entity);
            try (PreparedStatement ps = connection.prepareStatement(sp.getSql())) {
                bindParams(ps, sp);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            throw new RuntimeException("Error persisting entity", e);
        }
    }

    @Override
    public <T> T find(Class<T> entityClass, Object primaryKey) {
        checkTransaction();
        try {
            QueryBuilder<T> qb = new QueryBuilder<>(entityClass);
            SqlAndParamsDTO sp = qb.buildSelectById(primaryKey);

            try (PreparedStatement ps = connection.prepareStatement(sp.getSql())) {
                bindParams(ps, sp);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return mapResultSetToEntity(rs, entityClass);
                    }
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Error finding entity", e);
        }
        return null;
    }

    @Override
    public <T> T merge(T entity, Class<T> entityClass) {
        checkTransaction();
        try {
            QueryBuilder<T> qb = new QueryBuilder<>(entityClass);
            SqlAndParamsDTO sp = qb.buildUpdate(entity);
            try (PreparedStatement ps = connection.prepareStatement(sp.getSql())) {
                bindParams(ps, sp);
                ps.executeUpdate();
            }
            return entity;
        } catch (Exception e) {
            throw new RuntimeException("Error merging entity", e);
        }
    }

    @Override
    public <T> void remove(T entity, Class<T> entityClass) {
        checkTransaction();
        try {
            QueryBuilder<T> qb = new QueryBuilder<>(entityClass);

            // Extract primary key value
            Object idValue = null;
            for (Field field : entity.getClass().getDeclaredFields()) {
                Column col = field.getAnnotation(Column.class);
                if (col != null && col.id()) {
                    field.setAccessible(true);
                    idValue = field.get(entity);
                    break;
                }
            }
            if (idValue == null) throw new RuntimeException("Entity has no primary key value");

            SqlAndParamsDTO sp = qb.buildDelete(idValue);
            try (PreparedStatement ps = connection.prepareStatement(sp.getSql())) {
                bindParams(ps, sp);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            throw new RuntimeException("Error removing entity", e);
        }
    }

    // Transaction handling
    @Override
    public void beginTransaction() {
        if (inTransaction) {
            throw new RuntimeException("Transaction already in progress");
        }
        inTransaction = true;
        try {
            connection.setAutoCommit(false);
        } catch (SQLException e) {
            throw new RuntimeException("Error starting transaction", e);
        }
    }

    @Override
    public void commit() {
        checkTransaction();
        try {
            connection.commit();
            connection.setAutoCommit(true);
            inTransaction = false;
        } catch (SQLException e) {
            throw new RuntimeException("Error committing transaction", e);
        }
    }

    @Override
    public void rollback() {
        checkTransaction();
        try {
            connection.rollback();
            inTransaction = false;
        } catch (SQLException e) {
            throw new RuntimeException("Error rolling back transaction", e);
        }
    }

    @Override
    public <T> List<T> createQuery(String sql, Class<T> resultClass) {
        List<T> results = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                results.add(mapResultSetToEntity(rs, resultClass));
            }
        } catch (Exception e) {
            throw new RuntimeException("Error executing query", e);
        }
        return results;
    }

    // --- Helpers ---
    private void bindParams(PreparedStatement ps, SqlAndParamsDTO sp) throws Exception {
        for (int i = 0; i < sp.getParams().size(); i++) {
            ps.setObject(i + 1, sp.getParams().get(i));
        }
    }

    private <T> T mapResultSetToEntity(ResultSet rs, Class<T> entityClass) throws Exception {
        T entity = entityClass.getDeclaredConstructor().newInstance();
        for (Field field : entityClass.getDeclaredFields()) {
            Column col = field.getAnnotation(Column.class);
            if (col != null) {
                Object value = rs.getObject(col.name());
                field.setAccessible(true);
                field.set(entity, value);
            }
        }
        return entity;
    }
    private void checkTransaction() {
        if (!inTransaction) {
            throw new IllegalStateException("No active transaction. Call beginTransaction() first.");
        }
    }
}