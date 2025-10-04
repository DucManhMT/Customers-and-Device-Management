package crm.core.repository.dal.dao;

public abstract class FullOptionDAO<T> {
    protected final Class<T> clazz;
    public FullOptionDAO(Class<T> clazz) {
        this.clazz = clazz;
    }

}
