package crm.service_request.repository.persistence.query.common;

import java.util.List;

@Deprecated
public class Sort {
    // List of Order objects representing sorting criteria
    private List<Order> orders;

    private Sort(List<Order> orders) {
        this.orders = orders;
    }

    public List<Order> getOrders() {
        return orders;
    }

    public static Sort unsorted() {
        // Return a Sort instance with an empty list, representing unsorted
        return new Sort(List.of(new Order[0]));
    }

    public static Sort by(Order... orders) {
        if (orders == null || orders.length == 0) {
            throw new IllegalArgumentException("orders must not be null or empty");
        }
        return new Sort(List.of(orders));
    }
}