<%--
  Created by IntelliJ IDEA.
  User: anhtu
  Date: 10/6/2025
  Time: 9:34 PM
  To change this template use File | Settings | File Templates.
--%>


<%--Nghiêm cấm tự ý sửa components của người khác--%>


<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="align-items-center d-flex flex-column gap-3 mt-3">

    <!-- Item per page -->
    <div>
        <label for="recordsPerPage">Items per page</label>
        <input type="number" id="recordsPerPage" name="recordsPerPage"
               min="1" value="${empty recordsPerPage ? 5 : recordsPerPage}">
        <button type="submit" class="btn btn-sm btn-outline-primary ms-2">Set item</button>
    </div>

    <!-- Paging -->
    <div class="d-flex justify-content-center align-items-center gap-3">
        <c:if test="${currentPage > 1}">
            <a href="./list?page=${currentPage - 1}&sort=${sort}&status=${status}&search=${search}&recordsPerPage=${recordsPerPage}"
               class="btn btn-primary">Previous</a>
        </c:if>

        <span>Page ${currentPage} of ${totalPages}</span>

        <c:if test="${currentPage < totalPages}">
            <a href="./list?page=${currentPage + 1}&sort=${sort}&status=${status}&search=${search}&recordsPerPage=${recordsPerPage}"
               class="btn btn-primary">Next</a>
        </c:if>
    </div>

</div>
