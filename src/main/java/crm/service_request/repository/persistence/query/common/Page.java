
package crm.service_request.repository.persistence.query.common;

import java.util.List;

public class Page<T> {
    // The total number of elements across all pages.
    private long totalElements;

    // The pagination information for this page.
    private PageRequest pageRequest;

    // The content of this page.
    private List<T> content;

    public Page(long totalElements, PageRequest pageRequest, List<T> content) {
        this.totalElements = totalElements;
        this.pageRequest = pageRequest;
        this.content = content;
    }

    public int getTotalPages() {
        if (pageRequest.getPageSize() == 0) {
            return 0;
        }
        return (int) Math.ceil((double) totalElements / pageRequest.getPageSize());
    }

    public long getTotalElements() {
        return totalElements;
    }

    public PageRequest getPageRequest() {
        return pageRequest;
    }

    public List<T> getContent() {
        return content;
    }

    public boolean isFirst() {
        return pageRequest.getPageNumber() == 0;
    }

    public boolean isLast() {
        return pageRequest.getPageNumber() >= getTotalPages() - 1;
    }

    public boolean hasNext() {
        return pageRequest.getPageNumber() < getTotalPages() - 1;
    }
}
