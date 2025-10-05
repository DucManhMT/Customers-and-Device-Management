package crm.core.repository.hibernate.querybuilder;

import crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO;
import crm.core.repository.hibernate.querybuilder.enums.SortDirection;
import crm.core.repository.hibernate.annotation.*;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class SelectBuilder {
    private final Class<?> entityClass;
    private final String tableName;
    private final List<String> conditions = new ArrayList<>();
    private final List<Object> params = new ArrayList<>();
    private final List<String> orderByCondition = new ArrayList<>();
    private Integer limit;
    private Integer offset;

    public SelectBuilder(Class<?> entityClass) {
        this.entityClass = entityClass;
        Entity entity = entityClass.getAnnotation(Entity.class);
        if (entity == null){
            throw new RuntimeException("Missing @Entity annotation on " + entityClass.getSimpleName());
        }
        this.tableName = entity.tableName();
    }

    // ---------- WHERE ----------
    public SelectBuilder where(Map<String,Object> whereCondition) {
        for (String fieldName : whereCondition.keySet()){
            try {
                Field field = this.entityClass.getDeclaredField(fieldName);
                String columnName = EntityFieldMapper.getColumnName(field);
                conditions.add(columnName + " = ?");
                params.add(whereCondition.get(fieldName));
            } catch (NoSuchFieldException e) {
                throw new RuntimeException("Field not found: " + fieldName, e);
            }

        }
        return this;

    }

    // ---------- ORDER BY ----------
    public SelectBuilder orderBy(Map<String,SortDirection> orderCondition) {
        for (String fieldName : orderCondition.keySet()){
            try {
                Field field = this.entityClass.getDeclaredField(fieldName);
                String columnName = EntityFieldMapper.getColumnName(field);
                orderByCondition.add(columnName + " ?");
                params.add(orderCondition.get(fieldName).name());
            } catch (NoSuchFieldException e) {
                throw new RuntimeException("Field not found: " + fieldName, e);
            }

        }
        return this;
    }

    // ---------- LIMIT / OFFSET ----------
    public SelectBuilder limit(int limit) {
        this.limit = limit;
        return this;
    }

    public SelectBuilder offset(int offset) {
        this.offset = offset;
        return this;
    }

    // ---------- BUILD ----------
    public SqlAndParamsDTO build() {
        StringBuilder sql = new StringBuilder("SELECT * FROM ").append(tableName);
        if (!conditions.isEmpty()) {
            sql.append(" WHERE ").append(String.join(" AND ", conditions));
        }
        if (!orderByCondition.isEmpty()) {
            sql.append(" ORDER BY ").append(String.join(", ", orderByCondition));
        }
        if (limit != null) sql.append(" LIMIT ").append(limit);
        if (offset != null) sql.append(" OFFSET ").append(offset);
        return new SqlAndParamsDTO(sql.toString(), params);
    }
}
