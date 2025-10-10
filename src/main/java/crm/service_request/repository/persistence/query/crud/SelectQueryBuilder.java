package crm.service_request.repository.persistence.query.crud;

import java.util.ArrayList;
import java.util.List;

import crm.core.config.RepositoryConfig;
import crm.service_request.repository.persistence.query.common.ClauseBuilder;
import crm.service_request.repository.persistence.query.common.Order;

public class SelectQueryBuilder<E> extends AbstractQueryBuilder {

    private List<String> columns;
    private boolean isDistinct;
    private String whereClause;
    List<Order> orderByColumns;
    private String alias;
    private Integer limit;
    private Integer offset;

    public SelectQueryBuilder(String tableName) {
        super(tableName);
        this.orderByColumns = new ArrayList<>();
    }

    public static <E> SelectQueryBuilder<E> builder(String tableName) {
        if (tableName == null) {
            throw new IllegalArgumentException("EntityMeta cannot be null");
        }
        return new SelectQueryBuilder<E>(tableName);
    }

    public SelectQueryBuilder<E> alias(String alias) {
        this.alias = alias;
        return this;
    }

    public SelectQueryBuilder<E> columns(String... columns) {
        this.columns = List.of(columns);
        return this;
    }

    public SelectQueryBuilder<E> columns(List<String> columns) {
        this.columns = columns;
        return this;
    }

    public SelectQueryBuilder<E> distinct(boolean isDistinct) {
        this.isDistinct = isDistinct;
        return this;
    }

    public SelectQueryBuilder<E> where(String whereClause, Object... params) {
        this.getParameters().addAll(List.of(params));
        this.whereClause = whereClause;
        return this;
    }

    public SelectQueryBuilder<E> where(ClauseBuilder clause) {
        this.whereClause = clause.build();
        this.getParameters().addAll(clause.getParameters());
        return this;
    }

    public SelectQueryBuilder<E> orderBy(List<Order> orderByColumns) {
        this.orderByColumns = orderByColumns;
        return this;
    }

    public SelectQueryBuilder<E> limit(int limit) {
        this.limit = limit;
        return this;
    }

    public SelectQueryBuilder<E> offset(int offset) {
        this.offset = offset;
        return this;
    }

    @Override
    public String createQuery() {
        String tempAlias = alias;
        boolean useAlias = true;
        if (alias == null || alias.isEmpty() || alias.equalsIgnoreCase(tableName)) {
            // No need for alias if not provided or same as table name
            tempAlias = tableName;
            useAlias = false; // only use alias if explicitly set
        }
        if (tableName == null || tableName.isEmpty()) {
            throw new IllegalStateException("Table name is required for SELECT query");
        }
        StringBuilder query = new StringBuilder("SELECT ");
        if (isDistinct) {
            query.append("DISTINCT ");
        }
        if (columns == null || columns.isEmpty()) {
            // if no columns specified, select all
            if (useAlias) {
                query.append(tempAlias).append(".*");
            } else {
                query.append("*");
            }
        } else {
            // If caller already qualified columns, don't prefix; else prefix when alias is
            // explicitly used
            List<String> rendered = new ArrayList<>();
            for (String c : columns) {
                if (c.contains(".")) {
                    rendered.add(c);
                } else {
                    if (useAlias) {
                        rendered.add(tempAlias + "." + c);
                    } else {
                        rendered.add(c);
                    }
                }
            }
            query.append(String.join(", ", rendered));
        }
        query.append(" FROM ").append(tableName);
        if (useAlias) {
            query.append(" AS ").append(tempAlias);
        }
        if (whereClause != null && !whereClause.isEmpty()) {
            query.append(" WHERE ").append(whereClause);
        }
        if (orderByColumns != null && !orderByColumns.isEmpty()) {
            query.append(" ORDER BY ");
            for (int i = 0; i < orderByColumns.size(); i++) {
                Order order = orderByColumns.get(i);
                query.append(order.getColumn()).append(order.isAscending() ? " ASC" : " DESC");
                if (i < orderByColumns.size() - 1) {
                    query.append(", ");
                }
            }
        }
        if (limit != null) {
            query.append(" LIMIT ").append(limit);
        }
        if (offset != null) {
            query.append(" OFFSET ").append(offset);
        }
        return query.toString();
    }

    @Override
    public String build(boolean isPrintSql) {
        String query = createQuery();
        if (isPrintSql) {
            System.out.println("Generated Query: " + query);
        }
        return query;
    }

    @Override
    public String build() {
        String query = createQuery();
        if (RepositoryConfig.PRINT_SQL) {
            System.out.println("Generated Query: " + query);
        }
        return query;
    }

}
