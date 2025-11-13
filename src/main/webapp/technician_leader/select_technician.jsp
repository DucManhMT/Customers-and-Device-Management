<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Select Technician - Assign Tasks</title>
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

        .select-container {
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

        /* Two Column Layout */
        .layout-grid {
            display: grid;
            grid-template-columns: 350px 1fr;
            gap: 1.5rem;
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

        .form-group {
            margin-bottom: 1rem;
        }

        .form-label {
            font-size: 0.875rem;
            font-weight: 600;
            color: var(--gray-700);
            margin-bottom: 0.5rem;
            display: block;
        }

        .form-control {
            width: 100%;
            padding: 0.625rem 0.875rem;
            border: 1px solid var(--gray-300);
            border-radius: 8px;
            font-size: 0.9375rem;
            transition: all 0.2s;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
        }

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
            justify-content: center;
            gap: 0.5rem;
            text-decoration: none;
            width: 100%;
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

        .btn-sm {
            padding: 0.5rem 1rem;
            font-size: 0.8125rem;
            width: auto;
        }

        /* Selected Tasks Sidebar */
        .sidebar-card {
            background: white;
            border-radius: 12px;
            box-shadow: var(--shadow);
            overflow: hidden;
            position: sticky;
            top: 1rem;
        }

        .sidebar-header {
            padding: 1.25rem;
            background: var(--gray-50);
            border-bottom: 1px solid var(--gray-200);
        }

        .sidebar-title {
            font-size: 1rem;
            font-weight: 700;
            color: var(--gray-900);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .task-count {
            display: inline-flex;
            align-items: center;
            padding: 0.25rem 0.625rem;
            background: var(--primary);
            color: white;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 700;
            margin-left: auto;
        }

        .tasks-list {
            max-height: 400px;
            overflow-y: auto;
            padding: 1rem;
        }

        .task-item {
            padding: 0.875rem;
            background: var(--gray-50);
            border-radius: 8px;
            margin-bottom: 0.75rem;
            border: 1px solid var(--gray-200);
        }

        .task-item-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 0.5rem;
        }

        .task-id {
            font-weight: 700;
            color: var(--primary);
            font-size: 0.875rem;
        }

        .task-badge {
            padding: 0.25rem 0.5rem;
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
            border-radius: 4px;
            font-size: 0.7rem;
            font-weight: 600;
        }

        .task-customer {
            font-size: 0.8125rem;
            color: var(--gray-700);
            margin-bottom: 0.25rem;
        }

        .task-phone {
            font-size: 0.75rem;
            color: var(--gray-600);
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        /* Main Content */
        .main-content {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        /* Schedule Card */
        .schedule-card {
            background: white;
            border-radius: 12px;
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .schedule-header {
            padding: 1.25rem;
            background: var(--gray-50);
            border-bottom: 1px solid var(--gray-200);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .schedule-title {
            font-size: 1.125rem;
            font-weight: 700;
            color: var(--gray-900);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .schedule-nav {
            display: flex;
            gap: 0.5rem;
        }

        .schedule-body {
            padding: 1rem;
            overflow-x: auto;
        }

        .schedule-table {
            width: 100%;
            border-collapse: collapse;
            min-width: 800px;
        }

        .schedule-table th,
        .schedule-table td {
            padding: 0.75rem;
            text-align: left;
            border: 1px solid var(--gray-200);
            font-size: 0.875rem;
        }

        .schedule-table th {
            background: var(--gray-50);
            font-weight: 600;
            color: var(--gray-700);
            white-space: nowrap;
        }

        .schedule-table td {
            background: white;
        }

        .schedule-cell {
            font-size: 0.8125rem;
            color: var(--gray-600);
            line-height: 1.6;
        }

        .schedule-empty {
            text-align: center;
            color: var(--gray-400);
        }

        /* Task Date Styling */
        .task-start-date {
            display: inline-block;
            padding: 0.25rem 0.5rem;
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 600;
            margin: 0.125rem 0;
        }

        .task-deadline {
            display: inline-block;
            padding: 0.25rem 0.5rem;
            background: rgba(239, 68, 68, 0.1);
            color: var(--danger);
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 600;
            margin: 0.125rem 0;
        }

        .task-date-label {
            font-size: 0.7rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            opacity: 0.8;
        }

        /* Schedule Badge Styling */
        .schedule-badge {
            display: inline-block;
            padding: 0.375rem 0.625rem;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 600;
            margin: 0.125rem 0;
            line-height: 1.4;
        }

        .schedule-badge.schedule-start {
            background: rgba(16, 185, 129, 0.15);
            color: #047857;
            border: 1px solid rgba(16, 185, 129, 0.3);
        }

        .schedule-badge.schedule-deadline {
            background: rgba(239, 68, 68, 0.15);
            color: #b91c1c;
            border: 1px solid rgba(239, 68, 68, 0.3);
        }

        /* Technicians Card */
        .technicians-card {
            background: white;
            border-radius: 12px;
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .tech-header {
            padding: 1.25rem;
            border-bottom: 1px solid var(--gray-200);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .tech-title {
            font-size: 1.125rem;
            font-weight: 700;
            color: var(--gray-900);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .tech-controls {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .tech-controls label {
            font-size: 0.875rem;
            color: var(--gray-700);
            font-weight: 500;
        }

        .tech-controls select {
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

        .tech-info {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }

        .tech-name {
            font-weight: 600;
            color: var(--gray-900);
        }

        .tech-username {
            font-size: 0.75rem;
            color: var(--gray-600);
        }

        .contact-link {
            color: var(--primary);
            text-decoration: none;
        }

        .contact-link:hover {
            text-decoration: underline;
        }

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

        /* Pagination */
        .table-footer {
            padding: 1.25rem;
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
        @media (max-width: 1200px) {
            .layout-grid {
                grid-template-columns: 1fr;
            }

            .sidebar-card {
                position: static;
            }
        }

        @media (max-width: 768px) {
            .select-container {
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

            .tech-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .action-buttons {
                flex-direction: column;
                width: 100%;
            }

            .action-buttons .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>

<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>

<div class="select-container">
    <!-- Page Header -->
    <div class="page-header">
        <div class="header-content">
            <div class="header-icon">
                <i class="fas fa-user-plus"></i>
            </div>
            <div class="header-text">
                <h1>Select Technician</h1>
                <p>Choose a technician to assign the selected tasks</p>
            </div>
        </div>
    </div>

    <div class="layout-grid">
        <!-- Left Sidebar: Selected Tasks -->
        <div>
            <!-- Filter Card -->
            <div class="filter-card">
                <div class="filter-header">
                    <i class="fas fa-filter"></i>
                    Filter Technicians
                </div>
                <form id="filterForm" method="POST"
                      action="${pageContext.request.contextPath}/technician_leader/task/selectTechnician">
                    <c:forEach var="taskId" items="${selectedTaskIds}">
                        <input type="hidden" name="selectedTasks" value="${taskId}">
                    </c:forEach>
                    <c:if test="${not empty param.weekStart}">
                        <input type="hidden" name="weekStart" value="${param.weekStart}">
                    </c:if>

                    <div class="form-group">
                        <label class="form-label">Search by Name/ID</label>
                        <input type="text" class="form-control" name="searchName"
                               value="${searchName}" placeholder="Enter name or Staff ID...">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Location</label>
                        <select class="form-control" name="location">
                            <option value="">All Locations</option>
                            <c:forEach var="loc" items="${availableLocations}">
                                <option value="${loc}" ${selectedLocation == loc ? 'selected' : ''}>${loc}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Age Range</label>
                        <select class="form-control" name="ageRange">
                            <option value="">All Ages</option>
                            <option value="18-25" ${selectedAgeRange == '18-25' ? 'selected' : ''}>18-25 years</option>
                            <option value="26-35" ${selectedAgeRange == '26-35' ? 'selected' : ''}>26-35 years</option>
                            <option value="36-45" ${selectedAgeRange == '36-45' ? 'selected' : ''}>36-45 years</option>
                            <option value="46-55" ${selectedAgeRange == '46-55' ? 'selected' : ''}>46-55 years</option>
                            <option value="56+" ${selectedAgeRange == '56+' ? 'selected' : ''}>56+ years</option>
                        </select>
                    </div>
                    <div style="display: flex; gap: 0.5rem; margin-top: 1rem;">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search"></i> Apply
                        </button>
                        <button type="button" class="btn btn-secondary" onclick="clearFilters()">
                            <i class="fas fa-times"></i> Clear
                        </button>
                    </div>
                </form>
            </div>

            <!-- Selected Tasks -->
            <div class="sidebar-card">
                <div class="sidebar-header">
                    <div class="sidebar-title">
                        <i class="fas fa-clipboard-check"></i>
                        Selected Tasks
                        <span class="task-count">${selectedRequests.size()}</span>
                    </div>
                </div>
                <div class="tasks-list">
                    <c:choose>
                        <c:when test="${not empty selectedRequests}">
                            <c:forEach var="req" items="${selectedRequests}">
                                <div class="task-item">
                                    <div class="task-item-header">
                                        <span class="task-id">REQ-${req.requestID}</span>
                                        <span class="task-badge">
                                            <i class="fas fa-check"></i> Approved
                                        </span>
                                    </div>
                                    <div class="task-customer">
                                        <c:choose>
                                            <c:when test="${not empty req.contract.customer.customerName}">
                                                ${req.contract.customer.customerName}
                                            </c:when>
                                            <c:otherwise>N/A</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="task-phone">
                                        <i class="fas fa-phone"></i>
                                        <c:choose>
                                            <c:when test="${not empty req.contract.customer.phone}">
                                                ${req.contract.customer.phone}
                                            </c:when>
                                            <c:otherwise>No phone</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state" style="padding: 2rem 1rem;">
                                <i class="fas fa-inbox"></i>
                                <h3 style="font-size: 1rem;">No Tasks Selected</h3>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Weekly Schedule -->
            <c:if test="${not empty weekDays}">
                <div class="schedule-card">
                    <div class="schedule-header">
                        <div class="schedule-title">
                            <i class="fas fa-calendar-week"></i>
                            Weekly Schedule
                        </div>
                        <div class="schedule-nav">
                            <button type="button" class="btn btn-sm btn-secondary"
                                    onclick="goToWeek('${prevWeekStart}')">
                                <i class="fas fa-chevron-left"></i> Prev
                            </button>
                            <button type="button" class="btn btn-sm btn-secondary"
                                    onclick="goToWeek('${nextWeekStart}')">
                                Next <i class="fas fa-chevron-right"></i>
                            </button>
                        </div>
                    </div>
                    <div class="schedule-body">
                        <table class="schedule-table">
                            <thead>
                            <tr>
                                <th>Technician</th>
                                <c:forEach var="day" items="${weekDays}">
                                    <th>${day}</th>
                                </c:forEach>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="tech" items="${technicians}">
                                <tr>
                                    <td>
                                        <div class="tech-info">
                                            <div class="tech-name">${tech.staffName}</div>
                                            <div class="tech-username">${tech.account.username}</div>
                                        </div>
                                    </td>
                                    <c:forEach var="i" begin="0" end="${fn:length(weekDays) - 1}">
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty techSchedules[tech.account.username] and techSchedules[tech.account.username][i] != null}">
                                                    <div class="schedule-cell">
                                                        <c:out value="${techSchedules[tech.account.username][i]}"
                                                               escapeXml="false"/>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="schedule-cell schedule-empty">—</div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </c:forEach>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:if>

            <!-- Technicians List -->
            <div class="technicians-card">
                <div class="tech-header">
                    <div class="tech-title">
                        <i class="fas fa-users"></i>
                        Available Technicians
                        <span style="color: var(--gray-600); font-weight: 500;">
                            (<c:choose>
                            <c:when test="${not empty totalCount}">${totalCount}</c:when>
                            <c:otherwise>0</c:otherwise>
                        </c:choose> total)
                        </span>
                    </div>
                    <div class="tech-controls">
                        <label>Show:</label>
                        <form method="POST" action="${pageContext.request.contextPath}/task/selectTechnician"
                              style="display: inline;" id="pageSizeForm">
                            <c:forEach var="taskId" items="${selectedTaskIds}">
                                <input type="hidden" name="selectedTasks" value="${taskId}">
                            </c:forEach>
                            <input type="hidden" name="page" value="1">
                            <input type="hidden" name="searchName" value="${searchName}">
                            <input type="hidden" name="location" value="${selectedLocation}">
                            <input type="hidden" name="ageRange" value="${selectedAgeRange}">
                            <c:if test="${not empty param.weekStart}">
                                <input type="hidden" name="weekStart" value="${param.weekStart}">
                            </c:if>
                            <select name="recordsPerPage" onchange="this.form.submit()" class="form-control">
                                <option value="5" ${recordsPerPage == 5 ? 'selected' : ''}>5</option>
                                <option value="10" ${recordsPerPage == 10 ? 'selected' : ''}>10</option>
                                <option value="15" ${recordsPerPage == 15 ? 'selected' : ''}>15</option>
                                <option value="20" ${recordsPerPage == 20 ? 'selected' : ''}>20</option>
                            </select>
                        </form>
                    </div>
                </div>

                <div class="table-wrapper">
                    <table>
                        <thead>
                        <tr>
                            <th>Technician</th>
                            <th>Contact</th>
                            <th>Address</th>
                            <th>Date of Birth</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty technicians}">
                                <c:forEach var="tech" items="${technicians}">
                                    <tr>
                                        <td>
                                            <div class="tech-info">
                                                <div class="tech-name">${tech.staffName}</div>
                                                <div class="tech-username">ID: ${tech.staffID}</div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="tech-info">
                                                <a href="tel:${tech.phone}" class="contact-link">
                                                    <i class="fas fa-phone"></i> ${tech.phone}
                                                </a>
                                                <a href="mailto:${tech.email}" class="contact-link">
                                                    <i class="fas fa-envelope"></i> ${tech.email}
                                                </a>
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty tech.address}">
                                                    ${tech.address}
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: var(--gray-500);">No address</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty tech.dateOfBirth}">
                                                    ${tech.dateOfBirth}
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: var(--gray-500);">N/A</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <button type="button" class="btn btn-outline btn-sm"
                                                        onclick="viewTech('${tech.staffID}')">
                                                    <i class="fas fa-eye"></i> View
                                                </button>
                                                <a href="${pageContext.request.contextPath}/technician_leader/tasks/assign?assignTo=${tech.staffID}&requestId=${selectedTaskIds[0]}"
                                                   class="btn btn-success btn-sm">
                                                    <i class="fas fa-user-plus"></i> Assign
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5">
                                        <div class="empty-state">
                                            <i class="fas fa-users"></i>
                                            <h3>No Technicians Available</h3>
                                            <p>There are currently no technicians matching your criteria.</p>
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
                                ${((currentPage - 1) * recordsPerPage) + 1} -
                                ${currentPage * recordsPerPage > totalCount ? totalCount : currentPage * recordsPerPage}
                                of ${totalCount}
                            </c:when>
                            <c:otherwise>0</c:otherwise>
                        </c:choose>
                        entries
                    </div>

                    <div class="pagination-controls">
                        <c:set var="currentPage" value="${currentPage != null ? currentPage : 1}"/>
                        <c:set var="totalPages" value="${totalPages != null ? totalPages : 1}"/>

                        <form method="POST" action="${pageContext.request.contextPath}/task/selectTechnician"
                              style="display: inline;" id="paginationForm">
                            <c:forEach var="taskId" items="${selectedTaskIds}">
                                <input type="hidden" name="selectedTasks" value="${taskId}">
                            </c:forEach>
                            <input type="hidden" name="page" id="pageInput" value="${currentPage}">
                            <input type="hidden" name="searchName" value="${searchName}">
                            <input type="hidden" name="location" value="${selectedLocation}">
                            <input type="hidden" name="ageRange" value="${selectedAgeRange}">
                            <input type="hidden" name="recordsPerPage" value="${recordsPerPage}">
                            <c:if test="${not empty param.weekStart}">
                                <input type="hidden" name="weekStart" value="${param.weekStart}">
                            </c:if>
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
    </div>
</div>

<script>
    function goToPage(page) {
        document.getElementById('pageInput').value = page;
        document.getElementById('paginationForm').submit();
    }

    function goToWeek(weekStart) {
        const form = document.getElementById('filterForm');
        let weekInput = form.querySelector('input[name="weekStart"]');
        if (!weekInput) {
            weekInput = document.createElement('input');
            weekInput.type = 'hidden';
            weekInput.name = 'weekStart';
            form.appendChild(weekInput);
        }
        weekInput.value = weekStart;
        form.submit();
    }

    function clearFilters() {
        const form = document.getElementById('filterForm');
        form.querySelectorAll('input[type="text"], select').forEach(input => {
            if (input.name !== 'selectedTasks' && input.name !== 'weekStart') {
                if (input.tagName === 'SELECT') {
                    input.selectedIndex = 0;
                } else {
                    input.value = '';
                }
            }
        });
        form.submit();
    }

    function viewTech(staffId) {
        const form = document.createElement('form');
        form.method = 'post';
        form.action = '${pageContext.request.contextPath}/technician_leader/tech/employees/view';

        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'id';
        input.value = staffId;
        form.appendChild(input);

        document.body.appendChild(form);
        form.submit();
    }
</script>

</body>
</html>
