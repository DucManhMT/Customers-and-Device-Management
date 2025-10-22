<%--
  Created by IntelliJ IDEA.
  User: FPT SHOP
  Date: 10/11/2025
  Time: 2:34 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Create Role</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">

</head>
<body>
<header class="bg-white shadow-sm border-bottom mb-4 p-3">
    <h1 class="h3 mb-0 fw-bold text-dark">Role Management</h1>
</header>

<div class="container-fluid px-4 py-4">
    <div class="row g-4">
        <!-- Create New Role Form -->
        <div class="col-lg-8">
            <div class="form-card">
                <div class="d-flex align-items-center mb-4">
                    <div class="bg-primary bg-opacity-10 rounded p-2 me-3">
                        <i class="bi bi-plus-circle text-primary fs-5"></i>
                    </div>
                    <h2 class="h4 mb-0 ">Create New Role</h2>
                </div>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>
                <form id="roleForm" action="${pageContext.request.contextPath}/admin/role_list/create_role" method="post">
                    <!-- Role Name -->
<%--                    <div class="mb-4">--%>
<%--                        <label for="roleId" class="form-label fw-medium">Role ID</label>--%>
<%--                        <input type="text" class="form-control form-control-lg" id="roleId" name="roleId" required--%>
<%--                               placeholder="Enter ID..." value="${roleId != null ? roleId : ''}">--%>
<%--                    </div>--%>

                    <div class="mb-4">
                        <label for="roleName" class="form-label fw-medium">Role Name</label>
                        <input type="text" class="form-control form-control-lg" id="roleName" name="roleName" required
                               placeholder="Enter role name..." value="${roleName != null ? roleName : ''}">
                    </div>

                    <!-- Description -->


                    <!-- Permissions -->
                    <%--                    <div class="mb-4">--%>
                    <%--                        <label class="form-label fw-medium mb-3">Permissions</label>--%>
                    <%--                        <div class="row g-3">--%>
                    <%--                            <!-- User Management -->--%>
                    <%--                            <div class="col-md-6">--%>
                    <%--                                <div class="permission-group">--%>
                    <%--                                    <h5 class="h6 mb-3 d-flex align-items-center">--%>
                    <%--                                        <i class="bi bi-people text-muted me-2"></i>--%>
                    <%--                                        User Management--%>
                    <%--                                    </h5>--%>
                    <%--                                    <div class="d-flex flex-column gap-2">--%>
                    <%--                                        <div class="form-check">--%>
                    <%--                                            <input class="form-check-input" type="checkbox" name="permissions" value="users.view" id="users-view">--%>
                    <%--                                            <label class="form-check-label" for="users-view">View Users</label>--%>
                    <%--                                        </div>--%>
                    <%--                                        <div class="form-check">--%>
                    <%--                                            <input class="form-check-input" type="checkbox" name="permissions" value="users.create" id="users-create">--%>
                    <%--                                            <label class="form-check-label" for="users-create">Create Users</label>--%>
                    <%--                                        </div>--%>
                    <%--                                        <div class="form-check">--%>
                    <%--                                            <input class="form-check-input" type="checkbox" name="permissions" value="users.edit" id="users-edit">--%>
                    <%--                                            <label class="form-check-label" for="users-edit">Edit Users</label>--%>
                    <%--                                        </div>--%>
                    <%--                                        <div class="form-check">--%>
                    <%--                                            <input class="form-check-input" type="checkbox" name="permissions" value="users.delete" id="users-delete">--%>
                    <%--                                            <label class="form-check-label" for="users-delete">Delete Users</label>--%>
                    <%--                                        </div>--%>
                    <%--                                    </div>--%>
                    <%--                                </div>--%>
                    <%--                            </div>--%>

                    <%--                            <!-- Content Management -->--%>
                    <%--                            <div class="col-md-6">--%>
                    <%--                                <div class="permission-group">--%>
                    <%--                                    <h5 class="h6 mb-3 d-flex align-items-center">--%>
                    <%--                                        <i class="bi bi-file-text text-muted me-2"></i>--%>
                    <%--                                        Content Management--%>
                    <%--                                    </h5>--%>
                    <%--                                    <div class="d-flex flex-column gap-2">--%>
                    <%--                                        <div class="form-check">--%>
                    <%--                                            <input class="form-check-input" type="checkbox" name="permissions" value="content.view" id="content-view">--%>
                    <%--                                            <label class="form-check-label" for="content-view">View Content</label>--%>
                    <%--                                        </div>--%>
                    <%--                                        <div class="form-check">--%>
                    <%--                                            <input class="form-check-input" type="checkbox" name="permissions" value="content.create" id="content-create">--%>
                    <%--                                            <label class="form-check-label" for="content-create">Create Content</label>--%>
                    <%--                                        </div>--%>
                    <%--                                        <div class="form-check">--%>
                    <%--                                            <input class="form-check-input" type="checkbox" name="permissions" value="content.edit" id="content-edit">--%>
                    <%--                                            <label class="form-check-label" for="content-edit">Edit Content</label>--%>
                    <%--                                        </div>--%>
                    <%--                                        <div class="form-check">--%>
                    <%--                                            <input class="form-check-input" type="checkbox" name="permissions" value="content.publish" id="content-publish">--%>
                    <%--                                            <label class="form-check-label" for="content-publish">Publish Content</label>--%>
                    <%--                                        </div>--%>
                    <%--                                    </div>--%>
                    <%--                                </div>--%>
                    <%--                            </div>--%>

                    <%--                            <!-- System Settings -->--%>
                    <%--                            <div class="col-md-6">--%>
                    <%--                                <div class="permission-group">--%>
                    <%--                                    <h5 class="h6 mb-3 d-flex align-items-center">--%>
                    <%--                                        <i class="bi bi-gear text-muted me-2"></i>--%>
                    <%--                                        System Settings--%>
                    <%--                                    </h5>--%>
                    <%--                                    <div class="d-flex flex-column gap-2">--%>
                    <%--                                        <div class="form-check">--%>
                    <%--                                            <input class="form-check-input" type="checkbox" name="permissions" value="settings.view" id="settings-view">--%>
                    <%--                                            <label class="form-check-label" for="settings-view">View Settings</label>--%>
                    <%--                                        </div>--%>
                    <%--                                        <div class="form-check">--%>
                    <%--                                            <input class="form-check-input" type="checkbox" name="permissions" value="settings.edit" id="settings-edit">--%>
                    <%--                                            <label class="form-check-label" for="settings-edit">Edit Settings</label>--%>
                    <%--                                        </div>--%>
                    <%--                                        <div class="form-check">--%>
                    <%--                                            <input class="form-check-input" type="checkbox" name="permissions" value="backup.create" id="backup-create">--%>
                    <%--                                            <label class="form-check-label" for="backup-create">Create Backups</label>--%>
                    <%--                                        </div>--%>
                    <%--                                    </div>--%>
                    <%--                                </div>--%>
                    <%--                            </div>--%>

                    <%--                            <!-- Reports & Analytics -->--%>
                    <%--                            <div class="col-md-6">--%>
                    <%--                                <div class="permission-group">--%>
                    <%--                                    <h5 class="h6 mb-3 d-flex align-items-center">--%>
                    <%--                                        <i class="bi bi-bar-chart text-muted me-2"></i>--%>
                    <%--                                        Reports & Analytics--%>
                    <%--                                    </h5>--%>
                    <%--                                    <div class="d-flex flex-column gap-2">--%>
                    <%--                                        <div class="form-check">--%>
                    <%--                                            <input class="form-check-input" type="checkbox" name="permissions" value="reports.view" id="reports-view">--%>
                    <%--                                            <label class="form-check-label" for="reports-view">View Reports</label>--%>
                    <%--                                        </div>--%>
                    <%--                                        <div class="form-check">--%>
                    <%--                                            <input class="form-check-input" type="checkbox" name="permissions" value="reports.export" id="reports-export">--%>
                    <%--                                            <label class="form-check-label" for="reports-export">Export Reports</label>--%>
                    <%--                                        </div>--%>
                    <%--                                        <div class="form-check">--%>
                    <%--                                            <input class="form-check-input" type="checkbox" name="permissions" value="analytics.view" id="analytics-view">--%>
                    <%--                                            <label class="form-check-label" for="analytics-view">View Analytics</label>--%>
                    <%--                                        </div>--%>
                    <%--                                    </div>--%>
                    <%--                                </div>--%>
                    <%--                            </div>--%>
                    <%--                        </div>--%>
                    <%--                    </div>--%>

                    <!-- Submit Buttons -->
                    <div class="d-flex justify-content-end gap-2 pt-3 border-top">
                        <a href="${pageContext.request.contextPath}/admin/role_list" class="btn btn-outline-secondary">
                            Cancel
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-plus-circle me-2"></i>
                            Create Role
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Sidebar -->
<%--        <div class="col-lg-4">--%>
<%--            <!-- Existing Roles -->--%>
<%--            <div class="stats-card mb-4">--%>
<%--                <h3 class="h5 fw-semibold mb-3">Existing Roles</h3>--%>
<%--                <div id="rolesList">--%>
<%--                    <!-- Sample existing roles -->--%>
<%--                    <div class="role-card">--%>
<%--                        <div class="d-flex justify-content-between align-items-start mb-2">--%>
<%--                            <h4 class="h6 mb-0 fw-medium">Super Admin</h4>--%>
<%--                            <span class="badge bg-danger badge-custom">All Access</span>--%>
<%--                        </div>--%>
<%--                        <p class="text-muted small mb-2">Full system access and control</p>--%>
<%--                        <div class="d-flex gap-2">--%>
<%--                            <button class="btn btn-link btn-sm p-0 text-primary">Edit</button>--%>
<%--                            <button class="btn btn-link btn-sm p-0 text-muted">View</button>--%>
<%--                        </div>--%>
<%--                    </div>--%>

