package crm.core.repository.hibernate.querybuilder;

/**
 * Handler to manage relationships like @ManyToOne when mapping from ResultSet to entity.
 */
public class RelationshipHandler {

//    public static void handleRelationships(Object entity, ResultSet rs) {
//        for (Field f : entity.getClass().getDeclaredFields()) {
//            try {
//                if (f.isAnnotationPresent(ManyToOne.class)) {
//                    handleManyToOne(entity, f, rs);
//                }
//                // TODO: OneToOne, OneToMany nếu cần thêm
//            } catch (Exception e) {
//                throw new RuntimeException("Failed to handle relationship for field " + f.getName(), e);
//            }
//        }
//
//    }

//    private static void handleManyToOne(Object entity, Field field, ResultSet rs) throws Exception {
//        field.setAccessible(true);
//        ManyToOne ann = field.getAnnotation(ManyToOne.class);
//
//        String joinColumn = ann.joinColumn();
//        Object fkValue = rs.getObject(joinColumn);
//
//        if (fkValue != null) {
//            Class<?> targetType = getGenericType(field);
//            LazyReference<?> ref = new LazyReference<>(targetType, fkValue);
//            field.set(entity, ref);
//        }
//    }

// Lấy kiểu generic của LazyReference<>
//    private static Class<?> getGenericType(Field field) {
//        try {
//            // field type is LazyReference<Role>, so extract Role
//            String typeName = field.getGenericType().getTypeName();
//            String innerClass = typeName.substring(typeName.indexOf("<") + 1, typeName.indexOf(">"));
//            return Class.forName(innerClass);
//        } catch (Exception e) {
//            throw new RuntimeException("Cannot resolve generic type for field " + field.getName(), e);
//        }
//    }
}
