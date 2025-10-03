<%--
  Created by IntelliJ IDEA.
  User: anhtu
  Date: 10/3/2025
  Time: 9:48 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>View Service Request</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
</head>
<body>
<div>

    <h2>Service Request List</h2>
    <form method="get" action="../requests/list">
        <div class="d-flex align-items-center gap-3 bg-light p-3 mb-1">
            <c:choose>
                <c:when test="${sort == 'asc'}">
                    <button type="submit" name="sort" value="asc" class="btn btn-secondary" style="margin-left: 1rem;">
                        <i class="bi bi-sort-down"></i>
                        Asc
                    </button>
                </c:when>
                <c:otherwise>
                    <button type="submit" name="sort" value="desc" class="btn btn-secondary" style="margin-left: 1rem;">
                        <i class="bi bi-sort-up"></i>
                        Desc
                    </button>
                </c:otherwise>
            </c:choose>
            <div class="d-flex align-items-center gap-3"><label for="status">Filter by Status:</label>
                <select id="status" name="status" class="form-select" style="width: 200px; display: inline-block;">
                    <option value="">All</option>
                    <option value="Pending" ${status == 'Pending' ? 'selected' : ''}>Pending</option>
                    <option value="Approved" ${status == 'Approved' ? 'selected' : ''}>Approved</option>
                    <option value="Rejected" ${status == 'Rejected' ? 'selected' : ''}>Rejected</option>
                    <option value="Finished" ${status == 'Finished' ? 'selected' : ''}>Finished</option>
                </select>
                <button type="submit" class="btn btn-primary">Filter</button></div>

            <div class="m-auto d-flex align-items-center gap-3">
                <input class="form-control" type="text" name="search" placeholder="Search by username"  value="${search}" style="width: 300px; display: inline-block; margin-left: 10px;">
                <button type="submit" class="btn btn-primary">Search</button>
            </div>
            <div class="m-auto d-flex align-items-center gap-3">
                <input class="form-control" type="text" name="search" placeholder="Search by description"  value="${search}" style="width: 300px; display: inline-block; margin-left: 10px;">
                <button type="submit" class="btn btn-primary">Search</button>
            </div>
        </div>
        <table class="table table-bordered">
            <thead class="table-light">
            <tr>
                <th>No</th>
                <th>Contract ID</th>
                <th>Username</th>
                <th>Status</th>
                <th>Creation Date</th>
                <th>Finish Date</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${requests}" var="request" varStatus="status">
                <tr>
                    <td>${status.index + 1 +(currentPage-1)*recordsPerPage}</td>
                    <td><a href="./list">${request.contractID}</a></td>
                    <td><a href="./list">Xong cái join rồi có</a></td>
                    <td>${request.requestStatus}</td>
                    <td>${request.startDate}</td>
                    <td><c:out value="${empty request.finishedDate ? '-' : request.finishedDate}"/></td>
                    <td>
                        <a href="/requests/view?requestId=${request.requestID}" class="btn btn-info btn-sm">View</a>
                        <c:if test="${request.requestStatus == 'Pending'}">
                            <a href="/requests/edit?requestId=${request.requestID}" class="btn btn-warning btn-sm">Edit</a>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    <div class="aligen-items-center" >
        <div>
            <label>Item per page</label> <input type="number" name="recordsPerPage" min="1" max="${totalRecords==0?1:totalRecords}" value="${empty recordsPerPage ? 5 : recordsPerPage}" >
            <button>Set item</button>
        </div>

        <div class="d-flex justify-content-center align-items-center gap-3">
            <c:if test="${currentPage > 1}">
                <a href="./list?page=${currentPage - 1}&sort=${sort}&status=${status}&search=${search}&recordsPerPage=${recordsPerPage}" class="btn btn-primary">Previous</a>
            </c:if>
            <span>Page ${currentPage} of ${totalPages}</span>
            <c:if test="${currentPage < totalPages}">
                <a href="./list?page=${currentPage + 1}&sort=${sort}&status=${status}&search=${search}&recordsPerPage=${recordsPerPage}" class="btn btn-primary">Next</a>
            </c:if>
         </div>
    </div>
    </form>

</div>
</body>
</html>
