package crm.core.repository.hibernate.querybuilder;

import crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

/**
 * Builds an UPDATE ... SET ... WHERE key = ? statement from an annotated entity.
 */
public class UpdateBuilder<T> {

    private final T entity;
    private final String tableName;
    private final List<String> setFragments = new ArrayList<>();
    private final List<Object> params = new ArrayList<>();
    private String keyColumn;
    private Object keyValue;

    public UpdateBuilder(T entity) {
        this.entity = entity;
        this.tableName = EntityFieldMapper.getTableName(entity.getClass());
        map();
    }

    private void map() {
        try {
            Class<?> clazz = entity.getClass();
            for (Field field : clazz.getDeclaredFields()) {
                field.setAccessible(true);

                if (EntityFieldMapper.isKey(field)) {
                    keyColumn = EntityFieldMapper.getColumnName(field);
                    keyValue = field.get(entity);
                    continue;
                }

                boolean updatable =
                        EntityFieldMapper.isColumn(field) ||
                                EntityFieldMapper.isManyToOne(field) ||
                                EntityFieldMapper.isOneToOne(field);

                if (!updatable) continue;

                Object rawVal = field.get(entity);
                if (rawVal == null) continue;

                Object value = EntityFieldMapper.extractValue(entity, field);
                setFragments.add(EntityFieldMapper.getColumnName(field) + " = ?");
                params.add(value);
            }

            if (keyColumn == null)
                throw new IllegalStateException("No @Key field found in " + clazz.getSimpleName());
        } catch (Exception e) {
            throw new RuntimeException("Failed to prepare UPDATE mapping", e);
        }
    }

    public SqlAndParamsDTO build() {
        if (setFragments.isEmpty())
            throw new IllegalStateException("No non-null updatable columns for " + entity.getClass().getSimpleName());

        String sql = "UPDATE " + tableName +
                " SET " + String.join(", ", setFragments) +
                " WHERE " + keyColumn + " = ?";

        List<Object> finalParams = new ArrayList<>(params);
        finalParams.add(keyValue);

        return new SqlAndParamsDTO(sql, finalParams);
    }
}
