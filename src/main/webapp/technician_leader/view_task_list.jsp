<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Task List</title>
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

        .task-container {
            max-width: 1600px;
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
            gap: 1rem;
        }

        .header-icon {
            width: 56px;
            height: 56px;
            background: linear-gradient(135deg, var(--primary), var(--primary-light));
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
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

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .stat-card {
            background: white;
            border-radius: 12px;
            box-shadow: var(--shadow);
            padding: 1.5rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            transition: all 0.3s;
        }

        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .stat-icon {
            width: 56px;
            height: 56px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
        }

        .stat-icon.total {
            background: linear-gradient(135deg, var(--gray-600), var(--gray-700));
        }

        .stat-icon.page {
            background: linear-gradient(135deg, var(--primary), var(--primary-light));
        }

        .stat-icon.near-due {
            background: linear-gradient(135deg, var(--warning), #d97706);
        }

        .stat-icon.overdue {
            background: linear-gradient(135deg, var(--danger), #dc2626);
        }

        .stat-content h3 {
            font-size: 2rem;
            font-weight: 700;
            color: var(--gray-900);
            margin: 0;
        }

        .stat-content p {
            font-size: 0.875rem;
            color: var(--gray-600);
            margin: 0;
            font-weight: 600;
        }

        /* Filter Card */
        .filter-card {
            background: white;
            border-radius: 12px;
            box-shadow: var(--shadow);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .filter-header {
            font-size: 1.125rem;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .filter-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 1rem;
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
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .form-control, .form-select {
            padding: 0.625rem 0.875rem;
            border: 2px solid var(--gray-200);
            border-radius: 8px;
            font-size: 0.9375rem;
            transition: all 0.2s;
            background: white;
            color: var(--gray-900);
        }

        .form-control:focus, .form-select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-top: 1.75rem;
        }

        .checkbox-group input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
        }

        .checkbox-group label {
            font-size: 0.875rem;
            font-weight: 600;
            color: var(--gray-700);
            cursor: pointer;
            margin: 0;
        }

        .form-actions {
            display: flex;
            gap: 0.75rem;
            padding-top: 1rem;
            border-top: 1px solid var(--gray-200);
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

        .btn-danger {
            background: var(--danger);
            color: white;
        }

        .btn-danger:hover {
            background: #dc2626;
        }

        .btn-outline-primary {
            background: white;
            color: var(--primary);
            border: 1px solid var(--primary);
        }

        .btn-outline-primary:hover {
            background: var(--primary);
            color: white;
        }

        .btn-outline-danger {
            background: white;
            color: var(--danger);
            border: 1px solid var(--danger);
        }

        .btn-outline-danger:hover {
            background: var(--danger);
            color: white;
        }

        .btn-sm {
            padding: 0.375rem 0.875rem;
            font-size: 0.8125rem;
        }

        /* Table Card */
        .table-card {
            background: white;
            border-radius: 12px;
            box-shadow: var(--shadow);
            overflow: hidden;
        }

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
            padding: 1rem;
            text-align: left;
            font-size: 0.875rem;
            font-weight: 700;
            color: var(--gray-700);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            border-bottom: 2px solid var(--gray-200);
        }

        td {
            padding: 1rem;
            border-bottom: 1px solid var(--gray-200);
            font-size: 0.9375rem;
        }

        tbody tr {
            transition: all 0.2s;
        }

        tbody tr:hover {
            background: var(--gray-50);
        }

        tbody tr.row-near-due {
            background: rgba(245, 158, 11, 0.1);
        }

        tbody tr.row-overdue {
            background: rgba(239, 68, 68, 0.1);
        }

        /* Badges */
        .badge {
            display: inline-flex;
            align-items: center;
            padding: 0.375rem 0.75rem;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.025em;
            gap: 0.25rem;
        }

        .badge-pending {
            background: rgba(107, 114, 128, 0.1);
            color: var(--gray-700);
        }

        .badge-processing {
            background: rgba(79, 70, 229, 0.1);
            color: var(--primary);
        }

        .badge-finished {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
        }

        .badge-reject {
            background: rgba(239, 68, 68, 0.1);
            color: var(--danger);
        }

        /* Pagination */
        .pagination-wrapper {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.5rem;
            border-top: 1px solid var(--gray-200);
            flex-wrap: wrap;
            gap: 1rem;
        }

        .pagination-controls {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .pagination-info {
            font-size: 0.875rem;
            color: var(--gray-600);
            font-weight: 600;
        }

        .pagination-buttons {
            display: flex;
            gap: 0.5rem;
        }

        .page-input-group {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .page-input-group input {
            width: 80px;
            text-align: center;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 3rem 1rem;
            color: var(--gray-500);
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: var(--gray-400);
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 0.5rem;
        }

        /* Modal */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 9999;
            align-items: center;
            justify-content: center;
        }

        .modal.show {
            display: flex;
        }

        .modal-content {
            background: white;
            border-radius: 12px;
            max-width: 500px;
            width: 90%;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        }

        .modal-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--gray-200);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-header.error {
            background: var(--danger);
            color: white;
            border-radius: 12px 12px 0 0;
        }

        .modal-title {
            font-size: 1.125rem;
            font-weight: 700;
            margin: 0;
        }

        .modal-close {
            background: none;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: inherit;
            padding: 0;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 6px;
            transition: all 0.2s;
        }

        .modal-close:hover {
            background: rgba(0, 0, 0, 0.1);
        }

        .modal-body {
            padding: 1.5rem;
        }

        .modal-footer {
            padding: 1rem 1.5rem;
            border-top: 1px solid var(--gray-200);
            display: flex;
            justify-content: flex-end;
            gap: 0.75rem;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .task-container {
                padding: 1rem 0.75rem;
            }

            .page-header {
                padding: 1.5rem;
            }

            .header-icon {
                width: 48px;
                height: 48px;
                font-size: 1.25rem;
            }

            .header-text h1 {
                font-size: 1.5rem;
            }

            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .filter-grid {
                grid-template-columns: 1fr;
            }

            .form-actions {
                flex-direction: column;
            }

            .form-actions .btn {
                width: 100%;
                justify-content: center;
            }

            .pagination-wrapper {
                flex-direction: column;
            }

            .table-wrapper {
                overflow-x: scroll;
            }

            table {
                min-width: 800px;
            }
        }
    </style>
</head>
<body>

<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>

<div class="task-container">
    <!-- Page Header -->
    <div class="page-header">
        <div class="header-content">
            <div class="header-icon">
                <i class="fas fa-tasks"></i>
            </div>
            <div class="header-text">
                <h1>Task Management</h1>
                <p>View and manage all assigned tasks</p>
            </div>
        </div>
    </div>

    <!-- Stats Grid -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon total">
                <i class="fas fa-list"></i>
            </div>
            <div class="stat-content">
                <h3>${dashboardTotalMatched}</h3>
                <p>Total Matched</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon page">
                <i class="fas fa-file-alt"></i>
            </div>
            <div class="stat-content">
                <h3>${dashboardPageCount}</h3>
                <p>On This Page</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon near-due">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            <div class="stat-content">
                <h3>${dashboardNearDueCount}</h3>
                <p>Near Due</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon overdue">
                <i class="fas fa-exclamation-circle"></i>
            </div>
            <div class="stat-content">
                <h3>${dashboardOverdueCount}</h3>
                <p>Overdue</p>
            </div>
        </div>
    </div>

    <!-- Filter Card -->
    <div class="filter-card">
        <h2 class="filter-header">
            <i class="fas fa-filter"></i>
            Filter & Sort Tasks
        </h2>
        <form method="get" action="${pageContext.request.contextPath}/technician_leader/tasks/list">
            <div class="filter-grid">
                <div class="form-group">
                    <label class="form-label">Sort Deadline</label>
                    <select name="sortDir" class="form-select">
                        <option value="asc" ${sortDir == 'asc' ? 'selected' : ''}>Ascending</option>
                        <option value="desc" ${sortDir == 'desc' ? 'selected' : ''}>Descending</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Status</label>
                    <select name="status" class="form-select">
                        <option value="">All Statuses</option>
                        <option value="Pending" ${status == 'Pending' ? 'selected' : ''}>Pending</option>
                        <option value="Processing" ${status == 'Processing' ? 'selected' : ''}>Processing</option>
                        <option value="Finished" ${status == 'Finished' ? 'selected' : ''}>Finished</option>
                        <option value="Reject" ${status == 'Reject' ? 'selected' : ''}>Reject</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Assigned To</label>
                    <input type="text" name="staffName" class="form-control" value="${staffName}"
                           placeholder="Search by staff name"/>
                </div>
                <div class="form-group">
                    <label class="form-label">Near Due (Days)</label>
                    <input type="number" name="nearDueDays" class="form-control"
                           value="${empty nearDueHours ? 1 : nearDueHours}" min="1" max="30" placeholder="Days"/>
                </div>
                <div class="form-group">
                    <div class="checkbox-group">
                        <input type="checkbox" id="nearDue" name="nearDue" ${nearDue ? 'checked' : ''} />
                        <label for="nearDue">Show Near Due</label>
                    </div>
                </div>
                <div class="form-group">
                    <div class="checkbox-group">
                        <input type="checkbox" id="overdue" name="overdue" ${overdue ? 'checked' : ''} />
                        <label for="overdue">Show Overdue</label>
                    </div>
                </div>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-search"></i> Apply Filters
                </button>
                <a href="${pageContext.request.contextPath}/technician_leader/tasks/list" class="btn btn-secondary">
                    <i class="fas fa-redo"></i> Reset
                </a>
            </div>
        </form>
    </div>

    <!-- Task Table -->
    <div class="table-card">
        <div class="table-wrapper">
            <table>
                <thead>
                <tr>
                    <th style="width: 60px;">No</th>
                    <th>Request ID</th>
                    <th>Assigned To</th>
                    <th>Status</th>
                    <th>Start Date</th>
                    <th>Deadline</th>
                    <th style="width: 200px;">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty tasks}">
                        <c:forEach items="${tasks}" var="task" varStatus="status">
                            <c:set var="isNearDue" value="${nearDueMap[task.taskID]}"/>
                            <c:set var="isOverdue" value="${overdueMap[task.taskID]}"/>
                            <tr class="${isOverdue ? 'row-overdue' : (isNearDue ? 'row-near-due' : '')}">
                                <td>${status.index + 1 + (currentPage - 1) * recordsPerPage}</td>
                                <td>
                                    <strong><a
                                            href="${pageContext.request.contextPath}/technician_leader/requests/detail?requestId=9">#<c:out
                                            value="${task.request != null ? task.request.requestID : '-'}"/></a></strong>
                                </td>
                                <td>
                                    <i class="fas fa-user" style="color: var(--primary); margin-right: 0.375rem;"></i>
                                    <c:out value="${task.assignTo != null ? task.assignTo.staffName : '-'}"/>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test='${task.status == "Pending"}'>
                                                <span class="badge badge-pending">
                                                    <i class="fas fa-clock"></i> Pending
                                                </span>
                                        </c:when>
                                        <c:when test='${task.status == "Processing"}'>
                                                <span class="badge badge-processing">
                                                    <i class="fas fa-spinner"></i> Processing
                                                </span>
                                        </c:when>
                                        <c:when test='${task.status == "Finished"}'>
                                                <span class="badge badge-finished">
                                                    <i class="fas fa-check-circle"></i> Finished
                                                </span>
                                        </c:when>
                                        <c:when test='${task.status == "Reject"}'>
                                                <span class="badge badge-reject">
                                                    <i class="fas fa-times-circle"></i> Reject
                                                </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge">${task.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty task.startDate}">
                                            <i class="fas fa-calendar"
                                               style="color: var(--gray-500); margin-right: 0.375rem;"></i>
                                            ${task.startDate}
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty task.deadline}">
                                            <i class="fas fa-calendar-check"
                                               style="color: var(--gray-500); margin-right: 0.375rem;"></i>
                                            ${task.deadline}
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="${pageContext.request.contextPath}/staff/task/detail?taskId=${task.taskID}"
                                           class="btn btn-sm btn-outline-primary">
                                            <i class="fas fa-eye"></i> View
                                        </a>
                                        <c:if test='${task.status == "Pending" || task.status == "Processing"}'>
                                            <button type="button" class="btn btn-sm btn-outline-danger btn-delete-task"
                                                    data-task-id="${task.taskID}">
                                                <i class="fas fa-trash"></i> Deactive
                                            </button>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="7">
                                <div class="empty-state">
                                    <i class="fas fa-inbox"></i>
                                    <p>No tasks found. Try adjusting your filters.</p>
                                </div>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div class="pagination-wrapper">
            <div class="pagination-info">
                <i class="fas fa-list"></i> Page ${currentPage} of ${totalPages} (${dashboardTotalMatched} total)
            </div>

            <div class="pagination-controls">
                <!-- Items per page -->
                <form method="get" class="page-input-group">
                    <input type="hidden" name="sortDir" value="${param.sortDir}">
                    <input type="hidden" name="status" value="${param.status}">
                    <input type="hidden" name="staffName" value="${param.staffName}">
                    <input type="hidden" name="nearDue" value="${param.nearDue}">
                    <input type="hidden" name="nearDueDays" value="${param.nearDueDays}">
                    <input type="hidden" name="overdue" value="${param.overdue}">
                    <input type="hidden" name="page" value="${currentPage}">

                    <label style="font-size: 0.875rem; color: var(--gray-600);">Show:</label>
                    <c:set var="computedRpp"
                           value="${empty totalRecords or totalRecords <= 0 ? 1 : (recordsPerPage > totalRecords ? totalRecords : recordsPerPage)}"/>
                    <c:set var="computedMax" value="${empty totalRecords or totalRecords <= 0 ? 1 : totalRecords}"/>
                    <input type="number" name="recordsPerPage" class="form-control" value="${computedRpp}" min="1"
                           max="${computedMax}"/>
                    <button type="submit" class="btn btn-primary btn-sm">Set</button>
                </form>

                <!-- Page navigation -->
                <div class="pagination-buttons">
                    <c:if test="${currentPage > 1}">
                        <form method="get" style="display: inline;">
                            <input type="hidden" name="sortDir" value="${param.sortDir}">
                            <input type="hidden" name="status" value="${param.status}">
                            <input type="hidden" name="staffName" value="${param.staffName}">
                            <input type="hidden" name="nearDue" value="${param.nearDue}">
                            <input type="hidden" name="nearDueDays" value="${param.nearDueDays}">
                            <input type="hidden" name="overdue" value="${param.overdue}">
                            <input type="hidden" name="recordsPerPage" value="${computedRpp}">
                            <button type="submit" name="page" value="${currentPage - 1}"
                                    class="btn btn-secondary btn-sm">
                                <i class="fas fa-chevron-left"></i> Previous
                            </button>
                        </form>
                    </c:if>
                    <c:if test="${currentPage < totalPages}">
                        <form method="get" style="display: inline;">
                            <input type="hidden" name="sortDir" value="${param.sortDir}">
                            <input type="hidden" name="status" value="${param.status}">
                            <input type="hidden" name="staffName" value="${param.staffName}">
                            <input type="hidden" name="nearDue" value="${param.nearDue}">
                            <input type="hidden" name="nearDueDays" value="${param.nearDueDays}">
                            <input type="hidden" name="overdue" value="${param.overdue}">
                            <input type="hidden" name="recordsPerPage" value="${computedRpp}">
                            <button type="submit" name="page" value="${currentPage + 1}"
                                    class="btn btn-secondary btn-sm">
                                Next <i class="fas fa-chevron-right"></i>
                            </button>
                        </form>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Error Modal -->
<div class="modal" id="errorModal">
    <div class="modal-content">
        <div class="modal-header error">
            <h3 class="modal-title">Delete Failed</h3>
            <button type="button" class="modal-close" onclick="closeModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="modal-body" id="errorModalBody"></div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" onclick="closeModal()">Close</button>
        </div>
    </div>
</div>

<script>
    function closeModal() {
        document.getElementById('errorModal').classList.remove('show');
    }

    document.addEventListener('DOMContentLoaded', function () {
        const deleteButtons = document.querySelectorAll('.btn-delete-task');
        const modal = document.getElementById('errorModal');
        const modalBody = document.getElementById('errorModalBody');

        deleteButtons.forEach(btn => {
            btn.addEventListener('click', async function () {
                if (!confirm('Are you sure you want to delete this task?')) return;
                const taskId = this.dataset.taskId;

                try {
                    const response = await fetch('${pageContext.request.contextPath}/api/technician_leader/tasks/delete', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/json'},
                        body: JSON.stringify({taskId})
                    });
                    const data = await response.json();

                    if (response.ok && data.success) {
                        window.location.reload();
                    } else {
                        modalBody.textContent = data.message || data.error || 'Delete failed.';
                        modal.classList.add('show');
                    }
                } catch (err) {
                    modalBody.textContent = 'Server not responding.';
                    modal.classList.add('show');
                }
            });
        });

        // Close modal on background click
        modal.addEventListener('click', function (e) {
            if (e.target === modal) {
                closeModal();
            }
        });
    });
</script>

</body>
</html>