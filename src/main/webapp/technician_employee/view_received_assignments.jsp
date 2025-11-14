<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Received Assignments</title>
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
            --shadow-lg: 0 10px 15px rgba(0, 0, 0, 0.1);
        }

        /* Alert Messages */
        .alert {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-size: 0.9375rem;
            font-weight: 500;
            animation: slideInDown 0.4s ease-out;
        }

        .alert i {
            font-size: 1.25rem;
            flex-shrink: 0;
        }

        .alert-success {
            background: rgba(16, 185, 129, 0.1);
            color: #065f46;
            border: 1px solid rgba(16, 185, 129, 0.3);
        }

        .alert-danger {
            background: rgba(239, 68, 68, 0.1) !important;
            color: #7f1d1d !important;
            border: 1px solid rgba(239, 68, 68, 0.3) !important;
        }

        .alert-danger i {
            color: #ef4444 !important;
        }

        @keyframes slideInDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
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
        .assignments-container {
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
            flex-shrink: 0;
        }

        .header-text h1 {
            font-size: 1.875rem;
            font-weight: 700;
            color: var(--gray-900);
            margin: 0 0 0.25rem 0;
        }

        .header-text p {
            font-size: 0.9375rem;
            color: var(--gray-600);
            margin: 0;
        }

        /* Stats Bar */
        .stats-bar {
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: var(--shadow);
            margin-bottom: 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 1.5rem;
            flex-wrap: wrap;
        }

        .stat-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .stat-icon {
            width: 48px;
            height: 48px;
            background: linear-gradient(135deg, var(--primary), var(--primary-light));
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.25rem;
        }

        .stat-content {
            display: flex;
            flex-direction: column;
        }

        .stat-label {
            font-size: 0.75rem;
            color: var(--gray-600);
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .stat-value {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--gray-900);
        }

        /* Filter Section */
        .filter-section {
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
        }

        .filter-input {
            padding: 0.625rem 0.875rem;
            border: 1px solid var(--gray-300);
            border-radius: 8px;
            font-size: 0.875rem;
            transition: all 0.2s;
            background: white;
            color: var(--gray-900);
        }

        .filter-input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
        }

        .filter-input::placeholder {
            color: var(--gray-400);
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
            color: var(--gray-700);
            border: 1px solid var(--gray-300);
        }

        .btn-outline:hover {
            background: var(--gray-50);
        }

        /* Assignment Cards */
        .assignments-list {
            display: flex;
            flex-direction: column;
            gap: 1.25rem;
        }

        .assignment-card {
            background: white;
            border-radius: 12px;
            box-shadow: var(--shadow);
            padding: 1.5rem;
            transition: all 0.3s;
            border-left: 4px solid var(--warning);
        }

        .assignment-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .assignment-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 1rem;
            margin-bottom: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--gray-200);
        }

        .assignment-info {
            flex: 1;
        }

        .assignment-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--gray-900);
            margin: 0 0 0.5rem 0;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .assignment-title i {
            color: var(--primary);
            font-size: 1.125rem;
        }

        .assignment-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            font-size: 0.875rem;
            color: var(--gray-600);
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 0.375rem;
        }

        .meta-item i {
            color: var(--primary);
        }

        .meta-item strong {
            color: var(--gray-900);
            font-weight: 600;
        }

        .deadline-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.375rem;
            padding: 0.375rem 0.75rem;
            background: rgba(245, 158, 11, 0.1);
            color: var(--warning);
            border-radius: 6px;
            font-size: 0.8125rem;
            font-weight: 600;
        }

        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 6px;
            font-size: 0.8125rem;
            font-weight: 600;
            text-transform: uppercase;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            white-space: nowrap;
            background: rgba(245, 158, 11, 0.1);
            color: var(--warning);
        }

        .assignment-note {
            background: var(--gray-50);
            border-left: 3px solid var(--primary);
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
        }

        .assignment-note strong {
            color: var(--gray-900);
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.25rem;
        }

        .assignment-note strong i {
            color: var(--primary);
        }

        .assignment-note p {
            margin: 0;
            color: var(--gray-700);
            line-height: 1.6;
        }

        .assignment-actions {
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
            padding-top: 1rem;
            border-top: 1px solid var(--gray-200);
        }

        .assignment-actions .btn {
            flex: 1;
            min-width: 140px;
            justify-content: center;
        }

        /* Empty State */
        .empty-state {
            background: white;
            border-radius: 12px;
            box-shadow: var(--shadow);
            padding: 4rem 2rem;
            text-align: center;
        }

        .empty-icon {
            width: 80px;
            height: 80px;
            background: var(--gray-100);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
        }

        .empty-icon i {
            font-size: 2.5rem;
            color: var(--gray-400);
        }

        .empty-state h3 {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 0.5rem;
        }

        .empty-state p {
            font-size: 1rem;
            color: var(--gray-600);
            margin-bottom: 1.5rem;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .stats-bar {
                flex-direction: column;
                align-items: stretch;
            }

            .filter-section {
                width: 100%;
            }

            .filter-input {
                flex: 1;
                min-width: 0;
            }
        }

        @media (max-width: 768px) {
            .assignments-container {
                padding: 1rem 0.75rem;
            }

            .page-header {
                padding: 1.5rem;
            }

            .header-content {
                flex-direction: column;
                text-align: center;
            }

            .header-icon {
                width: 48px;
                height: 48px;
                font-size: 1.25rem;
            }

            .header-text h1 {
                font-size: 1.5rem;
            }

            .stats-bar {
                padding: 1rem;
            }

            .stat-item {
                width: 100%;
            }

            .filter-section {
                flex-direction: column;
            }

            .filter-input {
                width: 100%;
            }

            .assignment-header {
                flex-direction: column;
            }

            .assignment-meta {
                flex-direction: column;
                gap: 0.5rem;
            }

            .assignment-actions {
                flex-direction: column;
            }

            .assignment-actions .btn {
                width: 100%;
            }

        }
    </style>
