package crm.service_request.repository.persistence;

import java.sql.SQLException;
import java.util.List;

import crm.service_request.repository.persistence.query.common.ClauseBuilder;

public interface CrudRepository<E, K> {

    E save(E entity) throws SQLException;

    List<E> saveAll(List<E> entities) throws SQLException;

    E findById(K key);

    E update(E entity) throws SQLException;

    boolean isExist(K key);

    void deleteById(K key) throws SQLException;

    void deleteWithCondition(ClauseBuilder clause) throws SQLException;

    int count() throws SQLException;

    List<E> findAll();

    List<E> findWithCondition(ClauseBuilder clause);
}
