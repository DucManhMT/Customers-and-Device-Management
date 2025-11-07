<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 11/7/2025
  Time: 6:54 AM
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
<jsp:include page="../components/inventory_manager_sidebar.jsp"/>

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
                        <c:if test="${req.warehouseRequestStatus == 'Approved'}"><c:set var="statusClass"
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

                        <c:choose>
                            <c:when test="${empty req.sourceWarehouse}">
                                <button type="button" class="btn btn-outline-primary w-100" data-bs-toggle="modal"
                                        data-bs-target="#processRequestModal-${req.warehouseRequestID}">
                                    <i class="fas fa-cogs me-2"></i>Process Request
                                </button>
                            </c:when>
                            <c:otherwise>
                                <button type="button" class="btn btn-outline-secondary w-100" disabled>
                                    <i class="fas fa-check-circle me-2"></i>Request Processed
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Process Request Modal -->
                <div class="modal fade" id="processRequestModal-${req.warehouseRequestID}" tabindex="-1"
                     aria-labelledby="processModalLabel-${req.warehouseRequestID}" aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="processModalLabel-${req.warehouseRequestID}">
                                    Process Request for: ${req.product.productName}
                                </h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <p class="mb-0">Select a source warehouse based on available stock.</p>
                                    <p class="mb-0"><strong>Requested Quantity: <span
                                            class="badge bg-primary fs-6">${req.quantity}</span></strong></p>
                                </div>
                                <table class="table table-striped table-hover">
                                    <thead>
                                    <tr>
                                        <th>Warehouse</th>
                                        <th>Location</th>
                                        <th class="text-center">Available Quantity</th>
                                        <th class="text-center">Action</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="stock" items="${inventorySummary}">
                                        <c:if test="${stock.product.productID == req.product.productID}">
                                            <c:if test="${stock.warehouse.warehouseID != req.destinationWarehouse.warehouseID}">
                                                <tr>
                                                    <td>${stock.warehouse.warehouseName}</td>
                                                    <td>${stock.warehouse.location}</td>
                                                    <td class="text-center">${stock.count}</td>
                                                    <td class="text-center">
                                                        <form action="${pageContext.request.contextPath}/inventory_manager/view_transfer_requests"
                                                              method="post">
                                                            <input type="hidden" name="warehouseRequestID"
                                                                   value="${req.warehouseRequestID}">
                                                            <input type="hidden" name="sourceWarehouseID"
                                                                   value="${stock.warehouse.warehouseID}">
                                                            <button type="submit" class="btn btn-sm btn-success"
                                                                    <c:if test="${stock.count < req.quantity}">disabled</c:if>>
                                                                Choose
                                                            </button>
                                                        </form>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </c:if>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            </div>
                        </div>
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