</head>
<body>

<jsp:include page="../components/header.jsp" />
<jsp:include page="../components/sidebar.jsp"/>

<div class="assignments-container">
    <!-- Page Header -->
    <div class="page-header">
        <div class="header-content">
            <div class="header-icon">
                <i class="fas fa-inbox"></i>
            </div>
            <div class="header-text">
                <h1>Received Assignments</h1>
                <p>Review and manage approved tasks assigned to you by your team leader</p>
            </div>
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
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-circle"></i>
            <span>${errorMessage}</span>
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <div class="stats-bar">
                <div class="stat-item">
                    <div class="stat-icon">
                        <i class="fas fa-clipboard-list"></i>
                    </div>
                    <div class="stat-content">
                        <div class="stat-label">Total Assignments</div>
                        <div class="stat-value">${pendingTasks.size()}</div>
                    </div>
                </div>

                <!-- Filter Section -->
                <form method="get"
                      action="${pageContext.request.contextPath}/technician_employee/task/viewReceivedAssignments"
                      class="filter-section">
                    <input type="text" name="customerFilter" class="filter-input" placeholder="Customer name"
                           value="${param.customerFilter != null ? param.customerFilter : ''}"
                           style="width: 180px;">
                    <input type="text" name="phoneFilter" class="filter-input" placeholder="Phone number"
                           value="${param.phoneFilter != null ? param.phoneFilter : ''}"
                           style="width: 150px;">
                    <input type="date" name="fromDate" class="filter-input"
                           value="${param.fromDate != null ? param.fromDate : ''}"
                           style="width: 140px;">
                    <input type="date" name="toDate" class="filter-input"
                           value="${param.toDate != null ? param.toDate : ''}"
                           style="width: 140px;">
                    <select name="sort" class="filter-input" style="width: 140px;">
                        <option value="time_desc" ${param.sort == null || param.sort == 'time_desc' ? 'selected' : ''}>
                            Newest first
                        </option>
                        <option value="time_asc" ${param.sort == 'time_asc' ? 'selected' : ''}>Oldest first</option>
                    </select>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-filter"></i> Filter
                    </button>
                    <a href="${pageContext.request.contextPath}/technician_employee/task/viewReceivedAssignments"
                       class="btn btn-secondary">
                        <i class="fas fa-times"></i> Reset
                    </a>
                </form>
            </div>

    <c:choose>
        <c:when test="${empty pendingTasks}">
            <!-- Empty State -->
            <div class="empty-state">
                <div class="empty-icon">
                    <i class="fas fa-inbox"></i>
                </div>
                <h3>No Pending Assignments</h3>
                <p>You have no approved assignments waiting for your decision at the moment.</p>
                <a href="${pageContext.request.contextPath}/technician_employee/task/viewAssignedTasks"
                   class="btn btn-primary">
                    <i class="fas fa-tasks"></i>
                    View My Tasks
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <!-- Stats Bar -->
            

            <!-- Assignments List -->
            <div class="assignments-list">
                <c:forEach var="task" items="${pendingTasks}">
                    <div class="assignment-card">
                        <div class="assignment-header">
                            <div class="assignment-info">
                                <h3 class="assignment-title">
                                    <i class="fas fa-tasks"></i>
                                    ${not empty task.description ? task.description : (task.request.requestDescription != null ? task.request.requestDescription : 'Service Request')}
                                </h3>
                                <div class="assignment-meta">
                                    <div class="meta-item">
                                        <i class="fas fa-hashtag"></i>
                                        Task: <strong>#${task.taskID}</strong>
                                    </div>
                                    <div class="meta-item">
                                        <i class="fas fa-file-alt"></i>
                                        Request: <strong>#${task.request.requestID}</strong>
                                    </div>
                                    <c:if test="${not empty task.deadline}">
                                        <div class="deadline-badge">
                                            <i class="fas fa-calendar-alt"></i>
                                            Deadline: ${task.deadline}
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                            <span class="status-badge">
                                <i class="fas fa-clock"></i>
                                ${task.status}
                            </span>
                        </div>

                        <c:if test="${not empty task.request.note}">
                            <div class="assignment-note">
                                <strong>
                                    <i class="fas fa-sticky-note"></i>
                                    Request Note:
                                </strong>
                                <p>${task.request.note}</p>
                            </div>
                        </c:if>

                        <div class="assignment-actions">
                            <a class="btn btn-success"
                               href="${pageContext.request.contextPath}/technician_employee/task/assignmentDecision?taskId=${task.taskID}&amp;action=accept">
                                <i class="fas fa-check-circle"></i>
                                Review & Accept
                            </a>
                            <a class="btn btn-outline"
                               href="${pageContext.request.contextPath}/technician_employee/task/viewAssignedTasks">
                                <i class="fas fa-arrow-left"></i>
                                Back to My Tasks
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>