<%--                    <div class="role-card">--%>
<%--                        <div class="d-flex justify-content-between align-items-start mb-2">--%>
<%--                            <h4 class="h6 mb-0 fw-medium">Editor</h4>--%>
<%--                            <span class="badge bg-success badge-custom">Content</span>--%>
<%--                        </div>--%>
<%--                        <p class="text-muted small mb-2">Can create and edit content</p>--%>
<%--                        <div class="d-flex gap-2">--%>
<%--                            <button class="btn btn-link btn-sm p-0 text-primary">Edit</button>--%>
<%--                            <button class="btn btn-link btn-sm p-0 text-muted">View</button>--%>
<%--                        </div>--%>
<%--                    </div>--%>

<%--                    <div class="role-card">--%>
<%--                        <div class="d-flex justify-content-between align-items-start mb-2">--%>
<%--                            <h4 class="h6 mb-0 fw-medium">Viewer</h4>--%>
<%--                            <span class="badge bg-secondary badge-custom">Read Only</span>--%>
<%--                        </div>--%>
<%--                        <p class="text-muted small mb-2">View-only access to content</p>--%>
<%--                        <div class="d-flex gap-2">--%>
<%--                            <button class="btn btn-link btn-sm p-0 text-primary">Edit</button>--%>
<%--                            <button class="btn btn-link btn-sm p-0 text-muted">View</button>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>

