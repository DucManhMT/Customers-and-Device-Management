<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assigned Task List</title>
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
            --gray-600: #4B5563;
            --gray-700: #374151;
            --gray-900: #111827;
            --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.05);
            --shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.1);
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

        /* Main Container */
        .tasks-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }

        /* Page Header */
        .page-header {
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: var(--shadow);
            margin-bottom: 1.5rem;
        }

        .header-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .header-title {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .title-icon {
            width: 48px;
            height: 48px;
            background: linear-gradient(135deg, var(--primary), var(--primary-light));
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.25rem;
        }

        .page-header h1 {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--gray-900);
            margin: 0;
        }

        /* Alert Messages */
        .alert {
            padding: 1rem 1.25rem;
            border-radius: 8px;
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
            color: var(--success);
            border: 1px solid rgba(16, 185, 129, 0.2);
        }

        .alert-error {
            background: rgba(239, 68, 68, 0.1);
            color: var(--danger);
            border: 1px solid rgba(239, 68, 68, 0.2);
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.25rem;
            margin-bottom: 1.5rem;
        }

        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: var(--shadow);
            transition: all 0.3s;
        }

        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .stat-card:nth-child(1) .stat-icon {
            background: linear-gradient(135deg, var(--primary), var(--primary-light));
        }

        .stat-card:nth-child(2) .stat-icon {
            background: linear-gradient(135deg, var(--warning), #F97316);
        }

        .stat-card:nth-child(3) .stat-icon {
            background: linear-gradient(135deg, var(--success), #059669);
        }

        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.25rem;
            margin-bottom: 1rem;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 0.25rem;
        }

        .stat-label {
            font-size: 0.875rem;
            color: var(--gray-600);
            font-weight: 500;
        }

        /* Filter Card */
        .filter-card {
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: var(--shadow);
            margin-bottom: 1.5rem;
        }

        .filter-card h2 {
            font-size: 1.125rem;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 1.25rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .filter-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 1rem;
            margin-bottom: 1.25rem;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
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

        .btn-secondary {
            background: var(--gray-200);
            color: var(--gray-700);
        }

        .btn-secondary:hover {
            background: var(--gray-300);
        }

        .btn-success {
            background: var(--success);
            color: white;
        }

        .btn-success:hover {
            background: #059669;
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

        .btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        /* Tasks Grid */
        .tasks-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
            gap: 1.25rem;
            margin-bottom: 1.5rem;
        }

        .task-card {
            background: white;
            border-radius: 12px;
            box-shadow: var(--shadow);
            padding: 1.5rem;
            transition: all 0.3s;
            border-left: 4px solid var(--primary);
        }

        .task-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-md);
        }

        .task-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 1rem;
            margin-bottom: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--gray-200);
        }

        .task-title {
            font-size: 1.125rem;
            font-weight: 700;
            color: var(--gray-900);
            margin: 0;
            flex: 1;
            line-height: 1.4;
        }

        .task-badge {
            padding: 0.375rem 0.75rem;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            white-space: nowrap;
        }

        .badge-processing {
            background: rgba(245, 158, 11, 0.1);
            color: var(--warning);
        }

        .badge-finished {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
        }

        .badge-pending {
            background: rgba(107, 114, 128, 0.1);
            color: var(--gray-600);
        }

        .task-description {
            font-size: 0.875rem;
            color: var(--gray-600);
            line-height: 1.6;
            margin-bottom: 1rem;
        }

        .task-details {
            display: grid;
            gap: 0.625rem;
            margin-bottom: 1.25rem;
        }

        .task-detail {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.875rem;
        }

        .task-detail-label {
            color: var(--gray-600);
            font-weight: 500;
        }

        .task-detail-value {
            color: var(--gray-900);
            font-weight: 600;
        }

        .task-footer {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
            padding-top: 1rem;
            border-top: 1px solid var(--gray-200);
        }

        .task-footer .btn {
            flex: 1;
            justify-content: center;
            font-size: 0.8125rem;
            padding: 0.5rem 1rem;
        }

        /* Empty State */
        .empty-state {
            grid-column: 1 / -1;
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
        .pagination {
            background: white;
            padding: 1.25rem;
            border-radius: 12px;
            box-shadow: var(--shadow);
        }

        .pagination-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .pagination-info {
            font-size: 0.875rem;
            color: var(--gray-600);
            font-weight: 500;
        }

        .items-per-page {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.875rem;
            color: var(--gray-700);
        }

        .items-per-page label {
            font-weight: 500;
        }

        .items-per-page select {
            padding: 0.375rem 0.625rem;
            border: 1px solid var(--gray-300);
            border-radius: 6px;
            font-size: 0.875rem;
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
            .tasks-container {
                padding: 1rem 0.75rem;
            }

            .page-header {
                padding: 1rem;
            }

            .page-header h1 {
                font-size: 1.5rem;
            }

            .title-icon {
                width: 40px;
                height: 40px;
                font-size: 1rem;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .filter-grid {
                grid-template-columns: 1fr;
            }

            .tasks-grid {
                grid-template-columns: 1fr;
            }

            .pagination-content {
                flex-direction: column;
                align-items: stretch;
                text-align: center;
            }

            .pagination-controls {
                justify-content: center;
            }

            .task-footer {
                flex-direction: column;
            }

            .task-footer .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>

<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>

<div class="tasks-container">
    <!-- Page Header -->
    <div class="page-header">
        <div class="header-top">
            <div class="header-title">
                <div class="title-icon">
                    <i class="fas fa-tasks"></i>
                </div>
                <h1>My Assigned Tasks</h1>
            </div>
            <a href="${pageContext.request.contextPath}/technician_employee/task/viewReceivedAssignments"
               class="btn btn-outline">
                <i class="fas fa-inbox"></i>
                <span>Pending Assignments</span>
            </a>
        </div>
    </div>

    <!-- Alert Messages -->
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <span>${successMessage}</span>
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i>
            <span>${errorMessage}</span>
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <!-- Stats Grid -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon">
                <i class="fas fa-list-check"></i>
            </div>
            <div class="stat-number">${totalTasks}</div>
            <div class="stat-label">Total Tasks</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">
                <i class="fas fa-spinner"></i>
            </div>
            <div class="stat-number">${processingTasks}</div>
            <div class="stat-label">Processing</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">
                <i class="fas fa-check-circle"></i>
            </div>
            <div class="stat-number">${finishedTasks}</div>
            <div class="stat-label">Finished</div>
        </div>
    </div>

    <!-- Filter Card -->
    <div class="filter-card">
        <h2>
            <i class="fas fa-filter"></i>
            Filters
        </h2>
        <form method="POST" action="${pageContext.request.contextPath}/technician_employee/task/viewAssignedTasks">
            <input type="hidden" name="page" value="${currentPage != null ? currentPage : 1}">
            <input type="hidden" name="pageSize" value="${pageSize != null ? pageSize : 6}">

            <div class="filter-grid">
                <div class="form-group">
                    <label>Status</label>
                    <select class="form-control" name="statusFilter">
                        <option value="">All Status</option>
                        <option value="processing" ${statusFilter == 'processing' ? 'selected' : ''}>Processing</option>
                        <option value="finished" ${statusFilter == 'finished' ? 'selected' : ''}>Finished</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Sort by Time</label>
                    <select class="form-control" name="sortBy">
                        <option value="">No Sort</option>
                        <option value="newest" ${sortBy == 'newest' ? 'selected' : ''}>Newest First</option>
                        <option value="oldest" ${sortBy == 'oldest' ? 'selected' : ''}>Oldest First</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>From Date</label>
                    <input type="date" class="form-control" name="fromDate"
                           value="${fromDate}" id="fromDate">
                </div>
                <div class="form-group">
                    <label>To Date</label>
                    <input type="date" class="form-control" name="toDate"
                           value="${toDate}" id="toDate">
                </div>
            </div>
            <div class="filter-buttons">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-search"></i> Apply Filters
                </button>
                <a href="${pageContext.request.contextPath}/technician_employee/task/viewAssignedTasks"
                   class="btn btn-secondary">
                    <i class="fas fa-times"></i> Clear Filters
                </a>
            </div>
        </form>
    </div>

    <c:if test="${not empty statsNote}">
        <div style="text-align: center; margin-bottom: 1.5rem; color: var(--gray-600); font-style: italic;">
                ${statsNote}
        </div>
    </c:if>

    <!-- Tasks Grid -->
    <div class="tasks-grid">
        <c:choose>
            <c:when test="${not empty assignedTasks}">
                <c:forEach var="task" items="${assignedTasks}">
                    <c:set var="req" value="${task.request}"/>
                    <div class="task-card">
                        <div class="task-header">
                            <h3 class="task-title">
                                <c:choose>
                                    <c:when test="${not empty task.description}">
                                        ${task.description}
                                    </c:when>
                                    <c:when test="${not empty req.requestDescription}">
                                        ${req.requestDescription}
                                    </c:when>
                                    <c:otherwise>Task Assignment</c:otherwise>
                                </c:choose>
                            </h3>
                            <span class="task-badge badge-${task.status == 'Finished' ? 'finished' : task.status == 'Processing' ? 'processing' : 'pending'}">
                                    ${task.status}
                            </span>
                        </div>

                        <p class="task-description">
                            <c:if test="${not empty req}">
                                <strong>Request:</strong> ${not empty req.requestDescription ? req.requestDescription : 'No description'}
                                <br/>
                            </c:if>
                            <c:if test="${not empty req.note}">
                                <strong>Notes:</strong> ${req.note}
                            </c:if>
                        </p>

                        <div class="task-details">
                            <div class="task-detail">
                                <span class="task-detail-label">Task ID:</span>
                                <span class="task-detail-value">#${task.taskID}</span>
                            </div>
                            <div class="task-detail">
                                <span class="task-detail-label">Request ID:</span>
                                <span class="task-detail-value">#${req.requestID}</span>
                            </div>
                            <div class="task-detail">
                                <span class="task-detail-label">Start Date:</span>
                                <span class="task-detail-value">
                                    <c:choose>
                                        <c:when test="${not empty task.startDate}">
                                            ${task.startDate}
                                        </c:when>
                                        <c:otherwise>Not started</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="task-detail">
                                <span class="task-detail-label">Deadline:</span>
                                <span class="task-detail-value">
                                    <c:choose>
                                        <c:when test="${not empty task.deadline}">
                                            ${task.deadline}
                                        </c:when>
                                        <c:otherwise>Not set</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>

                        <div class="task-footer">
                            <form method="POST"
                                  action="${pageContext.request.contextPath}/technician_employee/request/detail"
                                  style="display: inline; flex: 1;">
                                <input type="hidden" name="id" value="${task.taskID}">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-eye"></i> View Details
                                </button>
                            </form>
                            <c:choose>
                                <c:when test="${req.requestStatus == 'Processing'}">
                                    <form method="GET"
                                          action="${pageContext.request.contextPath}/technician_employee/createProductRequests"
                                          style="display: inline; flex: 1;">
                                        <input type="hidden" name="taskID" value="${task.taskID}">
                                        <button type="submit" class="btn btn-outline">
                                            <i class="fas fa-plus"></i> Create Request
                                        </button>
                                    </form>
                                </c:when>
                            </c:choose>
                            <c:choose>
                                <c:when test="${task.status == 'Finished'}">
                                    <button class="btn btn-secondary" disabled style="flex: 1;">
                                        <i class="fas fa-check"></i> Finished
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <form method="POST"
                                          action="${pageContext.request.contextPath}/technician_employee/task/updateStatus"
                                          style="display: inline; flex: 1;"
                                          onsubmit="return confirm('Are you sure you want to mark this task as finished?')">
                                        <input type="hidden" name="taskId" value="${task.taskID}">
                                        <input type="hidden" name="status" value="finished">
                                        <button type="submit" class="btn btn-success">
                                            <i class="fas fa-check"></i> Mark Finished
                                        </button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <h3>No assigned tasks found</h3>
                    <p>You don't have any tasks assigned at the moment.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="pagination">
        <div class="pagination-content">
            <div class="pagination-info">
                <c:choose>
                    <c:when test="${not empty startItem && not empty endItem && not empty totalCount}">
                        Showing ${startItem} - ${endItem} of ${totalCount} tasks
                    </c:when>
                    <c:otherwise>No tasks found</c:otherwise>
                </c:choose>
            </div>

            <div class="items-per-page">
                <label>Show:</label>
                <form method="POST"
                      action="${pageContext.request.contextPath}/technician_employee/task/viewAssignedTasks"
                      style="display: inline;">
                    <input type="hidden" name="statusFilter" value="${statusFilter}">
                    <input type="hidden" name="sortBy" value="${sortBy}">
                    <input type="hidden" name="fromDate" value="${fromDate}">
                    <input type="hidden" name="toDate" value="${toDate}">
                    <input type="hidden" name="page" value="1">

                    <select class="form-control" name="pageSize" onchange="this.form.submit()">
                        <option value="4" ${pageSize == 4 ? 'selected' : ''}>4 tasks</option>
                        <option value="6" ${pageSize == 6 ? 'selected' : ''}>6 tasks</option>
                        <option value="8" ${pageSize == 8 ? 'selected' : ''}>8 tasks</option>
                        <option value="12" ${pageSize == 12 ? 'selected' : ''}>12 tasks</option>
                    </select>
                </form>
            </div>

            <div class="pagination-controls">
                <c:set var="currentPage" value="${currentPage != null ? currentPage : 1}"/>
                <c:set var="totalPages" value="${totalPages != null ? totalPages : 1}"/>
                <c:choose>
                    <c:when test="${currentPage > 1}">
                        <form method="POST"
                              action="${pageContext.request.contextPath}/technician_employee/task/viewAssignedTasks"
                              style="display: inline;">
                            <input type="hidden" name="statusFilter" value="${statusFilter}">
                            <input type="hidden" name="sortBy" value="${sortBy}">
                            <input type="hidden" name="fromDate" value="${fromDate}">
                            <input type="hidden" name="toDate" value="${toDate}">
                            <input type="hidden" name="pageSize" value="${pageSize}">
                            <input type="hidden" name="page" value="${currentPage - 1}">
                            <button type="submit" class="pagination-btn">‹ Previous</button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <button class="pagination-btn" disabled>‹ Previous</button>
                    </c:otherwise>
                </c:choose>
                <button class="pagination-btn active">${currentPage}</button>
                <c:choose>
                    <c:when test="${currentPage < totalPages}">
                        <form method="POST"
                              action="${pageContext.request.contextPath}/technician_employee/task/viewAssignedTasks"
                              style="display: inline;">
                            <input type="hidden" name="statusFilter" value="${statusFilter}">
                            <input type="hidden" name="sortBy" value="${sortBy}">
                            <input type="hidden" name="fromDate" value="${fromDate}">
                            <input type="hidden" name="toDate" value="${toDate}">
                            <input type="hidden" name="pageSize" value="${pageSize}">
                            <input type="hidden" name="page" value="${currentPage + 1}">
                            <button type="submit" class="pagination-btn">Next ›</button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <button class="pagination-btn" disabled>Next ›</button>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const fromDate = document.getElementById('fromDate');
        const toDate = document.getElementById('toDate');
        const today = new Date().toISOString().split('T')[0];

        if (fromDate) fromDate.setAttribute('max', today);
        if (toDate) toDate.setAttribute('max', today);

        if (fromDate) {
            fromDate.addEventListener('change', function () {
                if (this.value && toDate) {
                    toDate.setAttribute('min', this.value);
                }
            });
        }

        if (toDate) {
            toDate.addEventListener('change', function () {
                if (this.value && fromDate) {
                    fromDate.setAttribute('max', this.value);
                }
            });
        }
    });
</script>
</body>
</html>
