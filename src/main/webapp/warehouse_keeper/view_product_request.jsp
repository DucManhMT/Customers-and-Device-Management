<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Warehouse Product Requests</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .card {
            animation: fadeIn 0.5s ease-out;
        }
    </style>
</head>
<body class="bg-light">
<jsp:include page="../components/header.jsp"/>
<div class="container py-4">
    <jsp:include page="../components/warehouse_keeper_sidebar.jsp"/>
    <!-- Header -->
    <div class="card shadow-sm p-3 mb-4">
        <h1 class="h3 fw-bold text-dark mb-0">Incoming Product Requests</h1>
    </div>

    <!-- Page Size Selector -->
    <div class="card shadow-sm p-3 mb-4">
        <div class="d-flex justify-content-between align-items-center">
            <div class="d-flex align-items-center gap-2">
                <span class="text-muted small">Display:</span>
                <form action="${pageContext.request.contextPath}/warehouse_keeper/view_warehouse_product_requests" method="GET"
                      class="mb-0">
                    <input type="hidden" name="page" value="${currentPage}">
                    <select name="pageSize" id="pageSize" class="form-select form-select-sm"
                            onchange="this.form.submit()">
                        <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                        <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                        <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                        <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                    </select>
                </form>
            </div>
            <div class="text-muted small">
                Total: <span class="fw-semibold text-primary">${totalRequests}</span> requests
            </div>
        </div>
    </div>

    <!-- Requests Table -->
    <div class="card shadow-sm p-3 mb-4">
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
                                            ${pr.status == 'Finished' ? 'bg-primary' : ''}">
                                                ${pr.status}
                                        </span>
                                </td>
                                <td class="text-muted small">${pr.description}</td>
                                <td>
                                    <c:if test="${pr.status == 'Approved'}">
                                        <form action="${pageContext.request.contextPath}/warehouse_keeper/export_product"
                                              method="post" class="d-flex justify-content-center">
                                            <input type="hidden" name="productRequestID" value="${pr.productRequestID}">
                                            <input type="hidden" name="requestID" value="${pr.request.requestID}">
                                            <button type="submit" class="btn btn-sm btn-primary">Export</button>
                                        </form>
                                    </c:if>
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
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
        </c:choose>
    </div>

    <!-- Pagination -->
    <div class="card shadow-sm p-3">
        <c:set var="startItem" value="${totalRequests == 0 ? 0 : (currentPage - 1) * pageSize + 1}"/>
        <c:set var="endItem"
               value="${currentPage * pageSize > totalRequests ? totalRequests : currentPage * pageSize}"/>

        <div class="d-flex flex-column flex-md-row justify-content-between align-items-center gap-2">
            <div class="text-muted small">
                Page <span class="fw-semibold">${currentPage}</span> of <span class="fw-semibold">${totalPages}</span>
                (Displaying ${startItem} - ${endItem} of ${totalRequests} items)
            </div>

            <div class="d-flex align-items-center gap-2">
                <nav aria-label="Page navigation">
                    <ul class="pagination pagination-sm mb-0">
                        <!-- Previous -->
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/warehouse_keeper/view_warehouse_product_requests?page=${currentPage - 1}&pageSize=${pageSize}">Previous</a>
                        </li>

                        <!-- Page Numbers Logic -->
                        <c:set var="maxVisiblePages" value="5"/>
                        <c:set var="startPage" value="${currentPage - 2}"/>
                        <c:set var="endPage" value="${currentPage + 2}"/>
                        <c:if test="${startPage < 1}"><c:set var="endPage" value="${endPage - (startPage - 1)}"/><c:set
                                var="startPage" value="1"/></c:if>
                        <c:if test="${endPage > totalPages}"><c:set var="startPage"
                                                                    value="${startPage - (endPage - totalPages)}"/><c:set
                                var="endPage" value="${totalPages}"/></c:if>
                        <c:if test="${startPage < 1}"><c:set var="startPage" value="1"/></c:if>

                        <c:if test="${startPage > 1}">
                            <li class="page-item"><a class="page-link"
                                                     href="${pageContext.request.contextPath}/warehouse_keeper/view_warehouse_product_requests?page=1&pageSize=${pageSize}">1</a>
                            </li>
                            <c:if test="${startPage > 2}">
                                <li class="page-item disabled"><span class="page-link">...</span></li>
                            </c:if>
                        </c:if>

                        <c:forEach begin="${startPage}" end="${endPage}" var="i">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link"
                                   href="${pageContext.request.contextPath}/warehouse_keeper/view_warehouse_product_requests?page=${i}&pageSize=${pageSize}">${i}</a>
                            </li>
                        </c:forEach>

                        <c:if test="${endPage < totalPages}">
                            <c:if test="${endPage < totalPages - 1}">
                                <li class="page-item disabled"><span class="page-link">...</span></li>
                            </c:if>
                            <li class="page-item"><a class="page-link"
                                                     href="${pageContext.request.contextPath}/warehouse_keeper/view_warehouse_product_requests?page=${totalPages}&pageSize=${pageSize}">${totalPages}</a>
                            </li>
                        </c:if>

                        <!-- Next -->
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/warehouse_keeper/view_warehouse_product_requests?page=${currentPage + 1}&pageSize=${pageSize}">Next</a>
                        </li>
                    </ul>
                </nav>

                <!-- Go to Page -->
                <form action="${pageContext.request.contextPath}/warehouse_keeper/view_warehouse_product_requests" method="GET"
                      class="d-flex align-items-center gap-1 mb-0">
                    <input type="hidden" name="pageSize" value="${pageSize}">
                    <input type="number" name="page" min="1" max="${totalPages}"
                           class="form-control form-control-sm" style="width: 70px;" placeholder="Page">
                    <button type="submit" class="btn btn-sm btn-outline-secondary">Go</button>
                </form>
            </div>
        </div>
    </div>
</div>
</div>


<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
