<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Requests Timeline</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary: #6366f1;
            --primary-dark: #4f46e5;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --info: #3b82f6;
            --neutral-50: #f9fafb;
            --neutral-100: #f3f4f6;
            --neutral-200: #e5e7eb;
            --neutral-600: #6b7280;
            --neutral-800: #1f2937;
        }

        * {
            font-family: 'Inter', sans-serif;
        }

        body {
            background: var(--neutral-50);
        }

        .main-content {
            margin: 15px;
        }

        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 16px;
            padding: 32px;
            margin-bottom: 32px;
            color: white;
            box-shadow: 0 4px 20px rgba(102, 126, 234, 0.25);
        }

        .page-header h1 {
            font-weight: 700;
            font-size: 1.875rem;
            margin-bottom: 8px;
        }

        .page-header-subtitle {
            opacity: 0.95;
            font-size: 0.95rem;
        }

        .request-info-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 24px;
            border: 1px solid var(--neutral-200);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        }

        .request-info-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 16px;
            border-bottom: 2px solid var(--neutral-100);
        }

        .request-info-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--neutral-800);
        }

        .request-status-badge {
            padding: 8px 16px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 0.875rem;
            text-transform: uppercase;
        }

        .request-meta {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }

        .request-meta-item {
            display: flex;
            align-items: start;
            gap: 12px;
        }

        .request-meta-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            background: linear-gradient(135deg, #e0e7ff, #ddd6fe);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary);
            font-size: 1.1rem;
            flex-shrink: 0;
        }

        .request-meta-content {
            flex: 1;
        }

        .request-meta-label {
            color: var(--neutral-600);
            font-size: 0.813rem;
            margin-bottom: 4px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .request-meta-value {
            font-weight: 600;
            color: var(--neutral-800);
            font-size: 0.95rem;
        }

        .controls-bar {
            background: white;
            border-radius: 12px;
            padding: 16px 20px;
            margin-bottom: 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border: 1px solid var(--neutral-200);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        }

        .btn-create {
            background: var(--primary);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 10px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }

        .btn-create:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.3);
        }

        .timeline-container {
            position: relative;
            padding-left: 40px;
        }

        .timeline-line {
            position: absolute;
            left: 19px;
            top: 60px;
            bottom: 60px;
            width: 2px;
            background: linear-gradient(to bottom, var(--primary) 0%, var(--neutral-200) 100%);
        }

        .timeline-item {
            position: relative;
            margin-bottom: 32px;
            animation: slideIn 0.5s ease-out;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateX(-20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .timeline-marker {
            position: absolute;
            left: -27px;
            top: 12px;
            width: 16px;
            height: 16px;
            border-radius: 50%;
            background: white;
            border: 3px solid var(--primary);
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
            z-index: 2;
        }

        .timeline-date {
            position: absolute;
            left: -27px;
            top: 40px;
            background: var(--neutral-100);
            padding: 4px 8px;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--neutral-600);
            white-space: nowrap;
            transform: translateX(-50%);
            margin-left: 8px;
        }

        .request-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            border: 1px solid var(--neutral-200);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
            transition: all 0.3s ease;
        }

        .request-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.08);
            border-color: var(--primary);
        }

        .request-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 16px;
            padding-bottom: 12px;
            border-bottom: 1px solid var(--neutral-100);
        }

        .request-id {
            background: linear-gradient(135deg, #e0e7ff, #ddd6fe);
            color: var(--primary);
            padding: 6px 12px;
            border-radius: 8px;
            font-weight: 700;
            font-size: 0.875rem;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .status-accepted {
            background: #d1fae5;
            color: #065f46;
        }

        .status-processing {
            background: #dbeafe;
            color: #1e40af;
        }

        .status-rejected {
            background: #fee2e2;
            color: #991b1b;
        }

        .status-finished {
            background: #d1fae5;
            color: #047857;
        }

        .creator-info {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 16px;
            padding: 12px;
            background: var(--neutral-50);
            border-radius: 10px;
        }

        .creator-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 700;
            font-size: 0.875rem;
        }

        .creator-details {
            flex: 1;
        }

        .creator-label {
            font-size: 0.75rem;
            color: var(--neutral-600);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 2px;
        }

        .creator-name {
            font-weight: 600;
            color: var(--neutral-800);
            font-size: 0.9rem;
        }

        .product-info {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 16px;
        }

        .product-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            background: linear-gradient(135deg, #e0e7ff, #ddd6fe);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary);
            font-size: 1.25rem;
        }

        .product-details {
            flex: 1;
        }

        .product-name {
            font-weight: 700;
            color: var(--neutral-800);
            font-size: 1.05rem;
            margin-bottom: 4px;
        }

        .product-type {
            color: var(--neutral-600);
            font-size: 0.875rem;
        }

        .quantity-badge {
            background: linear-gradient(135deg, #fef3c7, #fde68a);
            padding: 8px 16px;
            border-radius: 10px;
            text-align: center;
        }

        .quantity-label {
            font-size: 0.7rem;
            color: #92400e;
            text-transform: uppercase;
            margin-bottom: 2px;
        }

        .quantity-value {
            font-size: 1.5rem;
            font-weight: 700;
            color: #78350f;
        }

        .request-description {
            background: var(--neutral-50);
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 16px;
            color: var(--neutral-600);
            font-size: 0.875rem;
            line-height: 1.6;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .btn-action {
            flex: 1;
            border: none;
            padding: 10px 16px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.875rem;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }

        .btn-finish {
            background: var(--success);
            color: white;
        }

        .btn-finish:hover {
            background: #059669;
            transform: translateY(-2px);
        }

        .btn-reject {
            background: var(--danger);
            color: white;
        }

        .btn-reject:hover {
            background: #dc2626;
            transform: translateY(-2px);
        }

        .empty-state {
            text-align: center;
            padding: 64px 24px;
            background: white;
            border-radius: 16px;
            border: 2px dashed var(--neutral-200);
        }

        .empty-state i {
            font-size: 4rem;
            color: var(--neutral-200);
            margin-bottom: 16px;
        }

        .empty-state p {
            color: var(--neutral-600);
            font-size: 1.1rem;
            margin: 0;
        }

        .pagination-container {
            background: white;
            border-radius: 12px;
            padding: 16px 20px;
            margin-top: 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border: 1px solid var(--neutral-200);
        }

        .pagination .page-link {
            border-radius: 8px;
            margin: 0 4px;
            border: 1px solid var(--neutral-200);
            color: var(--neutral-600);
            font-weight: 500;
        }

        .pagination .page-link:hover {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
        }

        .pagination .page-item.active .page-link {
            background: var(--primary);
            border-color: var(--primary);
        }

        @media (max-width: 768px) {
            .timeline-container {
                padding-left: 20px;
            }

            .timeline-line {
                left: 9px;
            }

            .timeline-marker {
                left: -17px;
            }

            .timeline-date {
                position: static;
                transform: none;
                margin: 8px 0;
                display: inline-block;
            }

            .action-buttons {
                flex-direction: column;
            }

            .request-meta {
                grid-template-columns: 1fr;
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
            <h1><i class="fas fa-timeline me-2"></i>Product Requests Timeline</h1>
            <p class="page-header-subtitle mb-0">Track and manage all product requests for this service request</p>
        </div>

        <!-- Request Info -->
        <c:if test="${not empty currentRequest}">
            <div class="request-info-card">
                <div class="request-info-header">
                    <h2 class="request-info-title">
                        <i class="fas fa-file-invoice me-2"></i>Request #${currentRequest.requestID}
                    </h2>
                    <span class="request-status-badge status-${currentRequest.requestStatus.toString().toLowerCase().replace('_', '-')}">
                            ${currentRequest.requestStatus}
                    </span>
                </div>

                <div class="request-meta">
                    <div class="request-meta-item">
                        <div class="request-meta-icon">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <div class="request-meta-content">
                            <div class="request-meta-label">Start Date</div>
                            <div class="request-meta-value">${currentRequest.startDate}</div>
                        </div>
                    </div>

                    <c:if test="${not empty currentRequest.finishedDate}">
                        <div class="request-meta-item">
                            <div class="request-meta-icon">
                                <i class="fas fa-calendar-times"></i>
                            </div>
                            <div class="request-meta-content">
                                <div class="request-meta-label">Finished Date</div>
                                <div class="request-meta-value">${currentRequest.finishedDate}</div>
                            </div>
                        </div>
                    </c:if>

                    <div class="request-meta-item">
                        <div class="request-meta-icon">
                            <i class="fas fa-file-contract"></i>
                        </div>
                        <div class="request-meta-content">
                            <div class="request-meta-label">Contract ID</div>
                            <div class="request-meta-value">#${currentRequest.contract.contractID}</div>
                        </div>
                    </div>

                    <c:if test="${not empty currentRequest.requestDescription}">
                        <div class="request-meta-item">
                            <div class="request-meta-icon">
                                <i class="fas fa-align-left"></i>
                            </div>
                            <div class="request-meta-content">
                                <div class="request-meta-label">Description</div>
                                <div class="request-meta-value">${currentRequest.requestDescription}</div>
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${not empty currentTask}">
                        <div class="request-meta-item">
                            <div class="request-meta-icon">
                                <i class="fas fa-tasks"></i>
                            </div>
                            <div class="request-meta-content">
                                <div class="request-meta-label">Current Task</div>
                                <div class="request-meta-value">#${currentTask.taskID}
                                    - ${currentTask.description}</div>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </c:if>

        <!-- Controls Bar -->
        <div class="controls-bar">
            <div class="d-flex align-items-center gap-2">
                <span class="text-muted fw-medium">Items per page:</span>
                <form action="${pageContext.request.contextPath}/technician_employee/view_product_requests" method="GET"
                      class="mb-0">
                    <input type="hidden" name="taskID" value="${taskID}">
                    <input type="hidden" name="page" value="${currentPage}">
                    <select name="pageSize" class="form-select form-select-sm" style="width: auto;"
                            onchange="this.form.submit()">
                        <option value="6" ${pageSize == 6 ? 'selected' : ''}>6</option>
                        <option value="9" ${pageSize == 9 ? 'selected' : ''}>9</option>
                        <option value="12" ${pageSize == 12 ? 'selected' : ''}>12</option>
                        <option value="24" ${pageSize == 24 ? 'selected' : ''}>24</option>
                    </select>
                </form>
            </div>
            <form action="${pageContext.request.contextPath}/technician_employee/create_product_request" method="Get">
                <input type="hidden" name="taskID" value="${currentTask.taskID}">
                <button class="btn-create"
                        type="submit">
                    <i class="fas fa-plus"></i>Create Request
                </button>
            </form>
        </div>

        <!-- Timeline -->
        <c:choose>
            <c:when test="${not empty productRequests}">
                <div class="timeline-container">
                    <div class="timeline-line"></div>
                    <c:forEach var="pr" items="${productRequests}" varStatus="status">
                        <div class="timeline-item" style="animation-delay: ${status.index * 0.1}s">
                            <div class="timeline-marker"></div>
                            <div class="timeline-date">
                                <i class="fas fa-calendar-alt me-1"></i>${pr.requestDate}
                            </div>

                            <div class="request-card">
                                <div class="request-header">
                                    <span class="request-id">#PR-${pr.productRequestID}</span>
                                    <span class="status-badge status-${pr.status.toString().toLowerCase()}">
                                            ${pr.status}
                                    </span>
                                </div>

                                <!-- Creator Info -->
                                <div class="creator-info">
                                    <div class="creator-avatar">
                                        <c:choose>
                                            <c:when test="${not empty pr.task.assignTo.image}">
                                                <img src="${pageContext.request.contextPath}${pr.task.assignTo.image}"
                                                     alt="${pr.task.assignTo.staffName}"
                                                     style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">
                                            </c:when>
                                            <c:otherwise>
                                                ${pr.task.assignTo.staffName.substring(0, 1).toUpperCase()}
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="creator-details">
                                        <div class="creator-label">Created By</div>
                                        <div class="creator-name">${pr.task.assignTo.staffName}</div>
                                    </div>
                                    <div class="text-end">
                                        <div class="creator-label">Task</div>
                                        <div class="creator-name">#${pr.task.taskID}</div>
                                    </div>
                                </div>

                                <div class="product-info">
                                    <div class="product-icon">
                                        <i class="fas fa-box"></i>
                                    </div>
                                    <div class="product-details">
                                        <div class="product-name">${pr.product.productName}</div>
                                        <div class="product-type">
                                            <i class="fas fa-tag me-1"></i>${pr.product.type.typeName}
                                        </div>
                                    </div>
                                    <div class="quantity-badge">
                                        <div class="quantity-label">Quantity</div>
                                        <div class="quantity-value">${pr.totalQuantity}</div>
                                    </div>
                                </div>

                                <c:if test="${not empty pr.description}">
                                    <div class="request-description">
                                        <i class="fas fa-quote-left me-2"></i>${pr.description}
                                    </div>
                                </c:if>

                                <c:if test="${pr.status == 'Transporting' && pr.task.assignTo.staffID == currentStaff.staffID}">
                                    <div class="action-buttons">
                                        <form action="${pageContext.request.contextPath}/technician_employee/view_product_requests"
                                              method="post" style="display: contents;">
                                            <input type="hidden" name="productRequestId" value="${pr.productRequestID}">
                                            <input type="hidden" name="taskID" value="${taskID}">
                                            <button type="submit" name="action" value="finished"
                                                    class="btn-action btn-finish">
                                                <i class="fas fa-check"></i>Mark as Finished
                                            </button>
                                            <button type="submit" name="action" value="reject"
                                                    class="btn-action btn-reject">
                                                <i class="fas fa-times"></i>Reject Request
                                            </button>
                                        </form>
                                    </div>
                                </c:if>

                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <p>No product requests found for this request</p>
                </div>
            </c:otherwise>
        </c:choose>

</body>
</html>
