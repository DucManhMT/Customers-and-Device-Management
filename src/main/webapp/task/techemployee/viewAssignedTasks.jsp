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
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
            color: #333;
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
        }
        
        /* Sidebar Styles */
        .sidebar {
            width: 280px;
            background: white;
            box-shadow: 2px 0 8px rgba(0,0,0,0.1);
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            z-index: 1000;
        }
        
        .sidebar-header {
            padding: 20px;
            background: #007bff;
            color: white;
            text-align: center;
        }
        
        .sidebar-header h3 {
            font-size: 18px;
            font-weight: 600;
            margin: 0;
        }
        
        .sidebar-header i {
            margin-right: 10px;
            font-size: 22px;
        }
        
        .sidebar-menu {
            list-style: none;
            padding: 20px 0;
            margin: 0;
        }
        
        .sidebar-menu li {
            margin: 5px 0;
        }
        
        .sidebar-menu li a {
            display: flex;
            align-items: center;
            padding: 12px 20px;
            color: #666;
            text-decoration: none;
        }
        
        .sidebar-menu li a:hover {
            background: #f8f9fa;
            color: #007bff;
        }
        
        .sidebar-menu li.active a {
            background: #e3f2fd;
            color: #007bff;
            font-weight: 600;
        }
        
        .sidebar-menu li a i {
            width: 20px;
            margin-right: 12px;
            font-size: 16px;
            text-align: center;
        }
        
        .sidebar-menu li.logout {
            position: absolute;
            bottom: 20px;
            width: calc(100% - 20px);
            margin: 0 10px;
        }
        
        .sidebar-menu li.logout a {
            color: white;
            background: linear-gradient(135deg, #dc3545, #c82333);
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 2px 4px rgba(220, 53, 69, 0.3);
            border: 2px solid transparent;
        }
        
        .sidebar-menu li.logout a:hover {
            background: linear-gradient(135deg, #c82333, #bd2130);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(220, 53, 69, 0.4);
            border-color: rgba(255, 255, 255, 0.2);
        }
        
        .sidebar-menu li.logout a:active {
            transform: translateY(0);
            box-shadow: 0 2px 4px rgba(220, 53, 69, 0.3);
        }
        
        .sidebar-menu li.logout a i {
            color: white;
            margin-right: 8px;
        }
        
        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: 280px;
        }
        
        /* Mobile Menu Button */
        .mobile-menu-btn {
            display: none;
            position: fixed;
            top: 15px;
            left: 15px;
            z-index: 1001;
            background: white;
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 8px;
            color: #007bff;
            font-size: 16px;
            cursor: pointer;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
            color: #333;
        }
        
        .header h1 {
            font-size: 32px;
            font-weight: 600;
            margin-bottom: 8px;
        }
        
        .header p {
            font-size: 16px;
            color: #666;
        }
        
        .card {
            background: white;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        
        .card-body {
            padding: 20px;
        }
        
        .filters {
            margin-bottom: 30px;
        }
        
        .filters h2 {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 15px;
            color: #333;
        }
        
        .filter-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
        }
        
        .form-group label {
            font-weight: bold;
            margin-bottom: 5px;
            color: #333;
        }
        
        .form-control {
            padding: 10px 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
            background: white;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #007bff;
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
        }
        
        .btn-primary {
            background: #007bff;
            color: white;
        }
        
        .btn-primary:hover {
            background: #0056b3;
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #545b62;
        }
        
        .btn-success {
            background: #28a745;
            color: white;
        }
        
        .btn-success:hover {
            background: #218838;
        }
        
        .btn-sm {
            padding: 6px 12px;
            font-size: 12px;
        }
        
        .finish-btn {
            margin-left: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
        }
        
        .finish-btn:disabled {
            background: #6c757d !important;
            cursor: not-allowed;
            opacity: 0.6;
        }
        
        .finish-btn:disabled:hover {
            background: #6c757d !important;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .stat-card:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        
        .stat-number {
            font-size: 36px;
            font-weight: 700;
            margin-bottom: 5px;
        }
        
        .stat-card:nth-child(1) .stat-number {
            color: #007bff; /* Blue for Total */
        }
        
        .stat-card:nth-child(2) .stat-number {
            color: #ffc107; /* Yellow for Pending */
        }
        
        .stat-card:nth-child(3) .stat-number {
            color: #17a2b8; /* Teal for Approved */
        }
        
        .stat-card:nth-child(4) .stat-number {
            color: #28a745; /* Green for Finished */
        }
        
        .stat-label {
            color: #666;
            font-weight: 500;
            font-size: 14px;
        }
        
        .tasks-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 20px;
        }
        
        .task-card {
            background: white;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            cursor: pointer;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .task-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        
        .task-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }
        
        .task-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            flex: 1;
            margin-right: 15px;
            margin-bottom: 8px;
        }
        
        .badge {
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            white-space: nowrap;
        }
        
        .badge-pending {
            background: #fff3cd;
            color: #856404;
        }
        
        .badge-progress {
            background: #cce5ff;
            color: #004085;
        }
        
        .badge-review {
            background: #e6ccff;
            color: #5a1a7b;
        }
        
        .badge-completed {
            background: #d4edda;
            color: #155724;
        }
        
        .badge-high {
            background: #f8d7da;
            color: #721c24;
        }
        
        .badge-medium {
            background: #fff3cd;
            color: #856404;
        }
        
        .badge-low {
            background: #e2e3ff;
            color: #383d41;
        }
        
        .task-description {
            color: #666;
            margin-bottom: 15px;
            line-height: 1.5;
            font-size: 14px;
        }
        
        .task-details {
            margin-bottom: 10px;
        }
        
        .task-detail {
            display: flex;
            align-items: center;
            font-size: 14px;
            margin-bottom: 8px;
        }
        
        .task-detail-label {
            color: #666;
            width: 80px;
            flex-shrink: 0;
        }
        
        .task-detail-value {
            font-weight: 600;
            color: #333;
        }
        
        .task-footer {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .link {
            color: #007bff;
            text-decoration: none;
            font-weight: 500;
        }
        
        .link:hover {
            text-decoration: underline;
        }
        
        .pagination {
            background: white;
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 15px;
            margin-top: 20px;
        }
        
        .pagination-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .pagination-info {
            color: #666;
            font-size: 14px;
        }
        
        .pagination-controls {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .pagination-btn {
            padding: 8px 12px;
            border: 1px solid #ccc;
            background: white;
            cursor: pointer;
            font-size: 14px;
        }
        
        .pagination-btn:hover:not(:disabled) {
            background-color: #f0f0f0;
        }
        
        .pagination-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
        
        .pagination-btn.active {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
        }
        
        @media (max-width: 768px) {
            .mobile-menu-btn {
                display: block;
            }
            
            .sidebar {
                transform: translateX(-100%);
                width: 260px;
            }
            
            .sidebar.active {
                transform: translateX(0);
            }
            
            .main-content {
                margin-left: 0;
            }
            
            .container {
                padding: 15px;
            }
            
            .header h1 {
                font-size: 24px;
            }
            
            .filter-grid {
                grid-template-columns: 1fr;
            }
            
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .tasks-grid {
                grid-template-columns: 1fr;
            }
            
            .task-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 8px;
            }
            
            .stat-number {
                font-size: 28px;
            }
        }
    </style>
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
                                <option value="approved" <%= "approved".equals(request.getAttribute("statusFilter")) ? "selected" : "" %>>Approved</option>
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
                    <%= request.getAttribute("approvedTasks") != null ? request.getAttribute("approvedTasks") : 0 %>
                </div>
                <div class="stat-label">Approved</div>
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
                    for (Request req : assignedRequests) {d
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
                    <a href="#" class="link">View details</a>
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
