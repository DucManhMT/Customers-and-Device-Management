<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="crm.common.model.Request" %>
<%@ page import="crm.common.model.enums.RequestStatus" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.time.*, java.time.format.DateTimeFormatter" %>
<%
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
%>
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
            <li>
                <a href="${pageContext.request.contextPath}/techemployee/dashboard.jsp">
                    <i class="fas fa-home"></i>
                    <span>Dashboard</span>
                </a>
            </li>
            <li class="active">
                <a href="${pageContext.request.contextPath}/techemployee/assignedTasks.jsp">
                    <i class="fas fa-list-check"></i>
                    <span>Assigned Tasks List</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/techemployee/equipment-request.jsp">
                    <i class="fas fa-box"></i>
                    <span>Equipment Request</span>
                </a>
            </li>
            <li class="logout">
                <a href="#" onclick="logout()">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Logout</span>
                </a>
            </li>
        </ul>
    </nav>

    <div class="main-content">
        <div class="container">
        <div class="header">
            <h1> Task List</h1>
        </div>

        <% 
            String successMessage = (String) request.getAttribute("successMessage");
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (successMessage != null && !successMessage.isEmpty()) { 
        %>
            <div style="background: #d4edda; color: #155724; padding: 15px; border-radius: 6px; margin-bottom: 20px; border: 1px solid #c3e6cb;">
                <i class="fas fa-check-circle"></i> <%= successMessage %>
            </div>
        <% } %>
        <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
            <div style="background: #f8d7da; color: #721c24; padding: 15px; border-radius: 6px; margin-bottom: 20px; border: 1px solid #f1aeb5;">
                <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
            </div>
        <% } %>

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
                                <option value="processing" <%= "processing".equals(request.getAttribute("statusFilter")) ? "selected" : "" %>>Processing</option>
                                <option value="finished" <%= "finished".equals(request.getAttribute("statusFilter")) ? "selected" : "" %>>Finished</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Sort by Time</label>
                            <select class="form-control" name="sortBy">
                                <option value="">No Sort</option>
                                <option value="newest" <%= "newest".equals(request.getAttribute("sortBy")) ? "selected" : "" %>>Newest First</option>
                                <option value="oldest" <%= "oldest".equals(request.getAttribute("sortBy")) ? "selected" : "" %>>Oldest First</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>From Date (dd-MM-yyyy)</label>
                            <input type="text" class="form-control" name="fromDate" 
                                   placeholder="dd-MM-yyyy (VD: 06-10-2025)"
                                   value="<%= request.getAttribute("fromDate") != null ? request.getAttribute("fromDate") : "" %>">
                        </div>
                        <div class="form-group">
                            <label>To Date (dd-MM-yyyy)</label>
                            <input type="text" class="form-control" name="toDate" 
                                   placeholder="dd-MM-yyyy (VD: 06-10-2025)"
                                   value="<%= request.getAttribute("toDate") != null ? request.getAttribute("toDate") : "" %>">
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
                    <%= request.getAttribute("totalTasks") != null ? request.getAttribute("totalTasks") : 0 %>
                </div>
                <div class="stat-label">Total Tasks</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">
                    <%= request.getAttribute("processingTasks") != null ? request.getAttribute("processingTasks") : 0 %>
                </div>
                <div class="stat-label">Processing</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">
                    <%= request.getAttribute("finishedTasks") != null ? request.getAttribute("finishedTasks") : 0 %>
                </div>
                <div class="stat-label">Finished</div>
            </div>
        </div>
        
        <% if (request.getAttribute("statsNote") != null && !((String)request.getAttribute("statsNote")).isEmpty()) { %>
            <div style="text-align: center; margin-bottom: 20px; color: #666; font-style: italic;">
                <%= request.getAttribute("statsNote") %>
            </div>
        <% } %>
        <div class="tasks-grid">
            <%
                List<Request> assignedRequests = (List<Request>) request.getAttribute("assignedRequests");
                if (assignedRequests != null && !assignedRequests.isEmpty()) {
                    for (Request req : assignedRequests) {
            %>
            <div class="task-card">
                <div class="task-header">
                    <h3 class="task-title"><%=req.getRequestDescription() != null ? req.getRequestDescription() : "Service Request"%></h3>
                    <span class="badge badge-progress"><%=req.getRequestStatus()%></span>
                </div>
                <p class="task-description"><%=req.getNote() != null ? req.getNote() : "No additional details available"%></p>
                <div class="task-details">
                    <div class="task-detail">
                        <span class="task-detail-label">Request ID:</span>
                        <span class="task-detail-value">#<%=req.getRequestID()%></span>
                    </div>
                    <div class="task-detail">
                        <span class="task-detail-label">Status:</span>
                        <span class="task-detail-value"><%=req.getRequestStatus()%></span>
                    </div>
                    <div class="task-detail">
                        <span class="task-detail-label">Start Date:</span>
                        <span class="task-detail-value">
                            <%= req.getStartDate() != null ? formatter.format(req.getStartDate()) : "Not set" %>
                        </span>
                    </div>
                </div>
                <div class="task-footer">
<form method="POST" action="${pageContext.request.contextPath}/task/detail" class="link">
    <input type="hidden" name="id" value="<%= req.getRequestID() %>">
    <button type="submit" class="btn-sm finish-btn">
        View details
    </button>
</form>

                    <% if (RequestStatus.Finished.equals(req.getRequestStatus())) { %>
                        <button class="btn btn-secondary btn-sm finish-btn" disabled>
                            <i class="fas fa-check"></i> Finished
                        </button>
                    <% } else { %>
                        <form method="POST" action="${pageContext.request.contextPath}/task/updateStatus" style="display: inline;" 
                              onsubmit="return confirm('Are you sure you want to mark this task as finished?')">
                            <input type="hidden" name="requestId" value="<%=req.getRequestID()%>">
                            <input type="hidden" name="status" value="finished">
                            <button type="submit" class="btn btn-success btn-sm finish-btn">
                                <i class="fas fa-check"></i> Mark as Finished
                            </button>
                        </form>
                    <% } %>
                </div>
            </div>
            <%
                    }
                } else {
            %>
                        <div style="grid-column: 1 / -1; text-align: center; padding: 40px; color: #666;">
                <i class="fas fa-inbox" style="font-size: 48px; margin-bottom: 16px; opacity: 0.5;"></i>
                <p style="font-size: 18px; margin: 0;">No assigned tasks found</p>
                <p style="font-size: 14px; margin: 8px 0 0 0; opacity: 0.7;">You don't have any tasks assigned at the moment.</p>
            </div>
            <%
                }
            %>
        </div>
        <div class="pagination">
            <div class="pagination-content">
                <div class="pagination-info">
                    <%
                        Integer startItem = (Integer) request.getAttribute("startItem");
                        Integer endItem = (Integer) request.getAttribute("endItem");
                        Integer totalCount = (Integer) request.getAttribute("totalCount");
                        
                        if (startItem != null && endItem != null && totalCount != null) {
                            out.print("Showing " + startItem + " - " + endItem + " of " + totalCount + " tasks");
                        } else {
                            out.print("No tasks found");
                        }
                    %>
                </div>
                
                <div class="items-per-page">
                    <label>Show:</label>
                    <form method="POST" action="${pageContext.request.contextPath}/task/viewAssignedTasks" style="display: inline;">
                        <input type="hidden" name="statusFilter" value="${statusFilter}">
                        <input type="hidden" name="sortBy" value="${sortBy}">
                        <input type="hidden" name="fromDate" value="${fromDate}">
                        <input type="hidden" name="toDate" value="${toDate}">
                        <input type="hidden" name="page" value="1">
                        
                        <select class="form-control" name="pageSize" onchange="this.form.submit()" style="width: auto; display: inline-block;">
                            <option value="4" ${pageSize == 4 ? 'selected' : ''}>4 tasks</option>
                            <option value="6" ${pageSize == 6 ? 'selected' : ''}>6 tasks</option>
                            <option value="8" ${pageSize == 8 ? 'selected' : ''}>8 tasks</option>
                            <option value="12" ${pageSize == 12 ? 'selected' : ''}>12 tasks</option>
                        </select>
                    </form>
                </div>
                
                <div class="pagination-controls">
                    <%
                        Integer currentPage = (Integer) request.getAttribute("currentPage");
                        Integer totalPages = (Integer) request.getAttribute("totalPages");
                        
                        if (currentPage == null) currentPage = 1;
                        if (totalPages == null) totalPages = 1;
                    %>
                        
                    <% if (currentPage > 1) { %>
                        <form method="POST" action="${pageContext.request.contextPath}/task/viewAssignedTasks" style="display: inline;">
                            <input type="hidden" name="statusFilter" value="${statusFilter}">
                            <input type="hidden" name="sortBy" value="${sortBy}">
                            <input type="hidden" name="fromDate" value="${fromDate}">
                            <input type="hidden" name="toDate" value="${toDate}">
                            <input type="hidden" name="pageSize" value="${pageSize}">
                            <input type="hidden" name="page" value="<%= currentPage - 1 %>">
                            <button type="submit" class="pagination-btn">‹ Previous</button>
                        </form>
                    <% } else { %>
                        <button class="pagination-btn" disabled>‹ Previous</button>
                    <% } %>
                        
                    <button class="pagination-btn active"><%= currentPage %></button>
                        
                    <% if (currentPage < totalPages) { %>
                        <form method="POST" action="${pageContext.request.contextPath}/task/viewAssignedTasks" style="display: inline;">
                            <input type="hidden" name="statusFilter" value="${statusFilter}">
                            <input type="hidden" name="sortBy" value="${sortBy}">
                            <input type="hidden" name="fromDate" value="${fromDate}">
                            <input type="hidden" name="toDate" value="${toDate}">
                            <input type="hidden" name="pageSize" value="${pageSize}">
                            <input type="hidden" name="page" value="<%= currentPage + 1 %>">
                            <button type="submit" class="pagination-btn">Next ›</button>
                        </form>
                    <% } else { %>
                        <button class="pagination-btn" disabled>Next ›</button>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
        </div>
    </div>

    <script>
        function validateDateFormat(inputElement) {
            const datePattern = /^\d{2}-\d{2}-\d{4}$/;
            const value = inputElement.value.trim();
            
            if (value && !datePattern.test(value)) {
                inputElement.style.borderColor = '#dc3545';
                inputElement.title = 'Định dạng ngày phải là: dd-MM-yyyy (VD: 06-10-2025)';
                return false;
            } else {
                inputElement.style.borderColor = '#ccc';
                inputElement.title = '';
                return true;
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            const fromDateInput = document.querySelector('input[name="fromDate"]');
            const toDateInput = document.querySelector('input[name="toDate"]');
            
            if (fromDateInput) {
                fromDateInput.addEventListener('blur', function() {
                    validateDateFormat(this);
                });
            }
            
            if (toDateInput) {
                toDateInput.addEventListener('blur', function() {
                    validateDateFormat(this);
                });
            }

            const filterForm = document.querySelector('form[action*="viewAssignedTasks"]');
            if (filterForm) {
                filterForm.addEventListener('submit', function(e) {
                    let isValid = true;
                    
                    if (fromDateInput && fromDateInput.value) {
                        isValid &= validateDateFormat(fromDateInput);
                    }
                    
                    if (toDateInput && toDateInput.value) {
                        isValid &= validateDateFormat(toDateInput);
                    }
                    
                    if (!isValid) {
                        e.preventDefault();
                        alert('Vui lòng nhập đúng định dạng ngày: dd-MM-yyyy (VD: 06-10-2025)');
                    }
                });
            }
        });
    </script>
</body>
</html>
