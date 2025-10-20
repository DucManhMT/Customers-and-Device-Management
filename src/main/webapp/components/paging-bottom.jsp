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
    <div class="d-flex align-items-center gap-2">
        <label for="recordsPerPage">Show: </label>

        <!-- Tính sẵn giá trị hiển thị và max theo quy tắc yêu cầu -->
        <c:set var="computedRpp"
               value="${empty totalRecords or totalRecords <= 0 ? 1 : (recordsPerPage>totalRecords?totalRecords:recordsPerPage)}"/>
        <c:set var="computedMax"
               value="${empty totalRecords or totalRecords <= 0 ? 1 : totalRecords}"/>


        <input type="number"
               id="recordsPerPage"
               name="recordsPerPage"
               class="form-control"
               step="1"
               value="${computedRpp}"
               min="1"
               max="${computedMax}"
               style="width: 70px; display: inline-block; text-align: center;"
        >
        <button type="submit" id="setBtn" class="btn btn-primary">Set</button>


    </div>

    <!-- Paging -->
    <form method="get" class="d-flex justify-content-center align-items-center gap-3">

        <!-- Hold all current query params -->
        <input type="hidden" name="sort" value="${sort}">
        <input type="hidden" name="status" value="${status}">
        <input type="hidden" name="search" value="${search}">
        <input type="hidden" name="recordsPerPage" value="${computedRpp}">
        <div class="d-flex justify-content-center align-items-center gap-3">
            <!-- Previous -->
            <c:if test="${currentPage gt 1}">
                <button type="submit" name="page" value="${currentPage - 1}" class="btn btn-primary">
                    Previous
                </button>
            </c:if>

            <span>Page ${currentPage} of ${totalPages}</span>

            <!-- Next -->
            <c:if test="${currentPage lt totalPages}">
                <button type="submit" name="page" value="${currentPage + 1}" class="btn btn-primary">
                    Next
                </button>
            </c:if>
        </div>

    </form>


</div>
