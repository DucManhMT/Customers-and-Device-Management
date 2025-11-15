package crm.service_request.repository.persistence;

import java.lang.reflect.Field;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import crm.core.config.TransactionManager;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.querybuilder.EntityFieldMapper;
import crm.core.repository.hibernate.querybuilder.QueryUtils;
import crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO;
import crm.service_request.repository.persistence.query.common.ClauseBuilder;
import crm.service_request.repository.persistence.query.common.Page;
import crm.service_request.repository.persistence.query.common.PageRequest;
import crm.service_request.repository.persistence.query.crud.DeleteQueryBuilder;
import crm.service_request.repository.persistence.query.crud.InsertQueryBuilder;
import crm.service_request.repository.persistence.query.crud.SelectQueryBuilder;

public abstract class AbstractRepository<E, K> implements CrudRepository<E, K> {

    private Class<E> entityClass;
    private Field keyField;
    private List<Field> fields;
    private String tableName;
    private final List<String> columns;
    private final QueryUtils queryUtils = new QueryUtils();

    public AbstractRepository(Class<E> entityClass) {
        this.entityClass = entityClass;
        this.keyField = EntityFieldMapper.findKeyField(entityClass);
        fields = List.of(entityClass.getDeclaredFields());
        tableName = EntityFieldMapper.getTableName(entityClass);
        columns = fields.stream()
                .filter(f -> !EntityFieldMapper.isOneToMany(f))
                .map(EntityFieldMapper::getColumnName)
                .filter(col -> col != null && !col.isBlank())
                .toList();
    }

