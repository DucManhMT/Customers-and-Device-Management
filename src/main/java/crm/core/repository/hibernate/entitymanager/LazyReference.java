package crm.core.repository.hibernate.entitymanager;


import crm.core.repository.persistence.config.DBcontext;

import java.sql.Connection;
import java.util.function.Function;

public class LazyReference<T> {

    private final Class<T> targetType;
    private final Object foreignKeyValue;

    private T loadedValue;
    private boolean loaded = false;


    public LazyReference(Class<T> targetType, Object foreignKeyValue) {
        this.targetType = targetType;
        this.foreignKeyValue = foreignKeyValue;
    }

    public Object getForeignKeyValue() {
        return foreignKeyValue;
    }


    public T get() {
        if (!loaded) {
            EntityManager em = new EntityManager(DBcontext.getConnection());
            loadedValue = em.find(targetType, foreignKeyValue);
            loaded = true;
        }
        return loadedValue;
    }

    public boolean isLoaded() {
        return loaded;
    }

    @Override
    public String toString() {
        return "LazyReference<" + targetType.getSimpleName() + ">(fk=" + foreignKeyValue + ", loaded=" + loaded + ")";
    }
}
