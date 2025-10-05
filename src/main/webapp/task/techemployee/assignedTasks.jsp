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
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
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
            background: #6c757d;
            cursor: not-allowed;
            opacity: 0.6;
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
            color: #007bff;
            margin-bottom: 5px;
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
    <!-- Mobile Menu Button -->
    <button class="mobile-menu-btn" onclick="toggleSidebar()">
        <i class="fas fa-bars"></i>
    </button>

    <!-- Sidebar Navigation -->
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

    <!-- Main Content -->
    <div class="main-content">
        <div class="container">
        <!-- Header -->
        <div class="header">
            <h1> Task List</h1>
        </div>

        <!-- Filters -->
        <div class="card filters">
            <div class="card-body">
                <h2>Filters</h2>
                <div class="filter-grid">
                    <div class="form-group">
                        <label>Status</label>
                        <select class="form-control">
                            <option value="">All Status</option>
                            <option value="pending">Pending</option>
                            <option value="in-progress">In Progress</option>
                            <option value="review">In Review</option>
                            <option value="completed">Completed</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Sort by Time</label>
                        <select class="form-control">
                            <option value="newest">Newest First</option>
                            <option value="oldest">Oldest First</option>
                            <option value="deadline">Deadline Approaching</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Search by Phone Number</label>
                        <input type="text" placeholder="Search by phone number..." class="form-control">
                    </div>
                </div>
                <div class="filter-buttons">
                    <button class="btn btn-primary">Apply Filters</button>
                    <button class="btn btn-secondary">Clear Filters</button>
                </div>
            </div>
        </div>

        <!-- Task Statistics -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number">4</div>
                <div class="stat-label">Total Tasks</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">1</div>
                <div class="stat-label">Pending</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">2</div>
                <div class="stat-label">In Progress</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">1</div>
                <div class="stat-label">Completed</div>
            </div>
        </div>

        <!-- Tasks List -->
        <div class="tasks-grid">
            <!-- Sample Task 1 -->
            <div class="task-card">
                <div class="task-header">
                    <h3 class="task-title">Laptop Screen Replacement</h3>
                    <span class="badge badge-progress">In Progress</span>
                </div>
                <p class="task-description">Dell Inspiron 15 laptop screen replacement due to physical damage. Customer requires urgent repair for work purposes.</p>
                <div class="task-details">
                    <div class="task-detail">
                        <span class="task-detail-label">Customer:</span>
                        <span class="task-detail-value">Nguyen Van Duc</span>
                    </div>
                    <div class="task-detail">
                        <span class="task-detail-label">Phone:</span>
                        <span class="task-detail-value">0938-123-456</span>
                    </div>
                    <div class="task-detail">
                        <span class="task-detail-label">Deadline:</span>
                        <span class="task-detail-value">Feb 15, 2024</span>
                        <span style="margin-left: 8px; color: #333; font-weight: bold;">5 days left</span>
                    </div>
                </div>
                <div class="task-footer">
                    <a href="#" class="link">View details</a>
                    <button class="btn btn-success btn-sm finish-btn" onclick="markAsFinished(this, 'TASK-001')">
                        <i class="fas fa-check"></i> Mark as Finished
                    </button>
                </div>
            </div>

            <!-- Sample Task 2 -->
            <div class="task-card">
                <div class="task-header">
                    <h3 class="task-title">PC Motherboard Diagnosis</h3>
                    <span class="badge badge-pending">Pending</span>
                </div>
                <p class="task-description">Asus gaming PC not booting. Suspected motherboard failure. Need complete hardware diagnosis and repair estimate.</p>
                <div class="task-details">
                    <div class="task-detail">
                        <span class="task-detail-label">Customer:</span>
                        <span class="task-detail-value">Tran Thi Mai</span>
                    </div>
                    <div class="task-detail">
                        <span class="task-detail-label">Phone:</span>
                        <span class="task-detail-value">0987-654-321</span>
                    </div>
                    <div class="task-detail">
                        <span class="task-detail-label">Deadline:</span>
                        <span class="task-detail-value">Feb 20, 2024</span>
                        <span style="margin-left: 8px; color: #666;">10 days left</span>
                    </div>

                </div>
                <div class="task-footer">
                    <a href="#" class="link">View details</a>
                    <button class="btn btn-success btn-sm finish-btn" onclick="markAsFinished(this, 'TASK-002')">
                        <i class="fas fa-check"></i> Mark as Finished
                    </button>
                </div>
            </div>
        </div>

        <!-- Pagination -->
        <div class="pagination">
            <div class="pagination-content">
                <div class="pagination-info">
                    Showing 1 - 4 of 4 tasks
                </div>
                
                <div class="items-per-page">
                    <label>Show:</label>
                    <select class="form-control">
                        <option value="4" selected>4 tasks</option>
                        <option value="6">6 tasks</option>
                        <option value="8">8 tasks</option>
                        <option value="12">12 tasks</option>
                    </select>
                </div>
                
                <div class="pagination-controls">
                    <button class="pagination-btn" disabled>‹ Previous</button>
                    <button class="pagination-btn active">1</button>
                    <button class="pagination-btn" disabled>Next ›</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Simple logout function
        function logout() {
            if(confirm('Are you sure you want to logout?')) {
                window.location.href = '${pageContext.request.contextPath}/login.jsp';
            }
        }
        
        // Mobile sidebar toggle
        function toggleSidebar() {
            document.querySelector('.sidebar').classList.toggle('active');
        }
        
        // Mark task as finished
        function markAsFinished(button, taskId) {
            if(confirm('Are you sure you want to mark this task as finished?')) {
                // Find the task card containing this button
                var taskCard = button.closest('.task-card');
                
                // Find and update the status badge
                var statusBadge = taskCard.querySelector('.badge');
                statusBadge.className = 'badge badge-completed';
                statusBadge.textContent = 'Completed';
                
                // Disable the finish button
                button.disabled = true;
                button.innerHTML = '<i class="fas fa-check"></i> Finished';
                
                // Optional: You can add AJAX call here to update the server
                // Example:
                // fetch('/api/tasks/' + taskId + '/finish', { method: 'PUT' })
                //     .then(response => response.json())
                //     .then(data => console.log('Task updated:', data));
                
                alert('Task marked as completed successfully!');
            }
        }
    </script>
        </div>
    </div>
</body>
</html>
