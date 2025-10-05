package crm.core.repository.hibernate.querybuilder;

import crm.core.repository.persistence.annotation.*;

import java.lang.reflect.Field;
<<<<<<< HEAD
import crm.core.repository.hibernate.annotation.*;
import crm.core.repository.hibernate.entitymanager.LazyReference;
import crm.core.repository.hibernate.querybuilder.DTO.ColumnsAndValuesDTO;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
=======

>>>>>>> main

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

<<<<<<< HEAD
    public static boolean isManyToOne(Field field) {
        return field.isAnnotationPresent(ManyToOne.class);
    }

    public static boolean isOneToOne(Field field) {
        return field.isAnnotationPresent(OneToOne.class);
    }

    public static boolean isOneToMany(Field field) {
        return field.isAnnotationPresent(OneToMany.class);
    }

    public static boolean isEntity(Class<?> clazz) {
        return clazz.isAnnotationPresent(Entity.class);
    }

=======
>>>>>>> main
    public static String getColumnName(Field field) {
        if (isColumn(field)) {
            return field.getAnnotation(Column.class).name();
        } else if (isManyToOne(field)) {
            ManyToOne ann = field.getAnnotation(ManyToOne.class);
            return ann.joinColumn(); // giả sử bạn có attribute joinColumn trong annotation
        } else if (isOneToOne(field)) {
            OneToOne ann = field.getAnnotation(OneToOne.class);
            return ann.joinColumn(); // giả sử bạn có attribute joinColumn trong annotation
        }
<<<<<<< HEAD

        throw new RuntimeException("Field " + field.getName() + " has no @Column annotation");
=======
        return field.getName();
>>>>>>> main
    }
    public static String getTableName(Class<?> clazz) {
        if (clazz.isAnnotationPresent(Entity.class)) {
            return clazz.getAnnotation(Entity.class).tableName();
        }
        throw new RuntimeException("Class " + clazz.getName() + " has no @Entity annotation");
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
<<<<<<< HEAD


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
            //Nếu là OneToOne, tạo LazyReference
            if (isOneToOne(field) && value != null) {
                Class<?> targetType = getGenericType(field);
                return new LazyReference<>(targetType, value);
            }

            // TODO: handle OneToMany nếu cần

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
                }
                if (isManyToOne(field)) {
                    Object value = extractValueFromResultSet(field, rs);
                    field.set(entity, value);
                }
                if (isOneToOne(field)) {
                    Object value = extractValueFromResultSet(field, rs);
                    field.set(entity, value);
                }

            }

            return entity;
        } catch (Exception e) {
            throw new RuntimeException("Failed to map entity " + clazz.getSimpleName(), e);
        }
    }

// Lấy kiểu generic của LazyReference<Role> -> Role
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

    public static Field findKeyField(Class<?> clazz) {
        for (Field field : clazz.getDeclaredFields()) {
            if (isKey(field)) {
                return field;
            }
        }
        throw new RuntimeException("No @Key field found in class " + clazz.getName());
    }

    public static ColumnsAndValuesDTO mapToColumnsAndValues(Object entity) {
        try {
            Class<?> clazz = entity.getClass();
            List<String> columns = new ArrayList<>();
            List<Object> values = new ArrayList<>();

            for (Field field : clazz.getDeclaredFields()) {
                field.setAccessible(true);
                if (isColumn(field)) {
                    String column = getColumnName(field);
                    Object value = extractValue(entity, field);
                    columns.add(column);
                    values.add(value);
                } else if (isManyToOne(field)) {
                    ManyToOne ann = field.getAnnotation(ManyToOne.class);
                    String column = ann.joinColumn();
                    Object value = extractValue(entity, field);
                    columns.add(column);
                    values.add(value);
                } else if (isOneToOne(field)) {
                    OneToOne ann = field.getAnnotation(OneToOne.class);
                    String column = ann.joinColumn();
                    Object value = extractValue(entity, field);
                    columns.add(column);
                    values.add(value);
                }
            }

            return new ColumnsAndValuesDTO(columns, values);
        } catch (Exception e) {
            throw new RuntimeException("Failed to map entity to columns and values", e);
        }
    }

=======
>>>>>>> main
}
