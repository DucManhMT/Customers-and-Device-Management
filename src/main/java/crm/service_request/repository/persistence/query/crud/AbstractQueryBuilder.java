package crm.service_request.repository.persistence.query.crud;

import crm.core.config.RepositoryConfig;

import java.util.ArrayList;
import java.util.List;

public abstract class AbstractQueryBuilder {
    private List<Object> parameters;
    protected String tableName;

    public AbstractQueryBuilder(String tableName) {
        this.tableName = tableName;
        this.parameters = new ArrayList<>();
    }

    public void setParameters(List<Object> parameters) {
        this.parameters = parameters;
    }

    public List<Object> getParameters() {
        return parameters;
    }

    public String build() {
        String query = createQuery();
        if (RepositoryConfig.PRINT_SQL) {
            System.out.println("Generated Query: " + query);
        }
        return query;
    }

    public String build(boolean isPrintSql) {
        String query = createQuery();
        if (isPrintSql) {
            System.out.println("Generated Query: " + query);
        }
        return query;
    }

    abstract public String createQuery();
}