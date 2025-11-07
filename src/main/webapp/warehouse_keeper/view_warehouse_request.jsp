<%--
  Created by IntelliJ IDEA.
  User: MasterLong
  Date: 10/20/2025
  Time: 3:42 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>View Warehouse Requests</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%-- Bootstrap 5 CSS --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <%-- Font Awesome for icons --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }

        .main-content {
            padding: 2rem;
        }

        .request-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
            gap: 1.5rem;
        }

        .request-card {
            border: 1px solid #dee2e6;
            border-radius: 0.5rem;
            transition: box-shadow 0.2s ease;
        }

        .request-card:hover {
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .request-card .card-header {
            font-weight: 600;
        }

        .product-list {
            max-height: 200px;
            overflow-y: auto;
            padding-right: 10px; /* For scrollbar */
        }

        .product-item {
            background-color: #f8f9fa;
            border-radius: 5px;
        }

        .status-badge {
            font-size: 0.9em;
        }
    </style>
</head>
<body>
<%-- Include Header and Sidebar --%>
<jsp:include page="../components/header.jsp"/>
<c:set var="activePage" value="transfers" scope="request"/>
<jsp:include page="../components/warehouse_keeper_sidebar.jsp"/>

<div class="main-content">
    <div class="container-fluid">

        <%-- Grid of Warehouse Requests --%>
        <div class="request-grid">
            <c:if test="${empty warehouseRequests}">
                <div class="alert alert-info w-100">There are no pending warehouse requests.</div>
            </c:if>

            <c:forEach var="req" items="${warehouseRequests}">
                <div class="card request-card">
                    <div class="card-header bg-light d-flex justify-content-between align-items-center">
                        <span>Request Date: ${req.date}</span>
                        <c:set var="statusClass" value="bg-secondary"/>
                        <c:if test="${req.warehouseRequestStatus == 'Pending'}"><c:set var="statusClass"
                                                                                       value="bg-warning text-dark"/></c:if>
                        <c:if test="${req.warehouseRequestStatus == 'Processing'}"><c:set var="statusClass"
                                                                                          value="bg-info text-dark"/></c:if>
                        <c:if test="${req.warehouseRequestStatus == 'Accepted'}"><c:set var="statusClass"
                                                                                        value="bg-success"/></c:if>
                        <c:if test="${req.warehouseRequestStatus == 'Rejected'}"><c:set var="statusClass"
                                                                                        value="bg-danger"/></c:if>
                        <span class="badge ${statusClass} status-badge">${req.warehouseRequestStatus}</span>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <small class="text-muted">From</small>
                                    <p class="fw-bold mb-0">${req.sourceWarehouse != null ? req.sourceWarehouse.warehouseName : 'Not Assigned'}</p>
                                </div>
                                <div class="align-self-center px-2">
                                    <i class="fas fa-arrow-right text-primary"></i>
                                </div>
                                <div class="text-end">
                                    <small class="text-muted">To</small>
                                    <p class="fw-bold mb-0">${req.destinationWarehouse.warehouseName}</p>
                                </div>
                            </div>
                        </div>

                        <hr>

                        <h6 class="card-subtitle mb-2 text-muted">Requested Products:</h6>
                        <div class="product-list mb-3">
                                <div class="d-flex justify-content-between align-items-center p-2 mb-2 product-item">
                                    <span>${req.product.productName}</span>
                                    <span class="badge bg-primary rounded-pill">Qty: ${req.quantity}</span>
                                </div>
                        </div>

                        <c:if test="${not empty req.note}">
                            <p class="card-text small fst-italic"><strong>Note:</strong> ${req.note}</p>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/warehouse_keeper/process_request?id=${req.warehouseRequestID}" class="btn btn-outline-primary w-100 mt-2">
                            <i class="fas fa-cogs me-2"></i>Process Request
                        </a>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<%-- Bootstrap 5 JS Bundle --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
