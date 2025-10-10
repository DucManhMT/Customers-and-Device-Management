<%--
  Created by IntelliJ IDEA.
  User: FPT SHOP
  Date: 10/6/2025
  Time: 4:30 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Role List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">

</head>
<body>
<div class="container-fluid py-4">
    <!-- Page Header -->
    <div class="row mb-4">
        <div class="col">
            <h2 class="fw-bold text-dark mb-2">Role Management</h2>
            <p class="text-muted mb-0">Manage system roles and their associated permissions</p>
        </div>
    </div>

    <!-- Stats Cards -->
    <div class="row mb-4">
        <div class="col-md-3 mb-3">
            <div class="card stats-card h-100">
                <div class="card-body d-flex align-items-center">
                    <div class="stats-icon bg-primary bg-opacity-10 text-primary me-3">
                        <i class="bi bi-people fs-4"></i>
                    </div>
                    <div>
                        <h6 class="card-subtitle mb-1 text-muted">Total Roles</h6>
                        <h3 class="card-title mb-0 fw-bold">5</h3>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-3">
            <div class="card stats-card h-100">
                <div class="card-body d-flex align-items-center">
                    <div class="stats-icon bg-success bg-opacity-10 text-success me-3">
                        <i class="bi bi-check-circle fs-4"></i>
                    </div>
                    <div>
                        <h6 class="card-subtitle mb-1 text-muted">Active Roles</h6>
                        <h3 class="card-title mb-0 fw-bold">4</h3>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-3">
            <div class="card stats-card h-100">
                <div class="card-body d-flex align-items-center">
                    <div class="stats-icon bg-warning bg-opacity-10 text-warning me-3">
                        <i class="bi bi-key fs-4"></i>
                    </div>
                    <div>
                        <h6 class="card-subtitle mb-1 text-muted">Permissions</h6>
                        <h3 class="card-title mb-0 fw-bold">24</h3>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-3">
            <div class="card stats-card h-100">
                <div class="card-body d-flex align-items-center">
                    <div class="stats-icon bg-info bg-opacity-10 text-info me-3">
                        <i class="bi bi-person-check fs-4"></i>
                    </div>
                    <div>
                        <h6 class="card-subtitle mb-1 text-muted">Assigned Users</h6>
                        <h3 class="card-title mb-0 fw-bold">127</h3>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Roles Table -->
    <div class="table-container">
        <div class="card-header bg-white border-bottom p-4">
            <div class="row align-items-center">
                <div class="col">
                    <h5 class="mb-0 fw-semibold">System Roles</h5>
                </div>
                <div class="col-auto">
                    <div class="d-flex gap-3">
                        <div class="position-relative">
                            <input type="text" class="form-control ps-5" placeholder="Search roles..." id="searchInput">
                            <i class="bi bi-search position-absolute top-50 start-0 translate-middle-y ms-3 text-muted"></i>
                        </div>
                        <select class="form-select" style="width: auto;">
                            <option>All Roles</option>
                            <option>Active</option>
                            <option>Inactive</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>

        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead>
                <tr>
                    <th>Role ID</th>
                    <th>Role Name</th>
                    <th>Description</th>
                    <th>Permissions</th>
                    <th>Users</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody id="rolesTableBody">
                <c:forEach items="${roles}" var="role">
                    <tr class="align-middle">
                        <td>${role.id}</td>
                        <td>${role.name}</td>
                        <td>${role.description}</td>
                        <td>
                            <c:forEach items="${role.permissions}" var="perm">
                                <span class="badge bg-secondary me-1 mb-1">${perm}</span>
                            </c:forEach>
                        </td>
                        <td>${role.userCount}</td>
                        <td>
                            <c:choose>
                                <c:when test="${role.active}">
                                    <span class="badge bg-success">Active</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary">Inactive</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="EditRole?id=${role.id}" class="btn btn-sm btn-primary me-2">
                                <i class="bi bi-pencil-square"></i> Edit
                            </a>
                            <a href="DeleteRole?id=${role.id}" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure you want to delete this role?');">
                                <i class="bi bi-trash"></i> Delete
                            </a>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Pagination -->
    <div class="d-flex justify-content-between align-items-center mt-4">
        <div class="text-muted">
            Showing <span class="fw-semibold">1</span> to <span class="fw-semibold">5</span> of <span class="fw-semibold">5</span> results
        </div>
        <nav>
            <ul class="pagination mb-0">
                <li class="page-item disabled">
                    <a class="page-link" href="#" tabindex="-1">Previous</a>
                </li>
                <li class="page-item active">
                    <a class="page-link" href="#">1</a>
                </li>
                <li class="page-item disabled">
                    <a class="page-link" href="#">Next</a>
                </li>
            </ul>
        </nav>
    </div>
</div>
</body>
</html>
