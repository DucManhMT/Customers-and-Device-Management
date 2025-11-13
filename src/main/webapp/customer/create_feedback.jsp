<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Feedback - Share Your Experience</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; 
            min-height: 100vh;
            padding: 2rem 0;
        }
        
        .feedback-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 1rem;
        }
        
        .page-header {
            text-align: center;
            color: white;
            margin-bottom: 3rem;
            animation: fadeInDown 0.6s ease-out;
        }
        
        .page-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }
        
        .page-header p {
            font-size: 1.1rem;
            opacity: 0.95;
        }
        
        .main-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
            margin-bottom: 2rem;
            animation: fadeInUp 0.6s ease-out;
        }
        
        .card-header-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            border: none;
        }
        
        .card-header-custom h2 {
            font-size: 1.75rem;
            font-weight: 600;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .card-header-custom h2 i {
            font-size: 2rem;
        }
        
        .card-body-custom {
            padding: 2.5rem;
        }
        
        .alert-custom {
            border: none;
            border-radius: 12px;
            padding: 1rem 1.5rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            animation: slideInRight 0.5s ease-out;
        }
        
        .alert-custom i {
            font-size: 1.5rem;
        }
        
        .alert-success-custom {
            background: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%);
            color: #065f46;
        }
        
        .alert-danger-custom {
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            color: #7f1d1d;
        }
        
        .form-section {
            margin-bottom: 2rem;
        }
        
        .form-label-custom {
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 0.75rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.95rem;
        }
        
        .form-label-custom i {
            color: #667eea;
            font-size: 1.1rem;
        }
        
        .form-control-custom, .form-select-custom {
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            padding: 0.875rem 1.25rem;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            background: #f9fafb;
        }
        
        .form-control-custom:focus, .form-select-custom:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
            background: white;
            outline: none;
        }
        
        .user-info-badge {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 12px;
            padding: 1.25rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            height: 100%;
        }
        
        .user-info-badge i {
            font-size: 2rem;
            opacity: 0.9;
        }
        
        .user-info-content h6 {
            margin: 0;
            font-weight: 600;
            font-size: 1.1rem;
        }
        
        .user-info-content small {
            opacity: 0.8;
        }
        
        .star-rating-container {
            background: #f9fafb;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            padding: 1.5rem;
            text-align: center;
        }
        
        .star-rating {
            display: inline-flex;
            flex-direction: row-reverse;
            gap: 0.5rem;
            justify-content: center;
            font-size: 3rem;
        }
        
        .star-rating input {
            display: none;
        }
        
        .star-rating label {
            cursor: pointer;
            color: #d1d5db;
            transition: all 0.2s ease;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.1);
        }
        
        .star-rating label:hover,
        .star-rating label:hover ~ label,
        .star-rating input:checked ~ label {
            color: #fbbf24;
            transform: scale(1.1);
        }
        
        .rating-description {
            margin-top: 1rem;
            padding: 0.75rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
        }
        
        .rating-excellent {
            background: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%);
            color: #065f46;
        }
        
        .rating-good {
            background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
            color: #1e40af;
        }
        
        .rating-average {
            background: linear-gradient(135deg, #ffeaa7 0%, #fdcb6e 100%);
            color: #78350f;
        }
        
        .rating-poor {
            background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%);
            color: #7f1d1d;
        }
        
        .rating-default {
            background: #f3f4f6;
            color: #6b7280;
        }
        
        .char-counter {
            text-align: right;
            font-size: 0.875rem;
            color: #6b7280;
            margin-top: 0.5rem;
        }
        
        .char-counter.warning {
            color: #d97706;
            font-weight: 600;
        }
        
        .char-counter.danger {
            color: #dc2626;
            font-weight: 700;
        }
        
        .btn-custom {
            padding: 0.875rem 2rem;
            border-radius: 12px;
            font-weight: 600;
            border: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.95rem;
        }
        
        .btn-primary-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
        }
        
        .btn-outline-custom {
            background: white;
            color: #667eea;
            border: 2px solid #667eea;
        }
        
        .btn-outline-custom:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
        }
        
        .btn-reset-custom {
            background: white;
            color: #dc2626;
            border: 2px solid #dc2626;
        }
        
        .btn-reset-custom:hover {
            background: #dc2626;
            color: white;
            transform: translateY(-2px);
        }
        
        .feedback-table-container {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border: 1px solid #f0f0f0;
        }
        
        .table-custom {
            margin: 0;
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }
        
        .table-custom thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            position: sticky;
            top: 0;
            z-index: 10;
        }
        
        .table-custom thead th {
            padding: 1.25rem 1rem;
            font-weight: 700;
            border: none;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 1px;
            text-align: center;
            white-space: nowrap;
        }
        
        .table-custom thead th:first-child {
            border-radius: 0;
        }
        
        .table-custom thead th:last-child {
            border-radius: 0;
        }
        
        .table-custom tbody tr {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border-bottom: 1px solid #f3f4f6;
            background: white;
        }
        
        .table-custom tbody tr:hover {
            background: linear-gradient(to right, #f9fafb 0%, #ffffff 100%);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.1);
            transform: translateX(4px);
        }
        
        .table-custom tbody tr:last-child {
            border-bottom: none;
        }
        
        .table-custom tbody td {
            padding: 1.25rem 1rem;
            vertical-align: middle;
            text-align: center;
            font-size: 0.9rem;
            color: #374151;
        }
        
        .table-custom tbody td:first-child {
            font-weight: 700;
            color: #667eea;
            font-size: 1rem;
        }
        
        .badge-service {
            padding: 0.6rem 1.25rem;
            border-radius: 25px;
            font-weight: 700;
            font-size: 0.8rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            display: inline-block;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
        }
        
        .badge-service:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(102, 126, 234, 0.4);
        }
        
        .rating-container {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
            padding: 0.5rem;
            background: linear-gradient(135deg, #fffbeb 0%, #fef3c7 100%);
            border-radius: 12px;
            margin: 0 auto;
            width: fit-content;
        }
        
        .star-group {
            display: flex;
            gap: 0.15rem;
        }
        
        .star-display {
            color: #fbbf24;
            font-size: 1.3rem;
            text-shadow: 0 2px 4px rgba(251, 191, 36, 0.3);
            filter: drop-shadow(0 0 2px rgba(251, 191, 36, 0.5));
        }
        
        .star-muted {
            color: #e5e7eb;
            font-size: 1.3rem;
        }
        
        .rating-score {
            font-weight: 700;
            color: #92400e;
            font-size: 0.9rem;
            background: white;
            padding: 0.25rem 0.75rem;
            border-radius: 8px;
        }
        
        .review-cell, .response-cell {
            max-width: 250px;
            padding: 0.75rem !important;
        }
        
        .review-content, .response-content {
            background: #f9fafb;
            padding: 0.75rem 1rem;
            border-radius: 10px;
            border-left: 3px solid #667eea;
            text-align: left;
            font-size: 0.85rem;
            line-height: 1.5;
            color: #4b5563;
        }
        
        .response-content {
            border-left-color: #10b981;
            background: linear-gradient(135deg, #ecfdf5 0%, #d1fae5 100%);
        }
        
        .response-content i {
            color: #10b981;
            margin-right: 0.5rem;
        }
        
        .no-review, .no-response {
            font-style: italic;
            color: #9ca3af;
            font-size: 0.85rem;
        }
        
        .badge-pending {
            background: linear-gradient(135deg, #fbbf24 0%, #f59e0b 100%);
            color: white;
            padding: 0.4rem 1rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.8rem;
            box-shadow: 0 2px 8px rgba(251, 191, 36, 0.3);
        }
        
        .date-cell {
            font-weight: 500;
            color: #6b7280;
            font-size: 0.85rem;
            white-space: nowrap;
        }
        
        .btn-view-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 0.65rem 1.5rem;
            border-radius: 10px;
            font-weight: 700;
            font-size: 0.85rem;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .btn-view-custom i {
            font-size: 1rem;
        }
        
        .btn-view-custom:hover {
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.5);
            color: white;
        }
        
        .btn-view-custom:active {
            transform: translateY(-1px) scale(1.02);
        }
        
        /* Scrollbar styling for table */
        .feedback-table-container {
            overflow-x: auto;
        }
        
        .feedback-table-container::-webkit-scrollbar {
            height: 8px;
        }
        
        .feedback-table-container::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }
        
        .feedback-table-container::-webkit-scrollbar-thumb {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 10px;
        }
        
        .feedback-table-container::-webkit-scrollbar-thumb:hover {
            background: linear-gradient(135deg, #5568d3 0%, #66348e 100%);
        }
        
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: #6b7280;
        }
        
        .empty-state i {
            font-size: 5rem;
            color: #d1d5db;
            margin-bottom: 1.5rem;
        }
        
        .empty-state h4 {
            color: #374151;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        
        .pagination-custom {
            display: flex;
            gap: 0.5rem;
            justify-content: center;
            margin-top: 2rem;
        }
        
        .pagination-custom .page-link {
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            padding: 0.5rem 1rem;
            color: #667eea;
            font-weight: 600;
            transition: all 0.2s ease;
        }
        
        .pagination-custom .page-link:hover {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }
        
        .pagination-custom .page-item.active .page-link {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-color: #667eea;
            color: white;
        }
        
        .form-text-custom {
            color: #6b7280;
            font-size: 0.875rem;
            margin-top: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .form-text-custom i {
            color: #667eea;
        }
        
        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes slideInRight {
            from {
                opacity: 0;
                transform: translateX(30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        
        @media (max-width: 768px) {
            .page-header h1 {
                font-size: 1.75rem;
            }
            
            .card-body-custom {
                padding: 1.5rem;
            }
            
            .star-rating {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
<jsp:include page="../components/header.jsp" />
<jsp:include page="../components/customer_sidebar.jsp"/>

<div class="feedback-container">

<div class="feedback-container">
    <!-- Page Header -->
    <div class="page-header">
        <h1><i class="bi bi-chat-heart"></i> Customer Feedback</h1>
        <p>Share your experience and help us improve our service</p>
    </div>

    <!-- Feedback Form Card -->
    <div class="main-card">
        <div class="card-header-custom">
            <h2><i class="bi bi-pencil-square"></i> Create New Feedback</h2>
        </div>
        <div class="card-body-custom">
            <!-- Alert Messages -->
            <c:if test="${not empty successMessage}">
                <div class="alert-custom alert-success-custom">
                    <i class="bi bi-check-circle-fill"></i>
                    <span>${successMessage}</span>
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert-custom alert-danger-custom">
                    <i class="bi bi-exclamation-triangle-fill"></i>
                    <span>${errorMessage}</span>
                </div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>

            <form method="post" action="../feedback/create" id="feedbackForm">
                <input type="hidden" name="username" value="${currentUsername}">
                <input type="hidden" name="requestId" value="${requestId}">

                <div class="row g-4">
                    <!-- Service Type Selection -->
                    <div class="col-md-8">
                        <div class="form-section">
                            <label for="feedbackType" class="form-label-custom">
                                <i class="bi bi-tag"></i> Service Type Evaluation
                            </label>
                            <select class="form-select form-select-custom" id="feedbackType" name="feedbackType" required onchange="toggleCustomInput()">
                                <option value="">-- Select service type to evaluate --</option>
                                <option value="repair_quality">🔧 Repair and Warranty Quality</option>
                                <option value="service_quality">⭐ Service Quality</option>
                                <option value="staff_attitude">👥 Staff Attitude</option>
                                <option value="other">📝 Other (custom input)</option>
                            </select>
                            <div class="form-text-custom">
                                <i class="bi bi-info-circle"></i>
                                <span>Choose the service aspect you want to evaluate</span>
                            </div>
                        </div>
                    </div>

                    <!-- User Information -->
                    <div class="col-md-4">
                        <div class="form-section">
                            <label class="form-label-custom">
                                <i class="bi bi-person-circle"></i> Customer Information
                            </label>
                            <div class="user-info-badge">
                                <i class="bi bi-person-check-fill"></i>
                                <div class="user-info-content">
                                    <h6>${currentUsername}</h6>
                                    <small>Verified Customer</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Custom Content Input (Hidden by default) -->
                <div class="form-section" id="customContentDiv" style="display: none;">
                    <label for="customContent" class="form-label-custom">
                        <i class="bi bi-pencil"></i> Custom Feedback Content
                    </label>
                    <input type="text" class="form-control form-control-custom" id="customContent" name="customContent"
                           placeholder="Enter your specific feedback content..." maxlength="255">
                    <div class="form-text-custom">
                        <i class="bi bi-lightbulb"></i>
                        <span>Describe what you want to feedback about</span>
                    </div>
                </div>

                <!-- Rating Section -->
                <div class="form-section">
                    <label class="form-label-custom">
                        <i class="bi bi-star-fill"></i> Service Quality Rating
                    </label>
                    <div class="star-rating-container">
                        <div class="star-rating">
                            <input type="radio" id="star5" name="rating" value="5" required>
                            <label for="star5" title="Excellent">★</label>
                            <input type="radio" id="star4" name="rating" value="4">
                            <label for="star4" title="Good">★</label>
                            <input type="radio" id="star3" name="rating" value="3">
                            <label for="star3" title="Average">★</label>
                            <input type="radio" id="star2" name="rating" value="2">
                            <label for="star2" title="Poor">★</label>
                            <input type="radio" id="star1" name="rating" value="1">
                            <label for="star1" title="Very Poor">★</label>
                        </div>
                        <div id="ratingDescription" class="rating-description rating-default">
                            Please select your rating
                        </div>
                    </div>
                </div>

                <!-- Detailed Review -->
                <div class="form-section">
                    <label for="description" class="form-label-custom">
                        <i class="bi bi-chat-left-text"></i> Your Detailed Review
                    </label>
                    <textarea class="form-control form-control-custom" id="description" name="description" rows="5"
                              placeholder="Share your experience: What did you like? What could be improved? Any suggestions for us?"
                              maxlength="255"></textarea>
                    <div class="char-counter">
                        <span id="charCount">0</span> / 255 characters
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="d-flex justify-content-between flex-wrap gap-3 mt-4">
                    <a href="${pageContext.request.contextPath}/customer/customer_actioncenter" class="btn-custom btn-outline-custom">
                        <i class="bi bi-arrow-left"></i> Back to Dashboard
                    </a>
                    <div class="d-flex gap-2">
                        <button type="reset" class="btn-custom btn-reset-custom">
                            <i class="bi bi-arrow-clockwise"></i> Reset Form
                        </button>
                        <button type="submit" class="btn-custom btn-primary-custom">
                            <i class="bi bi-send"></i> Submit Feedback
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Recent Feedbacks Card -->
    <div class="main-card">
        <div class="card-header-custom">
            <h2><i class="bi bi-clock-history"></i> Your Recent Feedbacks</h2>
        </div>
        <div class="card-body-custom">
            <c:if test="${not empty recentFeedbacks}">
                <div class="feedback-table-container">
                    <table class="table table-custom">
                        <thead>
                        <tr>
                            <th style="width: 5%">#</th>
                            <th style="width: 20%">Feedback Type</th>
                            <th style="width: 15%">Rating</th>
                            <th style="width: 25%">Review</th>
                            <th style="width: 20%">Response</th>
                            <th style="width: 15%">Date</th>
                            <th style="width: 10%">Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${recentFeedbacks}" var="feedback" varStatus="status">
                            <tr>
                                <td>${status.index + 1}</td>
                                <td>
                                    <span class="badge-service">${feedback.content}</span>
                                </td>
                                <td>
                                    <div class="rating-container">
                                        <div class="star-group">
                                            <c:forEach begin="1" end="5" var="i">
                                                <span class="${i <= feedback.rating ? 'star-display' : 'star-muted'}">★</span>
                                            </c:forEach>
                                        </div>
                                        <span class="rating-score">${feedback.rating}/5</span>
                                    </div>
                                </td>
                                <td class="review-cell">
                                    <c:choose>
                                        <c:when test="${not empty feedback.description}">
                                            <div class="review-content text-truncate" title="${feedback.description}">
                                                ${feedback.description}
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="no-review">No review provided</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="response-cell">
                                    <c:choose>
                                        <c:when test="${not empty feedback.response}">
                                            <div class="response-content text-truncate" title="${feedback.response}">
                                                <i class="bi bi-reply-fill"></i>${feedback.response}
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-pending">
                                                <i class="bi bi-clock"></i> Pending
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="date-cell">
                                    <i class="bi bi-calendar-event"></i> ${feedback.feedbackDate}
                                </td>
                                <td>
                                    <form method="get" action="../feedback/view" style="display: inline;">
                                        <input type="hidden" name="requestId" value="${feedback.requestID.getForeignKeyValue()}">
                                        <button type="submit" class="btn-view-custom">
                                            <i class="bi bi-eye-fill"></i> View
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Feedback pagination" class="mt-4">
                        <div class="row align-items-center g-3">
                            <div class="col-md-6">
                                <div class="d-flex align-items-center gap-2">
                                    <label for="recordsPerPage" class="form-label mb-0">Show:</label>
                                    <select id="recordsPerPage" class="form-select form-select-sm" style="width: auto;" onchange="changePageSize()">
                                        <option value="5" ${recordsPerPage == 5 ? 'selected' : ''}>5</option>
                                        <option value="10" ${recordsPerPage == 10 ? 'selected' : ''}>10</option>
                                        <option value="15" ${recordsPerPage == 15 ? 'selected' : ''}>15</option>
                                        <option value="20" ${recordsPerPage == 20 ? 'selected' : ''}>20</option>
                                    </select>
                                    <span class="text-muted">per page</span>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <ul class="pagination pagination-custom mb-0 justify-content-end"
                                    <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                        <c:choose>
                                            <c:when test="${currentPage <= 1}">
                                                <span class="page-link"><i class="bi bi-chevron-left"></i></span>
                                            </c:when>
                                            <c:otherwise>
                                                <a class="page-link" href="?page=${currentPage - 1}&recordsPerPage=${recordsPerPage}">
                                                    <i class="bi bi-chevron-left"></i>
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </li>

                                    <c:choose>
                                        <c:when test="${totalPages <= 7}">
                                            <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                                <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                                    <a class="page-link" href="?page=${pageNum}&recordsPerPage=${recordsPerPage}">${pageNum}</a>
                                                </li>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <c:choose>
                                                <c:when test="${currentPage <= 4}">
                                                    <c:forEach begin="1" end="5" var="pageNum">
                                                        <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                                            <a class="page-link" href="?page=${pageNum}&recordsPerPage=${recordsPerPage}">${pageNum}</a>
                                                        </li>
                                                    </c:forEach>
                                                    <li class="page-item disabled"><span class="page-link">...</span></li>
                                                    <li class="page-item">
                                                        <a class="page-link" href="?page=${totalPages}&recordsPerPage=${recordsPerPage}">${totalPages}</a>
                                                    </li>
                                                </c:when>
                                                <c:when test="${currentPage >= totalPages - 3}">
                                                    <li class="page-item">
                                                        <a class="page-link" href="?page=1&recordsPerPage=${recordsPerPage}">1</a>
                                                    </li>
                                                    <li class="page-item disabled"><span class="page-link">...</span></li>
                                                    <c:forEach begin="${totalPages - 4}" end="${totalPages}" var="pageNum">
                                                        <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                                            <a class="page-link" href="?page=${pageNum}&recordsPerPage=${recordsPerPage}">${pageNum}</a>
                                                        </li>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <li class="page-item">
                                                        <a class="page-link" href="?page=1&recordsPerPage=${recordsPerPage}">1</a>
                                                    </li>
                                                    <li class="page-item disabled"><span class="page-link">...</span></li>
                                                    <c:forEach begin="${currentPage - 1}" end="${currentPage + 1}" var="pageNum">
                                                        <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                                            <a class="page-link" href="?page=${pageNum}&recordsPerPage=${recordsPerPage}">${pageNum}</a>
                                                        </li>
                                                    </c:forEach>
                                                    <li class="page-item disabled"><span class="page-link">...</span></li>
                                                    <li class="page-item">
                                                        <a class="page-link" href="?page=${totalPages}&recordsPerPage=${recordsPerPage}">${totalPages}</a>
                                                    </li>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:otherwise>
                                    </c:choose>

                                    <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                        <c:choose>
                                            <c:when test="${currentPage >= totalPages}">
                                                <span class="page-link"><i class="bi bi-chevron-right"></i></span>
                                            </c:when>
                                            <c:otherwise>
                                                <a class="page-link" href="?page=${currentPage + 1}&recordsPerPage=${recordsPerPage}">
                                                    <i class="bi bi-chevron-right"></i>
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </li>
                                </ul>
                            </div>
                        </div>

                        <div class="text-center mt-3">
                            <small class="text-muted">
                                Page ${currentPage} of ${totalPages}
                                <c:if test="${not empty totalRecords}">
                                    | Total: ${totalRecords} feedbacks
                                </c:if>
                            </small>
                        </div>
                    </nav>
                </c:if>
            </c:if>

            <!-- Empty State -->
            <c:if test="${empty recentFeedbacks}">
                <div class="empty-state">
                    <i class="bi bi-chat-dots"></i>
                    <h4>No Feedback Yet</h4>
                    <p>You haven't submitted any feedback. Use the form above to share your experience!</p>
                </div>
            </c:if>
        </div>
    </div>
</div>

<script src="../css/bootstrap/bootstrap-5.3.8-dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Form validation
    document.getElementById('feedbackForm').addEventListener('submit', function(e) {
        const ratingChecked = document.querySelector('input[name="rating"]:checked');
        if (!ratingChecked) {
            e.preventDefault();
            alert('Please select a rating before submitting your feedback!');
            return false;
        }
    });

    // Toggle custom input field
    function toggleCustomInput() {
        const feedbackType = document.getElementById('feedbackType').value;
        const customDiv = document.getElementById('customContentDiv');
        const customInput = document.getElementById('customContent');

        if (feedbackType === 'other') {
            customDiv.style.display = 'block';
            customInput.required = true;
        } else {
            customDiv.style.display = 'none';
            customInput.required = false;
            customInput.value = '';
        }
    }

    // Star rating functionality
    const starInputs = document.querySelectorAll('input[name="rating"]');
    const ratingDescription = document.getElementById('ratingDescription');

    const ratingConfig = {
        5: { text: '⭐ Excellent - Outstanding Service!', class: 'rating-excellent' },
        4: { text: '😊 Good - Quality Service', class: 'rating-good' },
        3: { text: '😐 Average - Acceptable Service', class: 'rating-average' },
        2: { text: '😕 Poor - Needs Improvement', class: 'rating-poor' },
        1: { text: '😞 Very Poor - Unsatisfied', class: 'rating-poor' }
    };

    starInputs.forEach(input => {
        input.addEventListener('change', function() {
            const rating = parseInt(this.value);
            const config = ratingConfig[rating];
            
            ratingDescription.textContent = config.text;
            ratingDescription.className = 'rating-description ' + config.class;
        });
    });

    // Character counter for description
    const description = document.getElementById('description');
    const charCount = document.getElementById('charCount');

    description.addEventListener('input', function() {
        const currentLength = this.value.length;
        charCount.textContent = currentLength;
        
        // Remove all classes first
        charCount.classList.remove('warning', 'danger');
        
        // Add appropriate class based on length
        if (currentLength > 230) {
            charCount.classList.add('danger');
        } else if (currentLength > 200) {
            charCount.classList.add('warning');
        }
    });

    // Reset form handler
    document.querySelector('button[type="reset"]').addEventListener('click', function() {
        setTimeout(() => {
            ratingDescription.textContent = 'Please select your rating';
            ratingDescription.className = 'rating-description rating-default';
            charCount.textContent = '0';
            charCount.classList.remove('warning', 'danger');
            toggleCustomInput();
        }, 10);
    });

    // Change page size
    function changePageSize() {
        const recordsPerPage = document.getElementById('recordsPerPage').value;
        window.location.href = `?page=1&recordsPerPage=${recordsPerPage}`;
    }

    // Smooth scroll animation
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        });
    });
</script>
</body>
</html>