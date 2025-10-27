<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 10/17/2025
  Time: 2:26 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Tech Employee Product Requests</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<jsp:include page="../components/header.jsp"/>
<div class="container my-5">
    <h1 class="mb-4">Sended Product Requests</h1>

    <div class="card shadow-sm">
        <div class="card-header bg-light py-3">
            <h2 class="h5 mb-0">Pending Requests</h2>
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${not empty productRequests}">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                            <tr>
                                <th>Request ID</th>
                                <th>Product</th>
                                <th>Quantity</th>
                                <th>Request Date</th>
                                <th>Status</th>
                                <th>Description</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="pr" items="${productRequests}">
                                <tr>
                                    <td>#${pr.request.requestID}</td>
                                    <td>
                                        <div class="fw-bold">${pr.product.productName}</div>
                                        <div class="small text-muted">${pr.product.type.typeName}</div>
                                    </td>
                                    <td>${pr.quantity}</td>
                                    <td>${pr.requestDate}</td>
                                    <td>
                                        <span class="badge
                                            ${pr.status == 'Pending' ? 'bg-warning text-dark' : ''}
                                            ${pr.status == 'Approved' ? 'bg-success' : ''}
                                            ${pr.status == 'Rejected' ? 'bg-danger' : ''}">
                                                ${pr.status}
                                        </span>
                                    </td>
                                    <td class="text-muted small">${pr.description}</td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-info text-center" role="alert">
                        You haven't created product request yet.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

