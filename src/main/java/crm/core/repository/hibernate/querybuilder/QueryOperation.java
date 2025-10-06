package crm.core.repository.hibernate.querybuilder;

import crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO;
import crm.core.repository.hibernate.querybuilder.enums.SortDirection;

import javax.management.Query;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

public class QueryOperation {
    SqlAndParamsDTO sqlAndParamsDTO;

    public QueryOperation() {
    }
    public QueryOperation(SqlAndParamsDTO sqlAndParamsDTO) {
        this.sqlAndParamsDTO = sqlAndParamsDTO;
    }

    public SqlAndParamsDTO getSqlAndParamsDTO() {
        return sqlAndParamsDTO;
    }

    public void setSqlAndParamsDTO(SqlAndParamsDTO sqlAndParamsDTO) {
        this.sqlAndParamsDTO = sqlAndParamsDTO;
    }

    // Insert
    public static Insert insert(Object entity) {
        return new Insert();
    }
    // Update
    public static Update update(Object entity) {
        return new Update();
    }
    // Select
    public static Select select(Class<?> entityClass) {
        return new Select(entityClass);
    }
    //Delete
    public static Delete delete(Object entity) {
        return new Delete();
    }

    // Placeholder for Insert operation
    public static class Insert  {

    }

    // Placeholder for Update operation
    public static class Update  {

    }

    // Placeholder for Delete operation
    public static class Delete {

    }

    public static class Select {
        private final StringBuilder selectClause;
        private final Class<?> entityClass;
        private final StringBuilder whereClause = new StringBuilder();
        private final StringBuilder orderByClause = new StringBuilder();
        private final List<Object> parameters = new ArrayList<>();
        private Integer limit;
        private Integer offset;
        public Select( Class<?> entityClass) {
            this.entityClass = entityClass;
            this.selectClause = new StringBuilder("SELECT * ");
            String tableName = EntityFieldMapper.getTableName(entityClass);
            this.selectClause.append("FROM ").append(tableName);

        }

        public Select where(String fieldName, Object value) {
            try {
                Field field = entityClass.getDeclaredField(fieldName);
                String columnName = EntityFieldMapper.getColumnName(field);
                if (whereClause.isEmpty()) {
                    whereClause.append(" WHERE ");
                } else {
                    whereClause.append(" AND ");
                }
                whereClause.append(columnName).append(" = ?");
                parameters.add(value);
                return this;
            } catch (Exception e) {
                e.printStackTrace();
            }
            return this;
        }
        public Select and(String fieldName, Object value) {
            return where(fieldName, value);
        }


        public Select or(String fieldName, Object value) {
            try {
                Field field = entityClass.getDeclaredField(fieldName);
                String columnName = EntityFieldMapper.getColumnName(field);
                if (whereClause.isEmpty()) {
                    whereClause.append(" WHERE ");
                } else {
                    whereClause.append(" OR ");
                }
                whereClause.append(columnName).append(" = ?");
                parameters.add(value);
                return this;
            } catch (Exception e) {
                e.printStackTrace();
            }
            return this;
        }


        public Select orderBy(String fieldName, SortDirection direction) {
            try {
                Field field = entityClass.getDeclaredField(fieldName);
                String columnName = EntityFieldMapper.getColumnName(field);
                if (orderByClause.isEmpty()) {
                    orderByClause.append(" ORDER BY ");
                } else {
                    orderByClause.append(", ");
                }
                orderByClause.append(columnName).append(" ").append(direction.name());
            } catch (Exception e) {
                throw new RuntimeException("Invalid field in orderBy: " + fieldName, e);
            }
            return this;
        }

        public Select limit(int limit) {
            this.limit = limit;
            return this;
        }

        public Select offset(int offset) {
            this.offset = offset;
            return this;
        }

        public QueryOperation build() {
            StringBuilder sql = new StringBuilder(selectClause);
            sql.append(whereClause);
            if (!orderByClause.isEmpty()) {
                sql.append(orderByClause);
            }
            if (limit != null) {
                sql.append(" LIMIT ").append(limit);
            }
            if (offset != null) {
                sql.append(" OFFSET ").append(offset);
            }
            SqlAndParamsDTO dto = new SqlAndParamsDTO(sql.toString(), parameters);
            return new QueryOperation(dto);
        }
    }

}
