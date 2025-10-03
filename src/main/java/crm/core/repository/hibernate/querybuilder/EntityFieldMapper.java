package crm.core.repository.hibernate.querybuilder;

import crm.core.repository.persistence.annotation.*;

import java.lang.reflect.Field;


public class EntityFieldMapper {

    public static boolean isColumn(Field field) {
        return field.isAnnotationPresent(Column.class);
    }

    public static boolean isKey(Field field) {
        return field.isAnnotationPresent(Key.class);
    }

    public static boolean isEnumerated(Field field) {
        return field.isAnnotationPresent(Enumerated.class);
    }

    public static String getColumnName(Field field) {
        if (field.isAnnotationPresent(Column.class)) {
            return field.getAnnotation(Column.class).name();
        }
        return field.getName();
    }

    public static Object extractValue(Object entity, Field field) {
        try {
            field.setAccessible(true);
            Object value = field.get(entity);

            if (value != null && isEnumerated(field)) {
                return value.toString(); // Enum lưu dưới dạng String trong DB
            }
            return value;
        } catch (Exception e) {
            throw new RuntimeException("Error extracting value from field " + field.getName(), e);
        }
    }
}
