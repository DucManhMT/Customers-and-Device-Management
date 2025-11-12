<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    request.setAttribute("dateFormatter", dateFormatter);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Technician Dashboard - Action Center</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #4F46E5;
            --primary-dark: #4338CA;
            --success: #10B981;
            --success-dark: #059669;
            --warning: #F59E0B;
            --warning-dark: #D97706;
            --danger: #EF4444;
            --danger-dark: #DC2626;
            --info: #3B82F6;
            --info-dark: #2563EB;
            --gray-50: #F9FAFB;
            --gray-100: #F3F4F6;
            --gray-200: #E5E7EB;
            --gray-300: #D1D5DB;
            --gray-400: #9CA3AF;
            --gray-500: #6B7280;
            --gray-600: #4B5563;
            --gray-700: #374151;
            --gray-800: #1F2937;
            --gray-900: #111827;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background-color: var(--gray-50);
            color: var(--gray-900);
            line-height: 1.6;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem;
        }

        /* Page Header */
        .page-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .page-header-icon {
            width: 64px;
            height: 64px;
            background: linear-gradient(135deg, var(--primary), var(--info));
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 28px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .page-header-content h1 {
            font-size: 2rem;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 0.25rem;
        }

        .page-header-content p {
            color: var(--gray-500);
            font-size: 1rem;
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            border: 1px solid var(--gray-200);
        }

        .stat-card:hover {
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            transform: translateY(-2px);
        }

        .stat-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .stat-card-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
        }

        .stat-card-icon.primary {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
        }

        .stat-card-icon.success {
            background: linear-gradient(135deg, var(--success), var(--success-dark));
        }

        .stat-card-icon.warning {
            background: linear-gradient(135deg, var(--warning), var(--warning-dark));
        }

        .stat-card-icon.danger {
            background: linear-gradient(135deg, var(--danger), var(--danger-dark));
        }

        .stat-card-icon.info {
            background: linear-gradient(135deg, var(--info), var(--info-dark));
        }

        .stat-card-value {
            font-size: 2.25rem;
            font-weight: 700;
            color: var(--gray-900);
            line-height: 1;
        }

        .stat-card-label {
            color: var(--gray-500);
            font-size: 0.875rem;
            font-weight: 500;
            margin-top: 0.5rem;
        }

        /* Quick Actions */
        .section {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid var(--gray-200);
            margin-bottom: 2rem;
        }

        .section-header {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid var(--gray-100);
        }

        .section-header i {
            color: var(--primary);
            font-size: 1.5rem;
        }

        .section-header h2 {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--gray-900);
        }

        .quick-actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
        }

        .action-button {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1.25rem;
            background: var(--gray-50);
            border: 2px solid var(--gray-200);
            border-radius: 10px;
            text-decoration: none;
            color: var(--gray-700);
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .action-button:hover {
            background: var(--primary);
            border-color: var(--primary);
            color: white;
            transform: translateX(4px);
        }

        .action-button i {
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: white;
            border-radius: 8px;
            font-size: 1.25rem;
            transition: all 0.3s ease;
        }

        .action-button:hover i {
            background: rgba(255, 255, 255, 0.2);
            color: white;
        }

        /* Recent Tasks */
        .tasks-list {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .task-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1rem;
            background: var(--gray-50);
            border: 1px solid var(--gray-200);
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .task-item:hover {
            background: var(--gray-100);
            border-color: var(--primary);
        }

        .task-info {
            flex: 1;
        }

        .task-title {
            font-weight: 600;
            color: var(--gray-900);
            margin-bottom: 0.25rem;
        }

        .task-meta {
            display: flex;
            align-items: center;
            gap: 1rem;
            font-size: 0.875rem;
            color: var(--gray-500);
        }

        .task-meta i {
            width: 16px;
        }

        .task-status {
            padding: 0.375rem 0.75rem;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .task-status.processing {
            background: #DBEAFE;
            color: var(--info);
        }

        .task-status.near-due {
            background: #FEF3C7;
            color: var(--warning-dark);
        }

        .task-status.overdue {
            background: #FEE2E2;
            color: var(--danger);
        }

        .task-actions {
            display: flex;
            gap: 0.5rem;
            margin-left: 1rem;
        }

        .btn {
            padding: 0.5rem 1rem;
            border-radius: 6px;
            border: none;
            font-size: 0.875rem;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background: var(--primary-dark);
        }

        .btn-outline {
            background: transparent;
            border: 1px solid var(--gray-300);
            color: var(--gray-700);
        }

        .btn-outline:hover {
            background: var(--gray-100);
            border-color: var(--gray-400);
        }

        .empty-state {
            text-align: center;
            padding: 3rem 1rem;
            color: var(--gray-400);
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .empty-state p {
            font-size: 1.125rem;
            margin-bottom: 0.5rem;
        }

        .empty-state small {
            font-size: 0.875rem;
        }

        /* Alert */
        .alert {
            padding: 1rem 1.5rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .alert i {
            font-size: 1.25rem;
        }

        .alert-danger {
            background: #FEE2E2;
            color: var(--danger-dark);
            border: 1px solid #FCA5A5;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }

            .page-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .quick-actions-grid {
                grid-template-columns: 1fr;
            }

            .task-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }

            .task-actions {
                margin-left: 0;
                width: 100%;
            }

            .task-actions .btn {
                flex: 1;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="../components/header.jsp"/>
    <jsp:include page="../components/sidebar.jsp"/>

    <div class="container">
        <!-- Error Message -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <div>${errorMessage}</div>
            </div>
        </c:if>

        <!-- Page Header -->
        <div class="page-header">
            <div class="page-header-icon">
                <i class="fas fa-tachometer-alt"></i>
            </div>
            <div class="page-header-content">
                <h1>Technician Dashboard</h1>
                <p>Welcome back! Here's an overview of your tasks and activities</p>
            </div>
        </div>

        <!-- Statistics Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-card-header">
                    <div class="stat-card-icon primary">
                        <i class="fas fa-tasks"></i>
                    </div>
                </div>
                <div class="stat-card-value">${totalTasks}</div>
                <div class="stat-card-label">Total Tasks</div>
            </div>

            <div class="stat-card">
                <div class="stat-card-header">
                    <div class="stat-card-icon info">
                        <i class="fas fa-spinner"></i>
                    </div>
                </div>
                <div class="stat-card-value">${processingTasks}</div>
                <div class="stat-card-label">In Progress</div>
            </div>

            <div class="stat-card">
                <div class="stat-card-header">
                    <div class="stat-card-icon success">
                        <i class="fas fa-check-circle"></i>
                    </div>
                </div>
                <div class="stat-card-value">${finishedTasks}</div>
                <div class="stat-card-label">Completed</div>
            </div>

            <div class="stat-card">
                <div class="stat-card-header">
                    <div class="stat-card-icon warning">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                </div>
                <div class="stat-card-value">${nearDueTasks}</div>
                <div class="stat-card-label">Near Due (3 days)</div>
            </div>

            <div class="stat-card">
                <div class="stat-card-header">
                    <div class="stat-card-icon danger">
                        <i class="fas fa-exclamation-circle"></i>
                    </div>
                </div>
                <div class="stat-card-value">${overdueTasks}</div>
                <div class="stat-card-label">Overdue</div>
            </div>

            <div class="stat-card">
                <div class="stat-card-header">
                    <div class="stat-card-icon primary">
                        <i class="fas fa-calendar-day"></i>
                    </div>
                </div>
                <div class="stat-card-value">${todayTasks}</div>
                <div class="stat-card-label">Due Today</div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="section">
            <div class="section-header">
                <i class="fas fa-bolt"></i>
                <h2>Quick Actions</h2>
            </div>
            <div class="quick-actions-grid">
                <a href="${pageContext.request.contextPath}/technician_employee/task/viewAssignedTasks" class="action-button">
                    <i class="fas fa-list"></i>
                    <span>View All Tasks</span>
                </a>
                <a href="${pageContext.request.contextPath}/technician_employee/task/viewReceivedAssignments" class="action-button">
                    <i class="fas fa-inbox"></i>
                    <span>View Assignments</span>
                </a>
                <a href="${pageContext.request.contextPath}/technician_employee/product-request/list" class="action-button">
                    <i class="fas fa-box"></i>
                    <span>Product Requests</span>
                </a>
                <a href="${pageContext.request.contextPath}/technician_employee/task/viewAssignedTasks?statusFilter=processing" class="action-button">
                    <i class="fas fa-spinner"></i>
                    <span>Active Tasks</span>
                </a>
            </div>
        </div>

        <!-- Recent Tasks -->
        <div class="section">
            <div class="section-header">
                <i class="fas fa-clock"></i>
                <h2>Recent Active Tasks</h2>
            </div>
            
            <c:choose>
                <c:when test="${empty recentTasks}">
                    <div class="empty-state">
                        <i class="fas fa-clipboard-list"></i>
                        <p>No active tasks at the moment</p>
                        <small>Your processing tasks will appear here</small>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="tasks-list">
                        <c:forEach var="task" items="${recentTasks}">
                            <div class="task-item">
                                <div class="task-info">
                                    <div class="task-title">
                                        Task #${task.taskID} - Request #${task.request.requestID}
                                    </div>
                                    <div class="task-meta">
                                        <span><i class="fas fa-calendar"></i> 
                                            ${task.startDate.toLocalDate().format(dateFormatter)}
                                        </span>
                                        <c:if test="${not empty task.deadline}">
                                            <span><i class="fas fa-flag-checkered"></i> 
                                                Due: ${task.deadline.toLocalDate().format(dateFormatter)}
                                            </span>
                                        </c:if>
                                    </div>
                                </div>
                                
                                <c:choose>
                                    <c:when test="${not empty task.deadline}">
                                        <c:set var="today" value="<%= java.time.LocalDate.now() %>"/>
                                        <c:set var="deadlineDate" value="${task.deadline.toLocalDate()}"/>
                                        <c:set var="daysDiff" value="${java.time.temporal.ChronoUnit.DAYS.between(today, deadlineDate)}"/>
                                        
                                        <c:choose>
                                            <c:when test="${daysDiff < 0}">
                                                <span class="task-status overdue">Overdue</span>
                                            </c:when>
                                            <c:when test="${daysDiff <= 3}">
                                                <span class="task-status near-due">Near Due</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="task-status processing">Processing</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="task-status processing">Processing</span>
                                    </c:otherwise>
                                </c:choose>
                                
                                <div class="task-actions">
                                    <a href="${pageContext.request.contextPath}/technician_employee/request/detail?id=${task.request.requestID}" 
                                       class="btn btn-primary">
                                        <i class="fas fa-eye"></i>
                                        View Details
                                    </a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <div style="text-align: center; margin-top: 1.5rem;">
                        <a href="${pageContext.request.contextPath}/technician_employee/task/viewAssignedTasks" 
                           class="btn btn-outline">
                            <i class="fas fa-arrow-right"></i>
                            View All Tasks
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
