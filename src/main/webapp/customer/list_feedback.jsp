<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Feedbacks</title>
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

        .list-container {
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

        /* Filter Card */
        .filter-card {
            background: white;
            border-radius: 12px;
            box-shadow: var(--shadow);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .filter-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
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

        .btn-warning {
            background: var(--warning);
            color: white;
        }

        .btn-warning:hover {
            background: #d97706;
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

        .btn-sm {
            padding: 0.375rem 0.875rem;
            font-size: 0.8125rem;
        }

        /* Feedback Grid */
        .feedback-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(450px, 1fr));
            gap: 1.5rem;
        }

        .feedback-card {
            background: white;
            border-radius: 12px;
            box-shadow: var(--shadow);
            padding: 1.5rem;
            border-left: 4px solid var(--primary);
            transition: all 0.3s;
        }

        .feedback-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .feedback-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--gray-200);
        }

        .feedback-id {
            font-size: 0.875rem;
            font-weight: 700;
            color: var(--primary);
            background: rgba(79, 70, 229, 0.1);
            padding: 0.375rem 0.75rem;
            border-radius: 6px;
        }

        .feedback-date {
            font-size: 0.8125rem;
            color: var(--gray-500);
            display: flex;
            align-items: center;
            gap: 0.375rem;
        }

        .feedback-section {
            margin-bottom: 1rem;
        }

        .section-label {
            font-size: 0.75rem;
            font-weight: 700;
            color: var(--gray-600);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 0.375rem;
        }

        .section-value {
            font-size: 0.9375rem;
            color: var(--gray-700);
            line-height: 1.6;
        }

        .feedback-content-box {
            background: var(--gray-50);
            padding: 0.875rem;
            border-radius: 8px;
            border-left: 3px solid var(--primary);
        }

        /* Request Info Box */
        .request-info-box {
            background: linear-gradient(135deg, #EFF6FF, #DBEAFE);
            border: 1px solid var(--info);
            border-left: 4px solid var(--info);
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1rem;
        }

        .request-info-title {
            font-size: 0.75rem;
            font-weight: 700;
            color: #1e40af;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 0.75rem;
            display: flex;
            align-items: center;
            gap: 0.375rem;
        }

        .request-info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 0.75rem;
        }

        .info-item {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }

        .info-label {
            font-size: 0.6875rem;
            font-weight: 600;
            color: var(--gray-600);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .info-value {
            font-size: 0.875rem;
            color: var(--gray-900);
            font-weight: 600;
        }

        /* Rating */
        .rating-display {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .rating-stars {
            display: flex;
            gap: 0.25rem;
        }

        .rating-stars i {
            font-size: 1.125rem;
            color: var(--warning);
        }

        .rating-stars i.empty {
            color: var(--gray-300);
        }

        .rating-number {
            font-size: 0.875rem;
            font-weight: 700;
            color: var(--gray-700);
        }

        /* Badges */
        .badge {
            display: inline-flex;
            align-items: center;
            padding: 0.25rem 0.625rem;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.025em;
            gap: 0.25rem;
        }

        .badge-warning {
            background: rgba(245, 158, 11, 0.1);
            color: #92400e;
        }

        .badge-success {
            background: rgba(16, 185, 129, 0.1);
            color: #065f46;
        }

        .badge-danger {
            background: rgba(239, 68, 68, 0.1);
            color: #991b1b;
        }

        .badge-info {
            background: rgba(59, 130, 246, 0.1);
            color: #1e40af;
        }

        .badge-pending {
            background: rgba(245, 158, 11, 0.1);
            color: #92400e;
        }

        .badge-approved {
            background: rgba(34, 197, 94, 0.1);
            color: #166534;
        }

        .badge-processing {
            background: rgba(59, 130, 246, 0.1);
            color: #1e40af;
        }

        .badge-finished {
            background: rgba(16, 185, 129, 0.1);
            color: #065f46;
        }

        .badge-rejected {
            background: rgba(239, 68, 68, 0.1);
            color: #991b1b;
        }

        /* Response Box */
        .response-box {
            background: rgba(16, 185, 129, 0.05);
            border-left: 3px solid var(--success);
            padding: 0.875rem;
            border-radius: 8px;
            margin-top: 1rem;
        }

        .response-label {
            font-size: 0.75rem;
            font-weight: 700;
            color: #065f46;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 0.375rem;
            display: flex;
            align-items: center;
            gap: 0.375rem;
        }

        .response-text {
            font-size: 0.9375rem;
            color: #065f46;
            line-height: 1.6;
        }

        /* Card Actions */
        .card-actions {
            display: flex;
            gap: 0.5rem;
            padding-top: 1rem;
            border-top: 1px solid var(--gray-200);
            margin-top: 1rem;
        }

        /* Alert */
        .alert {
            background: rgba(59, 130, 246, 0.1);
            border: 1px solid var(--info);
            border-left: 4px solid var(--info);
            border-radius: 8px;
            padding: 1rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            color: #1e40af;
        }

        .alert i {
            font-size: 1.25rem;
        }

        /* Pagination */
        .pagination-wrapper {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.5rem 0 0;
            margin-top: 1.5rem;
            border-top: 1px solid var(--gray-200);
        }

        .pagination-info {
            font-size: 0.875rem;
            color: var(--gray-600);
            font-weight: 600;
        }

        .pagination {
            display: flex;
            gap: 0.375rem;
            list-style: none;
            margin: 0;
            padding: 0;
        }

        .page-item {
            list-style: none;
        }

        .page-link {
            padding: 0.5rem 0.875rem;
            border-radius: 6px;
            background: white;
            border: 1px solid var(--gray-300);
            color: var(--gray-700);
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s;
            font-size: 0.875rem;
        }

        .page-link:hover {
            background: var(--gray-50);
            border-color: var(--primary);
            color: var(--primary);
        }

        .page-item.active .page-link {
            background: var(--primary);
            border-color: var(--primary);
            color: white;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .list-container {
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

            .filter-grid {
                grid-template-columns: 1fr;
            }

            .feedback-grid {
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
                gap: 1rem;
                align-items: flex-start;
            }

            .request-info-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/customer_sidebar.jsp"/>

<div class="list-container">
    <!-- Page Header -->
    <div class="page-header">
        <div class="header-content">
            <div class="header-icon">
                <i class="fas fa-comments"></i>
            </div>
            <div class="header-text">
                <h1>My Feedbacks</h1>
                <p>View and manage your feedback history</p>
            </div>
        </div>
    </div>

    <!-- Filter Card -->
    <div class="filter-card">
        <form method="get" action="${pageContext.request.contextPath}/customer/feedback/list">
            <div class="filter-grid">
                <div class="form-group">
                    <label class="form-label">Search</label>
                    <input type="text" name="q" class="form-control" value="${fn:escapeXml(q)}"
                           placeholder="Search content or description"/>
                </div>
                <div class="form-group">
                    <label class="form-label">From Date</label>
                    <input type="date" name="fromDate" class="form-control" value="${fromDate}"/>
                </div>
                <div class="form-group">
                    <label class="form-label">To Date</label>
                    <input type="date" name="toDate" class="form-control" value="${toDate}"/>
                </div>
                <div class="form-group">
                    <label class="form-label">Status</label>
                    <select name="status" class="form-select">
                        <option value="" ${empty status ? 'selected' : ''}>All Statuses</option>
                        <option value="Pending" ${status == 'Pending' ? 'selected' : ''}>Pending</option>
                        <option value="Responded" ${status == 'Responded' ? 'selected' : ''}>Responded</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Rating</label>
                    <select name="rating" class="form-select">
                        <option value="" ${empty rating ? 'selected' : ''}>All Ratings</option>
                        <c:forEach var="r" begin="1" end="5">
                            <option value="${r}" ${rating == r.toString() ? 'selected' : ''}>${r}
                                Star${r > 1 ? 's' : ''}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Per Page</label>
                    <select name="recordsPerPage" class="form-select">
                        <option value="5" ${recordsPerPage == 5 ? 'selected' : ''}>5</option>
                        <option value="10" ${recordsPerPage == 10 ? 'selected' : ''}>10</option>
                        <option value="20" ${recordsPerPage == 20 ? 'selected' : ''}>20</option>
                        <option value="50" ${recordsPerPage == 50 ? 'selected' : ''}>50</option>
                    </select>
                </div>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-filter"></i> Apply Filters
                </button>
                <a href="${pageContext.request.contextPath}/customer/feedback/list" class="btn btn-secondary">
                    <i class="fas fa-redo"></i> Reset
                </a>
            </div>
        </form>
    </div>

    <!-- Results -->
    <c:if test="${empty feedbacks}">
        <div class="alert">
            <i class="fas fa-info-circle"></i>
            <span>No feedbacks found. Try adjusting your filters or create your first feedback.</span>
        </div>
    </c:if>

    <c:if test="${not empty feedbacks}">
        <div class="feedback-grid">
            <c:forEach var="fb" items="${feedbacks}">
                <div class="feedback-card">
                    <!-- Header -->
                    <div class="feedback-header">
                        <div class="feedback-id">
                            <i class="fas fa-hashtag"></i> ${fb.feedbackID}
                        </div>
                        <div class="feedback-date">
                            <i class="fas fa-calendar"></i>
                            <c:out value="${fb.feedbackDate}" default="-"/>
                        </div>
                    </div>

                    <!-- Content -->
                    <div class="feedback-section">
                        <div class="section-label">
                            <i class="fas fa-file-alt"></i> Content
                        </div>
                        <div class="feedback-content-box">
                            <div class="section-value">
                                <c:out value="${fb.content}" default="No content"/>
                            </div>
                        </div>
                    </div>

                    <!-- Description -->
                    <div class="feedback-section">
                        <div class="section-label">
                            <i class="fas fa-comment-dots"></i> Description
                        </div>
                        <div class="feedback-content-box">
                            <div class="section-value">
                                <c:out value="${fb.description}" default="No description"/>
                            </div>
                        </div>
                    </div>

                    <!-- Request Information -->
                    <c:catch var="requestError">
                        <c:set var="request" value="${fb.requestID.entity}"/>
                    </c:catch>
                    <c:if test="${not empty request}">
                        <div class="request-info-box">
                            <div class="request-info-title">
                                <i class="fas fa-tasks"></i> Request Information
                            </div>
                            <div class="request-info-grid">
                                <div class="info-item">
                                    <span class="info-label">Request ID</span>
                                    <span class="info-value">#${fb.requestID.foreignKeyValue}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Title</span>
                                    <span class="info-value"><c:out value="${request.title}" default="N/A"/></span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Status</span>
                                    <span class="info-value">
                                        <c:choose>
                                            <c:when test="${request.requestStatus.name() == 'Pending'}">
                                                <span class="badge badge-pending"><i
                                                        class="fas fa-clock"></i> Pending</span>
                                            </c:when>
                                            <c:when test="${request.requestStatus.name() == 'Approved'}">
                                                <span class="badge badge-approved"><i class="fas fa-check"></i> Approved</span>
                                            </c:when>
                                            <c:when test="${request.requestStatus.name() == 'Processing'}">
                                                <span class="badge badge-processing"><i class="fas fa-spinner"></i> Processing</span>
                                            </c:when>
                                            <c:when test="${request.requestStatus.name() == 'Finished'}">
                                                <span class="badge badge-finished"><i class="fas fa-check-circle"></i> Finished</span>
                                            </c:when>
                                            <c:when test="${request.requestStatus.name() == 'Rejected'}">
                                                <span class="badge badge-rejected"><i class="fas fa-times-circle"></i> Rejected</span>
                                            </c:when>
                                            <c:otherwise>
                                                <c:out value="${request.requestStatus}" default="N/A"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <c:if test="${not empty request.requestDate}">
                                    <div class="info-item">
                                        <span class="info-label">Request Date</span>
                                        <span class="info-value"><c:out value="${request.requestDate}"/></span>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </c:if>

                    <!-- Rating & Status -->
                    <div class="feedback-section">
                        <div class="rating-display">
                            <div class="rating-stars">
                                <c:forEach var="s" begin="1" end="5">
                                    <i class="fas fa-star ${s <= fb.rating ? '' : 'empty'}"></i>
                                </c:forEach>
                            </div>
                            <span class="rating-number">${fb.rating}/5</span>
                            <c:choose>
                                <c:when test="${fb.feedbackStatus != null && fb.feedbackStatus.name() == 'Pending'}">
                                    <span class="badge badge-warning">
                                        <i class="fas fa-clock"></i> Pending
                                    </span>
                                </c:when>
                                <c:when test="${fb.feedbackStatus != null && fb.feedbackStatus.name() == 'Responded'}">
                                    <span class="badge badge-success">
                                        <i class="fas fa-check-circle"></i> Responded
                                    </span>
                                </c:when>
                                <c:when test="${fb.feedbackStatus != null && fb.feedbackStatus.name() == 'Deleted'}">
                                    <span class="badge badge-danger">
                                        <i class="fas fa-trash"></i> Deleted
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge"><c:out value="${fb.feedbackStatus}" default="-"/></span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Response -->
                    <c:if test="${not empty fb.response}">
                        <div class="response-box">
                            <div class="response-label">
                                <i class="fas fa-reply"></i> Support Response
                            </div>
                            <div class="response-text">
                                <c:out value="${fb.response}"/>
                            </div>
                        </div>
                    </c:if>

                    <!-- Actions -->
                    <div class="card-actions">
                        <a href="${pageContext.request.contextPath}/customer/feedback/view?requestId=${fb.requestID}"
                           class="btn btn-sm btn-outline-primary">
                            <i class="fas fa-eye"></i> View Details
                        </a>
                        <c:if test="${fb.customerID == currentUsername}">
                            <a href="${pageContext.request.contextPath}/feedback/edit?feedbackId=${fb.feedbackID}"
                               class="btn btn-sm btn-warning">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Pagination -->
        <div class="pagination-wrapper">
            <div class="pagination-info">
                <i class="fas fa-list"></i> Showing ${feedbacks.size()} of ${totalRecords} results
            </div>
            <nav>
                <ul class="pagination">
                    <c:forEach var="p" begin="1" end="${totalPages}">
                        <li class="page-item ${p == currentPage ? 'active' : ''}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/customer/feedback/list?page=${p}&recordsPerPage=${recordsPerPage}&q=${fn:escapeXml(q)}&fromDate=${fromDate}&toDate=${toDate}&status=${status}&rating=${rating}">${p}</a>
                        </li>
                    </c:forEach>
                </ul>
            </nav>
        </div>
    </c:if>
</div>

</body>
</html>