<%--            <!-- Quick Stats -->--%>
<%--            <div class="stats-card">--%>
<%--                <h3 class="h5 fw-semibold mb-3">Quick Stats</h3>--%>
<%--                <div class="d-flex flex-column gap-2">--%>
<%--                    <div class="d-flex justify-content-between">--%>
<%--                        <span class="text-muted">Total Roles</span>--%>
<%--                        <span class="fw-medium" id="totalRoles">${roleCount}</span>--%>
<%--                    </div>--%>
<%--                    <div class="d-flex justify-content-between">--%>
<%--                        <span class="text-muted">Active Users</span>--%>
<%--                        <span class="fw-medium">24</span>--%>
<%--                    </div>--%>
<%--                    <div class="d-flex justify-content-between">--%>
<%--                        <span class="text-muted">Permissions</span>--%>
<%--                        <span class="fw-medium">15</span>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </div>--%>
    </div>
</div>

<script>
    function validateName(name) {
        const nameRegex = /^[a-zA-Z\s]{2,30}$/;
        return nameRegex.test(name.trim());
    }
    document.getElementById("roleForm").addEventListener("submit", function (event) {
        const nameInput = document.getElementById("roleName");
        const name = nameInput.value.trim();

        // Nếu không hợp lệ => chặn gửi form
        if (!validateName(name)) {
            event.preventDefault(); // chặn gửi
            alert("Role name must contain only letters and spaces (2–30 characters).");
            nameInput.focus();
        }
    });
</script>

</body>
</html>
