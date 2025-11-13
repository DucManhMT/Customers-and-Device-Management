<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assignment Decision</title>
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
        .decision-container {
            max-width: 1000px;
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

        /* Alert Messages */
        .alert {
            padding: 1rem 1.25rem;
            border-radius: 8px;
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
            color: var(--success);
            border: 1px solid rgba(16, 185, 129, 0.2);
        }

        .alert-danger {
            background: rgba(239, 68, 68, 0.1);
            color: var(--danger);
            border: 1px solid rgba(239, 68, 68, 0.2);
        }

        /* Section Card */
        .section-card {
            background: white;
            border-radius: 12px;
            box-shadow: var(--shadow);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .section-header {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 1.25rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid var(--gray-100);
        }

        .section-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, var(--primary), var(--primary-light));
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.125rem;
        }

        .section-header h2 {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--gray-900);
            margin: 0;
        }

        /* Meta Info */
        .meta-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 1.5rem;
            margin-bottom: 1.25rem;
            padding: 1rem;
            background: var(--gray-50);
            border-radius: 8px;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.875rem;
            color: var(--gray-600);
        }

        .meta-item i {
            color: var(--primary);
            font-size: 1rem;
        }

        .meta-item strong {
            color: var(--gray-900);
            font-weight: 600;
        }

        /* Detail Grid */
        .detail-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 1rem;
        }

        .detail-item {
            background: var(--gray-50);
            padding: 1rem;
            border-radius: 8px;
            border: 1px solid var(--gray-200);
        }

        .detail-label {
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--gray-600);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.375rem;
        }

        .detail-label i {
            color: var(--primary);
        }

        .detail-value {
            font-size: 1rem;
            font-weight: 600;
            color: var(--gray-900);
        }

        .detail-value.secondary {
            color: var(--gray-600);
            font-weight: 500;
        }

        .detail-value.warning {
            color: var(--warning);
        }

        /* Status Badge */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.375rem;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            font-size: 0.8125rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-badge.pending {
            background: rgba(245, 158, 11, 0.1);
            color: var(--warning);
        }

        .status-badge.approved {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
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
            white-space: pre-wrap;
        }

        /* Note Box */
        .note-box {
            background: rgba(245, 158, 11, 0.05);
            border-left: 3px solid var(--warning);
            border-radius: 8px;
            padding: 1rem;
            margin-top: 0.75rem;
        }

        .note-box strong {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--warning);
            margin-bottom: 0.5rem;
        }

        .note-box p {
            margin: 0;
            color: var(--gray-700);
            line-height: 1.6;
        }

        /* Customer Section */
        .customer-section .section-icon {
            background: linear-gradient(135deg, var(--success), #059669);
        }

        /* Form Section */
        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            font-size: 0.875rem;
            font-weight: 600;
            color: var(--gray-700);
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-label i {
            color: var(--primary);
        }

        .form-label .required {
            color: var(--danger);
            margin-left: 0.25rem;
        }

        .form-control {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid var(--gray-300);
            border-radius: 8px;
            font-size: 0.9375rem;
            transition: all 0.2s;
            background: white;
            color: var(--gray-900);
            font-family: inherit;
            resize: vertical;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
        }

        .form-control::placeholder {
            color: var(--gray-400);
        }

        .form-control.error {
            border-color: var(--danger);
        }

        .error-message {
            color: var(--danger);
            font-size: 0.8125rem;
            margin-top: 0.5rem;
            display: none;
            align-items: center;
            gap: 0.375rem;
        }

        .error-message.show {
            display: flex;
        }

        .form-help {
            font-size: 0.8125rem;
            color: var(--gray-600);
            margin-top: 0.5rem;
            display: flex;
            align-items: flex-start;
            gap: 0.375rem;
            line-height: 1.5;
        }

        .form-help i {
            color: var(--info);
            margin-top: 0.125rem;
            flex-shrink: 0;
        }

        .form-help strong {
            color: var(--gray-700);
        }

        /* Action Buttons */
        .action-section {
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: var(--shadow);
            border-top: 3px solid var(--gray-100);
        }

        .action-buttons {
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.9375rem;
            border: none;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
            justify-content: center;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
            flex: 1;
            min-width: 200px;
        }

        .btn-primary:hover {
            background: var(--primary-dark);
        }

        .btn-danger {
            background: white;
            color: var(--danger);
            border: 2px solid var(--danger);
            flex: 1;
            min-width: 200px;
        }

        .btn-danger:hover {
            background: var(--danger);
            color: white;
        }

        .btn-secondary {
            background: var(--gray-200);
            color: var(--gray-700);
        }

        .btn-secondary:hover {
            background: var(--gray-300);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .decision-container {
                padding: 1rem 0.75rem;
            }

            .page-header {
                padding: 1.5rem;
            }

            .header-content {
                flex-direction: column;
                text-align: center;
            }

            .header-icon {
                width: 48px;
                height: 48px;
                font-size: 1.25rem;
            }

            .header-text h1 {
                font-size: 1.5rem;
            }

            .section-card {
                padding: 1.25rem;
            }

            .meta-grid {
                flex-direction: column;
                gap: 0.75rem;
            }

            .detail-grid {
                grid-template-columns: 1fr;
            }

            .action-buttons {
                flex-direction: column;
            }

            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>

<jsp:include page="../components/header.jsp" />
<jsp:include page="../components/sidebar.jsp"/>

<div class="decision-container">
    <!-- Page Header -->
    <div class="page-header">
        <div class="header-content">
            <div class="header-icon">
                <i class="fas fa-clipboard-check"></i>
            </div>
            <div class="header-text">
                <h1>Task Assignment Review</h1>
                <p>Review task details and make your decision to accept or decline</p>
            </div>
        </div>
    </div>

    <!-- Alert Messages -->
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-circle"></i>
            <span>${errorMessage}</span>
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <span>${successMessage}</span>
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <c:set var="task" value="${requestScope.taskItem}"/>
    <c:set var="req" value="${task.request}"/>

    <form method="post" action="${pageContext.request.contextPath}/technician_employee/task/assignmentDecision">
        <input type="hidden" name="taskId" value="${task.taskID}"/>

        <!-- Task Information Section -->
        <div class="section-card">
            <div class="section-header">
                <div class="section-icon">
                    <i class="fas fa-tasks"></i>
                </div>
                <h2>Task Assignment Details</h2>
            </div>

            <div class="meta-grid">
                <div class="meta-item">
                    <i class="fas fa-hashtag"></i>
                    Task ID: <strong>#${task.taskID}</strong>
                </div>
                <div class="meta-item">
                    <i class="fas fa-link"></i>
                    Request ID: <strong>#${req.requestID}</strong>
                </div>
                <div class="meta-item">
                    <i class="fas fa-user-tie"></i>
                    Assigned by: <strong>${task.assignBy.staffName}</strong>
                </div>
            </div>

            <div class="detail-grid">
                <div class="detail-item">
                    <div class="detail-label">
                        <i class="fas fa-info-circle"></i>
                        Status
                    </div>
                    <div class="detail-value">
                        <span class="status-badge pending">${task.status}</span>
                    </div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">
                        <i class="fas fa-calendar-plus"></i>
                        Start Date
                    </div>
                    <div class="detail-value ${empty task.startDate ? 'secondary' : ''}">
                        ${not empty task.startDate ? task.startDate : 'Not started'}
                    </div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">
                        <i class="fas fa-calendar-alt"></i>
                        Deadline
                    </div>
                    <div class="detail-value warning">
                        ${not empty task.deadline ? task.deadline : 'Not set'}
                    </div>
                </div>
            </div>

            <c:if test="${not empty task.description}">
                <div style="margin-top: 1.25rem;">
                    <strong style="color: var(--gray-700); font-size: 0.875rem; display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.5rem;">
                        <i class="fas fa-file-alt" style="color: var(--primary);"></i>
                        Task Description
                    </strong>
                    <div class="content-box">
                        <p>${task.description}</p>
                    </div>
                </div>
            </c:if>
        </div>

        <!-- Customer Information Section -->
        <c:if test="${not empty req.contract and not empty req.contract.customer}">
            <c:set var="customer" value="${req.contract.customer}"/>
            <div class="section-card customer-section">
                <div class="section-header">
                    <div class="section-icon">
                        <i class="fas fa-user-circle"></i>
                    </div>
                    <h2>Customer Information</h2>
                </div>

                <div class="detail-grid">
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-user"></i>
                            Customer Name
                        </div>
                        <div class="detail-value">
                            ${not empty customer.customerName ? customer.customerName : 'N/A'}
                        </div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-phone"></i>
                            Phone Number
                        </div>
                        <div class="detail-value">
                            ${not empty customer.phone ? customer.phone : 'N/A'}
                        </div>
                    </div>
                    <div class="detail-item" style="grid-column: 1 / -1;">
                        <div class="detail-label">
                            <i class="fas fa-map-marker-alt"></i>
                            Address
                        </div>
                        <div class="detail-value secondary">
                            ${not empty customer.address ? customer.address : 'N/A'}
                        </div>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Request Details Section -->
        <div class="section-card">
            <div class="section-header">
                <div class="section-icon">
                    <i class="fas fa-clipboard-list"></i>
                </div>
                <h2>Request Details</h2>
            </div>

            <c:if test="${not empty req.requestDescription}">
                <div class="content-box">
                    <p>${req.requestDescription}</p>
                </div>
            </c:if>

            <c:if test="${not empty req.note}">
                <div class="note-box">
                    <strong>
                        <i class="fas fa-sticky-note"></i>
                        Additional Notes
                    </strong>
                    <p>${req.note}</p>
                </div>
            </c:if>
        </div>

        <!-- Task Note Section -->
        <div class="section-card">
            <div class="section-header">
                <div class="section-icon">
                    <i class="fas fa-sticky-note"></i>
                </div>
                <h2>Your Response</h2>
            </div>
            
            <div class="form-group" style="margin-bottom: 0;">
                <label class="form-label">
                    <i class="fas fa-comment-dots"></i>
                    Task Note
                    <span class="required" id="requiredIndicator" style="display: none;">*</span>
                </label>
                <textarea name="taskNote" id="taskNote" class="form-control" rows="5"
                          placeholder="Enter your note or comment about this task assignment..."></textarea>
                <div class="error-message" id="errorMessage">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>You must provide a reason when declining the task</span>
                </div>
                <div class="form-help">
                    <i class="fas fa-info-circle"></i>
                    <span><strong>Important:</strong> This note is optional when accepting, but <strong>required when declining</strong> the task.</span>
                </div>
            </div>
        </div>

        <!-- Action Buttons -->
        <div class="action-section">
            <div class="action-buttons">
                <button type="submit" name="decision" value="accept" class="btn btn-primary">
                    <i class="fas fa-check-circle"></i>
                    Accept & Start Task
                </button>
                <button type="submit" name="decision" value="decline" class="btn btn-danger" id="declineBtn">
                    <i class="fas fa-times-circle"></i>
                    Decline Task
                </button>
                <a href="${pageContext.request.contextPath}/technician_employee/task/viewReceivedAssignments"
                   class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i>
                    Back
                </a>
            </div>
        </div>
    </form>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.querySelector('form');
        const taskNoteTextarea = document.getElementById('taskNote');
        const errorMessage = document.getElementById('errorMessage');
        const requiredIndicator = document.getElementById('requiredIndicator');
        const declineBtn = document.getElementById('declineBtn');
        const acceptBtn = document.querySelector('button[name="decision"][value="accept"]');

        // Handle form submission
        form.addEventListener('submit', function(e) {
            const decision = document.activeElement.value;
            
            if (decision === 'decline') {
                const taskNote = taskNoteTextarea.value.trim();
                
                // Validate: task note is required when declining
                if (taskNote === '' || taskNote.length < 10) {
                    e.preventDefault();
                    taskNoteTextarea.classList.add('error');
                    errorMessage.classList.add('show');
                    
                    if (taskNote === '') {
                        errorMessage.querySelector('span').textContent = 'You must provide a reason when declining the task';
                    } else {
                        errorMessage.querySelector('span').textContent = 'Please provide at least 10 characters for the reason';
                    }
                    
                    taskNoteTextarea.focus();
                    
                    // Scroll to error message
                    taskNoteTextarea.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    return false;
                } else {
                    // Confirmation dialog
                    return confirm('Are you sure you want to DECLINE this task?\n\nYour reason will be recorded: "' + taskNote.substring(0, 100) + (taskNote.length > 100 ? '...' : '') + '"');
                }
            }
            
            // Accept case - no validation needed, but confirm
            if (decision === 'accept') {
                const taskNote = taskNoteTextarea.value.trim();
                let confirmMsg = 'Are you sure you want to ACCEPT this task?';
                if (taskNote !== '') {
                    confirmMsg += '\n\nYour note will be saved: "' + taskNote.substring(0, 100) + (taskNote.length > 100 ? '...' : '') + '"';
                }
                return confirm(confirmMsg);
            }
        });

        // Show required indicator when clicking decline button
        declineBtn.addEventListener('mouseenter', function() {
            requiredIndicator.style.display = 'inline';
            requiredIndicator.style.animation = 'pulse 0.5s';
        });

        declineBtn.addEventListener('click', function(e) {
            requiredIndicator.style.display = 'inline';
        });

        // Remove error state when user starts typing
        taskNoteTextarea.addEventListener('input', function() {
            if (this.value.trim() !== '') {
                this.classList.remove('error');
                errorMessage.classList.remove('show');
            }
        });

        // Clear required indicator and error when hovering accept button
        acceptBtn.addEventListener('mouseenter', function() {
            requiredIndicator.style.display = 'none';
            taskNoteTextarea.classList.remove('error');
            errorMessage.classList.remove('show');
        });

        // Add character counter
        const charCounter = document.createElement('div');
        charCounter.style.cssText = 'font-size: 0.75rem; color: var(--gray-500); margin-top: 0.25rem; text-align: right;';
        taskNoteTextarea.parentElement.insertBefore(charCounter, taskNoteTextarea.nextSibling);

        taskNoteTextarea.addEventListener('input', function() {
            const length = this.value.length;
            charCounter.textContent = length + ' characters';
            if (length > 0 && length < 10) {
                charCounter.style.color = 'var(--warning)';
            } else if (length >= 10) {
                charCounter.style.color = 'var(--success)';
            } else {
                charCounter.style.color = 'var(--gray-500)';
            }
        });
    });
</script>

</body>
</html>
