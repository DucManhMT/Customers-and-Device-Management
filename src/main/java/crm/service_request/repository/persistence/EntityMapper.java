package crm.service_request.repository.persistence;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.hibernate.annotation.OneToOne;
import crm.core.repository.hibernate.entitymanager.LazyReference;
import crm.core.repository.hibernate.querybuilder.EntityFieldMapper;
import crm.core.repository.hibernate.querybuilder.DTO.ColumnsAndValuesDTO;

public class EntityMapper extends EntityFieldMapper {
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
                    Object ref = extractValue(entity, field);
                    Object value = null;
                    if (ref != null) {
                        try {
                            // If it's a LazyReference, it should already expose the FK value via
                            // extractValue
                            value = ref;
                            // But extractValue returned LazyReference itself for relations; normalize to FK
                            if (ref instanceof LazyReference<?> lazy) {
                                value = lazy.getForeignKeyValue();
                            } else if (isEntity(ref.getClass())) {
                                // It's an entity instance; try to read its key field
                                Field fk = findKeyField(ref.getClass());
                                if (fk != null) {
                                    fk.setAccessible(true);
                                    value = fk.get(ref);
                                }
                            }
                        } catch (Exception ex) {
                            ex.printStackTrace();
                        }
                    }
                    columns.add(column);
                    values.add(value);
                } else if (isOneToOne(field)) {
                    OneToOne ann = field.getAnnotation(OneToOne.class);
                    String column = ann.joinColumn();
                    Object ref = extractValue(entity, field);
                    Object value = null;
                    if (ref != null) {
                        try {
                            if (ref instanceof LazyReference<?> lazy) {
                                value = lazy.getForeignKeyValue();
                            } else if (isEntity(ref.getClass())) {
                                Field fk = findKeyField(ref.getClass());
                                if (fk != null) {
                                    fk.setAccessible(true);
                                    value = fk.get(ref);
                                }
                            } else {
                                value = ref;
                            }
                        } catch (Exception ex) {
                            ex.printStackTrace();
                        }
                    }
                    columns.add(column);
                    values.add(value);
                }
            }

            return new ColumnsAndValuesDTO(columns, values);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
