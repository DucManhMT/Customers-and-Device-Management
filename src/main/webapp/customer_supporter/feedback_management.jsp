<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="crm.common.URLConstants" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback Management</title>
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

        .feedback-container {
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
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
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

        .alert-danger {
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid var(--danger);
            color: #991b1b;
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

        .stat-card:nth-child(4) .stat-icon {
            background: linear-gradient(135deg, var(--danger), #DC2626);
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
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
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

        .btn-info {
            background: var(--info);
            color: white;
        }

        .btn-info:hover {
            background: #2563EB;
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

        /* Badge */
        .badge {
            display: inline-flex;
            align-items: center;
            padding: 0.375rem 0.75rem;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 600;
            gap: 0.25rem;
        }

        .badge-warning {
            background: rgba(245, 158, 11, 0.1);
            color: #92400e;
        }

        .badge-success {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
        }

        .badge-danger {
            background: rgba(239, 68, 68, 0.1);
            color: var(--danger);
        }

        /* Rating Stars */
        .rating-stars {
            display: flex;
            gap: 0.125rem;
            color: #F59E0B;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 0.5rem;
        }

        .action-buttons form {
            display: inline;
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

        /* Link Button */
        .link-btn {
            background: none;
            border: none;
            color: var(--primary);
            text-decoration: none;
            cursor: pointer;
            padding: 0;
            font-weight: 600;
        }

        .link-btn:hover {
            text-decoration: underline;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .feedback-container {
                padding: 1rem 0.75rem;
            }

            .page-header {
                padding: 1.5rem;
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

            .stats-grid {
                grid-template-columns: 1fr;
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
                width: 100%;
            }

            .action-buttons .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>

<c:set var="activePage" value="feedbackManagement" scope="request" />
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>

<div class="feedback-container">
    <div class="page-header">
        <div class="header-left">
            <div class="header-icon">
                <i class="fas fa-comments"></i>
            </div>
            <div class="header-text">
                <h1>Feedback Management</h1>
                <p>Manage and respond to customer feedback</p>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/customer_supporter/customersupporter_actioncenter" 
           class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Back to Action Center
        </a>
    </div>

    <!-- Alert Messages -->
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <span>${successMessage}</span>
        </div>
    </c:if>
    
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger">
            <i class="fas fa-times-circle"></i>
            <span>${errorMessage}</span>
        </div>
    </c:if>

    <!-- Stats Grid -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon">
                <i class="fas fa-clipboard-list"></i>
            </div>
            <div class="stat-number">${totalCount != null ? totalCount : 0}</div>
            <div class="stat-label">Total Feedbacks</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">
                <i class="fas fa-check-circle"></i>
            </div>
            <div class="stat-number">${respondedCount != null ? respondedCount : 0}</div>
            <div class="stat-label">Responded</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">
                <i class="fas fa-clock"></i>
            </div>
            <div class="stat-number">${pendingCount != null ? pendingCount : 0}</div>
            <div class="stat-label">Pending</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">
                <i class="fas fa-trash"></i>
            </div>
            <div class="stat-number">${deletedCount != null ? deletedCount : 0}</div>
            <div class="stat-label">Deleted</div>
        </div>
    </div>

    <!-- Filter Card -->
    <div class="filter-card">
        <div class="filter-header">
            <i class="fas fa-filter"></i>
            Filter Feedbacks
        </div>
        <form id="filterForm" method="POST" 
              action="${pageContext.request.contextPath}/customer_supporter/feedback/management">
            <input type="hidden" name="page" value="1">

            <div class="filter-grid">
                <div class="form-group">
                    <label class="form-label">Customer Username</label>
                    <input type="text" class="form-control" name="username" 
                           value="${usernameFilter}" placeholder="Enter username...">
                </div>
                <div class="form-group">
                    <label class="form-label">Rating</label>
                    <select class="form-control" name="rating">
                        <option value="">All Ratings</option>
                        <option value="5" ${ratingFilter == '5' ? 'selected' : ''}>5 Stars</option>
                        <option value="4" ${ratingFilter == '4' ? 'selected' : ''}>4 Stars</option>
                        <option value="3" ${ratingFilter == '3' ? 'selected' : ''}>3 Stars</option>
                        <option value="2" ${ratingFilter == '2' ? 'selected' : ''}>2 Stars</option>
                        <option value="1" ${ratingFilter == '1' ? 'selected' : ''}>1 Star</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Status</label>
                    <select class="form-control" name="status">
                        <option value="">All Status</option>
                        <option value="Pending" ${statusFilter == 'Pending' ? 'selected' : ''}>Pending</option>
                        <option value="Responded" ${statusFilter == 'Responded' ? 'selected' : ''}>Responded</option>
                        <option value="Deleted" ${statusFilter == 'Deleted' ? 'selected' : ''}>Deleted</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Items Per Page</label>
                    <select class="form-control" name="pageSize">
                        <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                        <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                        <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                    </select>
                </div>
            </div>

            <div class="filter-buttons">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-search"></i> Apply Filters
                </button>
                <button type="button" class="btn btn-secondary" id="clearFiltersBtn">
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
                Feedback List
                <span style="color: var(--gray-600); font-weight: 500;">
                    (Page ${currentPage != null ? currentPage : 1} of ${totalPages != null ? totalPages : 1})
                </span>
            </div>
        </div>

        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Feedback ID</th>
                        <th>Request ID</th>
                        <th>Customer</th>
                        <th>Rating</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty feedbacks}">
                            <c:forEach var="f" items="${feedbacks}">
                                <tr>
                                    <td>
                                        <strong style="color: var(--primary);">#${f.feedbackID}</strong>
                                    </td>
                                    <td>
                                        <form method="GET" 
                                              action="${pageContext.request.contextPath}${URLConstants.CUSTOMER_SUPPORTER_REQUEST_DETAIL}" 
                                              style="display:inline;">
                                            <input type="hidden" name="requestId" value="${f.requestID.foreignKeyValue}"/>
                                            <button type="submit" class="link-btn">#${f.requestID.foreignKeyValue}</button>
                                        </form>
                                    </td>
                                    <td>${f.customerID}</td>
                                    <td>
                                        <div class="rating-stars">
                                            <c:forEach begin="1" end="${f.rating}">
                                                <i class="fas fa-star"></i>
                                            </c:forEach>
                                            <c:forEach begin="${f.rating + 1}" end="5">
                                                <i class="far fa-star"></i>
                                            </c:forEach>
                                        </div>
                                    </td>
                                    <td>
                                        <i class="fas fa-calendar" style="color: var(--gray-500); margin-right: 0.375rem;"></i>
                                        ${f.feedbackDate}
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${f.feedbackStatus.name() == 'Pending'}">
                                                <span class="badge badge-warning">
                                                    <i class="fas fa-clock"></i> Pending
                                                </span>
                                            </c:when>
                                            <c:when test="${f.feedbackStatus.name() == 'Responded'}">
                                                <span class="badge badge-success">
                                                    <i class="fas fa-check"></i> Responded
                                                </span>
                                            </c:when>
                                            <c:when test="${f.feedbackStatus.name() == 'Deleted'}">
                                                <span class="badge badge-danger">
                                                    <i class="fas fa-trash"></i> Deleted
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                ${f.feedbackStatus}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <form method="GET" 
                                                  action="${pageContext.request.contextPath}${URLConstants.CUSTOMER_VIEW_FEEDBACK}">
                                                <input type="hidden" name="requestId" value="${f.requestID.foreignKeyValue}"/>
                                                <button type="submit" class="btn btn-info btn-sm">
                                                    <i class="fas fa-eye"></i> View
                                                </button>
                                            </form>
                                            <form method="GET" 
                                                  action="${pageContext.request.contextPath}/feedback/respond">
                                                <input type="hidden" name="requestId" value="${f.requestID.foreignKeyValue}"/>
                                                <button type="submit" class="btn btn-success btn-sm">
                                                    <i class="fas fa-reply"></i> Respond
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7">
                                    <div class="empty-state">
                                        <i class="fas fa-comments"></i>
                                        <h3>No Feedbacks Found</h3>
                                        <p>There are no feedbacks matching your criteria.</p>
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
                Page ${currentPage != null ? currentPage : 1} of ${totalPages != null ? totalPages : 1}
            </div>

            <div class="pagination-controls">
                <c:set var="currentPage" value="${currentPage != null ? currentPage : 1}"/>
                <c:set var="totalPages" value="${totalPages != null ? totalPages : 1}"/>

                <form method="POST" 
                      action="${pageContext.request.contextPath}/customer_supporter/feedback/management"
                      style="display: inline;" id="paginationForm">
                    <input type="hidden" name="page" id="pageInput" value="${currentPage}">
                    <input type="hidden" name="username" value="${usernameFilter}">
                    <input type="hidden" name="rating" value="${ratingFilter}">
                    <input type="hidden" name="status" value="${statusFilter}">
                    <input type="hidden" name="pageSize" value="${pageSize}">
                </form>

                <c:choose>
                    <c:when test="${currentPage == 1}">
                        <button type="button" class="pagination-btn" disabled>
                            <i class="fas fa-angle-left"></i> Previous
                        </button>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="pagination-btn" onclick="goToPage(${currentPage - 1})">
                            <i class="fas fa-angle-left"></i> Previous
                        </button>
                    </c:otherwise>
                </c:choose>

                <button class="pagination-btn active">
                    ${currentPage}
                </button>

                <c:choose>
                    <c:when test="${currentPage >= totalPages}">
                        <button type="button" class="pagination-btn" disabled>
                            Next <i class="fas fa-angle-right"></i>
                        </button>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="pagination-btn" onclick="goToPage(${currentPage + 1})">
                            Next <i class="fas fa-angle-right"></i>
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

    document.addEventListener('DOMContentLoaded', function() {
        const clearBtn = document.getElementById('clearFiltersBtn');
        if (clearBtn) {
            clearBtn.addEventListener('click', function() {
                const form = document.getElementById('filterForm');
                if (!form) return;

                form.querySelectorAll('input[type="text"]').forEach(input => {
                    if (input.name !== 'page') {
                        input.value = '';
                    }
                });

                form.querySelectorAll('select').forEach(select => {
                    select.selectedIndex = 0;
                });

                const pageSizeSelect = form.querySelector('select[name="pageSize"]');
                if (pageSizeSelect) {
                    pageSizeSelect.value = '10';
                }

                const pageInput = form.querySelector('input[name="page"]');
                if (pageInput) {
                    pageInput.value = '1';
                }

                form.submit();
            });
        }
    });
</script>

</body>
</html>
