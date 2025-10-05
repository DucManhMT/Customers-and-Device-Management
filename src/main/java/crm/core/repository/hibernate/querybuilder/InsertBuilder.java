package crm.core.repository.hibernate.querybuilder;


import crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO;

import java.util.*;

/**
 * Builds INSERT INTO ... VALUES ... statements from annotated entity.
 */
public class InsertBuilder<T> {

    private final T entity;
    private final String tableName;
    private final List<String> columns;
    private final List<Object> values;

    public InsertBuilder(T entity) {
        this.entity = entity;
        this.tableName = EntityFieldMapper.getTableName(entity.getClass());
        this.columns = EntityFieldMapper.mapToColumnsAndValues(entity).getColumns();
        this.values = EntityFieldMapper.mapToColumnsAndValues(entity).getValues();
    }

    public SqlAndParamsDTO build() {
        String sql = "INSERT INTO " + tableName +
                " (" + String.join(", ", columns) + ")" +
                " VALUES (" + String.join(", ", Collections.nCopies(columns.size(), "?")) + ")";
        return new SqlAndParamsDTO(sql, values);
    }

}
