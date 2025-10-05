package crm.core.repository.hibernate.querybuilder;

import crm.core.repository.hibernate.annotation.*;
import crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

public class DeleteBuilder<T> {

    private final String tableName;
    private final String keyColumn;
    private final Object keyValue;
    private final List<Object> params = new ArrayList<>();

    // Khởi tạo từ entity
    public DeleteBuilder(T entity) {
        Class<?> clazz = entity.getClass();

        this.tableName = EntityFieldMapper.getTableName(clazz);

        Field keyField = EntityFieldMapper.findKeyField(clazz);

        if (EntityFieldMapper.isOneToMany(keyField)){
            this.keyColumn = keyField.getAnnotation(OneToMany.class).joinColumn();
            this.keyValue = EntityFieldMapper.extractValue(entity, keyField);
            params.add(keyValue);
        } else if (EntityFieldMapper.isOneToOne(keyField)){
            this.keyColumn = keyField.getAnnotation(OneToOne.class).joinColumn();
            this.keyValue = EntityFieldMapper.extractValue(entity, keyField);
            params.add(keyValue);
        } else {
            this.keyColumn = keyField.getAnnotation(Column.class).name();
            this.keyValue = EntityFieldMapper.extractValue(entity, keyField);
            params.add(keyValue);
        }

    }
    // Xây dựng câu lệnh SQL và tham số
    public SqlAndParamsDTO build() {
        if (keyColumn == null || keyValue == null) {
            throw new RuntimeException("Missing key column or value for delete operation");
        }

        String sql = "DELETE FROM " + tableName + " WHERE " + keyColumn + " = ?";
        return new SqlAndParamsDTO(sql, params);
    }
}