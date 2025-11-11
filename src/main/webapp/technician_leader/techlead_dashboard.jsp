<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tech Lead Dashboard</title>
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
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; background: var(--gray-50); color: var(--gray-900); line-height: 1.6; }
        .container { max-width: 1400px; margin: 0 auto; padding: 2rem 1rem; }
        .page-header { background: white; padding: 2rem; border-radius: 12px; box-shadow: var(--shadow); margin-bottom: 1.5rem; }
        .header-content { display: flex; align-items: center; justify-content: space-between; gap: 1rem; flex-wrap: wrap; }
        .header-left { display: flex; align-items: center; gap: 1rem; }
        .header-icon { width: 56px; height: 56px; background: linear-gradient(135deg, var(--primary), var(--primary-light)); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: white; font-size: 1.5rem; flex-shrink: 0; }
        .header-text h1 { font-size: 1.75rem; font-weight: 700; margin: 0 0 0.25rem 0; }
        .header-text p { font-size: 0.9375rem; color: var(--gray-600); margin: 0; }
        .quick-actions { display: flex; gap: .75rem; flex-wrap: wrap; }
        .btn { padding: 0.625rem 1.25rem; border-radius: 8px; font-weight: 600; font-size: 0.875rem; border: none; cursor: pointer; transition: all 0.2s; display: inline-flex; align-items: center; gap: 0.5rem; text-decoration: none; }
        .btn-primary { background: var(--primary); color: white; }
        .btn-primary:hover { background: var(--primary-dark); }
        .btn-outline { background: white; color: var(--primary); border: 1px solid var(--primary); }
        .btn-outline:hover { background: var(--primary); color: white; }
        .btn-success { background: var(--success); color: white; }
        .btn-success:hover { background: #059669; }
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 1.5rem; }
        .card { background: white; border-radius: 12px; box-shadow: var(--shadow); padding: 1.5rem; }
        .card-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 1rem; }
        .card-title { font-size: 1.125rem; font-weight: 700; display: flex; align-items: center; gap: .5rem; }
        .stat-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 1rem; }
        .stat { background: var(--gray-50); border: 1px solid var(--gray-200); border-radius: 10px; padding: 1rem; display: flex; align-items: center; gap: .75rem; }
        .stat .icon { width: 44px; height: 44px; border-radius: 10px; display:flex; align-items:center; justify-content:center; color:white; font-size:1.1rem; }
        .icon-total { background: linear-gradient(135deg, var(--gray-600), var(--gray-700)); }
        .icon-page { background: linear-gradient(135deg, var(--primary), var(--primary-light)); }
        .icon-near { background: linear-gradient(135deg, var(--warning), #d97706); }
        .icon-over { background: linear-gradient(135deg, var(--danger), #dc2626); }
        .icon-req { background: linear-gradient(135deg, var(--success), #059669); }
        .stat-content { display:flex; flex-direction:column; }
        .stat-number { font-size: 1.5rem; font-weight: 700; }
        .stat-label { font-size: .8125rem; color: var(--gray-600); font-weight: 600; }
        .card-actions { display:flex; gap:.5rem; flex-wrap: wrap; margin-top: 1rem; }
        @media (max-width: 768px) {
            .container { padding: 1rem .75rem; }
            .grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>

<div class="container">
    <!-- Header -->
    <div class="page-header">
        <div class="header-content">
            <div class="header-left">
                <div class="header-icon"><i class="fas fa-gauge-high"></i></div>
                <div class="header-text">
                    <h1>Tech Lead Dashboard</h1>
                    <p>Overview of tasks and approved requests, plus quick navigation</p>
                </div>
            </div>
            <div class="quick-actions">
                <a href="${pageContext.request.contextPath}/technician_leader/employees" class="btn btn-outline">
                    <i class="fas fa-user-gear"></i> View Technician List
                </a>
                <a href="${pageContext.request.contextPath}/technician_leader/request/viewAprovedTask" class="btn btn-success">
                    <i class="fas fa-clipboard-check"></i> View Approved Requests
                </a>
                <a href="${pageContext.request.contextPath}/technician_leader/tasks/list" class="btn btn-primary">
                    <i class="fas fa-list-check"></i> View Task List
                </a>
            </div>
        </div>
    </div>

    <!-- Mini dashboards -->
    <div class="grid">
        <!-- Task mini dashboard -->
        <div class="card">
            <div class="card-header">
                <div class="card-title"><i class="fas fa-tasks"></i> Tasks Summary</div>
            </div>
            <div class="stat-grid">
                <div class="stat">
                    <div class="icon icon-total"><i class="fas fa-list"></i></div>
                    <div class="stat-content">
                        <div class="stat-number">${taskTotal}</div>
                        <div class="stat-label">Total Matched</div>
                    </div>
                </div>
                <div class="stat">
                    <div class="icon icon-page"><i class="fas fa-file-alt"></i></div>
                    <div class="stat-content">
                        <div class="stat-number">${taskOnPage}</div>
                        <div class="stat-label">On Last Page</div>
                    </div>
                </div>
                <div class="stat">
                    <div class="icon icon-near"><i class="fas fa-exclamation-triangle"></i></div>
                    <div class="stat-content">
                        <div class="stat-number">${taskNearDue}</div>
                        <div class="stat-label">Near Due</div>
                    </div>
                </div>
                <div class="stat">
                    <div class="icon icon-over"><i class="fas fa-exclamation-circle"></i></div>
                    <div class="stat-content">
                        <div class="stat-number">${taskOverdue}</div>
                        <div class="stat-label">Overdue</div>
                    </div>
                </div>
            </div>
            <div class="card-actions">
                <a href="${pageContext.request.contextPath}/technician_leader/tasks/list" class="btn btn-primary"><i class="fas fa-arrow-right"></i> Go to Task List</a>
            </div>
        </div>

        <!-- Approved request mini dashboard -->
        <div class="card">
            <div class="card-header">
                <div class="card-title"><i class="fas fa-clipboard-check"></i> Approved Requests Summary</div>
            </div>
            <div class="stat-grid">
                <div class="stat">
                    <div class="icon icon-req"><i class="fas fa-tasks"></i></div>
                    <div class="stat-content">
                        <div class="stat-number">${requestTotal}</div>
                        <div class="stat-label">Total Approved</div>
                    </div>
                </div>
                <div class="stat">
                    <div class="icon icon-page"><i class="fas fa-user-plus"></i></div>
                    <div class="stat-content">
                        <div class="stat-number">${requestPendingAssign}</div>
                        <div class="stat-label">Pending Assignment</div>
                    </div>
                </div>
                <div class="stat">
                    <div class="icon icon-total"><i class="fas fa-user-check"></i></div>
                    <div class="stat-content">
                        <div class="stat-number">${requestAssigned}</div>
                        <div class="stat-label">Assigned</div>
                    </div>
                </div>
            </div>
            <div class="card-actions">
                <a href="${pageContext.request.contextPath}/technician_leader/request/viewAprovedTask" class="btn btn-success"><i class="fas fa-arrow-right"></i> Go to Approved Requests</a>
            </div>
        </div>
    </div>
</div>

</body>
</html>
