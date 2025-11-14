<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>View Warehouse Requests</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        :root {
            --primary-color: #4a90e2;
            --success-color: #22c55e;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --info-color: #3b82f6;
            --card-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            --card-shadow-hover: 0 8px 24px rgba(0, 0, 0, 0.12);
        }

        body {
            min-height: 100vh;
        }

        .main-content {
            padding: 2rem;
            margin-top: 60px;
        }

        .page-header {
            background: white;
            border-radius: 12px;
            padding: 1.5rem 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--card-shadow);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .page-header h2 {
            margin: 0;
            color: #1e293b;
            font-weight: 700;
        }

        .stats-badge {
            background: linear-gradient(135deg, var(--primary-color), #667eea);
            color: white;
            padding: 0.5rem 1.5rem;
            border-radius: 25px;
            font-weight: 600;
        }

        .request-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
            gap: 1.5rem;
        }

        .request-card {
            background: white;
            border: none;
            border-radius: 16px;
            overflow: hidden;
            transition: all 0.3s ease;
            box-shadow: var(--card-shadow);
            animation: fadeIn 0.5s ease;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .request-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--card-shadow-hover);
        }

        .request-card .card-header {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            border-bottom: 2px solid #e2e8f0;
            padding: 1.25rem 1.5rem;
            font-weight: 600;
        }

        .date-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: #64748b;
            font-size: 0.9rem;
        }

        .status-badge {
            font-size: 0.85rem;
            padding: 0.4rem 1rem;
            border-radius: 20px;
            font-weight: 600;
            letter-spacing: 0.5px;
            text-transform: uppercase;
        }

        .warehouse-flow {
            background: #f8fafc;
            border-radius: 12px;
            padding: 1.25rem;
            margin-bottom: 1rem;
        }

        .warehouse-box {
            background: white;
            border: 2px dashed #cbd5e1;
            border-radius: 8px;
            padding: 1rem;
            text-align: center;
            flex: 1;
        }

        .warehouse-box.filled {
            border: 2px solid var(--primary-color);
            background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
        }

        .flow-arrow {
            color: var(--primary-color);
            font-size: 1.5rem;
            margin: 0 1rem;
        }

        .product-list {
            max-height: 200px;
            overflow-y: auto;
            padding-right: 10px;
        }

        .product-list::-webkit-scrollbar {
            width: 6px;
        }

        .product-list::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }

        .product-list::-webkit-scrollbar-thumb {
            background: #cbd5e1;
            border-radius: 10px;
        }

        .product-item {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            border-left: 4px solid var(--primary-color);
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 0.75rem;
            transition: all 0.2s ease;
        }

        .product-item:hover {
            transform: translateX(5px);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }

        .quantity-badge {
            background: linear-gradient(135deg, var(--primary-color), #667eea);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 700;
        }

        .note-section {
            background: #fef3c7;
            border-left: 4px solid var(--warning-color);
            padding: 1rem;
            border-radius: 8px;
            margin-top: 1rem;
        }

        .btn-process {
            background: linear-gradient(135deg, var(--primary-color), #667eea);
            border: none;
            color: white;
            font-weight: 600;
            padding: 0.75rem;
            border-radius: 10px;
            transition: all 0.3s ease;
        }

        .btn-process:hover {
            background: linear-gradient(135deg, #667eea, var(--primary-color));
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(74, 144, 226, 0.4);
        }

        .btn-processed {
            background: #f1f5f9;
            border: 2px solid #cbd5e1;
            color: #64748b;
            font-weight: 600;
            padding: 0.75rem;
            border-radius: 10px;
        }

        .modal-content {
            border: none;
            border-radius: 16px;
            overflow: hidden;
        }

        .modal-header {
            background: linear-gradient(135deg, var(--primary-color), #667eea);
            color: white;
            border: none;
            padding: 1.5rem;
        }

        .modal-body {
            padding: 2rem;
        }

        .stock-table {
            border-radius: 12px;
            overflow: hidden;
        }

        .stock-table thead {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
        }

        .stock-table tbody tr {
            transition: background-color 0.2s ease;
        }

        .stock-table tbody tr:hover {
            background-color: #f8fafc;
        }

        .alert {
            border: none;
            border-radius: 12px;
            padding: 1rem 1.5rem;
            margin-bottom: 1.5rem;
            animation: slideDown 0.3s ease;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: 16px;
            box-shadow: var(--card-shadow);
        }

        .empty-state i {
            font-size: 4rem;
            color: #cbd5e1;
            margin-bottom: 1rem;
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 1rem;
            }

            .request-grid {
                grid-template-columns: 1fr;
            }

            .page-header {
                flex-direction: column;
                text-align: center;
                gap: 1rem;
            }
        }
    </style>
</head>
<body>
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>

<div class="main-content">
    <div class="container-fluid">

        <div class="page-header">
            <h2><i class="fas fa-clipboard-list me-2"></i>Warehouse Product Requests</h2>
            <span class="stats-badge">
                <i class="fas fa-box me-2"></i>${productRequests.size()} Total Requests
            </span>
        </div>

        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.errorMessage}
            </div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle me-2"></i>${sessionScope.successMessage}
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>

        <c:choose>
            <c:when test="${empty productRequests}">
                <div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <h4>No Product Requests</h4>
                    <p class="text-muted">There are currently no warehouse product requests to display.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="request-grid">
                    <c:forEach var="req" items="${productRequests}">
                        <div class="card request-card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <span class="date-badge">
                                    <i class="far fa-calendar-alt"></i>${req.requestDate}
                                </span>
                                <c:set var="statusClass" value="bg-secondary"/>
                                <c:if test="${req.status == 'Pending'}"><c:set var="statusClass" value="bg-warning text-dark"/></c:if>
                                <c:if test="${req.status == 'Transporting'}"><c:set var="statusClass" value="bg-info"/></c:if>
                                <c:if test="${req.status == 'Accepted'}"><c:set var="statusClass" value="bg-success"/></c:if>
                                <c:if test="${req.status == 'Rejected'}"><c:set var="statusClass" value="bg-danger"/></c:if>
                                <span class="badge ${statusClass} status-badge">${req.status}</span>
                            </div>
                            <div class="card-body p-4">
                                <div class="warehouse-flow">
                                    <div class="d-flex align-items-center justify-content-between">
                                        <div class="warehouse-box ${req.warehouse != null ? 'filled' : ''}">
                                            <i class="fas fa-warehouse fa-2x mb-2 text-primary"></i>
                                            <div class="small text-muted">Source</div>
                                            <div class="fw-bold">${req.warehouse != null ? req.warehouse.warehouseName : 'Not Assigned'}</div>
                                        </div>
                                        <i class="fas fa-arrow-right flow-arrow"></i>
                                        <div class="warehouse-box filled">
                                            <i class="fas fa-user-tie fa-2x mb-2 text-primary"></i>
                                            <div class="small text-muted">Recipient</div>
                                            <div class="fw-bold">${req.task.assignTo.staffName}</div>
                                        </div>
                                    </div>
                                </div>

                                <h6 class="fw-bold mb-3 mt-4">
                                    <i class="fas fa-box-open me-2 text-primary"></i>Requested Product
                                </h6>
                                <div class="product-list">
                                    <div class="product-item">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <div class="fw-bold mb-1">${req.product.productName}</div>
                                                <small class="text-muted">Product ID: ${req.product.productID}</small>
                                            </div>
                                            <span class="quantity-badge">
                                                <i class="fas fa-cubes me-1"></i>${req.totalQuantity}
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <c:if test="${not empty req.description}">
                                    <div class="note-section">
                                        <i class="fas fa-sticky-note me-2"></i>
                                        <strong>Note:</strong> ${req.description}
                                    </div>
                                </c:if>

                                <div class="mt-4">
                                    <c:choose>
                                        <c:when test="${empty req.warehouse}">
                                            <button type="button" class="btn btn-process w-100" data-bs-toggle="modal"
                                                    data-bs-target="#processRequestModal-${req.productRequestID}">
                                                <i class="fas fa-cogs me-2"></i>Process Request
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="button" class="btn btn-processed w-100" disabled>
                                                <i class="fas fa-check-circle me-2"></i>Request Processed
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <!-- Process Request Modal -->
                        <div class="modal fade" id="processRequestModal-${req.productRequestID}" tabindex="-1"
                             aria-labelledby="processModalLabel-${req.productRequestID}" aria-hidden="true">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="processModalLabel-${req.productRequestID}">
                                            <i class="fas fa-box-open me-2"></i>Process Request: ${req.product.productName}
                                        </h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                                aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="d-flex justify-content-between align-items-center mb-4 p-3 bg-light rounded">
                                            <p class="mb-0"><i class="fas fa-info-circle text-primary me-2"></i>Select a source warehouse based on available stock</p>
                                            <span class="quantity-badge">
                                                <i class="fas fa-cubes me-1"></i>Required: ${req.totalQuantity}
                                            </span>
                                        </div>
                                        <table class="table table-hover stock-table">
                                            <thead>
                                            <tr>
                                                <th><i class="fas fa-warehouse me-2"></i>Warehouse</th>
                                                <th><i class="fas fa-map-marker-alt me-2"></i>Location</th>
                                                <th class="text-center"><i class="fas fa-boxes me-2"></i>Available</th>
                                                <th class="text-center"><i class="fas fa-hand-pointer me-2"></i>Action</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:forEach var="stock" items="${inventorySummary}">
                                                <c:if test="${stock.product.productID == req.product.productID}">
                                                    <c:if test="${stock.warehouse.warehouseID != req.warehouse.warehouseID}">
                                                        <tr>
                                                            <td class="fw-bold">${stock.warehouse.warehouseName}</td>
                                                            <td>${stock.warehouse.location}</td>
                                                            <td class="text-center">
                                                                <span class="badge ${stock.count >= req.totalQuantity ? 'bg-success' : 'bg-warning text-dark'}">
                                                                        ${stock.count}
                                                                </span>
                                                            </td>
                                                            <td class="text-center">
                                                                <form action="${pageContext.request.contextPath}/inventory_manager/view_product_requests"
                                                                      method="post">
                                                                    <input type="hidden" name="productRequestID" value="${req.productRequestID}">
                                                                    <input type="hidden" name="warehouseID" value="${stock.warehouse.warehouseID}">
                                                                    <button type="submit" class="btn btn-sm ${stock.count >= req.totalQuantity ? 'btn-success' : 'btn-secondary'}"
                                                                            <c:if test="${stock.count < req.totalQuantity}">disabled</c:if>>
                                                                        <i class="fas fa-check me-1"></i>Choose
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
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                            <i class="fas fa-times me-2"></i>Close
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
