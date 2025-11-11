<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Requests - Warehouse Management</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-color: #4f46e5;
            --primary-hover: #4338ca;
            --success-color: #10b981;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --info-color: #3b82f6;
            --gradient-start: #667eea;
            --gradient-end: #764ba2;
        }

        * {
            font-family: 'Inter', sans-serif;
        }

        .page-header {
            background: linear-gradient(135deg, var(--gradient-start) 0%, var(--gradient-end) 100%);
            border-radius: 16px;
            padding: 32px;
            margin-bottom: 32px;
            box-shadow: 0 10px 40px rgba(102, 126, 234, 0.2);
            color: white;
            position: relative;
            overflow: hidden;
        }

        .page-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
        }

        .page-header h1 {
            font-weight: 700;
            font-size: 2rem;
            margin: 0;
            position: relative;
            z-index: 1;
        }

        .page-header-subtitle {
            opacity: 0.9;
            margin-top: 8px;
            font-size: 0.95rem;
        }

        .stats-badge {
            background: rgba(255, 255, 255, 0.2);
            padding: 8px 16px;
            border-radius: 10px;
            font-weight: 600;
            position: relative;
            z-index: 1;
        }

        .control-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
            border: 1px solid #e5e7eb;
            margin-bottom: 24px;
        }

        /* Grid Card Styles */
        .request-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
            gap: 24px;
            margin-bottom: 24px;
        }

        .request-card {
            background: white;
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
            border: 1px solid #e5e7eb;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .request-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: linear-gradient(135deg, var(--gradient-start), var(--gradient-end));
            transition: width 0.3s ease;
        }

        .request-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1);
        }

        .request-card:hover::before {
            width: 8px;
        }

        .card-header-section {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 16px;
            padding-bottom: 16px;
            border-bottom: 2px solid #f3f4f6;
        }

        .task-id-badge {
            background: linear-gradient(135deg, #e0e7ff, #ddd6fe);
            color: var(--primary-color);
            padding: 6px 14px;
            border-radius: 8px;
            font-weight: 700;
            font-size: 0.875rem;
            display: inline-block;
        }

        .status-badge {
            padding: 6px 14px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-block;
        }

        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .status-accepted {
            background: #d1fae5;
            color: #065f46;
        }

        .status-rejected {
            background: #fee2e2;
            color: #991b1b;
        }

        .status-finished {
            background: #dbeafe;
            color: #1e40af;
        }

        .product-section {
            margin-bottom: 16px;
        }

        .product-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 8px;
        }

        .product-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            background: linear-gradient(135deg, #f0f9ff, #e0f2fe);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--info-color);
            font-size: 1.3rem;
        }

        .product-info {
            flex: 1;
        }

        .product-name {
            font-weight: 700;
            color: #111827;
            font-size: 1.05rem;
            margin-bottom: 4px;
        }

        .product-type {
            color: #6b7280;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .quantity-display {
            background: linear-gradient(135deg, #fef3c7, #fde68a);
            padding: 8px 16px;
            border-radius: 10px;
            text-align: center;
        }

        .quantity-label {
            font-size: 0.7rem;
            color: #92400e;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 2px;
        }

        .quantity-value {
            font-size: 1.5rem;
            font-weight: 700;
            color: #78350f;
        }

        .staff-section {
            background: #f9fafb;
            border-radius: 12px;
            padding: 12px;
            margin-bottom: 16px;
        }

        .staff-header {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .staff-avatar {
            width: 48px;
            height: 48px;
            border-radius: 10px;
            background: linear-gradient(135deg, var(--gradient-start), var(--gradient-end));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 700;
            font-size: 1.1rem;
            flex-shrink: 0;
        }

        .staff-details {
            flex: 1;
        }

        .staff-name {
            font-weight: 600;
            color: #111827;
            font-size: 0.95rem;
            margin-bottom: 4px;
        }

        .staff-contact {
            color: #6b7280;
            font-size: 0.8rem;
            display: flex;
            align-items: center;
            gap: 4px;
            margin-bottom: 2px;
        }

        .staff-contact i {
            width: 14px;
            font-size: 0.75rem;
        }

        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-bottom: 16px;
        }

        .info-item {
            background: #f9fafb;
            padding: 10px 12px;
            border-radius: 10px;
        }

        .info-label {
            font-size: 0.7rem;
            color: #6b7280;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }

        .info-value {
            font-weight: 600;
            color: #111827;
            font-size: 0.9rem;
        }

        .description-section {
            background: #f9fafb;
            padding: 12px;
            border-radius: 10px;
            margin-bottom: 16px;
        }

        .description-label {
            font-size: 0.7rem;
            color: #6b7280;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 6px;
        }

        .description-text {
            color: #374151;
            font-size: 0.875rem;
            line-height: 1.5;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .btn-action {
            flex: 1;
            min-width: 120px;
            border-radius: 10px;
            padding: 10px 16px;
            font-weight: 600;
            font-size: 0.875rem;
            transition: all 0.3s ease;
            border: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }

        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .btn-accept {
            background: var(--success-color);
            color: white;
        }

        .btn-accept:hover {
            background: #059669;
        }

        .btn-reject {
            background: var(--danger-color);
            color: white;
        }

        .btn-reject:hover {
            background: #dc2626;
        }

        .btn-export {
            background: linear-gradient(135deg, var(--gradient-start), var(--gradient-end));
            color: white;
        }

        .btn-export:hover {
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }

        .form-control, .form-select {
            border-radius: 10px;
            border: 1px solid #e5e7eb;
            padding: 8px 12px;
            transition: all 0.2s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1);
        }

        .pagination .page-link {
            border-radius: 8px;
            margin: 0 4px;
            border: 1px solid #e5e7eb;
            color: #6b7280;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .pagination .page-link:hover {
            background: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
        }

        .pagination .page-item.active .page-link {
            background: var(--primary-color);
            border-color: var(--primary-color);
        }

        .pagination .page-item.disabled .page-link {
            background: #f9fafb;
            border-color: #e5e7eb;
        }

        .alert-custom {
            border: none;
            border-radius: 12px;
            padding: 16px 20px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 500;
        }

        .alert-custom i {
            font-size: 1.5rem;
        }

        .alert-success-custom {
            background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
            color: #065f46;
        }

        .alert-danger-custom {
            background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
            color: #991b1b;
        }

        .empty-state {
            padding: 64px 24px;
            text-align: center;
            color: #9ca3af;
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 16px;
            opacity: 0.5;
        }

        .empty-state p {
            margin: 0;
            font-size: 1.1rem;
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

        .request-card {
            animation: fadeIn 0.5s ease-out;
        }

        .main-content {
            margin: 15px;
        }

        @media (max-width: 768px) {
            .request-grid {
                grid-template-columns: 1fr;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .action-buttons {
                flex-direction: column;
            }

            .btn-action {
                min-width: 100%;
            }
        }
    </style>
</head>
<body>
<jsp:include page="../components/sidebar.jsp"/>
<div class="main-content">
    <jsp:include page="../components/header.jsp"/>

    <div class="page-content">
        <!-- Page Header -->
        <div class="page-header">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1><i class="fas fa-inbox me-2"></i>Incoming Product Requests</h1>
                    <p class="page-header-subtitle mb-0">Manage and process product requests from staff</p>
                </div>
                <div class="stats-badge">
                    <i class="fas fa-file-alt me-2"></i>
                    ${totalRequests} Total Requests
                </div>
            </div>
        </div>

        <!-- Messages -->
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert-custom alert-success-custom">
                <i class="fas fa-check-circle"></i>
                <span>${sessionScope.successMessage}</span>
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert-custom alert-danger-custom">
                <i class="fas fa-exclamation-circle"></i>
                <span>${sessionScope.errorMessage}</span>
            </div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <!-- Controls -->
        <div class="control-card">
            <div class="d-flex justify-content-between align-items-center">
                <div class="d-flex align-items-center gap-2">
                    <span class="text-muted fw-medium">Items per page:</span>
                    <form action="${pageContext.request.contextPath}/technician_employee/view_product_requests"
                          method="GET" class="mb-0">
                        <input type="hidden" name="page" value="${currentPage}">
                        <select name="pageSize" class="form-select form-select-sm" style="width: auto;"
                                onchange="this.form.submit()">
                            <option value="6" ${pageSize == 6 ? 'selected' : ''}>6</option>
                            <option value="12" ${pageSize == 12 ? 'selected' : ''}>12</option>
                            <option value="24" ${pageSize == 24 ? 'selected' : ''}>24</option>
                            <option value="48" ${pageSize == 48 ? 'selected' : ''}>48</option>
                        </select>
                    </form>
                </div>
                <div class="text-muted">
                    <c:set var="startItem" value="${totalRequests == 0 ? 0 : (currentPage - 1) * pageSize + 1}"/>
                    <c:set var="endItem"
                           value="${currentPage * pageSize > totalRequests ? totalRequests : currentPage * pageSize}"/>
                    Showing <span class="fw-bold text-primary">${startItem} - ${endItem}</span> of <span
                        class="fw-bold">${totalRequests}</span>
                </div>
            </div>
        </div>

        <!-- Requests Grid -->
        <c:choose>
            <c:when test="${not empty productRequests}">
                <div class="request-grid">
                    <c:forEach var="pr" items="${productRequests}">
                        <div class="request-card">
                            <!-- Card Header -->
                            <div class="card-header-section">
                                <span class="task-id-badge">#${pr.task.taskID}</span>
                                <span class="status-badge
                                    ${pr.status == 'Pending' ? 'status-pending' : ''}
                                    ${pr.status == 'Accepted' ? 'status-accepted' : ''}
                                    ${pr.status == 'Processing' ? 'status-processing' : ''}
                                    ${pr.status == 'Rejected' ? 'status-rejected' : ''}
                                    ${pr.status == 'Finished' ? 'status-finished' : ''}">
                                        ${pr.status}
                                </span>
                            </div>

                            <!-- Product Section -->
                            <div class="product-section">
                                <div class="product-header">
                                    <div class="product-icon">
                                        <i class="fas fa-box"></i>
                                    </div>
                                    <div class="product-info">
                                        <div class="product-name">${pr.product.productName}</div>
                                        <div class="product-type">
                                            <i class="fas fa-tag"></i>
                                                ${pr.product.type.typeName}
                                        </div>
                                    </div>
                                    <div class="quantity-display">
                                        <div class="quantity-label">Qty</div>
                                        <div class="quantity-value">${pr.quantity}</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Info Grid -->
                            <div class="info-grid">
                                <div class="info-item">
                                    <div class="info-label">Request Date</div>
                                    <div class="info-value">
                                        <i class="fas fa-calendar-alt me-1"></i>${pr.requestDate}
                                    </div>
                                </div>
                            </div>

                            <!-- Description -->
                            <div class="description-section">
                                <div class="description-label">Description</div>
                                <div class="description-text">${pr.description}</div>
                            </div>

                            <!-- Actions -->
                            <div class="action-buttons">
                                <c:if test="${pr.status == 'Processing'}">
                                    <form action="${pageContext.request.contextPath}/technician_employee/view_product_requests"
                                          method="post" style="display: contents;">
                                        <input type="hidden" name="productRequestID" value="${pr.productRequestID}">
                                        <button type="submit" name="action" value="finished"
                                                class="btn-action btn-accept">
                                            <i class="fas fa-check"></i>Finish
                                        </button>
                                        <button type="submit" name="action" value="reject"
                                                class="btn-action btn-reject">
                                            <i class="fas fa-times"></i>Reject
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <p>No product requests found</p>
                </div>
            </c:otherwise>
        </c:choose>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <div class="control-card mt-4">
                <div class="d-flex justify-content-between align-items-center">
                    <div class="text-muted">
                        Page <span class="fw-bold text-primary">${currentPage}</span> of <span
                            class="fw-bold">${totalPages}</span>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <nav aria-label="Page navigation">
                            <ul class="pagination mb-0">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage - 1}&pageSize=${pageSize}">
                                        <i class="fas fa-chevron-left"></i>
                                    </a>
                                </li>

                                <c:set var="startPage" value="${currentPage - 2}"/>
                                <c:set var="endPage" value="${currentPage + 2}"/>
                                <c:if test="${startPage < 1}">
                                    <c:set var="endPage" value="${endPage - (startPage - 1)}"/>
                                    <c:set var="startPage" value="1"/>
                                </c:if>
                                <c:if test="${endPage > totalPages}">
                                    <c:set var="startPage" value="${startPage - (endPage - totalPages)}"/>
                                    <c:set var="endPage" value="${totalPages}"/>
                                </c:if>
                                <c:if test="${startPage < 1}">
                                    <c:set var="startPage" value="1"/>
                                </c:if>

                                <c:if test="${startPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link" href="?page=1&pageSize=${pageSize}">1</a>
                                    </li>
                                    <c:if test="${startPage > 2}">
                                        <li class="page-item disabled">
                                            <span class="page-link">...</span>
                                        </li>
                                    </c:if>
                                </c:if>

                                <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="?page=${i}&pageSize=${pageSize}">${i}</a>
                                    </li>
                                </c:forEach>

                                <c:if test="${endPage < totalPages}">
                                    <c:if test="${endPage < totalPages - 1}">
                                        <li class="page-item disabled">
                                            <span class="page-link">...</span>
                                        </li>
                                    </c:if>
                                    <li class="page-item">
                                        <a class="page-link"
                                           href="?page=${totalPages}&pageSize=${pageSize}">${totalPages}</a>
                                    </li>
                                </c:if>

                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage + 1}&pageSize=${pageSize}">
                                        <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </ul>
                        </nav>

                        <form action="${pageContext.request.contextPath}/technician_employee/view_product_requests"
                              method="GET" class="d-flex align-items-center gap-1 mb-0">
                            <input type="hidden" name="pageSize" value="${pageSize}">
                            <input type="number" name="page" min="1" max="${totalPages}"
                                   class="form-control form-control-sm" style="width: 70px;" placeholder="Page">
                            <button type="submit" class="btn btn-sm btn-outline-secondary">
                                <i class="fas fa-arrow-right"></i>
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </c:if>
    </div>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
