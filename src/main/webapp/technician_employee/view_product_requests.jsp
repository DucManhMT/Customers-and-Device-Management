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
            --primary-light: #818cf8;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --info: #3b82f6;
            --neutral-50: #fafafa;
            --neutral-100: #f5f5f5;
            --neutral-200: #e5e5e5;
            --neutral-300: #d4d4d4;
            --neutral-400: #a3a3a3;
            --neutral-500: #737373;
            --neutral-600: #525252;
            --neutral-700: #404040;
            --neutral-800: #262626;
            --neutral-900: #171717;
        }

        * {
            font-family: 'Inter', sans-serif;
        }

        body {
            background: white;
            color: var(--neutral-800);
        }

        .main-content {
            margin: 20px;
        }

        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 20px;
            padding: 40px;
            margin-bottom: 32px;
            color: white;
            box-shadow: 0 10px 40px rgba(102, 126, 234, 0.2);
            position: relative;
            overflow: hidden;
        }

        .page-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            border-radius: 50%;
        }

        .page-header h1 {
            font-weight: 700;
            font-size: 2rem;
            margin-bottom: 8px;
            position: relative;
            z-index: 1;
        }

        .page-header-subtitle {
            opacity: 0.95;
            font-size: 1rem;
            position: relative;
            z-index: 1;
        }

        .request-info-card {
            background: white;
            border-radius: 16px;
            padding: 32px;
            margin-bottom: 32px;
            border: 1px solid var(--neutral-200);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.06);
        }

        .request-info-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--neutral-100);
        }

        .request-info-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--neutral-900);
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .request-status-badge {
            padding: 10px 20px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .request-meta {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 24px;
        }

        .request-meta-item {
            display: flex;
            align-items: start;
            gap: 16px;
            padding: 16px;
            background: var(--neutral-50);
            border-radius: 12px;
            transition: all 0.3s ease;
        }

        .request-meta-item:hover {
            background: var(--neutral-100);
            transform: translateY(-2px);
        }

        .request-meta-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            background: linear-gradient(135deg, var(--primary), var(--primary-light));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.25rem;
            flex-shrink: 0;
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.25);
        }

        .request-meta-content {
            flex: 1;
        }

        .request-meta-label {
            color: var(--neutral-500);
            font-size: 0.813rem;
            margin-bottom: 6px;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            font-weight: 500;
        }

        .request-meta-value {
            font-weight: 600;
            color: var(--neutral-900);
            font-size: 1rem;
            line-height: 1.4;
        }

        .controls-bar {
            background: white;
            border-radius: 16px;
            padding: 20px 28px;
            margin-bottom: 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border: 1px solid var(--neutral-200);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.06);
        }

        .btn-create {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.3);
        }

        .btn-create:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(99, 102, 241, 0.4);
        }

        .form-select-sm {
            border: 1px solid var(--neutral-300);
            border-radius: 10px;
            padding: 8px 12px;
            font-weight: 500;
            color: var(--neutral-700);
            transition: all 0.3s ease;
        }

        .form-select-sm:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
        }

        .timeline-container {
            position: relative;
            padding-left: 50px;
        }

        .timeline-line {
            position: absolute;
            left: 23px;
            top: 60px;
            bottom: 60px;
            width: 3px;
            background: linear-gradient(to bottom, var(--primary) 0%, var(--neutral-300) 100%);
            border-radius: 10px;
        }

        .timeline-item {
            position: relative;
            margin-bottom: 40px;
            animation: slideIn 0.6s ease-out;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateX(-30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .timeline-marker {
            position: absolute;
            left: -32px;
            top: 16px;
            width: 18px;
            height: 18px;
            border-radius: 50%;
            background: white;
            border: 4px solid var(--primary);
            box-shadow: 0 0 0 6px rgba(99, 102, 241, 0.15);
            z-index: 2;
        }

        .timeline-date {
            position: absolute;
            left: -32px;
            top: 50px;
            background: var(--neutral-100);
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--neutral-700);
            white-space: nowrap;
            transform: translateX(-50%);
            margin-left: 9px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }

        .request-card {
            background: white;
            border-radius: 16px;
            padding: 28px;
            border: 1px solid var(--neutral-200);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.06);
            transition: all 0.4s ease;
        }

        .request-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 32px rgba(0, 0, 0, 0.12);
            border-color: var(--primary);
        }

        .request-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 20px;
            padding-bottom: 16px;
            border-bottom: 2px solid var(--neutral-100);
        }

        .request-id {
            background: linear-gradient(135deg, #e0e7ff, #ddd6fe);
            color: var(--primary);
            padding: 8px 16px;
            border-radius: 10px;
            font-weight: 700;
            font-size: 0.95rem;
            box-shadow: 0 2px 8px rgba(99, 102, 241, 0.15);
        }

        .status-badge {
            padding: 8px 16px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 0.813rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .status-accepted {
            background: #d1fae5;
            color: #065f46;
        }

        .status-processing, .status-transporting {
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
            gap: 16px;
            margin-bottom: 20px;
            padding: 16px;
            background: linear-gradient(135deg, #fafafa, #f5f5f5);
            border-radius: 12px;
            border: 1px solid var(--neutral-200);
        }

        .creator-avatar {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 700;
            font-size: 1.125rem;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }

        .creator-details {
            flex: 1;
        }

        .creator-label {
            font-size: 0.75rem;
            color: var(--neutral-500);
            text-transform: uppercase;
            letter-spacing: 0.8px;
            margin-bottom: 4px;
            font-weight: 500;
        }

        .creator-name {
            font-weight: 600;
            color: var(--neutral-900);
            font-size: 1rem;
        }

        .product-info {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 20px;
            padding: 20px;
            background: var(--neutral-50);
            border-radius: 12px;
            border: 1px solid var(--neutral-200);
        }

        .product-icon {
            width: 56px;
            height: 56px;
            border-radius: 14px;
            background: linear-gradient(135deg, var(--primary), var(--primary-light));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.25);
        }

        .product-details {
            flex: 1;
        }

        .product-name {
            font-weight: 700;
            color: var(--neutral-900);
            font-size: 1.125rem;
            margin-bottom: 6px;
        }

        .product-type {
            color: var(--neutral-600);
            font-size: 0.9rem;
            font-weight: 500;
        }

        .quantity-badge {
            background: linear-gradient(135deg, #fef3c7, #fde68a);
            padding: 12px 20px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 2px 8px rgba(245, 158, 11, 0.2);
        }

        .quantity-label {
            font-size: 0.75rem;
            color: #92400e;
            text-transform: uppercase;
            margin-bottom: 4px;
            letter-spacing: 0.5px;
            font-weight: 600;
        }

        .quantity-value {
            font-size: 1.75rem;
            font-weight: 700;
            color: #78350f;
        }

        /* ========== NEW: Export Details Section ========== */
        .export-details-section {
            background: linear-gradient(135deg, #ecfdf5, #d1fae5);
            border: 2px solid var(--success);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.15);
        }

        .export-details-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 16px;
            padding-bottom: 12px;
            border-bottom: 2px solid #a7f3d0;
        }

        .export-details-title {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #065f46;
            font-weight: 700;
            font-size: 1rem;
        }

        .export-details-title i {
            font-size: 1.3rem;
        }

        .export-badge {
            background: #065f46;
            color: white;
            padding: 6px 14px;
            border-radius: 8px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .quantity-comparison {
            display: grid;
            grid-template-columns: 1fr auto 1fr;
            gap: 16px;
            align-items: center;
            margin-bottom: 16px;
        }

        .quantity-box {
            background: white;
            padding: 16px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            border: 2px solid transparent;
            transition: all 0.3s ease;
        }

        .quantity-box:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.15);
        }

        .quantity-box.requested {
            border-color: #fb923c;
        }

        .quantity-box.exported {
            border-color: var(--success);
        }

        .quantity-box-label {
            font-size: 0.75rem;
            color: var(--neutral-600);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 10px;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }

        .quantity-box-value {
            font-size: 2.25rem;
            font-weight: 700;
            line-height: 1;
            margin-bottom: 6px;
        }

        .quantity-box.requested .quantity-box-value {
            color: #ea580c;
        }

        .quantity-box.exported .quantity-box-value {
            color: #059669;
        }

        .quantity-box-unit {
            font-size: 0.813rem;
            color: var(--neutral-500);
            font-weight: 500;
        }

        .arrow-separator {
            font-size: 2.5rem;
            color: var(--success);
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% {
                opacity: 1;
                transform: scale(1);
            }
            50% {
                opacity: 0.7;
                transform: scale(1.1);
            }
        }

        .quantity-difference-box {
            background: white;
            padding: 14px 20px;
            border-radius: 10px;
            text-align: center;
            font-weight: 600;
            font-size: 0.95rem;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .quantity-difference-box.positive {
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            color: #065f46;
            border: 2px solid var(--success);
        }

        .quantity-difference-box.negative {
            background: linear-gradient(135deg, #fee2e2, #fecaca);
            color: #991b1b;
            border: 2px solid var(--danger);
        }

        .quantity-difference-box.equal {
            background: linear-gradient(135deg, #dbeafe, #bfdbfe);
            color: #1e40af;
            border: 2px solid var(--info);
        }

        .quantity-difference-box i {
            font-size: 1.3rem;
        }

        .warehouse-info {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            background: white;
            border-radius: 10px;
            margin-top: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }

        .warehouse-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            background: linear-gradient(135deg, #6366f1, #818cf8);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.1rem;
        }

        .warehouse-details {
            flex: 1;
        }

        .warehouse-label {
            font-size: 0.7rem;
            color: var(--neutral-500);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
            font-weight: 600;
        }

        .warehouse-name {
            font-weight: 600;
            color: var(--neutral-900);
            font-size: 0.95rem;
        }
        /* ========== END NEW SECTION ========== */

        .request-description {
            background: var(--neutral-50);
            padding: 16px;
            border-radius: 12px;
            margin-bottom: 20px;
            color: var(--neutral-700);
            font-size: 0.9rem;
            line-height: 1.7;
            border: 1px solid var(--neutral-200);
        }

        .action-buttons {
            display: flex;
            gap: 12px;
        }

        .btn-action {
            flex: 1;
            border: none;
            padding: 12px 20px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .btn-finish {
            background: linear-gradient(135deg, var(--success), #059669);
            color: white;
        }

        .btn-finish:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(16, 185, 129, 0.4);
        }

        .btn-reject {
            background: linear-gradient(135deg, var(--danger), #dc2626);
            color: white;
        }

        .btn-reject:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(239, 68, 68, 0.4);
        }

        .empty-state {
            text-align: center;
            padding: 80px 32px;
            background: white;
            border-radius: 20px;
            border: 2px dashed var(--neutral-300);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.06);
        }

        .empty-state i {
            font-size: 5rem;
            color: var(--neutral-300);
            margin-bottom: 24px;
        }

        .empty-state p {
            color: var(--neutral-600);
            font-size: 1.125rem;
            margin: 0;
            font-weight: 500;
        }

        .pagination-container {
            background: white;
            border-radius: 16px;
            padding: 20px 28px;
            margin-top: 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border: 1px solid var(--neutral-200);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.06);
        }

        .pagination .page-link {
            border-radius: 10px;
            margin: 0 4px;
            border: 1px solid var(--neutral-300);
            color: var(--neutral-700);
            font-weight: 500;
            padding: 10px 16px;
            transition: all 0.3s ease;
        }

        .pagination .page-link:hover {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
            transform: translateY(-2px);
        }

        .pagination .page-item.active .page-link {
            background: var(--primary);
            border-color: var(--primary);
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.3);
        }

        @media (max-width: 768px) {
            .main-content {
                margin: 15px;
            }

            .page-header {
                padding: 28px 24px;
            }

            .page-header h1 {
                font-size: 1.5rem;
            }

            .request-info-card, .request-card {
                padding: 20px;
            }

            .timeline-container {
                padding-left: 30px;
            }

            .timeline-line {
                left: 13px;
            }

            .timeline-marker {
                left: -22px;
            }

            .timeline-date {
                position: static;
                transform: none;
                margin: 12px 0;
                display: inline-block;
            }

            .action-buttons {
                flex-direction: column;
            }

            .request-meta {
                grid-template-columns: 1fr;
            }

            .controls-bar {
                flex-direction: column;
                gap: 16px;
                align-items: stretch;
            }

            .quantity-comparison {
                grid-template-columns: 1fr;
            }

            .arrow-separator {
                transform: rotate(90deg);
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
                        <i class="fas fa-file-invoice"></i>Request #${currentRequest.requestID}
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
                                <div class="request-meta-value">#${currentTask.taskID} - ${currentTask.description}</div>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </c:if>

        <!-- Controls Bar -->
        <div class="controls-bar">
            <div class="d-flex align-items-center gap-3">
                <span class="text-muted fw-medium">Items per page:</span>
                <form action="${pageContext.request.contextPath}/technician_employee/view_product_requests" method="GET" class="mb-0">
                    <input type="hidden" name="taskID" value="${taskID}">
                    <input type="hidden" name="page" value="${currentPage}">
                    <select name="pageSize" class="form-select form-select-sm" style="width: auto;" onchange="this.form.submit()">
                        <option value="6" ${pageSize == 6 ? 'selected' : ''}>6</option>
                        <option value="9" ${pageSize == 9 ? 'selected' : ''}>9</option>
                        <option value="12" ${pageSize == 12 ? 'selected' : ''}>12</option>
                        <option value="24" ${pageSize == 24 ? 'selected' : ''}>24</option>
                    </select>
                </form>
            </div>
            <c:if test="${currentTask.status != 'Finished' && currentTask.status != 'Cancelled'}">
            <form action="${pageContext.request.contextPath}/technician_employee/createProductRequests" method="Get">
                <input type="hidden" name="taskID" value="${currentTask.taskID}">
                <button class="btn-create" type="submit">
                    <i class="fas fa-plus"></i>Create Request
                </button>
            </form>
            </c:if>
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

                                <div class="creator-info">
                                    <div class="creator-avatar">
                                        <c:choose>
                                            <c:when test="${not empty pr.task.assignTo.image}">
                                                <img src="${pageContext.request.contextPath}${pr.task.assignTo.image}"
                                                     alt="${pr.task.assignTo.staffName}"
                                                     style="width: 100%; height: 100%; border-radius: 12px; object-fit: cover;">
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
                                        <div class="quantity-label">Requested</div>
                                        <div class="quantity-value">${pr.totalQuantity}</div>
                                    </div>
                                </div>

                                <!-- ========== NEW: Export Details Section ========== -->
                                <c:if test="${pr.status == 'Transporting' || pr.status == 'Finished'}">
                                    <div class="export-details-section">
                                        <div class="export-details-header">
                                            <div class="export-details-title">
                                                <i class="fas fa-truck-loading"></i>
                                                <span>Export Summary</span>
                                            </div>
                                            <span class="export-badge">
                                                <i class="fas fa-check-circle"></i> Exported
                                            </span>
                                        </div>

                                        <div class="quantity-comparison">
                                            <div class="quantity-box requested">
                                                <div class="quantity-box-label">
                                                    <i class="fas fa-file-invoice"></i>
                                                    Requested
                                                </div>
                                                <div class="quantity-box-value">${pr.totalQuantity}</div>
                                                <div class="quantity-box-unit">units</div>
                                            </div>

                                            <div class="arrow-separator">
                                                <i class="fas fa-arrow-right"></i>
                                            </div>

                                            <div class="quantity-box exported">
                                                <div class="quantity-box-label">
                                                    <i class="fas fa-box-open"></i>
                                                    Actually Exported
                                                </div>
                                                <div class="quantity-box-value">${pr.actualQuantity}</div>
                                                <div class="quantity-box-unit">units</div>
                                            </div>
                                        </div>

                                        <c:set var="difference" value="${pr.actualQuantity - pr.totalQuantity}"/>
                                        <div class="quantity-difference-box ${difference > 0 ? 'positive' : difference < 0 ? 'negative' : 'equal'}">
                                            <c:choose>
                                                <c:when test="${difference > 0}">
                                                    <i class="fas fa-arrow-up"></i>
                                                    <span>+${difference} units (Over delivered)</span>
                                                </c:when>
                                                <c:when test="${difference < 0}">
                                                    <i class="fas fa-arrow-down"></i>
                                                    <span>${difference} units (Under delivered)</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fas fa-check-circle"></i>
                                                    <span>Perfect Match - Exact quantity delivered</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <c:if test="${not empty pr.warehouse}">
                                            <div class="warehouse-info">
                                                <div class="warehouse-icon">
                                                    <i class="fas fa-warehouse"></i>
                                                </div>
                                                <div class="warehouse-details">
                                                    <div class="warehouse-label">Exported From</div>
                                                    <div class="warehouse-name">${pr.warehouse.warehouseName}</div>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>
                                </c:if>
                                <!-- ========== END NEW SECTION ========== -->

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
                                            <button type="submit" name="action" value="finished" class="btn-action btn-finish">
                                                <i class="fas fa-check"></i>Mark as Finished
                                            </button>
                                            <button type="submit" name="action" value="reject" class="btn-action btn-reject">
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

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <div class="pagination-container">
                <div class="text-muted">
                    Showing ${(currentPage - 1) * pageSize + 1} to ${currentPage * pageSize > totalRequests ? totalRequests : currentPage * pageSize} of ${totalRequests} requests
                </div>
                <nav>
                    <ul class="pagination mb-0">
                        <c:if test="${currentPage > 1}">
                            <li class="page-item">
                                <a class="page-link" href="?taskID=${taskID}&page=${currentPage - 1}&pageSize=${pageSize}">Previous</a>
                            </li>
                        </c:if>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="?taskID=${taskID}&page=${i}&pageSize=${pageSize}">${i}</a>
                            </li>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages}">
                            <li class="page-item">
                                <a class="page-link" href="?taskID=${taskID}&page=${currentPage + 1}&pageSize=${pageSize}">Next</a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </div>
        </c:if>
    </div>
</div>
</body>
</html>