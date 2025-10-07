<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tech Employee Dashboard</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/tech-dashboard.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="wrapper">
        <!-- Sidebar -->
        <nav class="sidebar">
            <div class="sidebar-header">
                <h3><i class="fas fa-tools"></i> Tech Dashboard</h3>
            </div>
            <ul class="sidebar-menu">
                <li class="active">
                    <a href="${pageContext.request.contextPath}/techemployee/dashboard.jsp">
                        <i class="fas fa-home"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/techemployee/assigned-tasks.jsp">
                        <i class="fas fa-list-check"></i>
                        <span>Assigned Tasks List</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/techemployee/task-details.jsp">
                        <i class="fas fa-clipboard-list"></i>
                        <span>Task Details & Status</span>
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
            <!-- Dashboard Overview -->
            <div class="content-header">
                <h2><i class="fas fa-home"></i> Dashboard Overview</h2>
                <p>Welcome back! Here's your activity summary.</p>
            </div>
            
            <div class="row">
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-tasks"></i>
                        </div>
                        <div class="stat-content">
                            <h3>24</h3>
                            <p>Total Tasks</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="stat-content">
                            <h3>8</h3>
                            <p>Pending</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-spinner"></i>
                        </div>
                        <div class="stat-content">
                            <h3>6</h3>
                            <p>In Progress</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div class="stat-content">
                            <h3>10</h3>
                            <p>Completed</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="row mt-4">
                <div class="col-12">
                    <div class="quick-actions-card">
                        <h5><i class="fas fa-bolt"></i> Quick Actions</h5>
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <a href="${pageContext.request.contextPath}/techemployee/assigned-tasks.jsp" class="btn btn-primary w-100">
                                    <i class="fas fa-list-check"></i> View My Tasks
                                </a>
                            </div>
                            <div class="col-md-4 mb-3">
                                <a href="${pageContext.request.contextPath}/techemployee/task-details.jsp" class="btn btn-success w-100">
                                    <i class="fas fa-clipboard-list"></i> Update Task Status
                                </a>
                            </div>
                            <div class="col-md-4 mb-3">
                                <a href="${pageContext.request.contextPath}/techemployee/equipment-request.jsp" class="btn btn-warning w-100">
                                    <i class="fas fa-box"></i> Request Equipment
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Activities -->
            <div class="row mt-4">
                <div class="col-12">
                    <div class="recent-activities-card">
                        <h5><i class="fas fa-history"></i> Recent Activities</h5>
                        <div class="activity-item">
                            <div class="activity-icon completed">
                                <i class="fas fa-check"></i>
                            </div>
                            <div class="activity-content">
                                <h6>Task Completed</h6>
                                <p>Network maintenance for Building A - Floor 3</p>
                                <small class="text-muted">2 hours ago</small>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-icon pending">
                                <i class="fas fa-plus"></i>
                            </div>
                            <div class="activity-content">
                                <h6>New Task Assigned</h6>
                                <p>Install security cameras in conference room</p>
                                <small class="text-muted">4 hours ago</small>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-icon approved">
                                <i class="fas fa-tools"></i>
                            </div>
                            <div class="activity-content">
                                <h6>Equipment Request Approved</h6>
                                <p>Laptop Dell Inspiron 15 - Request #EQ001</p>
                                <small class="text-muted">1 day ago</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function logout() {
            if(confirm('Are you sure you want to logout?')) {
                // Implement logout logic here
                window.location.href = '${pageContext.request.contextPath}/customer_login.jsp';
            }
        }
    </script>
</body>
</html>