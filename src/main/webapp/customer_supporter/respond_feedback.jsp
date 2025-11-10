<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Respond to Feedback</title>
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

        .respond-container {
            max-width: 900px;
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
            background: linear-gradient(135deg, var(--success), #059669);
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

        /* Form Elements */
        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            font-size: 0.875rem;
            font-weight: 600;
            color: var(--gray-700);
            margin-bottom: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .form-value {
            font-size: 1rem;
            color: var(--gray-900);
            padding: 0.75rem;
            background: var(--gray-50);
            border-radius: 8px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1.5rem;
            margin-bottom: 1.5rem;
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

        .rating-value {
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
        }

        /* Feedback Box */
        .feedback-box {
            background: var(--gray-50);
            border-left: 4px solid var(--primary);
            padding: 1rem;
            border-radius: 8px;
            position: relative;
            margin-bottom: 1.5rem;
        }

        .feedback-box .quote-icon {
            position: absolute;
            top: 0.75rem;
            right: 0.75rem;
            font-size: 1.5rem;
            color: var(--primary);
            opacity: 0.1;
        }

        .feedback-box p {
            margin: 0;
            font-size: 0.9375rem;
            line-height: 1.7;
            color: var(--gray-700);
        }

        /* Textarea */
        .form-textarea {
            width: 100%;
            min-height: 180px;
            padding: 0.875rem;
            font-size: 0.9375rem;
            font-family: inherit;
            color: var(--gray-900);
            background: white;
            border: 2px solid var(--gray-200);
            border-radius: 8px;
            resize: vertical;
            transition: all 0.2s;
        }

        .form-textarea:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
        }

        .form-hint {
            font-size: 0.875rem;
            color: var(--gray-500);
            margin-top: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.375rem;
        }

        .char-counter {
            font-size: 0.875rem;
            color: var(--gray-500);
            margin-top: 0.5rem;
            text-align: right;
        }

        .char-counter.warning {
            color: var(--warning);
        }

        .char-counter.danger {
            color: var(--danger);
        }

        /* Buttons */
        .btn {
            padding: 0.625rem 1.5rem;
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

        .btn-outline-secondary {
            background: white;
            color: var(--gray-700);
            border: 1px solid var(--gray-300);
        }

        .btn-outline-secondary:hover {
            background: var(--gray-50);
        }

        .form-actions {
            display: flex;
            gap: 0.75rem;
            padding-top: 1rem;
            border-top: 1px solid var(--gray-200);
            margin-top: 1.5rem;
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

        .badge-warning {
            background: rgba(245, 158, 11, 0.1);
            color: #92400e;
        }

        .badge-success {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .respond-container {
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

            .form-actions {
                flex-direction: column;
            }

            .form-actions .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>

<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>

<div class="respond-container">
    <!-- Page Header -->
    <div class="page-header">
        <div class="header-left">
            <div class="header-icon">
                <i class="fas fa-reply"></i>
            </div>
            <div class="header-text">
                <h1>Respond to Feedback</h1>
                
            </div>
        </div>
    </div>

    <!-- Feedback Information Card -->
    <div class="card">
        <div class="card-header">
            <h2 class="card-title">
                <i class="fas fa-info-circle"></i>
                Feedback Information
            </h2>
        </div>
        <div class="card-body">
            <div class="info-grid">
                <div class="form-group">
                    <label class="form-label">Customer</label>
                    <div class="form-value">
                        <i class="fas fa-user" style="color: var(--primary); margin-right: 0.5rem;"></i>
                        <strong><c:out value="${feedback.customerID}" default="N/A"/></strong>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Rating</label>
                    <div class="form-value">
                        <c:choose>
                            <c:when test="${not empty feedback.rating}">
                                <div class="rating-value">
                                    <div class="rating-stars">
                                        <c:forEach begin="1" end="5" var="i">
                                            <i class="fas fa-star ${i <= feedback.rating ? 'filled' : 'empty'}"></i>
                                        </c:forEach>
                                    </div>
                                    <span class="badge ${feedback.rating >= 4 ? 'badge-success' : 'badge-warning'}">
                                        ${feedback.rating}/5
                                    </span>
                                </div>
                            </c:when>
                            <c:otherwise>
                                N/A
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div class="info-grid">
                <div class="form-group">
                    <label class="form-label">Feedback Date</label>
                    <div class="form-value">
                        <i class="fas fa-calendar" style="color: var(--gray-500); margin-right: 0.5rem;"></i>
                        <c:out value="${feedback.feedbackDate}" default="N/A"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Response Date</label>
                    <div class="form-value">
                        <i class="fas fa-calendar-check" style="color: var(--gray-500); margin-right: 0.5rem;"></i>
                        <c:choose>
                            <c:when test="${not empty feedback.responseDate}">
                                <c:out value="${feedback.responseDate}"/>
                            </c:when>
                            <c:otherwise>
                                <span style="color: var(--gray-400);">Not responded yet</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div class="form-group" style="margin-bottom: 0;">
                <label class="form-label">Original Feedback</label>
                <div class="feedback-box">
                    <i class="fas fa-quote-left quote-icon"></i>
                    <p><c:out value="${feedback.description}" default="N/A"/></p>
                </div>
            </div>
        </div>
    </div>

    <!-- Response Form Card -->
    <div class="card">
        <div class="card-header">
            <h2 class="card-title">
                <i class="fas fa-edit"></i>
                Your Response
            </h2>
        </div>
        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/feedback/respond" id="responseForm">
                <input type="hidden" name="requestId" value="${feedback.requestID.foreignKeyValue}"/>

                <div class="form-group">
                    <label for="response" class="form-label">Response Message</label>
                    <textarea 
                        id="response" 
                        name="response" 
                        class="form-textarea"
                        maxlength="255"
                        placeholder="Enter your response to the customer's feedback..."
                    ><c:out value="${feedback.response}" default=""/></textarea>
                    <div class="form-hint">
                        <i class="fas fa-info-circle"></i>
                        <span>Maximum 255 characters. Leave empty to clear the response.</span>
                    </div>
                    <div class="char-counter" id="charCounter">
                        <span id="charCount">0</span> / 255 characters
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-check"></i> Save Response
                    </button>
                    <a href="${pageContext.request.contextPath}/customer/feedback/view?requestId=${feedback.requestID.foreignKeyValue}" class="btn btn-outline-secondary">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Character counter
    const textarea = document.getElementById('response');
    const charCount = document.getElementById('charCount');
    const charCounter = document.getElementById('charCounter');

    function updateCharCount() {
        const count = textarea.value.length;
        charCount.textContent = count;
        
        // Update color based on character count
        charCounter.classList.remove('warning', 'danger');
        if (count >= 255) {
            charCounter.classList.add('danger');
        } else if (count >= 200) {
            charCounter.classList.add('warning');
        }
    }

    // Initial count
    updateCharCount();

    // Update on input
    textarea.addEventListener('input', updateCharCount);
</script>

</body>
</html>
