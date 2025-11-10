<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback Details - CRM System</title>
    <link href="../css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #4F46E5;
            --primary-dark: #4338CA;
            --primary-light: #818CF8;
            --secondary: #10B981;
            --secondary-dark: #059669;
            --warning: #F59E0B;
            --danger: #EF4444;
            --info: #3B82F6;
            --dark: #1F2937;
            --gray-50: #F9FAFB;
            --gray-100: #F3F4F6;
            --gray-200: #E5E7EB;
            --gray-300: #D1D5DB;
            --gray-600: #4B5563;
            --gray-700: #374151;
            --gray-900: #111827;
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
        .feedback-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }

        /* Header */
        .feedback-header {
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            margin-bottom: 1.5rem;
        }

        .header-content {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .header-title {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .header-icon {
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

        .header-title h1 {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--gray-900);
            margin: 0;
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
            gap: 0.5rem;
            text-decoration: none;
        }

        .btn-secondary {
            background: var(--gray-100);
            color: var(--gray-700);
        }

        .btn-secondary:hover {
            background: var(--gray-200);
        }

        /* Grid Layout */
        .feedback-grid {
            display: grid;
            grid-template-columns: 1fr 320px;
            gap: 1.5rem;
        }

        /* Card */
        .card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin-bottom: 1.5rem;
        }

        .card-body {
            padding: 1.5rem;
        }

        .card-title {
            font-size: 1.125rem;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 1.25rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        /* Info Items */
        .info-item {
            display: flex;
            align-items: flex-start;
            gap: 1rem;
            padding: 1rem;
            background: var(--gray-50);
            border-radius: 8px;
            margin-bottom: 0.75rem;
        }

        .info-icon {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            font-size: 1rem;
        }

        .info-icon.primary {
            background: rgba(79, 70, 229, 0.1);
            color: var(--primary);
        }

        .info-icon.secondary {
            background: rgba(16, 185, 129, 0.1);
            color: var(--secondary);
        }

        .info-icon.warning {
            background: rgba(245, 158, 11, 0.1);
            color: var(--warning);
        }

        .info-icon.info {
            background: rgba(59, 130, 246, 0.1);
            color: var(--info);
        }

        .info-content {
            flex: 1;
        }

        .info-label {
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--gray-600);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 0.25rem;
        }

        .info-value {
            font-size: 0.9375rem;
            color: var(--gray-900);
            font-weight: 500;
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
            color: var(--secondary);
        }

        .badge-warning {
            background: rgba(245, 158, 11, 0.1);
            color: var(--warning);
        }

        .badge-danger {
            background: rgba(239, 68, 68, 0.1);
            color: var(--danger);
        }

        .badge-info {
            background: rgba(59, 130, 246, 0.1);
            color: var(--info);
        }

        /* Rating */
        .rating-stars {
            display: flex;
            gap: 0.25rem;
        }

        .rating-stars i {
            font-size: 1rem;
        }

        .star-filled {
            color: #FBBF24;
        }

        .star-empty {
            color: var(--gray-300);
        }

        .rating-value {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 600;
        }

        /* Content Box */
        .content-box {
            background: var(--gray-50);
            border-radius: 8px;
            padding: 1.25rem;
            border-left: 3px solid var(--primary);
            margin-top: 0.75rem;
        }

        .content-box p {
            margin: 0;
            color: var(--gray-700);
            line-height: 1.7;
        }

        /* Response Box */
        .response-box {
            background: rgba(16, 185, 129, 0.05);
            border-radius: 8px;
            padding: 1.25rem;
            border-left: 3px solid var(--secondary);
            margin-top: 0.75rem;
        }

        .response-date {
            font-size: 0.75rem;
            color: var(--gray-600);
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.375rem;
        }

        .response-text {
            margin: 0;
            color: var(--gray-700);
            line-height: 1.7;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
        }

        .btn-edit {
            background: var(--warning);
            color: white;
        }

        .btn-edit:hover {
            background: #D97706;
            color: white;
        }

        .btn-delete {
            background: var(--danger);
            color: white;
        }

        .btn-delete:hover {
            background: #DC2626;
            color: white;
        }

        /* Sidebar */
        .sidebar .card {
            position: sticky;
            top: 1.5rem;
        }

        /* Feedback Info Card - Right side info panel */
        .feedback-info-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            position: sticky;
            top: 1.5rem;
        }

        .feedback-info-body {
            padding: 1.5rem;
        }

        .feedback-info-title {
            font-size: 1.125rem;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 1.25rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .feedback-stat-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.875rem;
            background: var(--gray-50);
            border-radius: 8px;
            margin-bottom: 0.75rem;
        }

        .feedback-stat-icon {
            width: 36px;
            height: 36px;
            background: linear-gradient(135deg, var(--primary), var(--primary-light));
            color: white;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.875rem;
        }

        .feedback-stat-content {
            flex: 1;
        }

        .feedback-stat-label {
            font-size: 0.75rem;
            color: var(--gray-600);
            margin-bottom: 0.125rem;
        }

        .feedback-stat-value {
            font-size: 1rem;
            font-weight: 700;
            color: var(--gray-900);
        }

        .stat-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.875rem;
            background: var(--gray-50);
            border-radius: 8px;
            margin-bottom: 0.75rem;
        }

        .stat-icon {
            width: 36px;
            height: 36px;
            background: linear-gradient(135deg, var(--primary), var(--primary-light));
            color: white;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.875rem;
        }

        .stat-content {
            flex: 1;
        }

        .stat-label {
            font-size: 0.75rem;
            color: var(--gray-600);
            margin-bottom: 0.125rem;
        }

        .stat-value {
            font-size: 1rem;
            font-weight: 700;
            color: var(--gray-900);
        }

        /* Divider */
        .divider {
            height: 1px;
            background: var(--gray-200);
            margin: 1.25rem 0;
        }

        /* Link Button */
        .btn-link {
            background: none;
            border: none;
            color: var(--primary);
            font-weight: 600;
            padding: 0;
            cursor: pointer;
            text-decoration: none;
        }

        .btn-link:hover {
            color: var(--primary-dark);
            text-decoration: underline;
        }

        /* Responsive */
        @media (max-width: 992px) {
            .feedback-grid {
                grid-template-columns: 1fr;
            }

            .feedback-info-card {
                position: relative;
                top: 0;
            }
        }

        @media (max-width: 640px) {
            .feedback-container {
                padding: 1rem 0.75rem;
            }

            .feedback-header {
                padding: 1rem;
            }

            .header-content {
                flex-direction: column;
                align-items: stretch;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }

            .action-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>

<jsp:include page="../components/header.jsp" />
<jsp:include page="../components/sidebar.jsp"/>

<div class="feedback-container">
    <div class="feedback-header">
        <div class="header-content">
            <div class="header-title">
                <div class="header-icon">
                    <i class="fas fa-comments"></i>
                </div>
                <h1>Feedback Details</h1>
            </div>
            <form method="get" action="${pageContext.request.contextPath}/customer/requests">
                <button type="submit" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i>
                    Back to List
                </button>
            </form>
        </div>
    </div>

    <!-- Grid -->
    <div class="feedback-grid">
        <!-- Main Content -->
        <div class="main-content">
            <!-- Feedback Information Card -->
            <div class="card">
                <div class="card-body">
                    <h2 class="card-title">
                        <i class="fas fa-comment-dots"></i>
                        Feedback Information
                    </h2>

                    <!-- Feedback ID & Request ID -->
                    <div class="info-item">
                        <div class="info-icon primary">
                            <i class="fas fa-fingerprint"></i>
                        </div>
                        <div class="info-content">
                            <div class="info-label">Feedback ID</div>
                            <div class="info-value">
                                <span class="badge badge-primary">#${feedback.feedbackID}</span>
                            </div>
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="info-icon info">
                            <i class="fas fa-link"></i>
                        </div>
                        <div class="info-content">
                            <div class="info-label">Related Request</div>
                            <div class="info-value">
                                <form method="get" action="${pageContext.request.contextPath}/customer/requests/detail" style="display:inline;">
                                    <input type="hidden" name="requestId" value="${feedback.requestID.foreignKeyValue}"/>
                                    <button type="submit" class="btn-link">
                                        <span class="badge badge-info">#${feedback.requestID.foreignKeyValue}</span>
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Customer -->
                    <div class="info-item">
                        <div class="info-icon secondary">
                            <i class="fas fa-user"></i>
                        </div>
                        <div class="info-content">
                            <div class="info-label">Customer</div>
                            <div class="info-value">${feedback.customerID}</div>
                        </div>
                    </div>

                    <!-- Rating -->
                    <div class="info-item">
                        <div class="info-icon warning">
                            <i class="fas fa-star"></i>
                        </div>
                        <div class="info-content">
                            <div class="info-label">Rating</div>
                            <div class="info-value">
                                <div class="rating-value">
                                    <div class="rating-stars">
                                        <c:forEach begin="1" end="5" var="i">
                                            <i class="fas fa-star ${i <= feedback.rating ? 'star-filled' : 'star-empty'}"></i>
                                        </c:forEach>
                                    </div>
                                    <span class="badge ${feedback.rating >= 4 ? 'badge-success' : feedback.rating == 3 ? 'badge-warning' : 'badge-danger'}">
                                        ${feedback.rating}/5
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Feedback Date -->
                    <div class="info-item">
                        <div class="info-icon info">
                            <i class="fas fa-calendar-alt"></i>
                        </div>
                        <div class="info-content">
                            <div class="info-label">Feedback Date</div>
                            <div class="info-value">
                                <i class="far fa-clock"></i> ${feedback.feedbackDate}
                            </div>
                        </div>
                    </div>

                    <div class="divider"></div>

                    <!-- Content Section -->
                    <h6 style="font-weight: 700; color: var(--gray-900); margin-bottom: 0.5rem;">
                        <i class="fas fa-align-left"></i> Feedback Content
                    </h6>
                    <div class="content-box">
                        <p>${feedback.content}</p>
                    </div>

                    <!-- Description Section -->
                    <h6 style="font-weight: 700; color: var(--gray-900); margin-bottom: 0.5rem; margin-top: 1.25rem;">
                        <i class="fas fa-file-alt"></i> Customer Feedback
                    </h6>
                    <div class="content-box">
                        <p>${feedback.description}</p>
                    </div>

                    <!-- Response Section -->
                    <c:if test="${not empty feedback.response}">
                        <h6 style="font-weight: 700; color: var(--gray-900); margin-bottom: 0.5rem; margin-top: 1.25rem;">
                            <i class="fas fa-reply"></i> Our Response
                        </h6>
                        <div class="response-box">
                            <div class="response-date">
                                <i class="fas fa-check-circle"></i>
                                Responded on ${feedback.responseDate}
                            </div>
                            <p class="response-text">${feedback.response}</p>
                        </div>
                    </c:if>

                    <div class="divider"></div>

                    <!-- Action Buttons -->
                    <h6 style="font-weight: 700; color: var(--gray-900); margin-bottom: 0.75rem;">
                        <i class="fas fa-tools"></i> Quick Actions
                    </h6>
                    <div class="action-buttons">
                        <form method="get" action="${pageContext.request.contextPath}/feedback/edit" style="display: inline;">
                            <input type="hidden" name="feedbackId" value="${feedback.feedbackID}">
                            <button type="submit" class="btn btn-edit">
                                <i class="fas fa-edit"></i> Edit Feedback
                            </button>
                        </form>

                        <form method="post" action="${pageContext.request.contextPath}/feedback/delete" style="display: inline;">
                            <input type="hidden" name="feedbackId" value="${feedback.feedbackID}">
                            <button type="submit" class="btn btn-delete"
                                    onclick="return confirm('Are you sure you want to delete this feedback?');">
                                <i class="fas fa-trash-alt"></i> Delete Feedback
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Feedback Info Panel -->
        <div class="feedback-info-panel">
            <div class="feedback-info-card">
                <div class="feedback-info-body">
                    <h2 class="feedback-info-title">
                        <i class="fas fa-info-circle"></i>
                        Quick Information
                    </h2>

                    <!-- Response Status -->
                    <div class="feedback-stat-item">
                        <div class="feedback-stat-icon">
                            <i class="fas ${not empty feedback.response ? 'fa-check-circle' : 'fa-clock'}"></i>
                        </div>
                        <div class="feedback-stat-content">
                            <div class="feedback-stat-label">Response Status</div>
                            <div class="feedback-stat-value">
                                <span class="badge ${not empty feedback.response ? 'badge-success' : 'badge-warning'}">
                                    ${not empty feedback.response ? 'Responded' : 'Pending'}
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- Rating Level -->
                    <div class="feedback-stat-item">
                        <div class="feedback-stat-icon">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <div class="feedback-stat-content">
                            <div class="feedback-stat-label">Rating Level</div>
                            <div class="feedback-stat-value">
                                <span class="badge ${feedback.rating >= 4 ? 'badge-success' : feedback.rating == 3 ? 'badge-warning' : 'badge-danger'}">
                                    ${feedback.rating >= 4 ? 'Excellent' : feedback.rating == 3 ? 'Good' : 'Needs Improvement'}
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="divider"></div>

                    <!-- Statistics -->
                    <h6 style="font-weight: 700; color: var(--gray-900); margin-bottom: 0.75rem;">
                        <i class="fas fa-chart-bar"></i> Statistics
                    </h6>
                    
                    <div class="feedback-stat-item">
                        <div class="feedback-stat-icon">
                            <i class="fas fa-star"></i>
                        </div>
                        <div class="feedback-stat-content">
                            <div class="feedback-stat-label">Rating Score</div>
                            <div class="feedback-stat-value">${feedback.rating} / 5</div>
                        </div>
                    </div>

                    <div class="feedback-stat-item">
                        <div class="feedback-stat-icon">
                            <i class="fas fa-percentage"></i>
                        </div>
                        <div class="feedback-stat-content">
                            <div class="feedback-stat-label">Satisfaction</div>
                            <div class="feedback-stat-value">${feedback.rating * 20}%</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
