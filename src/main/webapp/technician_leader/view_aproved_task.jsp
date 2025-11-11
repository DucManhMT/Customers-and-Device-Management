<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Approved Requests - Assign Tasks</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #4F46E5;
            --primary-dark: #4338CA;
            --primary-light: #818CF8;
            --secondary: #10B981;
            --warning: #F59E0B;
            --danger: #EF4444;
            --info: #3B82F6;
            --success: #10B981;
            --gray-50: #F9FAFB;
            --gray-100: #F3F4F6;
            --gray-200: #E5E7EB;
            --gray-300: #D1D5DB;
            --gray-400: #9CA3AF;
            --gray-500: #6B7280;
            --gray-600: #4B5563;
            --gray-700: #374151;
            --gray-900: #111827;
            --shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.1);
            --shadow-lg: 0 10px 15px rgba(0, 0, 0, 0.1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: var(--gray-50);
            color: var(--gray-900);
            line-height: 1.6;
        }

        /* Container */
        .approved-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }

        /* Page Header */
        .page-header {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: var(--shadow);
            margin-bottom: 1.5rem;
        }

        .header-content {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .header-icon {
            width: 56px;
            height: 56px;
            background: linear-gradient(135deg, var(--success), #059669);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            flex-shrink: 0;
        }

        .header-text h1 {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--gray-900);
            margin: 0 0 0.25rem 0;
        }

        .header-text p {
            font-size: 0.9375rem;
            color: var(--gray-600);
            margin: 0;
        }

        .header-stats {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 1rem 1.5rem;
            background: linear-gradient(135deg, var(--success), #059669);
            border-radius: 10px;
            color: white;
        }

        .header-stats i {
            font-size: 2rem;
            opacity: 0.9;
        }

        .header-stats-text {
            display: flex;
            flex-direction: column;
        }

        .header-stats-label {
            font-size: 0.8125rem;
            opacity: 0.9;
        }

        .header-stats-value {
            font-size: 1.75rem;
            font-weight: 700;
        }

        /* Alert Messages */
        .alert {
            padding: 1rem 1.25rem;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-size: 0.9375rem;
        }

        .alert i {
            font-size: 1.25rem;
        }

        .alert-success {
            background: rgba(16, 185, 129, 0.1);
            border: 1px solid var(--success);
            color: #065f46;
        }

        .alert-warning {
            background: rgba(245, 158, 11, 0.1);
            border: 1px solid var(--warning);
            color: #92400e;
        }

        .alert-danger {
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid var(--danger);
            color: #991b1b;
        }

        /* Filter Card */
        .filter-card {
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: var(--shadow);
            margin-bottom: 1.5rem;
        }

        .filter-header {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1.25rem;
            font-size: 1.125rem;
            font-weight: 700;
            color: var(--gray-900);
        }

        .filter-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1rem;
            margin-bottom: 1.25rem;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-label {
            font-size: 0.875rem;
            font-weight: 600;
            color: var(--gray-700);
            margin-bottom: 0.5rem;
        }

        .form-control {
            padding: 0.625rem 0.875rem;
            border: 1px solid var(--gray-300);
            border-radius: 8px;
            font-size: 0.9375rem;
            transition: all 0.2s;
            background: white;
            color: var(--gray-900);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
        }

        .filter-buttons {
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
        }

        /* Buttons */
        .btn {
            padding: 0.625rem 1.25rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.875rem;
            border: none;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background: var(--primary-dark);
        }

        .btn-success {
            background: var(--success);
            color: white;
        }

        .btn-success:hover {
            background: #059669;
        }

        .btn-secondary {
            background: var(--gray-200);
            color: var(--gray-700);
        }

        .btn-secondary:hover {
            background: var(--gray-300);
        }

        .btn-outline {
            background: white;
            color: var(--primary);
            border: 1px solid var(--primary);
        }

        .btn-outline:hover {
            background: var(--primary);
            color: white;
        }

        .btn-sm {
            padding: 0.5rem 1rem;
            font-size: 0.8125rem;
        }

        /* Table Card */
        .table-card {
            background: white;
            border-radius: 12px;
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .table-header {
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid var(--gray-200);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .table-title {
            font-size: 1.125rem;
            font-weight: 700;
            color: var(--gray-900);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .table-controls {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .table-controls label {
            font-size: 0.875rem;
            color: var(--gray-700);
            font-weight: 500;
        }

        .table-controls select {
            padding: 0.375rem 0.625rem;
            border: 1px solid var(--gray-300);
            border-radius: 6px;
            font-size: 0.875rem;
        }

        /* Table */
        .table-wrapper {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background: var(--gray-50);
        }

        th {
            padding: 0.875rem 1rem;
            text-align: left;
            font-size: 0.8125rem;
            font-weight: 600;
            color: var(--gray-700);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            border-bottom: 1px solid var(--gray-200);
        }

        td {
            padding: 1rem;
            border-bottom: 1px solid var(--gray-200);
            font-size: 0.875rem;
            color: var(--gray-900);
        }

        tbody tr {
            transition: background 0.2s;
        }

        tbody tr:hover {
            background: var(--gray-50);
        }

        /* Request Info */
        .request-info {
            display: flex;
            flex-direction: column;
            gap: 0.375rem;
        }

        .request-title {
            font-weight: 600;
            color: var(--gray-900);
        }

        .request-note {
            font-size: 0.8125rem;
            color: var(--gray-600);
        }

        .request-id {
            display: inline-flex;
            align-items: center;
            padding: 0.25rem 0.625rem;
            background: var(--gray-100);
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--gray-700);
            margin-top: 0.25rem;
        }

        /* Customer Info */
        .customer-info {
            display: flex;
            flex-direction: column;
            gap: 0.375rem;
        }

        .customer-name {
            font-weight: 600;
            color: var(--gray-900);
        }

        .customer-contact {
            display: flex;
            align-items: center;
            gap: 0.375rem;
            font-size: 0.8125rem;
            color: var(--gray-600);
        }

        .customer-contact i {
            color: var(--primary);
            width: 14px;
        }

        /* Badge */
        .badge {
            display: inline-flex;
            align-items: center;
            padding: 0.375rem 0.75rem;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .badge-success {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
        }

        .badge-processing {
            background: rgba(59, 130, 246, 0.1);
            color: var(--info);
        }

        .badge-finished {
            background: rgba(107, 114, 128, 0.1);
            color: var(--gray-600);
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 0.5rem;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 3rem 1rem;
            color: var(--gray-600);
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.3;
            color: var(--gray-400);
        }

        .empty-state h3 {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--gray-700);
        }

        .empty-state p {
            font-size: 0.9375rem;
            opacity: 0.7;
        }

        /* Pagination */
        .table-footer {
            padding: 1.25rem 1.5rem;
            border-top: 1px solid var(--gray-200);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .pagination-info {
            font-size: 0.875rem;
            color: var(--gray-600);
            font-weight: 500;
        }

        .pagination-controls {
            display: flex;
            gap: 0.5rem;
        }

        .pagination-btn {
            padding: 0.5rem 1rem;
            border: 1px solid var(--gray-300);
            background: white;
            color: var(--gray-700);
            border-radius: 6px;
            font-size: 0.875rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
        }

        .pagination-btn:hover:not(:disabled) {
            background: var(--gray-100);
        }

        .pagination-btn.active {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
        }

        .pagination-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .approved-container {
                padding: 1rem 0.75rem;
            }

            .page-header {
                padding: 1.5rem;
            }

            .header-content {
                flex-direction: column;
                align-items: flex-start;
            }

            .header-icon {
                width: 48px;
                height: 48px;
                font-size: 1.25rem;
            }

            .header-text h1 {
                font-size: 1.5rem;
            }

            .filter-grid {
                grid-template-columns: 1fr;
            }

            .table-wrapper {
                overflow-x: auto;
            }

            .table-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .table-footer {
                flex-direction: column;
                align-items: stretch;
            }

            .pagination-controls {
                justify-content: center;
            }

            .action-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>

<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>

<div class="approved-container">
    <!-- Page Header -->
    <div class="page-header">
        <div class="header-content">
            <div class="header-left">
                <div class="header-icon">
                    <i class="fas fa-clipboard-check"></i>
                </div>
                <div class="header-text">
                    <h1>Approved Requests</h1>
                    <p>View and assign approved service requests to technicians</p>
                </div>
            </div>
            <div class="header-stats">
                <i class="fas fa-tasks"></i>
                <div class="header-stats-text">
                    <div class="header-stats-label">Total Requests</div>
                    <div class="header-stats-value">
                        <c:choose>
                            <c:when test="${not empty totalCount}">${totalCount}</c:when>
                            <c:otherwise>0</c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Alert Messages -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <span>${sessionScope.successMessage}</span>
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.warningMessage}">
        <div class="alert alert-warning">
            <i class="fas fa-exclamation-triangle"></i>
            <span>${sessionScope.warningMessage}</span>
        </div>
        <c:remove var="warningMessage" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger">
            <i class="fas fa-times-circle"></i>
            <span>${sessionScope.errorMessage}</span>
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <!-- Filter Card -->
    <div class="filter-card">
        <div class="filter-header">
            <i class="fas fa-filter"></i>
            Filter Requests
        </div>
        <form method="POST" action="${pageContext.request.contextPath}/technician_leader/request/viewAprovedTask"
              id="filterForm">
            <input type="hidden" name="page" value="1">
            <input type="hidden" name="pageSize" value="${pageSize}">

            <div class="filter-grid">
                <div class="form-group">
                    <label class="form-label">Search by Phone</label>
                    <input type="text" class="form-control" name="phoneFilter"
                           value="${phoneFilter}" placeholder="Enter phone number..."
                           inputmode="numeric">
                </div>
                <div class="form-group">
                    <label class="form-label">Customer Name</label>
                    <input type="text" class="form-control" name="customerFilter"
                           value="${customerFilter}" placeholder="Search customer...">
                </div>
                <div class="form-group">
                    <label class="form-label">Status</label>
                    <select class="form-control" name="statusFilter">
                        <option value="">All Status</option>
                        <option value="Approved" ${statusFilter == 'Approved' ? 'selected' : ''}>Approved</option>
                        <option value="Processing" ${statusFilter == 'Processing' ? 'selected' : ''}>Processing</option>
                        <option value="Finished" ${statusFilter == 'Finished' ? 'selected' : ''}>Finished</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">From Date</label>
                    <input type="date" class="form-control" name="fromDate"
                           value="${fromDate}" id="fromDate">
                </div>
                <div class="form-group">
                    <label class="form-label">To Date</label>
                    <input type="date" class="form-control" name="toDate"
                           value="${toDate}" id="toDate">
                </div>
            </div>

            <div class="filter-buttons">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-search"></i> Apply Filters
                </button>
                <button type="button" class="btn btn-secondary" onclick="clearFilters()">
                    <i class="fas fa-times"></i> Clear Filters
                </button>
            </div>
        </form>
    </div>

    <!-- Table Card -->
    <div class="table-card">
        <div class="table-header">
            <div class="table-title">
                <i class="fas fa-list"></i>
                Request List
                <span style="color: var(--gray-600); font-weight: 500;">
                    (<c:choose>
                    <c:when test="${not empty totalCount}">${totalCount}</c:when>
                    <c:otherwise>0</c:otherwise>
                </c:choose> requests)
                </span>
            </div>
            <div class="table-controls">
                <label>Show:</label>
                <form method="POST"
                      action="${pageContext.request.contextPath}/technician_leader/request/viewAprovedTask"
                      style="display: inline;" id="pageSizeForm">
                    <input type="hidden" name="page" value="1">
                    <input type="hidden" name="phoneFilter" value="${phoneFilter}">
                    <input type="hidden" name="customerFilter" value="${customerFilter}">
                    <input type="hidden" name="statusFilter" value="${statusFilter}">
                    <input type="hidden" name="fromDate" value="${fromDate}">
                    <input type="hidden" name="toDate" value="${toDate}">
                    <select name="pageSize" onchange="this.form.submit()" class="form-control">
                        <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                        <option value="8" ${pageSize == 8 ? 'selected' : ''}>8</option>
                        <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                        <option value="15" ${pageSize == 15 ? 'selected' : ''}>15</option>
                    </select>
                </form>
            </div>
        </div>

        <div class="table-wrapper">
            <table>
                <thead>
                <tr>
                    <th>Request Details</th>
                    <th>Customer Info</th>
                    <th>Date</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty approvedRequests}">
                        <c:forEach var="reqObj" items="${approvedRequests}">
                            <tr>
                                <td>
                                    <div class="request-info">
                                        <div class="request-title">
                                            <c:choose>
                                                <c:when test="${not empty reqObj.requestDescription}">
                                                    ${reqObj.requestDescription}
                                                </c:when>
                                                <c:otherwise>Service Request</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <c:if test="${not empty reqObj.note}">
                                            <div class="request-note">${reqObj.note}</div>
                                        </c:if>
                                        <span class="request-id">REQ-${reqObj.requestID}</span>
                                    </div>
                                </td>
                                <td>
                                    <div class="customer-info">
                                        <div class="customer-name">
                                            <c:choose>
                                                <c:when test="${not empty reqObj.contract.customer.customerName}">
                                                    ${reqObj.contract.customer.customerName}
                                                </c:when>
                                                <c:otherwise>N/A</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <c:if test="${not empty reqObj.contract.customer.phone}">
                                            <div class="customer-contact">
                                                <i class="fas fa-phone"></i>
                                                    ${reqObj.contract.customer.phone}
                                            </div>
                                        </c:if>
                                    </div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty reqObj.startDate}">
                                            <i class="fas fa-calendar"
                                               style="color: var(--gray-500); margin-right: 0.375rem;"></i>
                                            ${reqObj.startDate}
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: var(--gray-500);">No date</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${reqObj.requestStatus == 'Approved'}">
                                                <span class="badge badge-success">
                                                    <i class="fas fa-check-circle"></i> ${reqObj.requestStatus}
                                                </span>
                                        </c:when>
                                        <c:when test="${reqObj.requestStatus == 'Processing'}">
                                                <span class="badge badge-processing">
                                                    <i class="fas fa-spinner"></i> ${reqObj.requestStatus}
                                                </span>
                                        </c:when>
                                        <c:when test="${reqObj.requestStatus == 'Finished'}">
                                                <span class="badge badge-finished">
                                                    <i class="fas fa-check"></i> ${reqObj.requestStatus}
                                                </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge">${reqObj.requestStatus}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="${pageContext.request.contextPath}/technician_leader/requests/detail?requestId=${reqObj.requestID}"
                                           class="btn btn-outline btn-sm">
                                            <i class="fas fa-eye"></i> View
                                        </a>
                                        <c:if test="${reqObj.requestStatus != 'Finished'}">
                                            <form action="${pageContext.request.contextPath}/task/selectTechnician"
                                                  method="POST" style="display: inline;">
                                                <input type="hidden" name="selectedTasks" value="${reqObj.requestID}">
                                                <button type="submit" class="btn btn-success btn-sm">
                                                    <i class="fas fa-user-plus"></i> Assign
                                                </button>
                                            </form>
                                        </c:if>

                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="5">
                                <div class="empty-state">
                                    <i class="fas fa-clipboard-list"></i>
                                    <h3>No Approved Requests Found</h3>
                                    <p>There are currently no approved requests matching your criteria.</p>
                                </div>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>

        <div class="table-footer">
            <div class="pagination-info">
                Showing
                <c:choose>
                    <c:when test="${not empty totalCount and totalCount > 0}">
                        ${startItem} - ${endItem} of ${totalCount}
                    </c:when>
                    <c:otherwise>0</c:otherwise>
                </c:choose>
                entries
            </div>

            <div class="pagination-controls">
                <c:set var="currentPage" value="${currentPage != null ? currentPage : 1}"/>
                <c:set var="totalPages" value="${totalPages != null ? totalPages : 1}"/>

                <form method="POST"
                      action="${pageContext.request.contextPath}/technician_leader/request/viewAprovedTask"
                      style="display: inline;" id="paginationForm">
                    <input type="hidden" name="page" id="pageInput" value="${currentPage}">
                    <input type="hidden" name="phoneFilter" value="${phoneFilter}">
                    <input type="hidden" name="customerFilter" value="${customerFilter}">
                    <input type="hidden" name="statusFilter" value="${statusFilter}">
                    <input type="hidden" name="fromDate" value="${fromDate}">
                    <input type="hidden" name="toDate" value="${toDate}">
                    <input type="hidden" name="pageSize" value="${pageSize}">
                </form>

                <c:choose>
                    <c:when test="${currentPage == 1}">
                        <button type="button" class="pagination-btn" disabled>
                            <i class="fas fa-angles-left"></i>
                        </button>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="pagination-btn" onclick="goToPage(1)">
                            <i class="fas fa-angles-left"></i>
                        </button>
                    </c:otherwise>
                </c:choose>

                <c:choose>
                    <c:when test="${currentPage == 1}">
                        <button type="button" class="pagination-btn" disabled>
                            <i class="fas fa-angle-left"></i>
                        </button>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="pagination-btn" onclick="goToPage(${currentPage - 1})">
                            <i class="fas fa-angle-left"></i>
                        </button>
                    </c:otherwise>
                </c:choose>

                <button class="pagination-btn active">
                    Page ${currentPage} of ${totalPages}
                </button>

                <c:choose>
                    <c:when test="${currentPage >= totalPages}">
                        <button type="button" class="pagination-btn" disabled>
                            <i class="fas fa-angle-right"></i>
                        </button>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="pagination-btn" onclick="goToPage(${currentPage + 1})">
                            <i class="fas fa-angle-right"></i>
                        </button>
                    </c:otherwise>
                </c:choose>

                <c:choose>
                    <c:when test="${currentPage >= totalPages}">
                        <button type="button" class="pagination-btn" disabled>
                            <i class="fas fa-angles-right"></i>
                        </button>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="pagination-btn" onclick="goToPage(${totalPages})">
                            <i class="fas fa-angles-right"></i>
                        </button>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<script>
    function goToPage(page) {
        document.getElementById('pageInput').value = page;
        document.getElementById('paginationForm').submit();
    }

    function clearFilters() {
        const form = document.getElementById('filterForm');
        form.querySelectorAll('input[type="text"], input[type="date"]').forEach(input => {
            input.value = '';
        });
        form.querySelectorAll('select').forEach(select => {
            select.selectedIndex = 0;
        });
        form.querySelector('input[name="page"]').value = 1;
        form.submit();
    }

    // Date validation
    document.addEventListener('DOMContentLoaded', function () {
        const fromDate = document.getElementById('fromDate');
        const toDate = document.getElementById('toDate');
        const today = new Date().toISOString().split('T')[0];

        fromDate.setAttribute('max', today);
        toDate.setAttribute('max', today);

        fromDate.addEventListener('change', function () {
            if (this.value) {
                toDate.setAttribute('min', this.value);
            }
        });

        toDate.addEventListener('change', function () {
            if (this.value) {
                fromDate.setAttribute('max', this.value);
            }
        });

        // Phone filter - only digits
        const phoneFilter = document.querySelector('input[name="phoneFilter"]');
        if (phoneFilter) {
            phoneFilter.addEventListener('input', function () {
                this.value = this.value.replace(/\D/g, '');
            });
        }
    });
</script>

</body>
</html>