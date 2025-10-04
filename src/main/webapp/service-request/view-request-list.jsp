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
                    <button type="submit" name="sort" value="desc" class="btn btn-secondary" style="margin-left: 1rem;">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-sort-up" viewBox="0 0 16 16">
                            <path d="M3.5 12.5a.5.5 0 0 1-1 0V3.707L1.354 4.854a.5.5 0 1 1-.708-.708l2-1.999.007-.007a.5.5 0 0 1 .7.006l2 2a.5.5 0 1 1-.707.708L3.5 3.707zm3.5-9a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5M7.5 6a.5.5 0 0 0 0 1h5a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h3a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h1a.5.5 0 0 0 0-1z"/>
                        </svg>
                        Asc
                    </button>
                </c:when>
                <c:otherwise>
                    <button type="submit" name="sort" value="asc" class="btn btn-secondary" style="margin-left: 1rem;">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-sort-down" viewBox="0 0 16 16">
                            <path d="M3.5 2.5a.5.5 0 0 0-1 0v8.793l-1.146-1.147a.5.5 0 0 0-.708.708l2 1.999.007.007a.497.497 0 0 0 .7-.006l2-2a.5.5 0 0 0-.707-.708L3.5 11.293zm3.5 1a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5M7.5 6a.5.5 0 0 0 0 1h5a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h3a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h1a.5.5 0 0 0 0-1z"/>
                        </svg>
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
                <input class="form-control" type="text" name="username" placeholder="Search by username"  value="${search}" style="width: 300px; display: inline-block; margin-left: 10px;">
                <button type="submit" class="btn btn-primary">Search</button>
            </div>
            <div class="m-auto d-flex align-items-center gap-3">
                <input class="form-control" type="text" name="description" placeholder="Search by description"  value="${search}" style="width: 300px; display: inline-block; margin-left: 10px;">
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
            <label>Item per page</label> <input type="number" name="recordsPerPage" min="1"  value="${empty recordsPerPage ?  5 : recordsPerPage}" >
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
