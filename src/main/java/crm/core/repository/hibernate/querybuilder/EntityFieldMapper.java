package crm.core.repository.hibernate.querybuilder;

import java.lang.reflect.Field;

import crm.core.config.DBcontext;
import crm.core.repository.hibernate.annotation.*;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.repository.hibernate.entitymanager.LazyReference;
import crm.core.repository.hibernate.querybuilder.DTO.ColumnsAndValuesDTO;
import crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO;

import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

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

    public static boolean isEntity(Class<?> clazz) {
        return clazz.isAnnotationPresent(Entity.class);
    }

    public static String getColumnName(Field field) {
        if (isColumn(field)) {
            return field.getAnnotation(Column.class).name();
        } else if (isManyToOne(field)) {
            ManyToOne ann = field.getAnnotation(ManyToOne.class);
            return ann.joinColumn(); // có attribute joinColumn trong annotation
        } else if (isOneToOne(field)) {
            OneToOne ann = field.getAnnotation(OneToOne.class);
            return ann.joinColumn(); // có attribute joinColumn trong annotation
        }
        System.out.println(field.getName());
        return null;
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

    // Lấy giá trị từ ResultSet dựa trên kiểu trường
    public static Object extractValueFromResultSet(Field field, ResultSet rs) {
        try {
            String columnName = null;
            if (isColumn(field)) {
                columnName = getColumnName(field);
            } else if (isManyToOne(field)) {
                // Lấy tên cột từ @ManyToOne/@JoinColumn
                ManyToOne ann = field.getAnnotation(ManyToOne.class);
                columnName = ann.joinColumn(); // giả sử bạn có attribute joinColumn trong annotation
            } else if (isOneToOne(field)) {
                // Lấy tên cột từ @OneToOne/@JoinColumn
                OneToOne ann = field.getAnnotation(OneToOne.class);
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
            // Nếu là OneToOne, tạo LazyReference
            if (isOneToOne(field) && value != null) {
                Class<?> targetType = getGenericType(field);
                return new LazyReference<>(targetType, value);
            }

            // TODO: handle OneToMany nếu cần

            return value;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Ánh xạ ResultSet thành entity
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
                if (isOneToMany(field)) {
                    // OneToMany không lấy từ ResultSet,
                    List<?> list = new EntityFieldMapper().getOneToManyList(entity);
                    field.set(entity, list);
                }

            }

            return entity;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
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

    public List<?> getOneToManyList(Object entity) {
        Class<?> clazz = entity.getClass();
        List<Object> result = new ArrayList<>();
        for (Field field : clazz.getDeclaredFields()) {
            try {
                if (isOneToMany(field)) {
                    OneToMany ann = field.getAnnotation(OneToMany.class);
                    String mappedBy = ann.mappedBy();
                    Class<?> targetEntity = ann.targetEntity();

                    // Lấy giá trị khóa chính của entity hiện tại
                    Field keyField = findKeyField(entity.getClass());
                    keyField.setAccessible(true);
                    Object keyValue = keyField.get(entity);
                    List<Object> paramList = new ArrayList<>();
                    paramList.add(keyValue);
                    // Tạo truy vấn để lấy danh sách liên quan
                    String sql = "SELECT * FROM " + getTableName(targetEntity) + " WHERE " + mappedBy + " = ?";
                    SqlAndParamsDTO sqlAndParamsDTO = new SqlAndParamsDTO(sql, paramList);
                    List<?> relatedEntities = new EntityFieldMapper().executeQuery(sqlAndParamsDTO, targetEntity);
                    result.addAll(relatedEntities);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

        }
        return result;
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

    private <T> List<T> executeQuery(SqlAndParamsDTO sqlAndParamsDTO, Class<T> resultClass) {
        // Thực thi truy vấn SQL với tham số và trả về ResultSet
        EntityManager em = new EntityManager(DBcontext.getConnection());
        List<T> result = em.executeQuery(sqlAndParamsDTO, resultClass);
        return result;
    }

}
