package crm.service_request.repository.persistence.query.common;

public class PageRequest {
    // 1-indexed page number
    private int pageNumber;
    // Number of items per page
    private int pageSize;
    // Sorting criteria
    private Sort sort;

    public Sort getSort() {
        return sort;
    }

    public int getPageSize() {
        return pageSize;
    }

    public int getPageNumber() {
        return pageNumber;
    }

    public PageRequest(int pageNumber, int size, Sort sort) {
        this.pageNumber = pageNumber;
        this.pageSize = size;
        this.sort = sort;
    }

    public PageRequest(int pageNumber, int size) {
        this.pageNumber = pageNumber;
        this.pageSize = size;
    }

    public static PageRequest of(int pageNumber, int size, Sort sort) {
        validate(pageNumber, size);
        if (sort == null) {
            throw new IllegalArgumentException("sort must not be null");
        }
        return new PageRequest(pageNumber, size, sort);
    }

    public static PageRequest of(int pageNumber, int size) {
        validate(pageNumber, size);
        return new PageRequest(pageNumber, size);
    }

    private static void validate(int pageNumber, int size) {
        if (pageNumber < 1) {
            throw new IllegalArgumentException("Page number must be greater than 0");
        }
        if (size < 1) {
            throw new IllegalArgumentException("Page size must be greater than 0");
        }
    }
}
