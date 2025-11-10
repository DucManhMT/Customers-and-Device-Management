<%-- Created by IntelliJ IDEA. User: FPT SHOP Date: 10/6/2025 Time: 4:30 PM --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>Role List</title>

    <!-- Bootstrap / Icons / Font -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">

    <script src="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/js/bootstrap.bundle.min.js"></script>

    <style>
        /* Global layout consistent with admin pages */
        body {
            margin-left: 260px !important;
            padding-top: 70px !important;
            background: linear-gradient(135deg, #f5f7fa 0%, #eef4ff 100%);
            min-height: 100vh;
            color: #1e1e1e;
        }

        .container-fluid {
            max-width: 1200px;
            padding: 30px;
        }

        h2 { font-weight: 700; }

        /* Page header */
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px 24px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(102,126,234,0.16);
            margin-bottom: 18px;
            position: relative;
            overflow: hidden;
        }
        .page-header::before{
            content:'';
            position:absolute;
            top:-40%;
            right:-40%;
            width:180%;
            height:180%;
            background: radial-gradient(circle, rgba(255,255,255,0.06) 0%, transparent 70%);
            animation: rotate 20s linear infinite;
            opacity: .6;
        }
        @keyframes rotate { from { transform:rotate(0deg);} to { transform:rotate(360deg);} }
        .page-header h2 { margin:0; font-weight:700; }
        .page-header .sub { opacity:.95; font-size:.95rem; }

        /* Stats cards */
        .stats-card {
            border: none;
            border-radius: 14px;
            background: linear-gradient(120deg, #ff8a9e, #fad0c4);
            box-shadow: 0 8px 20px rgba(255, 105, 135, 0.12);
            transition: transform .25s ease, box-shadow .25s ease;
        }
        .stats-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 14px 30px rgba(0,0,0,0.08);
        }
        .stats-icon {
            width: 54px;
            height: 54px;
            border-radius: 12px;
            background: rgba(255,255,255,0.35);
            display:flex;
            align-items:center;
            justify-content:center;
            font-size:22px;
        }

        /* Search + add area */
        .table-container .card-header {
            background: linear-gradient(120deg, #6c5fff, #52a3ff);
            border-radius: 12px;
            color: white;
            box-shadow: 0 6px 18px rgba(98,88,255,0.12);
        }
        .table-container .form-control,
        .table-container .btn,
        .table-container .form-select {
            border-radius: 10px !important;
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, #2b6cb0 0%, #6b46c1 100%);
            color: #fff;
            border-radius: 10px;
            padding: 8px 12px;
            border: none;
        }
        .btn-primary-custom:hover { opacity: .95; }

        .btn-outline-light {
            color: #fff;
            border: 1px solid rgba(255,255,255,0.18);
            background: transparent;
        }

        /* Table */
        .card-table {
            border: none;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(35,44,78,0.06);
            overflow: hidden;
            background: white;
        }
        .table-responsive {
            overflow: auto;
            max-height: calc(100vh - 420px);
        }
        table.table {
            margin-bottom: 0;
            border-collapse: separate;
            border-spacing: 0;
        }
        table.table thead th {
            background: linear-gradient(to bottom, #f8f9ff, #eef4ff);
            font-weight: 700;
            color: #2e2e2e;
            position: sticky;
            top: 0;
            z-index: 5;
        }
        table.table tbody tr:hover {
            background: linear-gradient(to right, #fbfdff, #eef7ff);
        }
        table.table td, table.table th {
            vertical-align: middle;
            padding: 14px 16px;
        }

        /* Status badges */
        .badge-active {
            background: linear-gradient(135deg, #38c172, #2fa05c);
            padding: 6px 12px;
            border-radius: 8px;
            color: white;
            font-weight: 600;
        }
        .badge-inactive {
            background: linear-gradient(135deg, #ff6b6b, #f24a4a);
            padding: 6px 12px;
            border-radius: 8px;
            color: white;
            font-weight: 600;
        }

        /* Action buttons */
        .action-btn {
            border-radius: 8px;
            padding: 6px 10px;
            font-size: 0.88rem;
        }
        .btn-view { background: linear-gradient(135deg,#5b6ee1,#6b46c1); color:#fff; border:none; }
        .btn-edit { background: linear-gradient(135deg,#34a0ff,#2266dd); color:#fff; border:none; }
        .btn-activate { background: linear-gradient(135deg,#16a085,#1abc9c); color:#fff; border:none; }
        .btn-deactivate { background: linear-gradient(135deg,#ef4444,#e11d48); color:#fff; border:none; }

        /* Pagination */
        .pagination .page-link { border-radius: 8px !important; }
        .page-item.active .page-link {
            background: linear-gradient(135deg,#5a4fff,#4a3dff);
            border-color: transparent;
            color: #fff;
        }

        /* Alerts auto-hide */
        .alert {
            border-radius: 10px;
        }

        /* Responsive */
        @media (max-width: 992px) {
            body { margin-left: 0 !important; padding-top: 90px !important; }
            .container-fluid { padding: 18px; }
            .stats-card { margin-bottom: 12px; }
        }
    </style>
</head>
<body>
<c:set var="activePage" value="rolemanage" scope="request" />
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>

<div class="container-fluid">

    <div class="page-header d-flex justify-content-between align-items-center">
        <div>
            <h2 class="mb-0">Role Management</h2>
            <div class="sub">Overview and administration of roles</div>
        </div>

    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger mt-3" id="errorMessage">${error}</div>
    </c:if>
    <c:if test="${not empty roleSuccess}">
        <div class="alert alert-success mt-3" id="successMessage">${roleSuccess}</div>
    </c:if>

    <!-- Stats -->
    <div class="row my-4 g-3">
        <div class="col-md-6">
            <div class="card stats-card h-100 p-3">
                <div class="d-flex align-items-center">
                    <div class="stats-icon text-dark me-3"><i class="bi bi-people"></i></div>
                    <div>
                        <div class="text-muted small">Total Roles</div>
                        <h3 class="fw-bold mb-0">${totalRoles}</h3>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card stats-card h-100 p-3">
                <div class="d-flex align-items-center">
                    <div class="stats-icon text-dark me-3"><i class="bi bi-person-check"></i></div>
                    <div>
                        <div class="text-muted small">Assigned Users</div>
                        <h3 class="fw-bold mb-0">${totalUsers}</h3>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Search + Add -->
    <div class="table-container mb-3">
        <div class="card-header p-3">
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

                <div class="col-md-3 d-none d-md-block text-end">
                    <a href="${pageContext.request.contextPath}/admin/role_list/create_role"
                       class="btn btn-primary w-100">
                        <i class="bi bi-plus-lg"></i> Add New Role
                    </a>
                </div>
            </form>
        </div>
    </div>

    <!-- Table -->
    <div class="card-table">
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead>
                <tr>
                    <th>Role ID</th>
                    <th>Role Name</th>
                    <th>Users</th>
                    <th>Status</th>
                    <th class="text-center">Actions</th>
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
                        <td class="text-center">
                            <a href="${pageContext.request.contextPath}/admin/role_list/view_role_detail?id=${role.roleID}"
                               class="btn action-btn btn-view me-1" title="View">
                                <i class="bi bi-eye"></i>
                            </a>

                            <a href="${pageContext.request.contextPath}/admin/role_list/edit_role?id=${role.roleID}"
                               class="btn action-btn btn-edit me-1" title="Edit">
                                <i class="bi bi-pencil-square"></i>
                            </a>

                            <form action="${pageContext.request.contextPath}/admin/role_list" method="post" class="d-inline">
                                <input type="hidden" name="action"
                                       value="${role.roleStatus == 'Active' ? 'deactivate' : 'activate'}">
                                <input type="hidden" name="id" value="${role.roleID}">
                                <button class="btn action-btn ${role.roleStatus=='Active' ? 'btn-deactivate' : 'btn-activate'}"
                                        onclick="return confirm('Are you sure?')"
                                        title="${role.roleStatus=='Active' ? 'Deactivate' : 'Activate'}">
                                    <i class="bi ${role.roleStatus=='Active' ? 'bi-trash' : 'bi-check-circle'}"></i>
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- PAGINATION -->
    <form method="get" action="${pageContext.request.contextPath}/admin/role_list" class="mt-3 d-flex align-items-center justify-content-between">
        <input type="hidden" name="search" value="${search}">
        <div>
            <span class="me-2">Show:</span>
            <select name="itemsPerPage" class="form-select form-select-sm d-inline-block" style="width:auto;" onchange="this.form.submit()">
                <option value="5" ${itemsPerPage==5 ? 'selected' : ''}>5</option>
                <option value="10" ${itemsPerPage==10 ? 'selected' : ''}>10</option>
                <option value="15" ${itemsPerPage==15 ? 'selected' : ''}>15</option>
                <option value="20" ${itemsPerPage==20 ? 'selected' : ''}>20</option>
            </select>
        </div>

        <div>
            <nav>
                <ul class="pagination mb-0">
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
    </form>

</div>

<script>
    // Auto-hide alerts after 3s
    ['errorMessage', 'successMessage'].forEach(id => {
        const box = document.getElementById(id);
        if (box) {
            setTimeout(() => {
                box.style.transition = "opacity 0.5s ease";
                box.style.opacity = "0";
                setTimeout(() => box.remove(), 600);
            }, 3000);
        }
    });
</script>

</body>
</html>