package crm.core.repository.hibernate.entitymanager;


import crm.core.config.DBcontext;


public class LazyReference<T> {

    private final Class<T> targetType;
    private final Object foreignKeyValue;
    private final EntityManager em;
    private T loadedValue;
    private boolean loaded = false;


    public LazyReference(Class<T> targetType, Object foreignKeyValue) {
        this.targetType = targetType;
        this.foreignKeyValue = foreignKeyValue;
        this.em = new EntityManager(DBcontext.getConnection()); ;
    }

    public Object getForeignKeyValue() {
        return foreignKeyValue;
    }


    public T get() {
        if (!loaded) {
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
