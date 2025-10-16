package crm.core.repository.hibernate.entitymanager;

import java.sql.Connection;
import java.util.List;

import crm.core.repository.hibernate.querybuilder.QueryOperation;
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
public class EntityManager implements IEntityManager,AutoCloseable {

    private final Connection connection;
    private final QueryUtils queryUtils = new QueryUtils();


     public EntityManager(Connection connection) {
        this.connection = connection;
    }

    // ---------- PERSIST ----------
    @Override
    public <T> boolean persist(T entity, Class<T> entityClass) {
        try {
            SqlAndParamsDTO sqlParams = queryUtils.buildInsert(entity);
            try (PreparedStatement ps = connection.prepareStatement(sqlParams.getSql())) {
                setParams(ps, sqlParams.getParams());
                ps.executeUpdate();
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
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
        // Read operations no longer require explicit transaction
        try {
            SqlAndParamsDTO sqlParams = queryUtils.buildSelectById(entityClass, primaryKey);
            try (PreparedStatement ps = connection.prepareStatement(sqlParams.getSql())) {
                ps.setObject(1, sqlParams.getParams().get(0));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return EntityFieldMapper.mapEntity(rs, entityClass);
                    }
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Error finding entity " + entityClass.getName(), e);
        }
        return null;
    }

    // ---------- FIND ALL----------
    public <T> List<T> findAll(Class<T> entityClass) {
        // Read operations allowed outside transaction
        try {
            SqlAndParamsDTO sqlParams = queryUtils.buildSelectAll(entityClass);
            List<T> results = new ArrayList<>();
            try (PreparedStatement ps = connection.prepareStatement(sqlParams.getSql());
                    ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
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
                    while (rs.next()) {
                        T entity = EntityFieldMapper.mapEntity(rs, entityClass);
                        results.add(entity);
                    }
                }
            }
            return results;
        } catch (Exception e) {
            throw new RuntimeException("Error finding entities of type " + entityClass.getName() + " with conditions",
                    e);
        }
    }

    // ---------- FIND WITH ORDER ----------
    public <T> List<T> findWithOrder(Class<T> entityClass, Map<String, SortDirection> orderConditions) {
        try {
            SqlAndParamsDTO sqlParams = queryUtils.buildSelectWithOrder(entityClass, orderConditions);
            List<T> results = new ArrayList<>();
            try (PreparedStatement ps = connection.prepareStatement(sqlParams.getSql());
                    ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    T entity = EntityFieldMapper.mapEntity(rs, entityClass);
                    results.add(entity);
                }
            }
            return results;
        } catch (Exception e) {
            throw new RuntimeException(
                    "Error finding entities of type " + entityClass.getName() + " with order conditions", e);
        }
    }