    @Override
    public int count() {
        int count = 0;
        String query = "SELECT count(*) FROM " + tableName;
        Connection connection = DBcontext.getConnection();
        try (PreparedStatement statement = connection.prepareStatement(query);
             ResultSet resultSet = statement.executeQuery()) {
            if (resultSet.next()) {
                count = resultSet.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    @Override
    public void deleteById(K key) throws SQLException {
        DeleteQueryBuilder deleteBuilder = DeleteQueryBuilder.builder(tableName)
                .where(EntityFieldMapper.getColumnName(keyField) + " = ?", key);
        Connection connection = TransactionManager.getConnection();
        try (PreparedStatement statement = connection.prepareStatement(deleteBuilder.build())) {
            setStatementParameters(statement, deleteBuilder.getParameters());
            statement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    @Override
    public List<E> findAll() {
        List<E> results = null;
        SelectQueryBuilder selectBuilder = SelectQueryBuilder.builder(tableName).columns(columns);
        Connection connection = DBcontext.getConnection();
        try (PreparedStatement statement = connection.prepareStatement(selectBuilder.build());) {
            try (ResultSet resultSet = statement.executeQuery()) {
                results = mapListResultSetToEntities(resultSet);
            } catch (Exception e) {
                e.printStackTrace();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return results;
    }

    public Page<E> findAll(PageRequest pageRequest) {
        List<E> results = null;
        int total = 0;
        try {
            Connection connection = DBcontext.getConnection();
            // Build the base select query
            SelectQueryBuilder builder = SelectQueryBuilder.builder(tableName)
                    .columns(columns);
            // Count total records
            total = countRecord(builder, connection);
            int offset = (pageRequest.getPageNumber() - 1) * pageRequest.getPageSize();
            // Apply pagination and sorting to the original query
            builder.limit(pageRequest.getPageSize()).offset(offset);
            if (pageRequest.getOrders() != null && !pageRequest.getOrders().isEmpty()) {
                builder.orderBy(pageRequest.getOrders());
            } else if (pageRequest.getSort() != null && !pageRequest.getSort().getOrders().isEmpty()) { // backward
                // compat
                builder.orderBy(pageRequest.getSort().getOrders());
            }
            try (PreparedStatement statement = connection.prepareStatement(builder.build());) {
                setStatementParameters(statement, builder.getParameters());
                try (ResultSet resultSet = statement.executeQuery()) {
                    results = mapListResultSetToEntities(resultSet);
                } catch (Exception e) {
                    e.printStackTrace();
                }

                return new Page<E>(total, pageRequest, results);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public E findById(K key) {
        E entity = null;
        SelectQueryBuilder builder = SelectQueryBuilder.builder(tableName)
                .where(EntityFieldMapper.getColumnName(keyField) + " = ?", key);
        Connection connection = DBcontext.getConnection();
        try (PreparedStatement statement = connection.prepareStatement(builder.build());) {
            setStatementParameters(statement, builder.getParameters());
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    entity = EntityFieldMapper.mapEntity(resultSet, entityClass);
                    return entity;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public List<E> findWithCondition(ClauseBuilder clause) {
        List<E> results = new ArrayList<>();
        SelectQueryBuilder builder = SelectQueryBuilder.builder(tableName).columns(columns).where(clause);
        Connection connection = DBcontext.getConnection();
        try (PreparedStatement statement = connection.prepareStatement(builder.build());) {
            setStatementParameters(statement, builder.getParameters());
            try (ResultSet resultSet = statement.executeQuery()) {
                results = mapListResultSetToEntities(resultSet);
            } catch (Exception e) {
                e.printStackTrace();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return results;
    }

    public Page<E> findWithCondtion(ClauseBuilder clause, PageRequest pageRequest) {
        int total = 0;
        List<E> results = null;
        SelectQueryBuilder builder = SelectQueryBuilder.builder(tableName).columns(columns).where(clause);

        try {
            Connection connection = DBcontext.getConnection();
            total = countRecord(builder, connection);
            int offset = (pageRequest.getPageNumber() - 1) * pageRequest.getPageSize();
            builder.limit(pageRequest.getPageSize()).offset(offset);
            if (pageRequest.getOrders() != null && !pageRequest.getOrders().isEmpty()) {
                builder.orderBy(pageRequest.getOrders());
            } else if (pageRequest.getSort() != null && !pageRequest.getSort().getOrders().isEmpty()) { // backward
                // compat
                builder.orderBy(pageRequest.getSort().getOrders());
            }
            try (PreparedStatement statement = connection.prepareStatement(builder.build());) {
                setStatementParameters(statement, builder.getParameters());
                try (ResultSet resultSet = statement.executeQuery()) {
                    results = mapListResultSetToEntities(resultSet);
                } catch (Exception e) {
                    e.printStackTrace();
                }

                return new Page<E>(total, pageRequest, results);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;

    }

    @Override
    public boolean isExist(K key) {
        String query = "SELECT 1 FROM " + tableName + " WHERE "
                + EntityFieldMapper.getColumnName(keyField) + " = ? LIMIT 1";
        Connection connection = DBcontext.getConnection();
        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setObject(1, key);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public E save(E entity) throws SQLException {
        Connection connection = TransactionManager.getConnection();
        SqlAndParamsDTO sqlParams = queryUtils.buildInsert(entity);
        InsertQueryBuilder insertBuilder = InsertQueryBuilder.builder(tableName).columns(columns)
                .values(getFieldValues(entity));
        try (PreparedStatement statement = connection.prepareStatement(insertBuilder.build())) {
            setStatementParameters(statement, insertBuilder.getParameters());
            statement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return entity;
    }

    @Override
    public List<E> saveAll(List<E> entities) throws SQLException {
        Connection connection = TransactionManager.getConnection();
        InsertQueryBuilder insertBuilder = InsertQueryBuilder.builder(tableName).columns(columns);
        for (E entity : entities) {
            insertBuilder.values(getFieldValues(entity));
        }
        try (PreparedStatement statement = connection.prepareStatement(insertBuilder.build())) {
            setStatementParameters(statement, insertBuilder.getParameters());
            statement.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return entities;
    }

    @Override
    public E update(E entity) throws SQLException {
        Connection connection = TransactionManager.getConnection();
        try {
            SqlAndParamsDTO sqlParams = queryUtils.buildUpdate(entity);
            try (PreparedStatement ps = connection.prepareStatement(sqlParams.getSql())) {
                setStatementParameters(ps, sqlParams.getParams());
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return entity;
    }

    protected int countRecord(SelectQueryBuilder selectBuilder, Connection connection) {
        int count = 0;
        String countQuery = "SELECT COUNT(*) AS total FROM (" + selectBuilder.build(false) + ") AS count_table";
        try (PreparedStatement statement = connection.prepareStatement(countQuery)) {
            setStatementParameters(statement, selectBuilder.getParameters());
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    count = resultSet.getInt("total");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    protected void setStatementParameters(PreparedStatement statement, List<Object> values) throws SQLException {
        if (values != null) {
            for (int i = 0; i < values.size(); i++) {
                statement.setObject(i + 1, values.get(i));
            }
        }
    }

    protected List<Object> getFieldValues(E entity) {
        return EntityMapper.mapToColumnsAndValues(entity).getValues();
    }

    protected List<E> mapListResultSetToEntities(ResultSet resultSet) {
        List<E> results = new ArrayList<>();
        try {
            while (resultSet.next()) {
                E entity = EntityFieldMapper.mapEntity(resultSet, entityClass);
                results.add(entity);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return results;
    }

}
