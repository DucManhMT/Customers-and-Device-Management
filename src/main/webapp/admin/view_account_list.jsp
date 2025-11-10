<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Account List</title>

    <!-- Bootstrap 5 CSS -->
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
          rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        /* Layout consistent with admin Feature Management and Role pages */
        body {
            margin-left: 260px !important;
            padding-top: 70px !important;
            background: linear-gradient(135deg, #f5f7fa 0%, #e6eefb 100%);
            min-height: 100vh;
            font-family: system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial;
            color: #223;
        }

        .container-fluid { max-width: 1200px; padding: 30px; }

        /* Page Header */
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 22px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(102,126,234,0.18);
            margin-bottom: 20px;
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
        }
        @keyframes rotate { from { transform:rotate(0deg);} to { transform:rotate(360deg);} }
        .page-header h2 { margin:0; font-weight:700; text-shadow: 0 2px 6px rgba(0,0,0,0.08); }
        .btn-add {
            background: linear-gradient(135deg, #2b6cb0 0%, #6b46c1 100%);
            color: #fff;
            border-radius: 10px;
            padding: 8px 14px;
            border: none;
        }
        .btn-add:hover { opacity: .95; }

        /* Search panel */
        .search-panel {
            background: white;
            border-radius: 12px;
            padding: 18px;
            box-shadow: 0 6px 18px rgba(35,44,78,0.04);
            margin-bottom: 18px;
        }
        .search-box { border-radius: 8px; }

        /* Table */
        .card-table {
            border: none;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(35,44,78,0.06);
            overflow: hidden;
            background: white;
        }
        .table-responsive {
            max-height: calc(100vh - 390px);
            overflow: auto;
        }
        table.table {
            margin-bottom: 0;
        }
        table.table thead th {
            background: linear-gradient(to bottom, #f8f9fa, #eef2ff);
            border-bottom: 3px solid rgba(102,126,234,0.16);
            position: sticky;
            top: 0;
            z-index: 5;
            text-transform: none;
        }
        table.table tbody tr:hover {
            background: linear-gradient(to right, #fbfdff, #eef7ff);
            transform: translateZ(0);
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

        /* Pagination controls */
        .pagination .page-link { color: #334; }
        .pagination .page-item.active .page-link {
            background: linear-gradient(135deg,#667eea,#764ba2);
            border: none;
            color: #fff;
        }

        /* Responsive tweaks */
        @media (max-width: 992px) {
            body { margin-left: 0 !important; padding-top: 90px !important; }
            .container-fluid { padding: 18px; }
        }
    </style>
</head>
<body>
<c:set var="activePage" value="accountmanage" scope="request" />
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>

<div class="container-fluid">
    <div class="page-header d-flex justify-content-between align-items-center">
        <div>
            <h2>Account Management</h2>
            <div class="text-white-50" style="opacity:.95;">Manage users, roles and statuses</div>
        </div>
        <div>
            <a class="btn btn-add" href="${pageContext.request.contextPath}/admin/create_account">
                <i class="bi bi-plus-circle me-2"></i> Add New Account
            </a>
        </div>
    </div>

    <!-- Search and Filters -->
    <form id="searchForm" method="get">
        <div class="search-panel">
            <div class="row g-2 align-items-center">
                <div class="col-md-2">
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0"><i class="bi bi-person-badge"></i></span>
                        <input type="text" class="form-control border-start-0 search-box"
                               placeholder="Username" id="searchUsernameInput" name="searchUsername"
                               value="${searchUsername}">
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0"><i class="bi bi-person"></i></span>
                        <input type="text" class="form-control border-start-0 search-box"
                               placeholder="Name" id="searchNameInput" name="searchName"
                               value="${searchName}">
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0"><i class="bi bi-envelope"></i></span>
                        <input type="text" class="form-control border-start-0 search-box"
                               placeholder="Email" id="searchEmailInput" name="searchEmail"
                               value="${searchEmail}">
                    </div>
                </div>
                <div class="col-md-2">
                    <select class="form-select search-box" id="roleFilter" name="roleFilter">
                        <option value="">All Roles</option>
                        <c:forEach var="role" items="${roleList}">
                            <option value="${role.roleID}" <c:if test="${roleFilter == role.roleID}">selected</c:if>>
                                <c:out value="${role.roleName}"/>
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <select class="form-select search-box" id="statusFilter" name="statusFilter">
                        <option value="">All Status</option>
                        <option value="Active" <c:if test="${statusFilter == 'Active'}">selected</c:if>>Active</option>
                        <option value="Deactive" <c:if test="${statusFilter == 'Deactive'}">selected</c:if>>Deactive</option>
                    </select>
                </div>
                <div class="col-md-2 d-flex gap-2">
                    <button type="submit" class="btn btn-primary w-100 action-btn">
                        <i class="bi bi-search me-1"></i> Search
                    </button>
                    <button type="button" class="btn btn-outline-secondary w-100 action-btn"
                            onclick="window.location.href='${pageContext.request.contextPath}/admin/account_list'">
                        <i class="bi bi-arrow-clockwise me-1"></i> Reset
                    </button>
                </div>
            </div>
        </div>
    </form>

    <c:if test="${not empty sessionScope.success}">
        <div class="alert alert-success mt-3" role="alert">
                ${sessionScope.success}
        </div>
        <c:remove var="success" scope="session"/>
    </c:if>

    <!-- Accounts Table -->
    <div class="card-table mt-3">
        <div class="table-responsive">
            <table class="table table-hover mb-0 align-middle">
                <thead>
                <tr>
                    <th>Username</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Status</th>
                    <th class="text-center">Actions</th>
                </tr>
                </thead>
                <tbody id="accountsTableBody">
                <c:forEach var="account" items="${accountInfos}">
                    <tr>
                        <td><c:out value="${account.username}"/></td>
                        <td><c:out value="${account.name}"/></td>
                        <td><c:out value="${account.email}"/></td>
                        <td><c:out value="${account.role.roleName}"/></td>
                        <td><c:out value="${account.status}"/></td>
                        <td class="text-center">
                            <a href="${pageContext.request.contextPath}/admin/account_list/view_account_detail?id=${account.username}&role=${account.role.roleID}"
                               class="btn action-btn btn-view me-1">
                                <i class="bi bi-eye"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/account_list/edit_account?id=${account.username}&role=${account.role.roleID}"
                               class="btn action-btn btn-edit me-1">
                                <i class="bi bi-pencil-square"></i>
                            </a>
                            <form action="${pageContext.request.contextPath}/admin/account_list" method="post" class="d-inline">
                                <input type="hidden" name="action" value="${account.status == 'Active' ? 'deactivate' : 'activate'}"/>
                                <input type="hidden" name="username" value="${account.username}"/>
                                <button type="submit"
                                        class="btn action-btn ${account.status == 'Active' ? 'btn-deactivate' : 'btn-activate'}"
                                        onclick="return confirm('Are you sure you want to ${account.status == 'Active' ? 'deactivate' : 'activate'} this account?')">
                                    <i class="bi ${account.status == 'Active' ? 'bi-person-x' : 'bi-person-check'}"></i>
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Pagination & items per page -->
    <form method="get" action="${pageContext.request.contextPath}/admin/account_list" class="mt-4 d-flex justify-content-between align-items-center">
        <div>
            <span class="me-3">Show:</span>
            <select name="itemsPerPage" class="form-select form-select-sm" style="width: auto;" onchange="this.form.submit()">
                <option value="5" ${itemsPerPage==5 ? 'selected' : '' }>5</option>
                <option value="10" ${itemsPerPage==10 ? 'selected' : '' }>10</option>
                <option value="15" ${itemsPerPage==15 ? 'selected' : '' }>15</option>
                <option value="20" ${itemsPerPage==20 ? 'selected' : '' }>20</option>
            </select>
        </div>

        <div>
            <input type="hidden" name="searchUsername" value="${searchUsername}"/>
            <input type="hidden" name="searchName" value="${searchName}"/>
            <input type="hidden" name="searchEmail" value="${searchEmail}"/>
            <input type="hidden" name="roleFilter" value="${roleFilter}"/>
            <input type="hidden" name="statusFilter" value="${statusFilter}"/>

            <nav>
                <ul class="pagination mb-0">
                    <c:if test="${currentPage > 1}">
                        <li class="page-item">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/admin/account_list?page=${currentPage - 1}&itemsPerPage=${itemsPerPage}&searchUsername=${searchUsername}&searchName=${searchName}&searchEmail=${searchEmail}&roleFilter=${roleFilter}&statusFilter=${statusFilter}">
                                Previous
                            </a>
                        </li>
                    </c:if>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/admin/account_list?page=${i}&itemsPerPage=${itemsPerPage}&searchUsername=${searchUsername}&searchName=${searchName}&searchEmail=${searchEmail}&roleFilter=${roleFilter}&statusFilter=${statusFilter}">
                                    ${i}
                            </a>
                        </li>
                    </c:forEach>
                    <c:if test="${currentPage < totalPages}">
                        <li class="page-item">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/admin/account_list?page=${currentPage + 1}&itemsPerPage=${itemsPerPage}&searchUsername=${searchUsername}&searchName=${searchName}&searchEmail=${searchEmail}&roleFilter=${roleFilter}&statusFilter=${statusFilter}">
                                Next
                            </a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </div>
    </form>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>