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

public class QueryBuilder<T> {
    private final Class<T> clazz;

    public QueryBuilder(Class<T> clazz) {
        this.clazz = clazz;
    }

    public SqlAndParamsDTO buildInsert(T entity) throws Exception {
        Table table = clazz.getAnnotation(Table.class);
        if (table == null) throw new RuntimeException("Missing @Table");

        List<String> columns = new ArrayList<>();
        List<String> placeholders = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        for (Field field : clazz.getDeclaredFields()) {
            Column col = field.getAnnotation(Column.class);
            if (col != null) {
                columns.add(col.name());
                placeholders.add("?");
                field.setAccessible(true);
                params.add(field.get(entity));
            }
        }

        String sql = "INSERT INTO " + table.name() +
                " (" + String.join(", ", columns) + ")" +
                " VALUES (" + String.join(", ", placeholders) + ")";
        return new SqlAndParamsDTO(sql, params);
    }

    // Build SELECT statement by ID
    public SqlAndParamsDTO buildSelectById(Object idValue) {
        Table table = clazz.getAnnotation(Table.class);
        String idColumn = getIdColumn();

        String sql = "SELECT * FROM " + table.name() + " WHERE " + idColumn + " = ?";
        return new SqlAndParamsDTO(sql, idValue);
    }

    // Build UPDATE statement
    public SqlAndParamsDTO buildUpdate(T entity) throws Exception {
        Table table = clazz.getAnnotation(Table.class);
        List<String> assignments = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        String idColumn = null;
        Object idValue = null;

        for (Field field : clazz.getDeclaredFields()) {
            Column col = field.getAnnotation(Column.class);
            if (col != null) {
                field.setAccessible(true);
                Object value = field.get(entity);

                if (col.id()) {
                    idColumn = col.name();
                    idValue = value;
                } else {
                    assignments.add(col.name() + " = ?");
                    params.add(value);
                }
            }
        }

        if (idColumn == null) throw new RuntimeException("No primary key found");

        String sql = "UPDATE " + table.name() +
                " SET " + String.join(", ", assignments) +
                " WHERE " + idColumn + " = ?";
        params.add(idValue);

        return new SqlAndParamsDTO(sql, params);
    }

    // Build DELETE statement
    public SqlAndParamsDTO buildDelete(Object idValue) {
        Table table = clazz.getAnnotation(Table.class);
        String idColumn = getIdColumn();

        String sql = "DELETE FROM " + table.name() + " WHERE " + idColumn + " = ?";
        return new SqlAndParamsDTO(sql, idValue);
    }

    // Helper method to find the primary key column
    private String getIdColumn() {
        for (Field field : clazz.getDeclaredFields()) {
            Column col = field.getAnnotation(Column.class);
            if (col != null && col.id()) {
                return col.name();
            }
        }
        throw new RuntimeException("No primary key defined");
    }

}


