<%-- Created by IntelliJ IDEA. User: FPT SHOP Date: 10/6/2025 Time: 4:30 PM --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Role List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <script src="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<c:set var="activePage" value="rolemanage" scope="request" />
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/admin_sidebar.jsp"/>

<div class="container-fluid py-4">
    <!-- Page Header -->
    <div class="row mb-4">
        <div class="col">
            <h2 class="fw-bold text-dark mb-2">Role Management</h2>
        </div>
    </div>




    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>
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
            <form class="row g-2 align-items-center" method="get"
                  action="${pageContext.request.contextPath}/admin/role_list">
                <div class="col-12 col-md-5">
                    <input type="text" class="form-control" name="search" placeholder="Search roles..."
                           value="${search}">
                </div>

                <div class="col-12 col-md-2">
                    <button type="submit" class="btn btn-outline-secondary w-100">
                        <i class="bi bi-search"></i> Search
                    </button>
                </div>
                <div class="col-12 col-md-2">
                    <a href="${pageContext.request.contextPath}/admin/role_list"
                       class="btn btn-outline-secondary w-100">
                        <i class="bi bi-arrow-clockwise"></i> Reset
                    </a>
                </div>
                <div class="col-12 col-md-3">
                    <a href="${pageContext.request.contextPath}/admin/role_list/create_role"
                       class="btn btn-primary w-100">
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
                        <a href="${pageContext.request.contextPath}/admin/role_list/view_role_detail?id=${role.roleID}"
                           class="btn btn-sm btn-info me-2 text-white">
                            <i class="bi bi-eye"></i> View Detail
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/role_list/edit_role?id=${role.roleID}"
                           class="btn btn-sm btn-primary me-2">
                            <i class="bi bi-pencil-square"></i> Edit
                        </a>
                        <form action="${pageContext.request.contextPath}/admin/role_list" method="post"
                              style="display:inline;">
                            <input type="hidden" name="action" value="delete"/>
                            <input type="hidden" name="id" value="${role.roleID}"/>
                            <button type="submit" class="btn btn-sm btn-danger"
                                    onclick="return confirm('Are you sure you want to delete this role?');">
                                <i class="bi bi-trash"></i> Delete
                            </button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Pagination -->
    <form method="get" action=${pageContext.request.contextPath}/admin/role_list>
        <input type="hidden" name="search" value="${search}"/>
        <div class="mt-4 d-flex align-items-center">
            <span class="me-3">Show:</span>
            <select name="itemsPerPage" class="form-select form-select-sm" style="width: auto;"
                    onchange="this.form.submit()">
                <option value="5" ${itemsPerPage==5 ? 'selected' : '' }>5</option>
                <option value="10" ${itemsPerPage==10 ? 'selected' : '' }>10</option>
                <option value="15" ${itemsPerPage==15 ? 'selected' : '' }>15</option>
                <option value="20" ${itemsPerPage==20 ? 'selected' : '' }>20</option>
            </select>
        </div>
    </form>
    <nav class="mt-4">
        <ul class="pagination justify-content-center">
            <!-- Previous -->
            <c:if test="${currentPage > 1}">
                <li class="page-item">
                    <a class="page-link"
                       href="${pageContext.request.contextPath}/admin/role_list?page=${currentPage - 1}&itemsPerPage=${recordsPerPage}&search=${search}">
                        Previous
                    </a>
                </li>
            </c:if>

            <!-- Các số trang -->
            <c:forEach begin="1" end="${totalPages}" var="i">
                <li class="page-item ${i == currentPage ? 'active' : ''}">
                    <a class="page-link"
                       href="${pageContext.request.contextPath}/admin/role_list?page=${i}&itemsPerPage=${recordsPerPage}&search=${search}">
                            ${i}
                    </a>
                </li>
            </c:forEach>

            <!-- Next -->
            <c:if test="${currentPage < totalPages}">
                <li class="page-item">
                    <a class="page-link"
                       href="${pageContext.request.contextPath}/admin/role_list?page=${currentPage + 1}&itemsPerPage=${recordsPerPage}&search=${search}">
                        Next
                    </a>
                </li>
            </c:if>
        </ul>
    </nav>
</div>
</body>
</html>