    // ---------- FIND WITH PAGINATION ----------
    public <T> List<T> findWithPagination(Class<T> entityClass, int limit, int offset) {
        try {
            SqlAndParamsDTO sqlParams = queryUtils.buildSelectWithLimitOffset(entityClass, limit, offset);
            List<T> results = new ArrayList<>();
            try (PreparedStatement ps = connection.prepareStatement(sqlParams.getSql())) {
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        T entity = EntityFieldMapper.mapEntity(rs, entityClass);
                        results.add(entity);
                    }
                }
            }
            return results;
        } catch (Exception e) {
            throw new RuntimeException("Error finding entities of type " + entityClass.getName() + " with pagination",
                    e);
        }
    }

    // ---------- FIND WITH CONDITIONS AND ORDER ----------
    public <T> List<T> findWithConditionsAndOrder(Class<T> entityClass, Map<String, Object> conditions,
            Map<String, SortDirection> orderConditions) {
        try {
            SqlAndParamsDTO sqlParams = queryUtils.buildSelectWithConditionsAndOrder(entityClass, conditions,
                    orderConditions);
            List<T> results = new ArrayList<>();
            try (PreparedStatement ps = connection.prepareStatement(sqlParams.getSql())) {
                setParams(ps, sqlParams.getParams());
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        T entity = EntityFieldMapper.mapEntity(rs, entityClass);
                        results.add(entity);
                    }
                }
            }
            return results;
        } catch (Exception e) {
            throw new RuntimeException(
                    "Error finding entities of type " + entityClass.getName() + " with conditions and order", e);
        }
    }

    // ---------- FIND WITH CONDITIONS AND PAGINATION ----------
    public <T> List<T> findWithConditionsAndPagination(Class<T> entityClass, Map<String, Object> conditions, int limit,
            int offset) {
        try {
            SqlAndParamsDTO sqlParams = queryUtils.buildSelectWithConditionsAndLimitOffset(entityClass, conditions,
                    limit, offset);
            List<T> results = new ArrayList<>();
            try (PreparedStatement ps = connection.prepareStatement(sqlParams.getSql())) {
                setParams(ps, sqlParams.getParams());
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        T entity = EntityFieldMapper.mapEntity(rs, entityClass);
                        results.add(entity);
                    }
                }
            }
            return results;
        } catch (Exception e) {
            throw new RuntimeException(
                    "Error finding entities of type " + entityClass.getName() + " with conditions and pagination", e);
        }
    }

    // ---------- FIND WITH ORDER AND PAGINATION ----------
    public <T> List<T> findWithOrderAndPagination(Class<T> entityClass, Map<String, SortDirection> orderConditions,
            int limit, int offset) {
        try {
            SqlAndParamsDTO sqlParams = queryUtils.buildSelectWithOrderAndLimitOffset(entityClass, orderConditions,
                    limit, offset);
            List<T> results = new ArrayList<>();
            try (PreparedStatement ps = connection.prepareStatement(sqlParams.getSql())) {
                setParams(ps, sqlParams.getParams());
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        T entity = EntityFieldMapper.mapEntity(rs, entityClass);
                        results.add(entity);
                    }
                }
            }
            return results;
        } catch (Exception e) {
            throw new RuntimeException(
                    "Error finding entities of type " + entityClass.getName() + " with order and pagination", e);
        }
    }

    // ---------- FIND WITH CONDITIONS, ORDER AND PAGINATION ----------
    public <T> List<T> findWithConditionsOrderAndPagination(Class<T> entityClass, Map<String, Object> conditions,
            Map<String, SortDirection> orderConditions, int limit, int offset) {
        try {
            SqlAndParamsDTO sqlParams = queryUtils.buildSelectWithAll(entityClass, conditions, orderConditions, limit,
                    offset);
            List<T> results = new ArrayList<>();
            try (PreparedStatement ps = connection.prepareStatement(sqlParams.getSql())) {
                setParams(ps, sqlParams.getParams());
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        T entity = EntityFieldMapper.mapEntity(rs, entityClass);
                        results.add(entity);
                    }
                }
            }
            return results;
        } catch (Exception e) {
            throw new RuntimeException("Error finding entities of type " + entityClass.getName()
                    + " with conditions, order and pagination", e);
        }
    }

    // ---------- QUERY ----------
    public <T> List<T> executeQuery(SqlAndParamsDTO sqlAndParamsDTO, Class<T> resultClass) {
        try {
            List<T> results = new ArrayList<>();
            try (PreparedStatement ps = connection.prepareStatement(sqlAndParamsDTO.getSql())) {
                setParams(ps, sqlAndParamsDTO.getParams());
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    T entity = EntityFieldMapper.mapEntity(rs, resultClass);
                    results.add(entity);
                }
            }
            return results;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void executeUpdate(SqlAndParamsDTO sqlAndParamsDTO) {
        try (PreparedStatement ps = connection.prepareStatement(sqlAndParamsDTO.getSql())) {
            setParams(ps, sqlAndParamsDTO.getParams());
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error executing update", e);
        }
    }

    //ADVANCED QUERY WITH BUILDER
    public <T> List<T> executeCustomQuery(Class<T> resultClass, QueryOperation queryOperation) {
        try {
            SqlAndParamsDTO sqlParams = queryOperation.getSqlAndParamsDTO();
            List<T> results = new ArrayList<>();
            try (PreparedStatement ps = connection.prepareStatement(sqlParams.getSql())) {
                setParams(ps, sqlParams.getParams());
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        T entity = EntityFieldMapper.mapEntity(rs, resultClass);
                        results.add(entity);
                    }
                }
            }
            return results;
        } catch (Exception e) {
            throw new RuntimeException("Error executing advanced query for " + resultClass.getName(), e);
        }
    }

    // -------------COUNT-------------
    public <T> int count(Class<T> entityClass) {
        try {
            SqlAndParamsDTO sqlParams = queryUtils.buildCount(entityClass);
            try (PreparedStatement ps = connection.prepareStatement(sqlParams.getSql());
                    ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Error counting entities of type " + entityClass.getName(), e);
        }
        return 0;
    }

    public void beginTransaction() throws SQLException {
        if (connection.getAutoCommit()) {
            connection.setAutoCommit(false);
        }
    }
    public void commit() throws SQLException {
        if (!connection.getAutoCommit()) {
            connection.commit();
            connection.setAutoCommit(true);
        }
    }
    public void rollback() {
        try {
            if (!connection.getAutoCommit()) {
                connection.rollback();
                connection.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ---------- COUNT WITH CONDITIONS ----------
    public <T> int countWithConditions(Class<T> entityClass, Map<String, Object> conditions) {
        try {
            SqlAndParamsDTO selectSqlParams = queryUtils.buildSelectWithConditions(entityClass, conditions);
            String selectSql = selectSqlParams.getSql();
            String upper = selectSql.toUpperCase();
            int fromIdx = upper.indexOf(" FROM ");
            String countSql;
            if (fromIdx != -1) {
                countSql = "SELECT COUNT(*) AS total" + selectSql.substring(fromIdx);
            } else {
                SqlAndParamsDTO cnt = queryUtils.buildCount(entityClass);
                countSql = cnt.getSql();
            }

            try (PreparedStatement ps = connection.prepareStatement(countSql)) {
                setParams(ps, selectSqlParams.getParams());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Error counting entities of type " + entityClass.getName() + " with conditions", e);
        }
        return 0;
    }



    // ---------- UTILITIES ----------

    private void setParams(PreparedStatement ps, List<Object> params) throws SQLException {
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
    }

    @Override
    public void close() throws Exception {
        if (connection != null && !connection.isClosed()) {
            connection.close();
        }
    }
}
