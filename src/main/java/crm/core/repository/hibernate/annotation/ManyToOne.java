package crm.core.repository.hibernate.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target({ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
public @interface ManyToOne {
    /**
     * Name of the foreign key column in this entity's table referencing the
     * target entity's primary key.
     *
     * @return FK column name
     */
    String joinColumn();


}
