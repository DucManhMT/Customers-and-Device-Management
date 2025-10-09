<%--
  Created by IntelliJ IDEA.
  User: anhtu
  Date: 10/3/2025
  Time: 9:48 AM
  To change this template use File | Settings | File Templates.
--%>


<%--Nghiêm cấm tự ý sửa components của người khác--%>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>View Service Request</title>
    <link href="../css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>

<div class="container-fluid">

    <div class="container-fluid">
        <h2 class="mt-1">Service Request List</h2>
        <form method="get" action="../requests/list" onkeydown="if(event.key==='Enter'){event.preventDefault();}">
            <div class="d-flex align-items-center gap-3 bg-light p-3 mb-1">

                <jsp:include page="../components/sort.jsp"/>

                <jsp:include page="../components/request-status-select.jsp"/>

                <div class="m-auto d-flex align-items-center gap-3">
                    <input class="form-control" type="text" name="customerName" placeholder="Search by Customer Name"
                           value="${search}" style="width: 300px; display: inline-block; margin-left: 10px;">
                </div>
                <div class="m-auto d-flex align-items-center gap-3">
                    <input class="form-control" type="text" name="description" placeholder="Search by description"
                           value="${search}" style="width: 300px; display: inline-block; margin-left: 10px;">
                </div>

                <jsp:include page="../components/do-filter.jsp"/>
            </div>
            <table class="table table-bordered">
                <thead class="table-light">
                <tr>
                    <th>No</th>
                    <th>Contract ID</th>
                    <th>Customer Name</th>
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
                        <td><a href="./list">${request.contract.contractID}</a></td>
                        <td><a href="./list">${request.contract.customer.customerName}</a></td>
                        <td>${request.requestStatus}</td>
                        <td>${request.startDate}</td>
                        <td><c:out value="${empty request.finishedDate ? '-' : request.finishedDate}"/></td>
                        <td>
                            <a href="/requests/view?requestId=${request.requestID}" class="btn btn-info btn-sm">View</a>
                            <c:if test="${request.requestStatus == 'Pending'}">
                                <a href="/requests/edit?requestId=${request.requestID}"
                                   class="btn btn-warning btn-sm">Process</a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <jsp:include page="../components/paging-bottom.jsp"/>
        </form>

        <jsp:include page="../components/scroll-button.jsp"/>
    </div>

</body>
</html>
