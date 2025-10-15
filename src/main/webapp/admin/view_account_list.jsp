<%--
  Created by IntelliJ IDEA.
  User: FPT SHOP
  Date: 10/15/2025
  Time: 11:17 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Account List</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <div class="col-md-2 sidebar p-0">
            <div class="p-4">
                <h4 class="mb-4"><i class="bi bi-shield-check"></i> Admin Panel</h4>
                <nav class="nav flex-column">
                    <a class="nav-link active" href="#"><i class="bi bi-people me-2"></i> Accounts</a>
                    <a class="nav-link" href="#"><i class="bi bi-graph-up me-2"></i> Analytics</a>
                    <a class="nav-link" href="#"><i class="bi bi-gear me-2"></i> Settings</a>
                    <a class="nav-link" href="#"><i class="bi bi-bell me-2"></i> Notifications</a>
                    <a class="nav-link" href="#"><i class="bi bi-file-text me-2"></i> Reports</a>
                </nav>
            </div>
        </div>

        <!-- Main Content -->
        <div class="col-md-10 main-content">
            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="mb-1">Account Management</h2>
                    <p class="text-muted">Monitor and manage all user accounts</p>
                </div>
                <button class="btn btn-primary" onclick="showAddAccountModal()">
                    <i class="bi bi-plus-circle me-2"></i>Add New Account
                </button>
            </div>

            <!-- Stats Cards -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="stats-card">
                        <div class="d-flex align-items-center">
                            <div class="stats-icon" style="background: linear-gradient(135deg, #667eea, #764ba2);">
                                <i class="bi bi-people"></i>
                            </div>
                            <div class="ms-3">
                                <h3 class="mb-0" id="totalAccounts">1,247</h3>
                                <p class="text-muted mb-0">Total Accounts</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stats-card">
                        <div class="d-flex align-items-center">
                            <div class="stats-icon" style="background: linear-gradient(135deg, #11998e, #38ef7d);">
                                <i class="bi bi-check-circle"></i>
                            </div>
                            <div class="ms-3">
                                <h3 class="mb-0" id="activeAccounts">1,089</h3>
                                <p class="text-muted mb-0">Active</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stats-card">
                        <div class="d-flex align-items-center">
                            <div class="stats-icon" style="background: linear-gradient(135deg, #ff9a9e, #fecfef);">
                                <i class="bi bi-clock"></i>
                            </div>
                            <div class="ms-3">
                                <h3 class="mb-0" id="pendingAccounts">43</h3>
                                <p class="text-muted mb-0">Pending</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stats-card">
                        <div class="d-flex align-items-center">
                            <div class="stats-icon" style="background: linear-gradient(135deg, #fc466b, #3f5efb);">
                                <i class="bi bi-x-circle"></i>
                            </div>
                            <div class="ms-3">
                                <h3 class="mb-0" id="inactiveAccounts">115</h3>
                                <p class="text-muted mb-0">Inactive</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Search and Filters -->
            <div class="accounts-table mb-4">
                <div class="p-4 border-bottom">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <div class="input-group">
                                    <span class="input-group-text bg-white border-end-0">
                                        <i class="bi bi-search"></i>
                                    </span>
                                <input type="text" class="form-control border-start-0 search-box"
                                       placeholder="Search by name, email, or ID..."
                                       id="searchInput" onkeyup="filterAccounts()">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <select class="form-select" id="roleFilter" onchange="filterAccounts()">
                                <option value="">All Roles</option>
                                <option value="admin">Admin</option>
                                <option value="user">User</option>
                                <option value="moderator">Moderator</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <select class="form-select" id="statusFilter" onchange="filterAccounts()">
                                <option value="">All Status</option>
                                <option value="active">Active</option>
                                <option value="inactive">Inactive</option>
                                <option value="pending">Pending</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Accounts Table -->
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead>
                        <tr>
                            <th>Account ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Last Login</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody id="accountsTableBody">
                        <!-- Table rows will be populated by JavaScript -->
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <div class="p-4 border-top">
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="text-muted">
                            Showing <span id="showingStart">1</span> to <span id="showingEnd">10</span> of <span
                                id="totalResults">1247</span> results
                        </div>
                        <nav>
                            <ul class="pagination mb-0" id="pagination">
                                <!-- Pagination will be populated by JavaScript -->
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Add Account Modal -->
<div class="modal fade" id="addAccountModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Add New Account</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form onsubmit="addAccount(event)">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Full Name</label>
                        <input type="text" class="form-control" id="newAccountName" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-control" id="newAccountEmail" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Role</label>
                        <select class="form-select" id="newAccountRole" required>
                            <option value="">Select Role</option>
                            <option value="user">User</option>
                            <option value="moderator">Moderator</option>
                            <option value="admin">Admin</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Status</label>
                        <select class="form-select" id="newAccountStatus" required>
                            <option value="active">Active</option>
                            <option value="pending">Pending</option>
                            <option value="inactive">Inactive</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Add Account</button>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>
