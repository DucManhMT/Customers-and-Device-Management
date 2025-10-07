package crm.core.repository.persistence.repository;

import java.lang.reflect.Field;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import crm.core.repository.hibernate.querybuilder.EntityFieldMapper;
import crm.core.repository.persistence.config.TransactionManager;
import crm.core.repository.persistence.query.clause.ClauseBuilder;
import crm.core.repository.persistence.query.common.Page;
import crm.core.repository.persistence.query.common.PageRequest;
import crm.core.repository.persistence.query.crud.DeleteBuilder;
import crm.core.repository.persistence.query.crud.InsertBuilder;
import crm.core.repository.persistence.query.crud.SelectBuilder;
import crm.core.repository.persistence.query.crud.UpdateBuilder;

public abstract class AbstractRepository<E, K> implements CrudRepository<E, K> {

    private Class<E> entityClass;
    private Field keyField;
    private List<Field> fields;
    private String tableName;
    private final List<String> columns;

    public AbstractRepository(Class<E> entityClass) {
        this.entityClass = entityClass;
        this.keyField = EntityFieldMapper.findKeyField(entityClass);
        fields = List.of(entityClass.getDeclaredFields());
        tableName = EntityFieldMapper.getTableName(entityClass);
        columns = fields.stream().filter((f) -> !EntityFieldMapper.isOneToMany(f))
                .map(EntityFieldMapper::getColumnName)
                .toList();
    }

    @Override
    public int count() {
        int count = 0;
        try {
            TransactionManager.beginTransaction();
            Connection connection = TransactionManager.getConnection();
            String query = "Slect count(*) from " + tableName;
            try (PreparedStatement statement = connection.prepareStatement(query)) {
                try (ResultSet resultSet = statement.executeQuery()) {
                    if (resultSet.next()) {
                        count = resultSet.getInt(1);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
            TransactionManager.commit();
        } catch (SQLException e) {
            try {
                TransactionManager.rollback();
            } catch (SQLException e1) {
                // TODO Auto-generated catch block
                e1.printStackTrace();
            }
            e.printStackTrace();
        }
        return count;
    }

    @Override
    public void deleteById(K key) throws SQLException {
        DeleteBuilder deleteBuilder = DeleteBuilder.builder(tableName)
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
    public void deleteWithCondition(ClauseBuilder clause) throws SQLException {
        DeleteBuilder deleteBuilder = DeleteBuilder.builder(tableName).where(clause.build(),
                clause.getParameters());
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
        SelectBuilder selectBuilder = SelectBuilder.builder(tableName).columns(columns);
        Connection connection = TransactionManager.getConnection();
        try (PreparedStatement statement = connection.prepareStatement(selectBuilder.build())) {
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
            TransactionManager.beginTransaction();
            Connection connection = TransactionManager.getConnection();
            // Build the base select query
            SelectBuilder builder = SelectBuilder.builder(tableName)
                    .columns(columns);
            // Count total records
            total = countRecord(builder, connection);
            int offset = (pageRequest.getPageNumber() - 1) * pageRequest.getPageSize();
            // Apply pagination and sorting to the original query
            builder.limit(pageRequest.getPageSize()).offset(offset);
            if (pageRequest.getSort() != null && !pageRequest.getSort().getOrders().isEmpty()) {
                builder.orderBy(pageRequest.getSort().getOrders());
            }
            try (PreparedStatement statement = connection.prepareStatement(builder.build())) {
                setStatementParameters(statement, builder.getParameters());
                try (ResultSet resultSet = statement.executeQuery()) {
                    results = mapListResultSetToEntities(resultSet);
                    return new Page<E>(total, pageRequest, results);
                } catch (Exception e) {
                    e.printStackTrace();
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
            TransactionManager.commit();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public E findById(K key) {
        E entity = null;
        SelectBuilder builder = SelectBuilder.builder(tableName)
                .where(EntityFieldMapper.getColumnName(keyField) + " = ?", key);
        Connection connection = TransactionManager.getConnection();
        try (PreparedStatement statement = connection.prepareStatement(builder.build())) {
            setStatementParameters(statement, builder.getParameters());
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    entity = EntityFieldMapper.mapEntity(resultSet, entityClass);
                    return entity;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public List<E> findWithCondition(ClauseBuilder clause) {
        List<E> results = null;
        SelectBuilder builder = SelectBuilder.builder(tableName).columns(columns).where(clause);
        try {
            TransactionManager.beginTransaction();
            Connection connection = TransactionManager.getConnection();
            try (PreparedStatement statement = connection.prepareStatement(builder.build())) {
                setStatementParameters(statement, builder.getParameters());
                try (ResultSet resultSet = statement.executeQuery()) {
                    results = mapListResultSetToEntities(resultSet);
                } catch (Exception e) {
                    e.printStackTrace();
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
            TransactionManager.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return results;
    }

    public Page<E> findWithCondtion(ClauseBuilder clause, PageRequest pageRequest) {
        int total = 0;
        List<E> results = null;
        SelectBuilder builder = SelectBuilder.builder(tableName).columns(columns).where(clause);

        try {
            TransactionManager.beginTransaction();
            Connection connection = TransactionManager.getConnection();
            total = countRecord(builder, connection);
            int offset = (pageRequest.getPageNumber() - 1) * pageRequest.getPageSize();
            builder.limit(pageRequest.getPageSize()).offset(offset);
            if (pageRequest.getSort() != null && !pageRequest.getSort().getOrders().isEmpty()) {
                builder.orderBy(pageRequest.getSort().getOrders());
            }
            try (PreparedStatement statement = connection.prepareStatement(builder.build())) {
                setStatementParameters(statement, builder.getParameters());
                try (ResultSet resultSet = statement.executeQuery()) {
                    results = mapListResultSetToEntities(resultSet);
                    return new Page<E>(total, pageRequest, results);
                } catch (Exception e) {
                    e.printStackTrace();
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
    public boolean isExist(K key) {
        try {
            TransactionManager.beginTransaction();
            Connection connection = TransactionManager.getConnection();
            String query = "SELECT 1 FROM " + tableName + " WHERE "
                    + EntityFieldMapper.getColumnName(keyField) + " = ? LIMIT 1";
            try (PreparedStatement statement = connection.prepareStatement(query)) {
                statement.setObject(1, key);
                try (ResultSet resultSet = statement.executeQuery()) {
                    if (resultSet.next()) {
                        return true;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
            TransactionManager.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public E save(E entity) throws SQLException {
        Connection connection = TransactionManager.getConnection();
        InsertBuilder insertBuilder = InsertBuilder.builder(tableName).columns(columns).values(getFieldValues(entity));
        System.out.println(insertBuilder.getParameters());
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
        InsertBuilder insertBuilder = InsertBuilder.builder(tableName).columns(columns);
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
        UpdateBuilder builder = UpdateBuilder.builder(tableName);
        List<Object> values = EntityFieldMapper.mapToColumnsAndValues(entity).getValues();
        String keyColumnName = EntityFieldMapper.getColumnName(keyField);
        Object keyValue = null;

        for (int i = 0; i < columns.size(); i++) {
            if (columns.get(i).equals(keyColumnName)) {
                keyValue = values.get(i);
                continue;
            }
            builder.set(columns.get(i), values.get(i));

        }
        builder.where(keyColumnName + " = ?", keyValue);

        try (PreparedStatement statement = connection.prepareStatement(builder.build())) {
            setStatementParameters(statement, builder.getParameters());
            statement.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return entity;
    }

    protected int countRecord(SelectBuilder selectBuilder, Connection connection) {
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
