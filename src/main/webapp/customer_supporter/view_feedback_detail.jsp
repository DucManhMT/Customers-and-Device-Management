<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback Details</title>
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

        .detail-container {
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

        /* Breadcrumb */
        .breadcrumb {
            display: flex;
            gap: 0.5rem;
            font-size: 0.875rem;
            color: var(--gray-600);
            margin-top: 0.5rem;
        }

        .breadcrumb a {
            color: var(--primary);
            text-decoration: none;
        }

        .breadcrumb a:hover {
            text-decoration: underline;
        }

        .breadcrumb-separator {
            color: var(--gray-400);
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

        /* Layout Grid */
        .layout-grid {
            display: grid;
            grid-template-columns: 1fr 350px;
            gap: 1.5rem;
        }

        /* Card */
        .card {
            background: white;
            border-radius: 12px;
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 1.5rem;
        }

        .card-header {
            padding: 1.25rem 1.5rem;
            background: var(--gray-50);
            border-bottom: 1px solid var(--gray-200);
        }

        .card-title {
            font-size: 1.125rem;
            font-weight: 700;
            color: var(--gray-900);
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin: 0;
        }

        .card-body {
            padding: 1.5rem;
        }

        /* Info Item */
        .info-item {
            margin-bottom: 1.5rem;
        }

        .info-item:last-child {
            margin-bottom: 0;
        }

        .info-label {
            font-size: 0.875rem;
            font-weight: 600;
            color: var(--gray-700);
            margin-bottom: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .info-value {
            font-size: 1rem;
            color: var(--gray-900);
        }

        /* Info Grid */
        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }

        /* Badge */
        .badge {
            display: inline-flex;
            align-items: center;
            padding: 0.375rem 0.75rem;
            border-radius: 6px;
            font-size: 0.875rem;
            font-weight: 600;
            gap: 0.375rem;
        }

        .badge-primary {
            background: rgba(79, 70, 229, 0.1);
            color: var(--primary);
        }

        .badge-info {
            background: rgba(59, 130, 246, 0.1);
            color: var(--info);
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
            gap: 0.25rem;
            align-items: center;
        }

        .rating-stars i {
            font-size: 1.25rem;
        }

        .rating-stars .filled {
            color: #F59E0B;
        }

        .rating-stars .empty {
            color: var(--gray-300);
        }

        /* Feedback Content */
        .feedback-content {
            background: var(--gray-50);
            border-left: 4px solid var(--primary);
            padding: 1.25rem;
            border-radius: 8px;
            position: relative;
        }

        .feedback-content .quote-icon {
            position: absolute;
            top: 1rem;
            right: 1rem;
            font-size: 2rem;
            color: var(--primary);
            opacity: 0.1;
        }

        .feedback-content p {
            margin: 0;
            font-size: 0.9375rem;
            line-height: 1.7;
            color: var(--gray-700);
        }

        /* Response Section */
        .response-section {
            background: rgba(16, 185, 129, 0.05);
            border-left: 4px solid var(--success);
            padding: 1.25rem;
            border-radius: 8px;
        }

        .response-header {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.75rem;
            font-size: 0.875rem;
            color: var(--gray-600);
        }

        .response-header i {
            color: var(--success);
        }

        .response-section p {
            margin: 0;
            font-size: 0.9375rem;
            line-height: 1.7;
            color: var(--gray-700);
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

        .btn-outline-success {
            background: white;
            color: var(--success);
            border: 1px solid var(--success);
        }

        .btn-outline-success:hover {
            background: var(--success);
            color: white;
        }

        .btn-link {
            background: none;
            border: none;
            color: var(--primary);
            padding: 0;
            text-decoration: none;
            cursor: pointer;
        }

        .btn-link:hover {
            text-decoration: underline;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
        }

        .action-buttons form {
            display: inline;
        }

        /* Quick Info */
        .quick-info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.875rem 0;
            border-bottom: 1px solid var(--gray-200);
        }

        .quick-info-item:last-child {
            border-bottom: none;
        }

        .quick-info-label {
            font-size: 0.875rem;
            color: var(--gray-600);
            font-weight: 500;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .layout-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .detail-container {
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

            .info-grid {
                grid-template-columns: 1fr;
            }

            .action-buttons {
                flex-direction: column;
            }

            .action-buttons .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>

<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>

<div class="detail-container">
    <!-- Page Header -->
    <div class="page-header">
        <div class="header-left">
            <div class="header-icon">
                <i class="fas fa-comment-dots"></i>
            </div>
            <div class="header-text">
                <h1>Feedback Details</h1>
                <div class="breadcrumb">
                    <a href="${pageContext.request.contextPath}/">Home</a>
                    <span class="breadcrumb-separator">/</span>
                    <a href="${pageContext.request.contextPath}/customer_supporter/feedback/management">Feedback List</a>
                    <span class="breadcrumb-separator">/</span>
                    <span>Feedback #${feedback.feedbackID}</span>
                </div>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/customer_supporter/feedback/management" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Back to List
        </a>
    </div>

    <!-- Alert Messages -->
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <span>${successMessage}</span>
        </div>
    </c:if>
    <c:if test="${empty successMessage and not empty sessionScope.successMessage}">
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <span>${sessionScope.successMessage}</span>
        </div>
        <c:remove var="successMessage" scope="session" />
    </c:if>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger">
            <i class="fas fa-times-circle"></i>
            <span>${errorMessage}</span>
        </div>
    </c:if>
    <c:if test="${empty errorMessage and not empty sessionScope.errorMessage}">
        <div class="alert alert-danger">
            <i class="fas fa-times-circle"></i>
            <span>${sessionScope.errorMessage}</span>
        </div>
        <c:remove var="errorMessage" scope="session" />
    </c:if>

    <div class="layout-grid">
        <!-- Main Content -->
        <div>
            <!-- Feedback Details Card -->
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">
                        <i class="fas fa-clipboard-list"></i>
                        Feedback Information
                    </h2>
                </div>
                <div class="card-body">
                    <div class="info-grid">
                        <div class="info-item">
                            <div class="info-label">Feedback ID</div>
                            <div class="info-value">
                                <span class="badge badge-primary">
                                    <i class="fas fa-hashtag"></i> ${feedback.feedbackID}
                                </span>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Request ID</div>
                            <div class="info-value">
                                <a href="${pageContext.request.contextPath}/customer_supporter/requests/detail?requestId=${feedback.requestID.foreignKeyValue}" class="btn-link">
                                    <span class="badge badge-info">
                                        <i class="fas fa-hashtag"></i> ${feedback.requestID.foreignKeyValue}
                                    </span>
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="info-grid">
                        <div class="info-item">
                            <div class="info-label">Customer Username</div>
                            <div class="info-value">
                                <i class="fas fa-user" style="color: var(--primary); margin-right: 0.5rem;"></i>
                                <strong>${feedback.customerID}</strong>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Rating</div>
                            <div class="info-value">
                                <div style="display: flex; align-items: center; gap: 1rem;">
                                    <div class="rating-stars">
                                        <c:forEach begin="1" end="5" var="i">
                                            <i class="fas fa-star ${i <= feedback.rating ? 'filled' : 'empty'}"></i>
                                        </c:forEach>
                                    </div>
                                    <span class="badge ${feedback.rating >= 4 ? 'badge-success' : feedback.rating == 3 ? 'badge-warning' : 'badge-danger'}">
                                        ${feedback.rating}/5
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="info-label">Feedback Date</div>
                        <div class="info-value">
                            <i class="fas fa-calendar" style="color: var(--gray-500); margin-right: 0.5rem;"></i>
                            ${feedback.feedbackDate}
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="info-label">Content</div>
                        <div class="feedback-content">
                            <i class="fas fa-quote-left quote-icon"></i>
                            <p>${feedback.content}</p>
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="info-label">Customer Feedback</div>
                        <div class="feedback-content">
                            <i class="fas fa-quote-left quote-icon"></i>
                            <p>${feedback.description}</p>
                        </div>
                    </div>

                    <c:if test="${not empty feedback.response}">
                        <div class="info-item">
                            <div class="info-label">Our Response</div>
                            <div class="response-section">
                                <div class="response-header">
                                    <i class="fas fa-reply"></i>
                                    <span>Responded on:
                                        <c:choose>
                                            <c:when test="${not empty feedback.responseDate}">
                                                ${feedback.responseDate}
                                            </c:when>
                                            <c:otherwise>N/A</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <p>${feedback.response}</p>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Actions Card -->
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">
                        <i class="fas fa-tasks"></i>
                        Actions
                    </h2>
                </div>
                <div class="card-body">
                    <div class="action-buttons">
                        <c:if test="${empty feedback.response}">
                            <form method="GET" action="${pageContext.request.contextPath}/feedback/respond">
                                <input type="hidden" name="requestId" value="${feedback.requestID.foreignKeyValue}">
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-reply"></i> Add Response
                                </button>
                            </form>
                        </c:if>

                        <c:if test="${not empty feedback.response}">
                            <form method="GET" action="${pageContext.request.contextPath}/feedback/respond">
                                <input type="hidden" name="requestId" value="${feedback.requestID.foreignKeyValue}">
                                <button type="submit" class="btn btn-outline-success">
                                    <i class="fas fa-edit"></i> Edit Response
                                </button>
                            </form>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sidebar -->
        <div>
            <!-- Quick Information Card -->
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">
                        <i class="fas fa-info-circle"></i>
                        Quick Information
                    </h2>
                </div>
                <div class="card-body" style="padding: 0;">
                    <div class="quick-info-item" style="padding: 1rem 1.5rem;">
                        <span class="quick-info-label">Response Status:</span>
                        <span class="badge ${not empty feedback.response ? 'badge-success' : 'badge-warning'}">
                            <i class="fas ${not empty feedback.response ? 'fa-check' : 'fa-clock'}"></i>
                            ${not empty feedback.response ? 'Responded' : 'Pending'}
                        </span>
                    </div>
                    <div class="quick-info-item" style="padding: 1rem 1.5rem;">
                        <span class="quick-info-label">Rating Level:</span>
                        <span class="badge ${feedback.rating >= 4 ? 'badge-success' : feedback.rating == 3 ? 'badge-warning' : 'badge-danger'}">
                            <i class="fas ${feedback.rating >= 4 ? 'fa-thumbs-up' : feedback.rating == 3 ? 'fa-meh' : 'fa-thumbs-down'}"></i>
                            ${feedback.rating >= 4 ? 'High' : feedback.rating == 3 ? 'Medium' : 'Low'}
                        </span>
                    </div>
                    <div class="quick-info-item" style="padding: 1rem 1.5rem;">
                        <span class="quick-info-label">Feedback ID:</span>
                        <strong style="color: var(--primary);">#${feedback.feedbackID}</strong>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
