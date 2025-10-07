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
    <link href="../css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
<div class=" container-fluid">

    <!-- Contracts -->
    <c:set var="contracts" value="${[
    {'contractID':'C001'},
    {'contractID':'C002'},
    {'contractID':'C003'},
    {'contractID':'C004'},
    {'contractID':'C005'}
]}"/>

    <!-- Requests -->
    <c:set var="requests" value="${[
    {'requestID':'R-1001', 'contractID':'C001', 'description':'Install new network router for Branch A', 'status':'Pending',  'creationDate':'2025-09-12', 'finishDate': null},
    {'requestID':'R-1002', 'contractID':'C002', 'description':'Replace faulty server fan and update firmware', 'status':'Approved', 'creationDate':'2025-09-08', 'finishDate': null},
    {'requestID':'R-1003', 'contractID':'C003', 'description':'Check power stability at data center', 'status':'Rejected', 'creationDate':'2025-09-15', 'finishDate': null},
    {'requestID':'R-1004', 'contractID':'C004', 'description':'Preventive maintenance for all CCTV systems', 'status':'Finished','creationDate':'2025-08-30', 'finishDate':'2025-09-02'},
    {'requestID':'R-1005', 'contractID':'C002', 'description':'Upgrade storage capacity for warehouse server', 'status':'Approved', 'creationDate':'2025-09-20', 'finishDate': null},
    {'requestID':'R-1006', 'contractID':'C003', 'description':'Database backup & restore test', 'status':'Finished', 'creationDate':'2025-07-01', 'finishDate':'2025-07-02'},
    {'requestID':'R-1007', 'contractID':'C001', 'description':'Replace broken monitor at Office B', 'status':'Pending',  'creationDate':'2025-09-25', 'finishDate': null}
]}"/>
    <!-- Pagination Variables -->
    <%
        request.setAttribute("currentPage", 3);
        request.setAttribute("totalPages", 10);
    %>

    <h2 class="mt-1">Service Request</h2>
    <form action="">
        <div class="d-flex align-items-center gap-3 bg-light p-3 mb-1">

            <jsp:include page="../components/sort.jsp"/>

            <div class="d-flex align-items-center gap-3"><label for="status">Filter by Status:</label>
                <select id="status" name="status" class="form-select" style="width: 200px; display: inline-block;">
                    <option value="">All</option>
                    <option value="Pending" ${status == 'Pending' ? 'selected' : ''}>Pending</option>
                    <option value="Approved" ${status == 'Approved' ? 'selected' : ''}>Approved</option>
                    <option value="Rejected" ${status == 'Rejected' ? 'selected' : ''}>Rejected</option>
                    <option value="Finished" ${status == 'Finished' ? 'selected' : ''}>Finished</option>
                </select>
            </div>

            <div class="d-flex align-items-center gap-3"><label for="status">Select Contract:</label>
                <select id="status" name="status" class="form-select" style="width: 200px; display: inline-block;">
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
                    <td><a href="./list">${request.contractID}</a></td>
                    <td>${request.description}</td>
                    <td>${request.status}</td>
                    <td>${request.creationDate}</td>
                    <td>${request.finishDate}</td>
                    <td>
                        <a href="../requests/detail?requestId=${request.requestID}" class="btn btn-info btn-sm">View</a>
                        <a href="../requests/detail?requestId=${request.requestID}"
                           class="btn btn-primary btn-sm">Timeline</a>
                        <a href="../requests/detail?requestId=${request.requestID}"
                           class="btn btn-primary btn-sm">Feedback</a>
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
