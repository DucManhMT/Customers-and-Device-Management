<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Technician Management</title>
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
        .technician-container {
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
            background: linear-gradient(135deg, var(--success), #059669);
        }

        .stat-card:nth-child(3) .stat-icon {
            background: linear-gradient(135deg, var(--warning), #F97316);
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

        /* Technician Info */
        .tech-info {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .tech-avatar {
            width: 48px;
            height: 48px;
            border-radius: 10px;
            object-fit: cover;
            flex-shrink: 0;
        }

        .tech-avatar-placeholder {
            width: 48px;
            height: 48px;
            border-radius: 10px;
            background: linear-gradient(135deg, var(--primary), var(--primary-light));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.25rem;
            flex-shrink: 0;
        }

        .tech-details {
            display: flex;
            flex-direction: column;
        }

        .tech-name {
            font-weight: 600;
            color: var(--gray-900);
            margin-bottom: 0.125rem;
        }

        .tech-role {
            font-size: 0.75rem;
            color: var(--gray-600);
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

        .badge-primary {
            background: rgba(79, 70, 229, 0.1);
            color: var(--primary);
        }

        .badge-success {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
        }

        /* Contact Info */
        .contact-info {
            display: flex;
            flex-direction: column;
            gap: 0.375rem;
        }

        .contact-item {
            display: flex;
            align-items: center;
            gap: 0.375rem;
            font-size: 0.8125rem;
            color: var(--gray-600);
        }

        .contact-item i {
            color: var(--primary);
            width: 14px;
        }

        .contact-item a {
            color: var(--gray-600);
            text-decoration: none;
        }

        .contact-item a:hover {
            color: var(--primary);
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
            .technician-container {
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

            .stats-grid {
                grid-template-columns: 1fr;
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
        }
    </style>
</head>
<body>

<jsp:include page="../components/header.jsp" />
<jsp:include page="../components/sidebar.jsp"/>

<div class="technician-container">
    <c:choose>
        <c:when test="${techEmployees != null}">
            <!-- Page Header -->
            <div class="page-header">
                <div class="header-content">
                    <div class="header-left">
                        <div class="header-icon">
                            <i class="fas fa-user-cog"></i>
                        </div>
                        <div class="header-text">
                            <h1>Technician Management</h1>
                            <p>Manage and monitor all technician employees</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Stats Grid -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-number">
                        <c:choose>
                            <c:when test="${not empty totalCount}">${totalCount}</c:when>
                            <c:otherwise>0</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="stat-label">Total Technicians</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-phone"></i>
                    </div>
                    <div class="stat-number">
                        <c:choose>
                            <c:when test="${not empty totalCount}">${totalCount}</c:when>
                            <c:otherwise>0</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="stat-label">Verified Contacts</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-envelope"></i>
                    </div>
                    <div class="stat-number">
                        <c:choose>
                            <c:when test="${not empty totalCount}">${totalCount}</c:when>
                            <c:otherwise>0</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="stat-label">Email Registered</div>
                </div>
            </div>

            <!-- Filter Card -->
            <div class="filter-card">
                <div class="filter-header">
                    <i class="fas fa-filter"></i>
                    Search & Filter
                </div>
                <form method="POST" action="${pageContext.request.contextPath}/technician_leader/employees">
                    <input type="hidden" name="page" value="1">
                    <input type="hidden" name="recordsPerPage" value="${recordsPerPage}">

                    <div class="filter-grid">
                        <div class="form-group">
                            <label class="form-label">Search by Name/ID</label>
                            <input type="text" class="form-control" name="searchName" value="${searchName}"
                                   placeholder="Enter name or Staff ID...">
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
                    </div>

                    <div class="filter-buttons">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search"></i> Apply Filters
                        </button>
                        <a href="${pageContext.request.contextPath}/technician_leader/employees"
                           class="btn btn-secondary">
                            <i class="fas fa-times"></i> Clear Filters
                        </a>
                    </div>
                </form>
            </div>

            <!-- Table Card -->
            <div class="table-card">
                <div class="table-header">
                    <div class="table-title">
                        <i class="fas fa-list"></i>
                        Technician List
                        <span style="color: var(--gray-600); font-weight: 500;">
                            (<c:choose>
                                <c:when test="${not empty totalCount}">${totalCount}</c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose> technicians)
                        </span>
                    </div>
                    <div class="table-controls">
                        <label>Show:</label>
                        <form method="POST" action="${pageContext.request.contextPath}/technician_leader/employees"
                              style="display: inline;" id="pageSizeForm">
                            <input type="hidden" name="page" value="1">
                            <input type="hidden" name="searchName" value="${searchName}">
                            <input type="hidden" name="location" value="${selectedLocation}">
                            <input type="hidden" name="ageRange" value="${selectedAgeRange}">
                            <select name="recordsPerPage" onchange="this.form.submit()" class="form-control">
                                <option value="5" ${recordsPerPage == 5 ? 'selected' : ''}>5</option>
                                <option value="10" ${recordsPerPage == 10 ? 'selected' : ''}>10</option>
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
                                <th>Staff ID</th>
                                <th>Contact Info</th>
                                <th>Address</th>
                                <th>Date of Birth</th>
                                <th>Role</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty techEmployees}">
                                    <c:forEach items="${techEmployees}" var="employee">
                                        <tr>
                                            <td>
                                                <div class="tech-info">
                                                    <c:choose>
                                                        <c:when test="${not empty employee.image}">
                                                            <img src="../assets/${employee.image}"
                                                                 alt="${employee.staffName}"
                                                                 class="tech-avatar">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="tech-avatar-placeholder">
                                                                <i class="fas fa-user"></i>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <div class="tech-details">
                                                        <div class="tech-name">${employee.staffName}</div>
                                                        <div class="tech-role">Tech Employee</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="badge badge-primary">#${employee.staffID}</span>
                                            </td>
                                            <td>
                                                <div class="contact-info">
                                                    <div class="contact-item">
                                                        <i class="fas fa-envelope"></i>
                                                        <a href="mailto:${employee.email}">${employee.email}</a>
                                                    </div>
                                                    <div class="contact-item">
                                                        <i class="fas fa-phone"></i>
                                                        <a href="tel:${employee.phone}">${employee.phone}</a>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty employee.address}">
                                                        ${employee.address}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: var(--gray-500);">No address</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty employee.dateOfBirth}">
                                                        ${employee.dateOfBirth}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: var(--gray-500);">Not provided</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="badge badge-success">
                                                    <i class="fas fa-check-circle"></i> ROLE
                                                </span>
                                            </td>
                                            <td>
                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/technician_leader/tech/employees/view"
                                                      style="display: inline;">
                                                    <input type="hidden" name="id" value="${employee.staffID}">
                                                    <button type="submit" class="btn btn-outline btn-sm">
                                                        <i class="fas fa-eye"></i> View
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7">
                                            <div class="empty-state">
                                                <i class="fas fa-users"></i>
                                                <h3>No Technicians Found</h3>
                                                <p>There are currently no technician employees matching your criteria.</p>
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

                        <form method="POST" action="${pageContext.request.contextPath}/technician_leader/employees"
                              style="display: inline;" id="paginationForm">
                            <input type="hidden" name="page" id="pageInput" value="${currentPage}">
                            <input type="hidden" name="searchName" value="${searchName}">
                            <input type="hidden" name="location" value="${selectedLocation}">
                            <input type="hidden" name="ageRange" value="${selectedAgeRange}">
                            <input type="hidden" name="recordsPerPage" value="${recordsPerPage}">
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

        </c:when>
        <c:otherwise>
            <!-- Empty State when data not loaded -->
            <div class="page-header">
                <div class="empty-state" style="padding: 4rem 1rem;">
                    <i class="fas fa-info-circle"></i>
                    <h3>Data Not Loaded</h3>
                    <p>Please use the proper navigation to access the technician employee list.</p>
                    <div style="margin-top: 2rem; display: flex; gap: 1rem; justify-content: center;">
                        <a href="${pageContext.request.contextPath}/technician_leader/employees" class="btn btn-primary">
                            <i class="fas fa-arrow-right"></i> Load Technicians
                        </a>
                        <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">
                            <i class="fas fa-home"></i> Back to Home
                        </a>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script>
    function goToPage(page) {
        document.getElementById('pageInput').value = page;
        document.getElementById('paginationForm').submit();
    }
</script>

</body>
</html>
