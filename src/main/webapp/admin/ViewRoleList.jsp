<%-- Created by IntelliJ IDEA. User: FPT SHOP Date: 10/6/2025 Time: 4:30 PM --%>
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
        </div>
    </div>

    <!-- Stats Cards -->
    <div class="row mb-4">
        <div class="col-md-6">
            <div class="card stats-card h-100">
                <div class="card-body d-flex align-items-center">
                    <div class="stats-icon bg-primary bg-opacity-10 text-primary me-3">
                        <i class="bi bi-people fs-4"></i>
                    </div>
                    <div>
                        <h6 class="card-subtitle mb-1 text-muted">Total Roles</h6>
                        <h3 class="card-title mb-0 fw-bold">${totalRoles}</h3>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card stats-card h-100">
                <div class="card-body d-flex align-items-center">
                    <div class="stats-icon bg-info bg-opacity-10 text-info me-3">
                        <i class="bi bi-person-check fs-4"></i>
                    </div>
                    <div>
                        <h6 class="card-subtitle mb-1 text-muted">Assigned Users</h6>
                        <h3 class="card-title mb-0 fw-bold">${totalUsers}</h3>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Roles Table -->
    <div class="table-container">
        <div class="card-header bg-white border-bottom p-4">
            <form class="row g-2 align-items-center" method="get" action="ViewRoleList">
                <div class="col-12 col-md-5">
                    <input type="text" class="form-control" name="search" placeholder="Search roles..." value="${search}">
                </div>

                <div class="col-12 col-md-2">
                    <button type="submit" class="btn btn-outline-secondary w-100">
                        <i class="bi bi-search"></i> Search
                    </button>
                </div>
                <div class ="col-12 col-md-2">
                    <a href="ViewRoleList" class="btn btn-outline-secondary w-100">
                        <i class="bi bi-arrow-clockwise"></i> Reset
                    </a>
                </div>
                <div class="col-12 col-md-3">
                    <a href="AddRole" class="btn btn-primary w-100">
                        <i class="bi bi-plus-lg"></i> Add New Role
                    </a>
                </div>
            </form>
        </div>
    </div>

    <div class="table-responsive">
        <table class="table table-hover mb-0">
            <thead>
            <tr>
                <th>Role ID</th>
                <th>Role Name</th>
                <th>Users</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody id="rolesTableBody">
            <c:forEach items="${roles}" var="role">
                <tr class="align-middle">
                    <td>${role.roleID}</td>
                    <td>${role.roleName}</td>
                    <td>${userCountPerRole[role.roleID]}</td>
                    <td>
                        <a href="ViewRoleDetail?id=${role.roleID}" class="btn btn-sm btn-info me-2 text-white">
                            <i class="bi bi-eye"></i> View Detail
                        </a>
                        <a href="EditRole?id=${role.roleID}" class="btn btn-sm btn-primary me-2">
                            <i class="bi bi-pencil-square"></i> Edit
                        </a>
                        <a href="DeleteRole?id=${role.roleID}" class="btn btn-sm btn-danger"
                           onclick="return confirm('Are you sure you want to delete this role?');">
                            <i class="bi bi-trash"></i> Delete
                        </a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Pagination -->
    <form method="get" action="ViewRoleList">
        <input type="hidden" name="search" value="${search}" />
        <div class="d-flex align-items-center">
            <span class="me-3">Show:</span>
            <select name="itemsPerPage" class="form-select form-select-sm" style="width: auto;"
                    onchange="this.form.submit()">
                <option value="5" ${recordsPerPage==5 ? 'selected' : '' }>5</option>
                <option value="10" ${recordsPerPage==10 ? 'selected' : '' }>10</option>
                <option value="15" ${recordsPerPage==15 ? 'selected' : '' }>15</option>
                <option value="20" ${recordsPerPage==20 ? 'selected' : '' }>20</option>
            </select>
        </div>
    </form>
    <nav class="mt-4">
        <ul class="pagination justify-content-center">
            <!-- Previous -->
            <c:if test="${currentPage > 1}">
                <li class="page-item">
                    <a class="page-link"
                       href="ViewRoleList?page=${currentPage - 1}&itemsPerPage=${recordsPerPage}&search=${search}">
                        Previous
                    </a>
                </li>
            </c:if>

            <!-- Các số trang -->
            <c:forEach begin="1" end="${totalPages}" var="i">
                <li class="page-item ${i == currentPage ? 'active' : ''}">
                    <a class="page-link"
                       href="ViewRoleList?page=${i}&itemsPerPage=${recordsPerPage}&search=${search}">
                            ${i}
                    </a>
                </li>
            </c:forEach>

            <!-- Next -->
            <c:if test="${currentPage < totalPages}">
                <li class="page-item">
                    <a class="page-link"
                       href="ViewRoleList?page=${currentPage + 1}&itemsPerPage=${recordsPerPage}&search=${search}">
                        Next
                    </a>
                </li>
            </c:if>
        </ul>
    </nav>
</div>
</body>
</html>