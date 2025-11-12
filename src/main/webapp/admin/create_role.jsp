<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Create Role</title>

    <!-- Bootstrap 5 + Icons -->
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        /* Keep UI consistent with Feature Management / Role pages */
        body {
            margin-left: 260px !important;
            padding-top: 70px !important;
            background: linear-gradient(135deg, #f5f7fa 0%, #eef4ff 100%);
            min-height: 100vh;
            font-family: system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial;
            color: #1e1e1e;
        }

        .container-fluid {
            max-width: 1100px;
            padding: 30px;
        }

        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 22px 24px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(102,126,234,0.18);
            margin-bottom: 20px;
            position: relative;
            overflow: hidden;
        }
        .page-header::before {
            content: '';
            position: absolute;
            top: -40%;
            right: -40%;
            width: 180%;
            height: 180%;
            background: radial-gradient(circle, rgba(255,255,255,0.06) 0%, transparent 70%);
            animation: rotate 20s linear infinite;
            opacity: .6;
        }
        @keyframes rotate { from { transform: rotate(0deg);} to { transform: rotate(360deg);} }

        .page-header h1 { margin:0; font-weight:700; }
        .page-header p { margin:0; opacity:.95; }

        .form-card {
            background: white;
            border-radius: 12px;
            padding: 22px;
            box-shadow: 0 8px 24px rgba(35,44,78,0.06);
        }

        label.form-label { font-weight: 600; }

        input.form-control {
            border-radius: 10px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #2b6cb0 0%, #6b46c1 100%);
            border: none;
            color: white;
            padding: 10px 16px;
            border-radius: 10px;
            font-weight: 600;
        }
        .btn-primary:hover { opacity: .95; }

        .btn-outline-secondary {
            border-radius: 10px;
            color: #6c757d;
            border-color: #6c757d;
            background: #fff;
        }
        .btn-outline-secondary:hover { background: #6c757d; color: #fff; }

        .btn-assign {
            background: linear-gradient(135deg,#5b6ee1,#6b46c1);
            color: #fff;
            border-radius: 10px;
            padding: 10px 14px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: .5rem;
        }
        .btn-assign.disabled, .btn-assign[disabled] {
            opacity: .5;
            pointer-events: none;
        }

        .help-text { color: #6c757d; font-size: 0.9rem; }

        .alert {
            border-radius: 10px;
        }

        @media (max-width: 992px) {
            body { margin-left: 0 !important; padding-top: 90px !important; }
            .container-fluid { padding: 18px; }
        }
    </style>
</head>
<body>
<c:set var="activePage" value="rolemanage" scope="request" />
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>

<div class="container-fluid">
    <div class="page-header">
        <div class="d-flex justify-content-between align-items-start">
            <div>
                <h1 class="h4 mb-1">Create New Role</h1>
                <p class="mb-0">Add a new role and then assign features to it using the Assign Features flow.</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/admin/role_list" class="btn btn-outline-light">
                    <i class="bi bi-arrow-left me-1"></i> Back to Roles
                </a>
            </div>
        </div>
    </div>

    <c:if test="${not empty success}">
        <div class="alert alert-success mt-3" role="alert">${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger mt-3" role="alert">${error}</div>
    </c:if>

    <div class="row">
        <div class="col-lg-8">
            <div class="form-card">
                <div class="d-flex align-items-center mb-4">
                    <div class="bg-white bg-opacity-10 rounded p-2 me-3">
                        <i class="bi bi-plus-circle text-white fs-4"></i>
                    </div>
                    <h2 class="h5 mb-0">Role Details</h2>
                </div>

                <form id="createRoleForm" action="${pageContext.request.contextPath}/admin/role_list/create_role" method="post">
                    <div class="mb-3">
                        <label for="roleName" class="form-label">Role Name</label>
                        <input type="text" id="roleName" name="roleName" class="form-control" required
                               placeholder="Enter role name" value="${roleName != null ? roleName : ''}">
                        <div class="form-text help-text">Give the role a clear, descriptive name (e.g. "Support", "Warehouse").</div>
                    </div>

                    <!-- DESCRIPTION & PERMISSION BLOCK REMOVED
                         Replaced with Assign Features flow button (see below).
                         The Assign Features button will be enabled only when the page has a roleID (i.e. after creation).
                    -->

                    <div class="d-flex justify-content-end gap-2 border-top pt-3">
                        <a href="${pageContext.request.contextPath}/admin/role_list" class="btn btn-outline-secondary">Cancel</a>

                        <!-- Create Role submit -->
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-plus-circle me-1"></i>Create Role
                        </button>


                    </div>
                </form>
            </div>
        </div>

        <!-- Optional right column: quick info -->
        <div class="col-lg-4">
            <div class="card p-3 mb-3" style="border-radius:12px; box-shadow:0 8px 24px rgba(35,44,78,0.06);">
                <h6 class="mb-2">Quick Tips</h6>
                <ul class="list-unstyled small text-muted mb-0">
                    <li class="mb-2"><i class="bi bi-check2 me-2 text-primary"></i>Use clear role names.</li>
                    <li class="mb-2"><i class="bi bi-check2 me-2 text-primary"></i>Assign permissions carefully after creating the role.</li>
                    <li><i class="bi bi-check2 me-2 text-primary"></i>Admins always retain full access.</li>
                </ul>
            </div>

            <div class="card p-3" style="border-radius:12px; box-shadow:0 8px 24px rgba(35,44,78,0.06);">
                <h6 class="mb-2">Existing Roles</h6>
                <div class="text-muted small">You can view and manage existing roles on the Roles list.</div>
                <a href="${pageContext.request.contextPath}/admin/role_list" class="d-inline-block mt-3 btn btn-primary btn-sm">View Roles</a>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>