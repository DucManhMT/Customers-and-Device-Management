<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Edit Role</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        /* ONLY UI / styling changes — layout consistent with Feature Management page */
        body {
            margin-left: 260px !important;
            padding-top: 70px !important;
            background: linear-gradient(135deg, #f5f7fa 0%, #e6eefb 100%);
            min-height: 100vh;
            color: #223;
        }

        .main-content {
            padding: 30px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .breadcrumb {
            background: transparent;
            margin-bottom: 0;
        }

        /* Header: xanh-tím animated radial like Feature Management */
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 26px 28px;
            border-radius: 14px;
            box-shadow: 0 10px 30px rgba(102,126,234,0.18);
            margin-bottom: 18px;
            position: relative;
            overflow: hidden;
        }
        .page-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 220%;
            height: 220%;
            background: radial-gradient(circle, rgba(255,255,255,0.06) 0%, transparent 70%);
            animation: rotate 20s linear infinite;
        }
        @keyframes rotate { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }
        .page-header h1 {
            position: relative; z-index: 1;
            font-weight: 700; margin-bottom: 6px;
            text-shadow: 0 2px 6px rgba(0,0,0,0.12);
            font-size: 1.5rem;
        }
        .page-header p { position: relative; z-index: 1; opacity: .95; margin-bottom:0; }

        .btn-back {
            background: rgba(255,255,255,0.12);
            color: #fff;
            border-radius: 8px;
            padding: 7px 12px;
            transition: 0.18s;
            text-decoration: none;
            backdrop-filter: blur(2px);
            display: inline-flex;
            align-items: center;
            font-size: 0.92rem;
        }
        .btn-back:hover { background: rgba(255,255,255,0.18); color: white; }

        /* Card styles */
        .card {
            border: none;
            border-radius: 14px;
            box-shadow: 0 8px 26px rgba(35,44,78,0.06);
            overflow: hidden;
            background: white;
            transition: all 0.25s ease;
        }
        .card:hover { box-shadow: 0 12px 36px rgba(35,44,78,0.09); }

        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 14px 18px;
            font-weight: 600;
            border-bottom: none;
            border-radius: 0;
            font-size: 0.98rem;
        }

        /* Role card (prominent) */
        .role-card {
            border-radius: 14px;
            padding: 20px;
            color: white;
            background: linear-gradient(135deg, #3b49b0 0%, #1f2d6a 100%);
            box-shadow: 0 14px 36px rgba(31,45,106,0.26);
            overflow: hidden;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .role-card h2 { margin: 0; font-size: 1.4rem; font-weight: 700; text-shadow: 0 3px 10px rgba(0,0,0,0.18); }
        .role-meta { color: rgba(255,255,255,0.92); margin-top: 6px; font-size: 0.92rem; }

        .badge-count {
            display: inline-block;
            padding: 8px 14px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 13px;
            background: linear-gradient(135deg,#5b6ee1,#6b46c1);
            color: #fff;
            box-shadow: 0 6px 16px rgba(102,126,234,0.14);
        }

        /* Role information and permissions */
        .permission-item {
            background: #fff;
            border: 1px solid #e9eefb;
            border-radius: 10px;
            padding: 12px 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: .18s;
        }
        .permission-item + .permission-item { margin-top: 10px; }
        .permission-item:hover { border-color: #667eea; background: #f8fbff; }

        .feature-url {
            font-size: 12px;
            color: #6c757d;
            font-family: 'Courier New', monospace;
            word-break: break-all;
            margin-top: 6px;
        }

        /* Buttons (visual only) */
        .btn-primary-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
            padding: 10px 16px;
            border-radius: 10px;
            font-weight: 600;
        }
        .btn-outline-secondary-custom {
            border-radius: 10px;
            color: #6c757d;
            border-color: #6c757d;
            background: #fff;
        }
        .btn-outline-secondary-custom:hover { background: #6c757d; color: #fff; }

        /* Accounts list */
        .list-group-item {
            border: none;
            border-bottom: 1px solid #ececf4;
            padding: 12px 16px;
            transition: background .15s;
        }
        .list-group-item:hover { background: #fbfbff; }

        #accountCount {
            background: linear-gradient(135deg, #5b6ee1, #6b46c1);
            color: #fff;
            padding: 8px 12px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 0.92rem;
        }

        /* Toast */
        .toast { border-radius: 12px; box-shadow: 0 6px 18px rgba(0,0,0,0.16); }

        /* Responsive */
        @media (max-width: 992px) {
            body { margin-left: 0 !important; padding-top: 90px !important; }
            .main-content { padding: 18px; }
            .page-header { padding: 20px; }
            .role-card { flex-direction: column; align-items: flex-start; gap: 12px; }
        }
    </style>
</head>
<body>
<c:set var="activePage" value="rolemanage" scope="request" />

<jsp:include page="/components/header.jsp" />
<jsp:include page="/components/admin_sidebar.jsp" />
<div class="main-content">
    <div class="container">
        <!-- Alert messages -->
        <c:if test="${param.success == '1'}">
            <div class="alert alert-success mt-3" role="alert">
                Role updated successfully!
            </div>
        </c:if>
        <c:if test="${param.remove == '1'}">
            <div class="alert alert-warning mt-3" role="alert">
                Role removed from account successfully!
            </div>
        </c:if>

        <!-- Header -->
        <div class="row mb-4">
            <div class="col-12">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/role_list" class="text-decoration-none">Role Management</a></li>
                        <li class="breadcrumb-item active">Edit Role</li>
                    </ol>
                </nav>

                <div class="d-flex justify-content-between align-items-center">
                    <h1 class="h3 mb-0">Edit Role</h1>
                    <div>
                        <a href="${pageContext.request.contextPath}/admin/role_list" class="btn btn-outline-secondary me-2">
                            <i class="bi bi-x-lg me-1"></i>Cancel
                        </a>
                        <button form="roleForm" type="submit" class="btn btn-primary">
                            <i class="bi bi-check-lg me-1"></i>Save Changes
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <!-- Role Details -->
            <div class="col-lg-8">
                <form id="roleForm" method="post" action="${pageContext.request.contextPath}/admin/role_list/edit_role">
                    <input type="hidden" name="roleID" value="${role.roleID}"/>

                    <div class="card mb-4">
                        <div class="card-header">
                            <h5 class="card-title mb-0">
                                <i class="bi bi-person-badge me-2"></i>Role Information
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                <label for="roleName" class="form-label">Role Name</label>
                                <input type="text" class="form-control" id="roleName" name="roleName" value="${role.roleName}" required>
                                <div class="form-text">Choose a descriptive name for this role</div>
                            </div>
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger">${error}</div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Permissions -->
                    <!-- Permissions Card (checkboxes converted to switches) -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <i class="bi bi-shield-check me-2"></i>Permissions
                        </div>
                        <div class="card-body">
                            <div class="permission-group">
                                <c:forEach var="feature" items="${features}">
                                    <div class="permission-item">
                                        <div>
                                            <strong>${feature.featureURL}</strong>
                                            <div class="feature-url"><i class="bi bi-arrow-return-right me-1"></i>${feature.description}</div>
                                        </div>

                                        <!-- Switch (replaces checkbox) -->
                                        <div class="form-check form-switch">
                                            <input class="form-check-input custom-switch"
                                                   type="checkbox"
                                                   name="featureIds"
                                                   value="${feature.featureID}"
                                                   id="feature_${feature.featureID}"
                                                   aria-label="Toggle permission ${feature.featureURL}"
                                                   <c:if test="${selectedFeatureIds.contains(feature.featureID)}">checked</c:if>>
                                            <label class="form-check-label visually-hidden" for="feature_${feature.featureID}">Toggle</label>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Accounts with this Role -->
            <div class="col-lg-4">
                <div class="card">
                    <div class="card-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="card-title mb-0">
                                <i class="bi bi-people me-2"></i>Accounts with this Role
                            </h5>
                            <span class="badge bg-primary" id="accountCount">${accountCount}</span>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <div class="list-group list-group-flush" id="accountsList">
                            <c:forEach var="account" items="${accounts}">
                                <div class="list-group-item account-card">
                                    <div class="d-flex align-items-center">
                                        <div class="flex-grow-1">
                                            <h6 class="mb-1">${account.username}</h6>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${empty accounts}">
                                <div class="list-group-item text-center text-muted">No account for this role</div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Success Toast -->
<div class="toast-container position-fixed bottom-0 end-0 p-3">
    <div id="successToast" class="toast" role="alert">
        <div class="toast-header">
            <i class="bi bi-check-circle-fill text-success me-2"></i>
            <strong class="me-auto">Success</strong>
            <button type="button" class="btn-close" data-bs-dismiss="toast"></button>
        </div>
        <div class="toast-body" id="toastMessage">
            Role updated successfully!
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
