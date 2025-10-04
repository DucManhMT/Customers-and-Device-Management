package crm.core.repository.persistence.repository;

public class SimpleRepository<E, K> extends AbstractRepository<E, K> {

    public SimpleRepository(Class<E> cls) {
        super(cls);
    }

}
