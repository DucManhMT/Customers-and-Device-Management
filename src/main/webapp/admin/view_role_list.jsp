<%-- Created by IntelliJ IDEA. User: FPT SHOP Date: 10/6/2025 Time: 4:30 PM --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Role List</title>

    <!-- Bootstrap / Icons / Font -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">

    <script src="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/js/bootstrap.bundle.min.js"></script>

    <style>
        body {
            background: #f1f4ff;
        }

        h2 {
            font-weight: 700;
            color: #1e1e1e;
        }

        /* ==== STAT CARDS ==== */
        .stats-card {
            border: none;
            border-radius: 18px;
            background: linear-gradient(120deg, #ff8a9e, #fad0c4);
            box-shadow: 0 8px 20px rgba(255, 105, 135, 0.25);
            transition: 0.25s ease-in-out;
        }
        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 26px rgba(0,0,0,0.12);
        }

        .stats-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            background: rgba(255,255,255,0.35);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
        }

        /* ==== FILTER SEARCH AREA ==== */
        .table-container .card-header {
            background: linear-gradient(120deg, #6c5fff, #52a3ff);
            border-radius: 15px;
            color: white;
            box-shadow: 0 5px 16px rgba(98, 88, 255, 0.25);
        }

        .table-container .form-control,
        .table-container .btn,
        .table-container .form-select {
            border-radius: 10px !important;
        }

        /* ===== BUTTONS ===== */
        .btn-primary {
            background: #5a4fff;
            border-radius: 10px;
            border: none;
        }
        .btn-primary:hover {
            background: #4a3dff;
        }

        .btn-info {
            background: #02b8ff;
            border: none;
            color: white;
        }

        .btn-danger {
            background: #ff4d4f;
            border: none;
        }

        .btn-success {
            background: #27c94f;
            border: none;
        }

        /* ==== TABLE ==== */
        .table {
            background: #ffffff;
            border-radius: 14px;
            overflow: hidden;
            box-shadow: 0 5px 18px rgba(0,0,0,0.08);
        }
        .table thead {
            background: #e7e9ff;
            font-weight: 600;
            color: #2e2e2e;
        }
        .table-hover tbody tr:hover {
            background: #f0f2ff;
        }

        /* STATUS BADGE */
        .badge-active {
            background: #38c172;
            padding: 6px 12px;
            border-radius: 8px;
            color: white;
        }
        .badge-inactive {
            background: #f24a4a;
            padding: 6px 12px;
            border-radius: 8px;
            color: white;
        }

        /* PAGINATION */
        .pagination .page-link {
            border-radius: 8px !important;
        }
        .page-item.active .page-link {
            background: #5a4fff;
            border-color: #5a4fff;
        }
    </style>
</head>
<body>

<c:set var="activePage" value="rolemanage" scope="request" />
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/admin_sidebar.jsp"/>

<div class="container-fluid py-4">

    <div class="row mb-4">
        <div class="col">
            <h2 class="fw-bold">Role Management</h2>
        </div>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger" id="errorMessage">${error}</div>
    </c:if>
    <c:if test="${not empty roleSuccess}">
        <div class="alert alert-success" id="successMessage">${roleSuccess}</div>
    </c:if>

    <!-- Stats -->
    <div class="row mb-4">
        <div class="col-md-6">
            <div class="card stats-card h-100">
                <div class="card-body d-flex align-items-center">
                    <div class="stats-icon text-dark me-3">
                        <i class="bi bi-people"></i>
                    </div>
                    <div>
                        <h6 class="text-dark-50">Total Roles</h6>
                        <h3 class="fw-bold">${totalRoles}</h3>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card stats-card h-100">
                <div class="card-body d-flex align-items-center">
                    <div class="stats-icon text-dark me-3">
                        <i class="bi bi-person-check"></i>
                    </div>
                    <div>
                        <h6 class="text-dark-50">Assigned Users</h6>
                        <h3 class="fw-bold">${totalUsers}</h3>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Search + Add -->
    <div class="table-container">
        <div class="card-header p-4">
            <form class="row g-2 align-items-center" method="get"
                  action="${pageContext.request.contextPath}/admin/role_list">

                <div class="col-md-5">
                    <input type="text" class="form-control" name="search"
                           placeholder="Search roles..." value="${search}">
                </div>

                <div class="col-md-2">
                    <button class="btn btn-outline-light w-100">
                        <i class="bi bi-search"></i> Search
                    </button>
                </div>

                <div class="col-md-2">
                    <a href="${pageContext.request.contextPath}/admin/role_list"
                       class="btn btn-outline-light w-100">
                        <i class="bi bi-arrow-clockwise"></i> Reset
                    </a>
                </div>

                <div class="col-md-3">
                    <a href="${pageContext.request.contextPath}/admin/role_list/create_role"
                       class="btn btn-primary w-100">
                        <i class="bi bi-plus-lg"></i> Add New Role
                    </a>
                </div>

            </form>
        </div>
    </div>

    <!-- Table -->
    <div class="table-responsive mt-3">
        <table class="table table-hover">
            <thead>
            <tr>
                <th>Role ID</th>
                <th>Role Name</th>
                <th>Users</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>

            <c:forEach items="${roles}" var="role">
                <tr class="align-middle">
                    <td>${role.roleID}</td>
                    <td>${role.roleName}</td>
                    <td>${userCountPerRole[role.roleID]}</td>

                    <td>
                        <span class="${role.roleStatus=='Active' ? 'badge-active' : 'badge-inactive'}">
                                ${role.roleStatus}
                        </span>
                    </td>

                    <td>
                        <a href="${pageContext.request.contextPath}/admin/role_list/view_role_detail?id=${role.roleID}"
                           class="btn btn-info btn-sm me-2">
                            <i class="bi bi-eye"></i> View
                        </a>

                        <a href="${pageContext.request.contextPath}/admin/role_list/edit_role?id=${role.roleID}"
                           class="btn btn-primary btn-sm me-2">
                            <i class="bi bi-pencil-square"></i> Edit
                        </a>

                        <form action="${pageContext.request.contextPath}/admin/role_list"
                              method="post" class="d-inline">
                            <input type="hidden" name="action"
                                   value="${role.roleStatus == 'Active' ? 'deactivate' : 'activate'}">
                            <input type="hidden" name="id" value="${role.roleID}">

                            <button class="btn btn-sm ${role.roleStatus=='Active' ? 'btn-danger' : 'btn-success'}"
                                    onclick="return confirm('Are you sure?')">
                                <i class="bi ${role.roleStatus=='Active' ? 'bi-trash' : 'bi-check-circle'}"></i>
                                    ${role.roleStatus=='Active' ? 'Deactivate' : 'Activate'}
                            </button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>


    <!-- PAGINATION -->
    <form method="get" action="${pageContext.request.contextPath}/admin/role_list" class="mt-3">
        <input type="hidden" name="search" value="${search}">
        <span>Show:</span>
        <select name="itemsPerPage" class="form-select form-select-sm d-inline-block ms-2" style="width:auto;" onchange="this.form.submit()">
            <option value="5" ${itemsPerPage==5 ? 'selected' : ''}>5</option>
            <option value="10" ${itemsPerPage==10 ? 'selected' : ''}>10</option>
            <option value="15" ${itemsPerPage==15 ? 'selected' : ''}>15</option>
            <option value="20" ${itemsPerPage==20 ? 'selected' : ''}>20</option>
        </select>
    </form>

    <nav class="mt-4">
        <ul class="pagination justify-content-center">
            <c:if test="${currentPage > 1}">
                <li class="page-item">
                    <a class="page-link"
                       href="${pageContext.request.contextPath}/admin/role_list?page=${currentPage - 1}&itemsPerPage=${recordsPerPage}&search=${search}">
                        Previous
                    </a>
                </li>
            </c:if>

            <c:forEach begin="1" end="${totalPages}" var="i">
                <li class="page-item ${i == currentPage ? 'active' : ''}">
                    <a class="page-link"
                       href="${pageContext.request.contextPath}/admin/role_list?page=${i}&itemsPerPage=${recordsPerPage}&search=${search}">
                            ${i}
                    </a>
                </li>
            </c:forEach>

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

<script>
    ['errorMessage', 'successMessage'].forEach(id => {
        const box = document.getElementById(id);
        if (box) {
            setTimeout(() => {
                box.style.transition = "opacity 0.5s ease";
                box.style.opacity = "0";
                setTimeout(() => box.remove(), 500);
            }, 3000);
        }
    });
</script>

</body>
</html>
