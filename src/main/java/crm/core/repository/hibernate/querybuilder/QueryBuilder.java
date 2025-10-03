package crm.core.repository.hibernate.querybuilder;
import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Table;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

/**
 * Generic QueryBuilder to create SQL statements based on entity annotations.
 * @param <T> Entity type
 */


import crm.core.repository.persistence.annotation.Entity;


public class QueryBuilder {

    // ---------- INSERT ----------
    public <T> SqlAndParamsDTO buildInsert(T entity) {
        Class<?> clazz = entity.getClass();
        checkEntity(clazz);

        String tableName = clazz.getAnnotation(Entity.class).tableName();

        List<String> cols = new ArrayList<>();
        List<String> placeholders = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        for (Field field : clazz.getDeclaredFields()) {
            if (EntityFieldMapper.isColumn(field) || EntityFieldMapper.isKey(field)) {
                cols.add(EntityFieldMapper.getColumnName(field));
                params.add(EntityFieldMapper.extractValue(entity, field));
                placeholders.add("?");
            } else if (RelationshipHandler.isManyToOne(field)) {
                cols.add(RelationshipHandler.getJoinColumn(field));
                params.add(RelationshipHandler.extractManyToOneValue(entity, field));
                placeholders.add("?");
            }
        }

        String sql = "INSERT INTO " + tableName +
                " (" + String.join(", ", cols) + ")" +
                " VALUES (" + String.join(", ", placeholders) + ")";
        return new SqlAndParamsDTO(sql, params);
    }

    // ---------- UPDATE ----------
    public <T> SqlAndParamsDTO buildUpdate(T entity) {
        Class<?> clazz = entity.getClass();
        checkEntity(clazz);

        String tableName = clazz.getAnnotation(Entity.class).tableName();

        List<String> sets = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        String where = null;
        Object keyVal = null;

        for (Field field : clazz.getDeclaredFields()) {
            if (EntityFieldMapper.isKey(field)) {
                where = EntityFieldMapper.getColumnName(field) + " = ?";
                keyVal = EntityFieldMapper.extractValue(entity, field);
            } else if (EntityFieldMapper.isColumn(field)) {
                sets.add(EntityFieldMapper.getColumnName(field) + " = ?");
                params.add(EntityFieldMapper.extractValue(entity, field));
            } else if (RelationshipHandler.isManyToOne(field)) {
                sets.add(RelationshipHandler.getJoinColumn(field) + " = ?");
                params.add(RelationshipHandler.extractManyToOneValue(entity, field));
            }
        }

        if (where == null) throw new RuntimeException("No @Key found in entity " + clazz.getName());
        params.add(keyVal);

        String sql = "UPDATE " + tableName + " SET " + String.join(", ", sets) + " WHERE " + where;
        return new SqlAndParamsDTO(sql, params);
    }

    // ---------- DELETE ----------
    public <T> SqlAndParamsDTO buildDelete(T entity) {
        Class<?> clazz = entity.getClass();
        checkEntity(clazz);

        String tableName = clazz.getAnnotation(Entity.class).tableName();

        String where = null;
        Object keyVal = null;

        for (Field field : clazz.getDeclaredFields()) {
            if (EntityFieldMapper.isKey(field)) {
                where = EntityFieldMapper.getColumnName(field) + " = ?";
                keyVal = EntityFieldMapper.extractValue(entity, field);
                break;
            }
        }

        if (where == null) throw new RuntimeException("No @Key found in entity " + clazz.getName());

        return new SqlAndParamsDTO("DELETE FROM " + tableName + " WHERE " + where, keyVal);
    }

    // ---------- SELECT BY KEY ----------
    public <T> SqlAndParamsDTO buildSelectById(Class<T> clazz, Object id) {
        checkEntity(clazz);

        String tableName = clazz.getAnnotation(Entity.class).tableName();

        String keyCol = null;
        for (Field field : clazz.getDeclaredFields()) {
            if (EntityFieldMapper.isKey(field)) {
                keyCol = EntityFieldMapper.getColumnName(field);
                break;
            }
        }
        if (keyCol == null) throw new RuntimeException("No @Key found in entity " + clazz.getName());

        return new SqlAndParamsDTO("SELECT * FROM " + tableName + " WHERE " + keyCol + " = ?", id);
    }

    private void checkEntity(Class<?> clazz) {
        if (!clazz.isAnnotationPresent(Entity.class)) {
            throw new IllegalArgumentException("Class " + clazz.getName() + " is not annotated with @Entity");
        }
    }
}
