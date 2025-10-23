<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assigned Task List</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/task/viewAssignedTasks.css">
</head>
<body>
<button class="mobile-menu-btn" onclick="toggleSidebar()">
    <i class="fas fa-bars"></i>
</button>

<nav class="sidebar">
    <div class="sidebar-header">
        <h3><i class="fas fa-tools"></i> Tech Dashboard</h3>
    </div>
    <ul class="sidebar-menu">
        <li class="active">
            <a href="${pageContext.request.contextPath}/techemployee/assignedTasks.jsp">
                <i class="fas fa-list-check"></i>
                <span>Assigned Tasks List</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/technician_employee/techemployee_actioncenter">
                <i class="fas fa-box"></i>
                <span>Back to Action Center</span>
            </a>
        </li>
    </ul>
</nav>

<div class="main-content">
    <div class="container">
        <div class="header">
            <h1> Task List</h1>
        </div>

        <c:if test="${not empty successMessage}">
            <div style="background: #d4edda; color: #155724; padding: 15px; border-radius: 6px; margin-bottom: 20px; border: 1px solid #c3e6cb;">
                <i class="fas fa-check-circle"></i> ${successMessage}
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div style="background: #f8d7da; color: #721c24; padding: 15px; border-radius: 6px; margin-bottom: 20px; border: 1px solid #f1aeb5;">
                <i class="fas fa-exclamation-circle"></i> ${errorMessage}
            </div>
        </c:if>

        <div class="card filters">
            <div class="card-body">
                <h2>Filters</h2>
                <form method="POST" action="${pageContext.request.contextPath}/task/viewAssignedTasks">
                    <input type="hidden" name="page" value="${currentPage != null ? currentPage : 1}">
                    <input type="hidden" name="pageSize" value="${pageSize != null ? pageSize : 6}">

                    <div class="filter-grid">
                        <div class="form-group">
                            <label>Status</label>
                            <select class="form-control" name="statusFilter">
                                <option value="">All Status</option>
                                <option value="processing" ${statusFilter == 'processing' ? 'selected' : ''}>Processing</option>
                                <option value="finished" ${statusFilter == 'finished' ? 'selected' : ''}>Finished</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Sort by Time</label>
                            <select class="form-control" name="sortBy">
                                <option value="">No Sort</option>
                                <option value="newest" ${sortBy == 'newest' ? 'selected' : ''}>Newest First</option>
                                <option value="oldest" ${sortBy == 'oldest' ? 'selected' : ''}>Oldest First</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>From Date (dd-MM-yyyy)</label>
                            <input type="text" class="form-control" name="fromDate"
                                   placeholder="dd-MM-yyyy (VD: 06-10-2025)"
                                   value="${fromDate}">
                        </div>
                        <div class="form-group">
                            <label>To Date (dd-MM-yyyy)</label>
                            <input type="text" class="form-control" name="toDate"
                                   placeholder="dd-MM-yyyy (VD: 06-10-2025)"
                                   value="${toDate}">
                        </div>
                    </div>
                    <div class="filter-buttons">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search"></i> Apply Filters
                        </button>
                        <a href="${pageContext.request.contextPath}/task/viewAssignedTasks" class="btn btn-secondary">
                            <i class="fas fa-times"></i> Clear Filters
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number">
                    ${totalTasks}
                </div>
                <div class="stat-label">Total Tasks</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">
                    ${processingTasks}
                </div>
                <div class="stat-label">Processing</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">
                    ${finishedTasks}
                </div>
                <div class="stat-label">Finished</div>
            </div>
        </div>

        <c:if test="${not empty statsNote}">
            <div style="text-align: center; margin-bottom: 20px; color: #666; font-style: italic;">
                ${statsNote}
            </div>
        </c:if>
        <div class="tasks-grid">
            <c:choose>
                <c:when test="${not empty assignedRequests}">
                    <c:forEach var="req" items="${assignedRequests}">
                        <div class="task-card">
                            <div class="task-header">
                                <h3 class="task-title">
                                    <c:choose>
                                        <c:when test="${not empty req.requestDescription}">
                                            ${req.requestDescription}
                                        </c:when>
                                        <c:otherwise>Service Request</c:otherwise>
                                    </c:choose>
                                </h3>
                                <span class="badge badge-progress">${req.requestStatus}</span>
                            </div>
                            <p class="task-description">
                                <c:choose>
                                    <c:when test="${not empty req.note}">
                                        ${req.note}
                                    </c:when>
                                    <c:otherwise>No additional details available</c:otherwise>
                                </c:choose>
                            </p>
                            <div class="task-details">
                                <div class="task-detail">
                                    <span class="task-detail-label">Request ID:</span>
                                    <span class="task-detail-value">#${req.requestID}</span>
                                </div>
                                <div class="task-detail">
                                    <span class="task-detail-label">Status:</span>
                                    <span class="task-detail-value">${req.requestStatus}</span>
                                </div>
                                <div class="task-detail">
                                    <span class="task-detail-label">Start Date:</span>
                                    <span class="task-detail-value">
                                        <c:choose>
                                            <c:when test="${not empty req.startDate}">
                                                ${req.startDate}
                                            </c:when>
                                            <c:otherwise>Not set</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>
                            <div class="task-footer">
                                <form method="POST" action="${pageContext.request.contextPath}/task/detail" class="link">
                                    <input type="hidden" name="id" value="${req.requestID}">
                                    <button type="submit" class="btn-sm finish-btn">
                                        View details
                                    </button>
                                </form>
                                <form method="GET" action="${pageContext.request.contextPath}/tech/employees/createProductRequests" class="link">
                                    <input type="hidden" name="requestID" value="${req.requestID}">
                                    <button type="submit" class="btn-sm finish-btn">
                                        Create Product Request
                                    </button>
                                </form>
                                <c:choose>
                                    <c:when test="${req.requestStatus == 'Finished'}">
                                        <button class="btn btn-secondary btn-sm finish-btn" disabled>
                                            <i class="fas fa-check"></i> Finished
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <form method="POST" action="${pageContext.request.contextPath}/task/updateStatus"
                                              style="display: inline;"
                                              onsubmit="return confirm('Are you sure you want to mark this task as finished?')">
                                            <input type="hidden" name="requestId" value="${req.requestID}">
                                            <input type="hidden" name="status" value="finished">
                                            <button type="submit" class="btn btn-success btn-sm finish-btn">
                                                <i class="fas fa-check"></i> Mark as Finished
                                            </button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div style="grid-column: 1 / -1; text-align: center; padding: 40px; color: #666;">
                        <i class="fas fa-inbox" style="font-size: 48px; margin-bottom: 16px; opacity: 0.5;"></i>
                        <p style="font-size: 18px; margin: 0;">No assigned tasks found</p>
                        <p style="font-size: 14px; margin: 8px 0 0 0; opacity: 0.7;">You don't have any tasks assigned at the moment.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="pagination">
            <div class="pagination-content">
                <div class="pagination-info">
                    <c:choose>
                        <c:when test="${not empty startItem && not empty endItem && not empty totalCount}">
                            Showing ${startItem} - ${endItem} of ${totalCount} tasks
                        </c:when>
                        <c:otherwise>No tasks found</c:otherwise>
                    </c:choose>
                </div>

                <div class="items-per-page">
                    <label>Show:</label>
                    <form method="POST" action="${pageContext.request.contextPath}/task/viewAssignedTasks"
                          style="display: inline;">
                        <input type="hidden" name="statusFilter" value="${statusFilter}">
                        <input type="hidden" name="sortBy" value="${sortBy}">
                        <input type="hidden" name="fromDate" value="${fromDate}">
                        <input type="hidden" name="toDate" value="${toDate}">
                        <input type="hidden" name="page" value="1">

                        <select class="form-control" name="pageSize" onchange="this.form.submit()"
                                style="width: auto; display: inline-block;">
                            <option value="4" ${pageSize == 4 ? 'selected' : ''}>4 tasks</option>
                            <option value="6" ${pageSize == 6 ? 'selected' : ''}>6 tasks</option>
                            <option value="8" ${pageSize == 8 ? 'selected' : ''}>8 tasks</option>
                            <option value="12" ${pageSize == 12 ? 'selected' : ''}>12 tasks</option>
                        </select>
                    </form>
                </div>

                <div class="pagination-controls">
                    <c:set var="currentPage" value="${currentPage != null ? currentPage : 1}" />
                    <c:set var="totalPages" value="${totalPages != null ? totalPages : 1}" />
                    <c:choose>
                        <c:when test="${currentPage > 1}">
                            <form method="POST" action="${pageContext.request.contextPath}/task/viewAssignedTasks" style="display: inline;">
                                <input type="hidden" name="statusFilter" value="${statusFilter}">
                                <input type="hidden" name="sortBy" value="${sortBy}">
                                <input type="hidden" name="fromDate" value="${fromDate}">
                                <input type="hidden" name="toDate" value="${toDate}">
                                <input type="hidden" name="pageSize" value="${pageSize}">
                                <input type="hidden" name="page" value="${currentPage - 1}">
                                <button type="submit" class="pagination-btn">‹ Previous</button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <button class="pagination-btn" disabled>‹ Previous</button>
                        </c:otherwise>
                    </c:choose>
                    <button class="pagination-btn active">${currentPage}</button>
                    <c:choose>
                        <c:when test="${currentPage < totalPages}">
                            <form method="POST" action="${pageContext.request.contextPath}/task/viewAssignedTasks" style="display: inline;">
                                <input type="hidden" name="statusFilter" value="${statusFilter}">
                                <input type="hidden" name="sortBy" value="${sortBy}">
                                <input type="hidden" name="fromDate" value="${fromDate}">
                                <input type="hidden" name="toDate" value="${toDate}">
                                <input type="hidden" name="pageSize" value="${pageSize}">
                                <input type="hidden" name="page" value="${currentPage + 1}">
                                <button type="submit" class="pagination-btn">Next ›</button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <button class="pagination-btn" disabled>Next ›</button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>
</div>

<script src="${pageContext.request.contextPath}/js/view_assigned_tasks.js"></script>
</body>
</html>
