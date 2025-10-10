package crm.core.repository.hibernate.entitymanager;
import java.util.List;
/**
 * Interface defining basic CRUD operations and transaction handling for an entity manager.
 */

public interface IEntityManager {

    /***
     * Create an entity in the database.
     * @param entity the entity to be persisted
     * @param entityClass Class of the entity
     * @param <T> Type of the entity
     */
    <T> void persist(T entity, Class<T> entityClass);

    /***
     * Read an entity from the database by its primary key.
     * @param entityClass Class of the entity
     * @param primaryKey Primary key of the entity
     * @param <T> Type of the entity
     * @return the found entity or null if not found
     */
    <T> T find(Class<T> entityClass, Object primaryKey);

    /***
     * Update an existing entity in the database.
     * @param entity the entity to be updated
     * @param entityClass Class of the entity
     * @param <T> Type of the entity
     * @return the updated entity
     */
    <T> T merge(T entity, Class<T> entityClass);

    /***
     * Delete an entity from the database.
     * @param entity the entity to be removed
     * @param entityClass  Class of the entity
     * @param <T> Type of the entity
     */
    <T> void remove(T entity, Class<T> entityClass);


}

