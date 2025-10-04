package crm.core.repository.hibernate.querybuilder;

import java.lang.reflect.Field;
import crm.core.repository.hibernate.annotation.*;
import crm.core.repository.hibernate.entitymanager.LazyReference;
import java.sql.ResultSet;

public class EntityFieldMapper {

    public static boolean isKey(Field field) {
        return field.isAnnotationPresent(Key.class);
    }

    public static boolean isColumn(Field field) {
        return field.isAnnotationPresent(Column.class);
    }

    public static boolean isEnumerated(Field field) {
        return field.isAnnotationPresent(Enumerated.class);
    }

    public static boolean isManyToOne(Field field) {
        return field.isAnnotationPresent(ManyToOne.class);
    }

    public static boolean isOneToOne(Field field) {
        return field.isAnnotationPresent(OneToOne.class);
    }

    public static boolean isOneToMany(Field field) {
        return field.isAnnotationPresent(OneToMany.class);
    }

    public static String getColumnName(Field field) {
        if (field.isAnnotationPresent(Column.class)) {
            return field.getAnnotation(Column.class).name();
        }
        throw new RuntimeException("Field " + field.getName() + " has no @Column annotation");
    }

    public static Object extractValue(Object entity, Field field) {
        try {
            field.setAccessible(true);
            Object value = field.get(entity);

            // Enum xử lý đặc biệt nếu có @Enumerated
            if (isEnumerated(field) && value != null) {
                return value.toString(); // Lưu dưới dạng VARCHAR
            }

            // LazyReference thì lấy FK
            if (value instanceof LazyReference<?> ref) {
                return ref.getForeignKeyValue();
            }

            return value;
        } catch (Exception e) {
            throw new RuntimeException("Cannot extract value for field " + field.getName(), e);
        }
    }


    public static Object extractValueFromResultSet(Field field, ResultSet rs) {
        try {
            String columnName = null;
            if (isColumn(field)) {
                columnName = getColumnName(field);
            } else if (isManyToOne(field)) {
                // Lấy tên cột từ @ManyToOne/@JoinColumn
                ManyToOne ann = field.getAnnotation(ManyToOne.class);
                columnName = ann.joinColumn(); // giả sử bạn có attribute joinColumn trong annotation
            }

            if (columnName == null) {
                throw new RuntimeException("No column mapping for field " + field.getName());
            }

            Object value = rs.getObject(columnName);

            // Nếu là Enum, chuyển đổi từ String sang Enum
            if (isEnumerated(field) && value != null) {
                Class<?> enumType = field.getType();
                return Enum.valueOf((Class<Enum>) enumType, value.toString());
            }

            // Nếu là ManyToOne, tạo LazyReference
            if (isManyToOne(field) && value != null) {
                Class<?> targetType = getGenericType(field);
                return new LazyReference<>(targetType, value);
            }
            // TODO: handle OneToOne, OneToMany nếu cần


            return value;
        } catch (Exception e) {
            throw new RuntimeException("Cannot extract value from ResultSet for field " + field.getName(), e);
        }
    }

    public static <T> T mapEntity(ResultSet rs, Class<T> clazz) {
        try {
            T entity = clazz.getDeclaredConstructor().newInstance();

            for (Field field : clazz.getDeclaredFields()) {
                field.setAccessible(true);


                if (isColumn(field)) {
                    Object value = extractValueFromResultSet(field, rs);
                    field.set(entity, value);
                } if (isManyToOne(field)) {
                    Object value = extractValueFromResultSet(field, rs);
                    field.set(entity, value);
                }

            }

            return entity;
        } catch (Exception e) {
            throw new RuntimeException("Failed to map entity " + clazz.getSimpleName(), e);
        }
    }


    private static Class<?> getGenericType(Field field) {
        try {
            // field type is LazyReference<Role>, so extract Role
            String typeName = field.getGenericType().getTypeName();
            String innerClass = typeName.substring(typeName.indexOf("<") + 1, typeName.indexOf(">"));
            return Class.forName(innerClass);
        } catch (Exception e) {
            throw new RuntimeException("Cannot resolve generic type for field " + field.getName(), e);
        }
    }

}
