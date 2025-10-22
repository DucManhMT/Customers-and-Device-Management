<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Warehouse Product Requests</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<div class="container my-5">
    <h1 class="mb-4">Incoming Product Requests</h1>

    <div class="card shadow-sm">
        <div class="card-header bg-light py-3">
            <h2 class="h5 mb-0">Pending Requests</h2>
        </div>
        <a href="${pageContext.request.contextPath}/warehouse_keeper/warehousekeeper_actioncenter"
           class="btn btn-secondary d-flex align-items-center">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                 class="bi bi-house-door-fill me-2" viewBox="0 0 16 16">
                <path d="M6.5 14.5v-3.505c0-.245.25-.495.5-.495h2c.25 0 .5.25.5.5v3.505A.5.5 0 0 0 9.5 15h-3a.5.5 0 0 0-.5-.5z"/>
                <path d="M1.5 2.5a.5.5 0 0 0 0 1v12A1.5 1.5 0 0 0 3 17h10a1.5 1.5 0 0 0 1.5-1.5v-12a.5.5 0 0 0 0-1H1.5zM11 2h.5a.5.5 0 0 1 .5.5V4h-1V2.5a.5.5 0 0 1 .5-.5zM4.5 2H5v1.5H4V2.5a.5.5 0 0 1 .5-.5z"/>
            </svg>
            Home
        </a>
        <div class="card-body">
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger" role="alert">
                        ${errorMessage}
                </div>
            </c:if>
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
                                <th class="text-center">Actions</th>
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
                                            ${pr.status == 'Rejected' ? 'bg-danger' : ''}
                                            ${pr.status == 'Finished' ? 'bg-success' : ''}">
                                                ${pr.status}
                                        </span>
                                    </td>
                                    <td class="text-muted small">${pr.description}</td>
                                    <td>
                                        <c:if test="${pr.status == 'Pending'}">
                                            <form action="${pageContext.request.contextPath}/warehouse_keeper/view_warehouse_product_requests"
                                                  method="post"
                                                  class="d-flex justify-content-center gap-2">
                                                <input type="hidden" name="productRequestID"
                                                       value="${pr.productRequestID}">
                                                <button type="submit" name="action" value="accept"
                                                        class="btn btn-sm btn-success">
                                                    Accept
                                                </button>
                                                <button type="submit" name="action" value="reject"
                                                        class="btn btn-sm btn-danger">
                                                    Reject
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${pr.status == 'Approved'}">
                                            <form action="${pageContext.request.contextPath}/warehouse_keeper/export_product"
                                                  method="post" class="d-inline">
                                                <input type="hidden" name="productRequestID"
                                                       value="${pr.productRequestID}">
                                                <input type="hidden" name="requestID" value="${pr.request.requestID}">
                                                <button type="submit" class="btn btn-sm btn-primary">Export</button>
                                            </form>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-info text-center" role="alert">
                        There are no pending product requests for your warehouse.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
