package crm.core.repository.hibernate.entitymanager;

import java.sql.Connection;
import java.util.List;
import java.lang.reflect.Field;

import crm.core.repository.hibernate.querybuilder.EntityFieldMapper;
import crm.core.repository.hibernate.querybuilder.QueryBuilder;
import crm.core.repository.hibernate.querybuilder.SqlAndParamsDTO;
import java.sql.*;
import java.util.ArrayList;
/**
 * Lightweight EntityManager implementation
 */
public class EntityManager implements IEntityManager {

    private final Connection connection;
    private final QueryBuilder queryBuilder = new QueryBuilder();

    private boolean inTransaction = false;

    public EntityManager(Connection connection) {
        this.connection = connection;
    }

    // ---------- PERSIST ----------
    @Override
    public <T> void persist(T entity, Class<T> entityClass) {
        try {
            SqlAndParamsDTO sqlParams = queryBuilder.buildInsert(entity);
            try (PreparedStatement ps = connection.prepareStatement(sqlParams.getSql())) {
                setParams(ps, sqlParams.getParams());
                ps.executeUpdate();
            }
        } catch (Exception e) {
            throw new RuntimeException("Error persisting entity " + entityClass.getName(), e);
        }
    }

    // ---------- FIND ----------
    @Override
    public <T> T find(Class<T> entityClass, Object primaryKey) {
        try {
            SqlAndParamsDTO sqlParams = queryBuilder.buildSelectById(entityClass, primaryKey);
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

    // ---------- MERGE (UPDATE) ----------
    @Override
    public <T> T merge(T entity, Class<T> entityClass) {
        try {
            SqlAndParamsDTO sqlParams = queryBuilder.buildUpdate(entity);
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
            SqlAndParamsDTO sqlParams = queryBuilder.buildDelete(entity);
            try (PreparedStatement ps = connection.prepareStatement(sqlParams.getSql())) {
                setParams(ps, sqlParams.getParams());
                ps.executeUpdate();
            }
        } catch (Exception e) {
            throw new RuntimeException("Error removing entity " + entityClass.getName(), e);
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
