package crm.service_request.repository.persistence.query.common;

public class Order {
    // column name to order by
    private String column;
    // true for ASC, false for DESC
    private boolean isAscending;

    private void validate(String column) {
        if (column == null || column.trim().isEmpty()) {
            throw new IllegalArgumentException("Column name must not be null or empty.");
        }
    }

    public Order(String column, boolean isAscending) {
        validate(column);
        this.column = column;
        this.isAscending = isAscending;
    }

    public String getColumn() {
        return column;
    }

    public boolean isAscending() {
        return isAscending;
    }

    public void setAscending(boolean isAscending) {
        this.isAscending = isAscending;
    }

    public static Order asc(String column) {
        return new Order(column, true);
    }

    public static Order desc(String column) {
        return new Order(column, false);
    }

}
