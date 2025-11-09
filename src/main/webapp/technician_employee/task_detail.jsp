<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Task Detail</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/task/taskDetail.css">
</head>
<body>

<div class="container">
    <jsp:include page="../components/header.jsp"/>
    <div class="header">
        <h1><i class="fas fa-tasks"></i> Task Detail</h1>
        <p class="subtitle">Detailed information about your assigned task</p>
    </div>


    <c:if test="${not empty errorMessage}">
        <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i> ${errorMessage}
        </div>
    </c:if>

    <div class="content">
        <c:if test="${not empty task}">
            <div class="task-info-grid">
                <div class="info-card">
                    <h3><i class="fas fa-info-circle"></i> Request Information</h3>
                    <div class="info-item">
                        <span class="info-label">Request ID:</span>
                        <span class="info-value">#${task.requestID}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Status:</span>
                        <span class="info-value">
                                <c:choose>
                                    <c:when test="${task.requestStatus eq 'Approved'}">
                                        <span class="status-badge status-approved">Approved</span>
                                    </c:when>
                                    <c:when test="${task.requestStatus eq 'Finished'}">
                                        <span class="status-badge status-finished">Finished</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge status-default">${task.requestStatus}</span>
                                    </c:otherwise>
                                </c:choose>
                            </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Start Date:</span>
                        <span class="info-value">
                                <c:choose>
                                    <c:when test="${not empty task.startDate}">${task.startDate}</c:when>
                                    <c:otherwise>Not set</c:otherwise>
                                </c:choose>
                            </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Finished Date:</span>
                        <span class="info-value">
                                <c:choose>
                                    <c:when test="${not empty task.finishedDate}">${task.finishedDate}</c:when>
                                    <c:otherwise>Not finished</c:otherwise>
                                </c:choose>
                            </span>
                    </div>
                </div>

                <div class="info-card">
                    <h3><i class="fas fa-user"></i> Customer & Contract</h3>
                    <c:if test="${not empty customer}">
                        <div class="info-item">
                            <span class="info-label">Customer:</span>
                            <span class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty customer.customerName}">${customer.customerName}</c:when>
                                        <c:otherwise>N/A</c:otherwise>
                                    </c:choose>
                                </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Phone:</span>
                            <span class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty customer.phone}">${customer.phone}</c:when>
                                        <c:otherwise>N/A</c:otherwise>
                                    </c:choose>
                                </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Email:</span>
                            <span class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty customer.email}">${customer.email}</c:when>
                                        <c:otherwise>N/A</c:otherwise>
                                    </c:choose>
                                </span>
                        </div>
                    </c:if>
                    <c:if test="${not empty contract}">
                        <div class="info-item">
                            <span class="info-label">Contract ID:</span>
                            <span class="info-value">#${contract.contractID}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Contract Start:</span>
                            <span class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty contract.startDate}">${contract.startDate}</c:when>
                                        <c:otherwise>N/A</c:otherwise>
                                    </c:choose>
                                </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Contract End:</span>
                            <span class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty contract.expiredDate}">${contract.expiredDate}</c:when>
                                        <c:otherwise>N/A</c:otherwise>
                                    </c:choose>
                                </span>
                        </div>
                    </c:if>
                    <c:if test="${empty customer and empty contract}">
                        <div class="info-item">
                            <span class="info-value" style="color: #999; font-style: italic;">No customer/contract information available</span>
                        </div>
                    </c:if>
                </div>
            </div>

            <div class="description-section">
                <h3><i class="fas fa-file-alt"></i> Task Description</h3>
                <div class="description-text">
                    <c:choose>
                        <c:when test="${not empty task.requestDescription}">${task.requestDescription}</c:when>
                        <c:otherwise>No description provided</c:otherwise>
                    </c:choose>
                </div>
            </div>

            <c:if test="${not empty task.note}">
                <div class="description-section">
                    <h3><i class="fas fa-sticky-note"></i> Additional Notes</h3>
                    <div class="description-text">
                            ${task.note}
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty assignedAccounts}">
                <div class="info-card">
                    <h3><i class="fas fa-users"></i> Assigned Technicians</h3>
                    <c:forEach var="account" items="${assignedAccounts}">
                        <div class="info-item">
                            <span class="info-label">Username:</span>
                            <span class="info-value">${account.username}</span>
                        </div>
                    </c:forEach>
                </div>
            </c:if>

            <div class="action-buttons">
                <c:choose>
                    <c:when test="${task.requestStatus eq 'Approved'}">
                        <form method="POST" action="${pageContext.request.contextPath}/request/finish"
                              style="display: inline;"
                              onsubmit="return confirm('Are you sure you want to mark this request as finished?')">
                            <input type="hidden" name="requestId" value="${task.requestID}">
                            <input type="hidden" name="status" value="finished">
                            <button type="submit" class="btn btn-success"><i class="fas fa-check"></i> Mark as Finished
                            </button>
                        </form>
                    </c:when>
                    <c:when test="${task.requestStatus eq 'Finished'}">
                        <button class="btn btn-secondary" disabled><i class="fas fa-check-circle"></i> Task Completed
                        </button>
                    </c:when>
                </c:choose>
                <a href="${pageContext.request.contextPath}/technician_employee/techemployee_actioncenter"
                   class="btn home-button">
                    <span>Back to Action Center</span>
                </a>
            </div>

        </c:if>
        <c:if test="${empty task}">
            <div class="empty-state">
                <i class="fas fa-exclamation-triangle"></i>
                <h3>Task Not Found</h3>
                <p>The requested task could not be found or you don't have permission to view it.</p>
            </div>
        </c:if>
    </div>
</div>
</body>
</html>