<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    request.setAttribute("dateFormatter", dateFormatter);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Task Detail - Technician</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #4F46E5;
            --primary-dark: #4338CA;
            --success: #10B981;
            --success-dark: #059669;
            --warning: #F59E0B;
            --danger: #EF4444;
            --danger-dark: #DC2626;
            --info: #3B82F6;
            --gray-50: #F9FAFB;
            --gray-100: #F3F4F6;
            --gray-200: #E5E7EB;
            --gray-300: #D1D5DB;
            --gray-500: #6B7280;
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
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background-color: var(--gray-50);
            color: var(--gray-900);
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }

        /* Page Header */
        .page-header {
            background: white;
            border-radius: 12px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            border: 1px solid var(--gray-200);
        }

        .page-header h1 {
            font-size: 1.875rem;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .page-header h1 i {
            color: var(--primary);
        }

        .page-header p {
            color: var(--gray-500);
            font-size: 1rem;
        }

        /* Alert */
        .alert {
            padding: 1rem 1.5rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            background: #FEE2E2;
            color: var(--danger-dark);
            border: 1px solid #FCA5A5;
        }

        .alert i {
            font-size: 1.25rem;
        }

        /* Info Grid */
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .info-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            border: 1px solid var(--gray-200);
        }

        .info-card h3 {
            font-size: 1.125rem;
            font-weight: 600;
            color: var(--gray-900);
            margin-bottom: 1.25rem;
            padding-bottom: 0.75rem;
            border-bottom: 2px solid var(--gray-100);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .info-card h3 i {
            color: var(--primary);
        }

        .info-item {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            padding: 0.75rem 0;
            border-bottom: 1px solid var(--gray-100);
        }

        .info-item:last-child {
            border-bottom: none;
        }

        .info-label {
            font-weight: 500;
            color: var(--gray-600);
            flex-shrink: 0;
            margin-right: 1rem;
        }

        .info-value {
            text-align: right;
            color: var(--gray-900);
            font-weight: 500;
        }

        /* Status Badges */
        .status-badge {
            padding: 0.375rem 0.75rem;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-block;
        }

        .status-approved {
            background: #DBEAFE;
            color: var(--info);
        }

        .status-finished {
            background: #D1FAE5;
            color: var(--success);
        }

        .status-pending {
            background: #FEF3C7;
            color: var(--warning);
        }

        .status-default {
            background: var(--gray-200);
            color: var(--gray-700);
        }

        /* Description Section */
        .description-section {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            border: 1px solid var(--gray-200);
        }

        .description-section h3 {
            font-size: 1.125rem;
            font-weight: 600;
            color: var(--gray-900);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .description-section h3 i {
            color: var(--primary);
        }

        .description-text {
            color: var(--gray-700);
            line-height: 1.8;
            padding: 1rem;
            background: var(--gray-50);
            border-radius: 8px;
            border-left: 4px solid var(--primary);
        }

        /* Technicians List */
        .technician-list {
            display: flex;
            flex-wrap: wrap;
            gap: 0.75rem;
        }

        .technician-badge {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            background: var(--gray-100);
            border-radius: 8px;
            border: 1px solid var(--gray-200);
        }

        .technician-badge i {
            color: var(--primary);
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            margin-top: 2rem;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            border: none;
            font-size: 0.875rem;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-success {
            background: var(--success);
            color: white;
        }

        .btn-success:hover {
            background: var(--success-dark);
            transform: translateY(-2px);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .btn-secondary {
            background: var(--gray-300);
            color: var(--gray-600);
            cursor: not-allowed;
        }

        .btn-outline {
            background: white;
            border: 2px solid var(--gray-300);
            color: var(--gray-700);
        }

        .btn-outline:hover {
            background: var(--gray-100);
            border-color: var(--gray-400);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .empty-state i {
            font-size: 4rem;
            color: var(--gray-300);
            margin-bottom: 1rem;
        }

        .empty-state h3 {
            font-size: 1.5rem;
            color: var(--gray-900);
            margin-bottom: 0.5rem;
        }

        .empty-state p {
            color: var(--gray-500);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .action-buttons {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }

            .info-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.25rem;
            }

            .info-value {
                text-align: left;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="../components/header.jsp"/>
    <jsp:include page="../components/sidebar.jsp"/>

    <div class="container">
        <!-- Page Header -->
        <div class="page-header">
            <h1><i class="fas fa-tasks"></i> Task Detail</h1>
            <p>Detailed information about your assigned task</p>
        </div>

    <c:if test="${not empty errorMessage}">
        <div class="alert">
            <i class="fas fa-exclamation-circle"></i>
            <div>${errorMessage}</div>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${not empty requestObj}">
            <!-- Info Grid -->
            <div class="info-grid">
                <!-- Request Information Card -->
                <div class="info-card">
                    <h3><i class="fas fa-info-circle"></i> Request Information</h3>
                    <div class="info-item">
                        <span class="info-label">Request ID:</span>
                        <span class="info-value">#${requestObj.requestID}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Request Status:</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${requestObj.requestStatus eq 'Approved'}">
                                    <span class="status-badge status-approved">Approved</span>
                                </c:when>
                                <c:when test="${requestObj.requestStatus eq 'Finished'}">
                                    <span class="status-badge status-finished">Finished</span>
                                </c:when>
                                <c:when test="${requestObj.requestStatus eq 'Processing'}">
                                    <span class="status-badge status-approved">Processing</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-badge status-default">${requestObj.requestStatus}</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Start Date:</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty requestObj.startDate}">
                                    <i class="fas fa-calendar"></i> ${requestObj.startDate}
                                </c:when>
                                <c:otherwise><span style="color: var(--gray-400);">Not set</span></c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Finished Date:</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty requestObj.finishedDate}">
                                    <i class="fas fa-check-circle"></i> ${requestObj.finishedDate}
                                </c:when>
                                <c:otherwise><span style="color: var(--gray-400);">Not finished</span></c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>

                <!-- Task Information Card -->
                <div class="info-card">
                    <h3><i class="fas fa-clipboard-check"></i> Task Information</h3>
                    <c:choose>
                        <c:when test="${not empty taskObj}">
                            <div class="info-item">
                                <span class="info-label">Task ID:</span>
                                <span class="info-value">#${taskObj.taskID}</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Task Status:</span>
                                <span class="info-value">
                                    <c:choose>
                                        <c:when test="${taskObj.status eq 'Processing'}">
                                            <span class="status-badge status-approved">Processing</span>
                                        </c:when>
                                        <c:when test="${taskObj.status eq 'Finished'}">
                                            <span class="status-badge status-finished">Finished</span>
                                        </c:when>
                                        <c:when test="${taskObj.status eq 'Pending'}">
                                            <span class="status-badge status-pending">Pending</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-default">${taskObj.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Start Date:</span>
                                <span class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty taskObj.startDate}">
                                            <i class="fas fa-play-circle"></i> ${taskObj.startDate.format(dateFormatter)}
                                        </c:when>
                                        <c:otherwise><span style="color: var(--gray-400);">Not set</span></c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Deadline:</span>
                                <span class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty taskObj.deadline}">
                                            <i class="fas fa-flag-checkered"></i> ${taskObj.deadline.format(dateFormatter)}
                                        </c:when>
                                        <c:otherwise><span style="color: var(--gray-400);">No deadline</span></c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="info-item">
                                <span class="info-value" style="color: var(--gray-400); font-style: italic;">No task assigned yet</span>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Customer & Contract Grid -->
            <div class="info-grid">
                <div class="info-card">
                    <h3><i class="fas fa-user"></i> Customer Information</h3>
                    <c:choose>
                        <c:when test="${not empty customer}">
                            <div class="info-item">
                                <span class="info-label">Customer Name:</span>
                                <span class="info-value">${customer.customerName}</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Phone:</span>
                                <span class="info-value">
                                    <i class="fas fa-phone"></i> ${customer.phone}
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Email:</span>
                                <span class="info-value">
                                    <i class="fas fa-envelope"></i> ${customer.email}
                                </span>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="info-item">
                                <span class="info-value" style="color: var(--gray-400); font-style: italic;">No customer information</span>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="info-card">
                    <h3><i class="fas fa-file-contract"></i> Contract Information</h3>
                    <c:choose>
                        <c:when test="${not empty contract}">
                            <div class="info-item">
                                <span class="info-label">Contract ID:</span>
                                <span class="info-value">#${contract.contractID}</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Contract Start:</span>
                                <span class="info-value">
                                    <i class="fas fa-calendar-alt"></i> ${contract.startDate}
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Contract End:</span>
                                <span class="info-value">
                                    <i class="fas fa-calendar-times"></i> ${contract.expiredDate}
                                </span>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="info-item">
                                <span class="info-value" style="color: var(--gray-400); font-style: italic;">No contract information</span>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Request Description -->
            <div class="description-section">
                <h3><i class="fas fa-file-alt"></i> Request Description</h3>
                <div class="description-text">
                    <c:choose>
                        <c:when test="${not empty requestObj.requestDescription}">${requestObj.requestDescription}</c:when>
                        <c:otherwise><span style="color: var(--gray-400); font-style: italic;">No description provided</span></c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Task Description -->
            <c:if test="${not empty taskObj}">
                <div class="description-section">
                    <h3><i class="fas fa-tasks"></i> Task Description</h3>
                    <div class="description-text">
                        <c:choose>
                            <c:when test="${not empty taskObj.description}">${taskObj.description}</c:when>
                            <c:otherwise><span style="color: var(--gray-400); font-style: italic;">No description provided</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:if>

            <!-- Assigned Technicians -->
            <c:if test="${not empty assignedAccounts}">
                <div class="info-card">
                    <h3><i class="fas fa-users"></i> Assigned Technicians</h3>
                    <div class="technician-list">
                        <c:forEach var="account" items="${assignedAccounts}">
                            <div class="technician-badge">
                                <i class="fas fa-user-cog"></i>
                                <span>${account.username}</span>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>

            <!-- Action Buttons -->
            <div class="action-buttons">
                <c:choose>
                    <c:when test="${not empty taskObj and taskObj.status eq 'Processing'}">
                        <form method="POST" action="${pageContext.request.contextPath}/technician_employee/task/updateStatus"
                              style="display: inline;"
                              onsubmit="return confirm('Are you sure you want to mark this task as finished?')">
                            <input type="hidden" name="taskId" value="${taskObj.taskID}">
                            <input type="hidden" name="status" value="finished">
                            <button type="submit" class="btn btn-success">
                                <i class="fas fa-check"></i> Mark as Finished
                            </button>
                        </form>
                    </c:when>
                    <c:when test="${not empty taskObj and taskObj.status eq 'Finished'}">
                        <button class="btn btn-secondary" disabled>
                            <i class="fas fa-check-circle"></i> Task Completed
                        </button>
                    </c:when>
                    <c:when test="${empty taskObj}">
                        <button class="btn btn-secondary" disabled>
                            <i class="fas fa-info-circle"></i> No Task Assigned
                        </button>
                    </c:when>
                </c:choose>
                <a href="${pageContext.request.contextPath}/technician_employee/techemployee_actioncenter"
                   class="btn btn-outline">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <i class="fas fa-exclamation-triangle"></i>
                <h3>Task Not Found</h3>
                <p>The requested task could not be found or you don't have permission to view it.</p>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>