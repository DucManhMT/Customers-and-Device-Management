package crm.core.repository.hibernate.querybuilder;

import crm.core.repository.hibernate.annotation.ManyToOne;

import java.lang.reflect.Field;
import java.util.*;

import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.OneToOne;
import crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO;
import crm.core.repository.hibernate.querybuilder.enums.SortDirection;

/**
 * Generic QueryUtils to create SQL statements based on entity annotations.
 */
public class QueryUtils {

    // ---------- COUNT ----------
    public <T> SqlAndParamsDTO buildCount(Class<T> clazz) {
        if (!EntityFieldMapper.isEntity(clazz)) {
            throw new IllegalArgumentException("Class " + clazz.getName() + " is not annotated with @Entity");
        }
        String tableName = EntityFieldMapper.getTableName(clazz);
        String sql = "SELECT COUNT(*) AS total FROM " + tableName;
        return new SqlAndParamsDTO(sql, Collections.emptyList());
    }

    // ---------- INSERT ----------
    public <T> SqlAndParamsDTO buildInsert(T entity) {
        InsertBuilder <T> insertBuilder = new InsertBuilder<>(entity);
        return insertBuilder.build();
    }

    // ---------- UPDATE ----------
    public <T> SqlAndParamsDTO buildUpdate(T entity) {
        UpdateBuilder <T> updateBuilder = new UpdateBuilder<>(entity);
        return updateBuilder.build();
    }

    // ---------- DELETE ----------
    public <T> SqlAndParamsDTO buildDelete(T entity) {
        DeleteBuilder <T> deleteBuilder = new DeleteBuilder<>(entity);
        return deleteBuilder.build();
    }

    // ---------- SELECT BY ID ----------
    public <T> SqlAndParamsDTO buildSelectById(Class<T> clazz, Object id) {
        SelectBuilder selectByIdBuilder = new SelectBuilder(clazz);
        Map<String, Object> whereCondition = new HashMap<>();
        Field keyField = EntityFieldMapper.findKeyField(clazz);
        String keyFieldName = keyField.getName();
        whereCondition.put(keyFieldName, id);
        selectByIdBuilder.where(whereCondition);
        return selectByIdBuilder.build();
    }

    // ---------- SELECT ALL ----------
    public <T> SqlAndParamsDTO buildSelectAll(Class<T> clazz) {
        SelectBuilder selectAllBuilder = new SelectBuilder(clazz);
        return selectAllBuilder.build();
    }

    // ---------- SELECT WITH ORDER ----------
    public <T> SqlAndParamsDTO buildSelectWithOrder(Class<T> clazz, Map<String, SortDirection> orderConditions) {
        SelectBuilder selectBuilder = new SelectBuilder(clazz);
        selectBuilder.orderBy(orderConditions);
        return selectBuilder.build();
    }

    // ---------- SELECT WITH LIMIT & OFFSET ----------
    public <T> SqlAndParamsDTO buildSelectWithLimitOffset(Class<T> clazz, int limit, int offset) {
        SelectBuilder selectBuilder = new SelectBuilder(clazz);
        selectBuilder.limit(limit).offset(offset);
        return selectBuilder.build();
    }

    //---------- SELECT WITH CONDITIONS ----------
    public <T> SqlAndParamsDTO buildSelectWithConditions(Class<T> clazz, Map<String, Object> conditions) {
        SelectBuilder selectBuilder = new SelectBuilder(clazz);
        selectBuilder.where(conditions);
        return selectBuilder.build();
    }

    // ---------- SELECT WITH CONDITIONS AND ORDER ----------
    public <T> SqlAndParamsDTO buildSelectWithConditionsAndOrder(Class<T> clazz, Map<String, Object> conditions, Map<String, SortDirection> orderConditions) {
        SelectBuilder selectBuilder = new SelectBuilder(clazz);
        selectBuilder.where(conditions).orderBy(orderConditions);
        return selectBuilder.build();
    }

    // ---------- SELECT WITH CONDITIONS AND LIMIT & OFFSET ----------
    public <T> SqlAndParamsDTO buildSelectWithConditionsAndLimitOffset(Class<T> clazz, Map<String, Object> conditions, int limit, int offset) {
        SelectBuilder selectBuilder = new SelectBuilder(clazz);
        selectBuilder.where(conditions).limit(limit).offset(offset);
        return selectBuilder.build();
    }
    // ---------- SELECT WITH ORDER, LIMIT & OFFSET ----------
    public <T> SqlAndParamsDTO buildSelectWithOrderAndLimitOffset(Class<T> clazz, Map<String, SortDirection> orderConditions, int limit, int offset) {
        SelectBuilder selectBuilder = new SelectBuilder(clazz);
        selectBuilder.orderBy(orderConditions).limit(limit).offset(offset);
        return selectBuilder.build();
    }

    //SELECT WITH CONDITIONS, ORDER, LIMIT & OFFSET ----------
    public <T> SqlAndParamsDTO buildSelectWithAll(Class<T> clazz, Map<String, Object> conditions, Map<String, SortDirection> orderConditions, int limit, int offset) {
        SelectBuilder selectBuilder = new SelectBuilder(clazz);
        selectBuilder.where(conditions).orderBy(orderConditions).limit(limit).offset(offset);
        return selectBuilder.build();
    }


}
