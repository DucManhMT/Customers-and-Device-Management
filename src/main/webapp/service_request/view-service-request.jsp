<%--
  Created by IntelliJ IDEA.
  User: anhtu
  Date: 10/6/2025
  Time: 8:44 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>View Service Request</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
          rel="stylesheet"/>
</head>
<body>
<jsp:include page="../components/header.jsp"/>
<div class=" container-fluid">

    <form action="">
        <div class="d-flex align-items-center gap-3 bg-light p-3 mb-1">

            <jsp:include page="../components/sort.jsp"/>

            <jsp:include page="../components/request-status-select.jsp"/>

            <div class="d-flex align-items-center gap-3"><label for="status">Select Contract:</label>
                <select id="status" name="contractId" class="form-select" style="width: 200px; display: inline-block;">
                    <option value="">All</option>
                    <c:forEach var="contract" items="${contracts}">
                        <option value="${contract.contractID}"
                                <c:if test="${contract.contractID == contractId}">selected</c:if>>
                                ${contract.contractID}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <jsp:include page="../components/do-filter.jsp"/>
        </div>
        <c:if test="${not empty error}">
            <div class="alert alert-danger mt-3">${error}</div>
        </c:if>
        <table class="table table-bordered">
            <thead class="table-light">
            <tr>
                <th>No</th>
                <th>Contract ID</th>
                <th>Description</th>
                <th>Status</th>
                <th>Creation Date</th>
                <th>Finish Date</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${requests}" var="request" varStatus="status">
                <tr>
                    <td>${status.index + 1 +(currentPage-1)*recordsPerPage}</td>
                    <td><a href="./list">${request.contract.contractID}</a></td>
                    <td>${request.requestDescription}</td>
                    <td>${request.requestStatus}</td>
                    <td>${request.startDate}</td>
                    <td>${request.finishedDate}</td>
                    <td>
                        <a href="./requests/detail?requestId=${request.requestID}" class="btn btn-info btn-sm">View</a>
                        <a href="./requests/timeline?requestId=${request.requestID}"
                           class="btn btn-primary btn-sm">Timeline</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <a href="./../feedback/create"
           class="btn btn-primary btn-sm">Feedback</a>
        <jsp:include page="../components/paging-bottom.jsp"/>
    </form>
    <jsp:include page="../components/scroll-button.jsp"/>

</div>
</body>
</html>
