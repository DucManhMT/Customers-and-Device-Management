package crm.core.repository.hibernate.querybuilder;


import java.lang.reflect.Field;


import crm.core.repository.persistence.annotation.ManyToOne;
import crm.core.repository.persistence.annotation.OneToOne;


public class RelationshipHandler {

    public static boolean isManyToOne(Field field) {
        return field.isAnnotationPresent(ManyToOne.class);
    }

    public static boolean isOneToOne(Field field) {
        return field.isAnnotationPresent(OneToOne.class);
    }

    public static String getJoinColumn(Field field) {
        if (field.isAnnotationPresent(ManyToOne.class)) {
            return field.getAnnotation(ManyToOne.class).joinColumn();
        }
        if (field.isAnnotationPresent(OneToOne.class)) {
            return field.getAnnotation(OneToOne.class).joinColumn();
        }
        return null;
    }

    public static Object extractManyToOneValue(Object entity, Field field) {
        try {
            field.setAccessible(true);
            Object ref = field.get(entity);
            if (ref == null) return null;

            // Tìm @Key trong entity được tham chiếu
            for (Field f : ref.getClass().getDeclaredFields()) {
                if (f.isAnnotationPresent(crm.core.repository.persistence.annotation.Key.class)) {
                    f.setAccessible(true);
                    return f.get(ref);
                }
            }
            throw new RuntimeException("No @Key found in related entity " + ref.getClass().getName());
        } catch (Exception e) {
            throw new RuntimeException("Error extracting ManyToOne value from " + field.getName(), e);
        }
    }
}
