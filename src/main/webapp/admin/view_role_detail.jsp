<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Role Detail</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">

    <style>
        /* Page layout consistent with Feature Management page */
        body {
            margin-left: 260px !important;
            padding-top: 70px !important;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;

        .permission-container {
            padding: 30px;
            max-width: 100%;
        }

        /* Header (match Feature Management styling - xanh tím gradient) */
        .page-header {
            background: linear-gradient(135deg, #2b6cb0 0%, #6b46c1 50%, #8b5cf6 100%);
            color: white;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
        }

        .page-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.08) 0%, transparent 70%);
            animation: rotate 20s linear infinite;
        }

        @keyframes rotate {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        .page-header h1, .page-header h2 {
            position: relative;
            z-index: 1;
            font-weight: 700;
            margin-bottom: 8px;
            text-shadow: 0 2px 6px rgba(0,0,0,0.12);
        }

        .page-header p {
            position: relative;
            z-index: 1;
            opacity: 0.95;
        }

        .btn-back {
            background: rgba(255,255,255,0.12);
            color: #fff;
            border-radius: 8px;
            padding: 8px 14px;
            transition: 0.25s;
            text-decoration: none;
            backdrop-filter: blur(2px);
            display: inline-flex;
            align-items: center;
        }
        .btn-back:hover {
            background: rgba(255,255,255,0.18);
            color: white;
        }

        /* Role card styled to match the admin page cards */
        .role-card {
            border: none;
            border-radius: 16px;
            padding: 24px;
            color: white;
            background: linear-gradient(135deg, #3b49b0 0%, #1f2d6a 100%);
            box-shadow: 0 12px 30px rgba(31,45,106,0.35);
            overflow: hidden;
            position: relative;
        }
        .role-card .role-name {
            font-size: 1.5rem;
            font-weight: 700;
            margin: 0;
            text-shadow: 0 2px 8px rgba(0,0,0,0.18);
        }
        .role-card .role-meta {
            color: rgba(255,255,255,0.9);
            margin-top: 6px;
            font-size: 0.95rem;
        }

        /* Permissions card */
        .card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
            overflow: hidden;
            background: white;
            transition: all 0.3s ease;
            margin-bottom: 20px;
        }

        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 18px 24px;
            font-weight: 600;
            font-size: 17px;
            border-bottom: none;
        }

        .badge-custom {
            background: linear-gradient(90deg, #5b6ee1, #6b46c1);
            color: white;
            padding: 6px 10px;
            border-radius: 6px;
        }

        .permission-box {
            border: 1px solid #e9e9f3;
            border-radius: 12px;
            padding: 13px 16px;
            background: white;
            transition: .2s;
            box-shadow: 0 6px 18px rgba(102, 126, 234, 0.06);
        }

        .permission-box:hover {
            background: #f4f6ff;
            border-color: #d5d7ff;
        }

        .feature-icon {
            color: #6b46c1;
            font-size: 1.6rem;
            margin-right: 12px;
        }

        .text-muted-small {
            color: #6c757d;
            font-size: 0.9rem;
        }

        /* Responsive tweaks */
        @media (max-width: 768px) {
            body { margin-left: 0 !important; }
            .permission-container { padding: 16px; }
            .role-card { padding: 18px; }
        }
    </style>
</head>

<body>
<!-- Keep same header & sidebar includes as admin pages for consistent layout -->
<c:set var="activePage" value="rolemanage" scope="request" />

<jsp:include page="/components/header.jsp" />
<jsp:include page="/components/admin_sidebar.jsp" />

<div class="permission-container">
    <div class="page-header">
        <a href="${pageContext.request.contextPath}/admin/role_list" class="btn-back mb-3">
            <i class="bi bi-arrow-left me-2"></i> Back to Roles
        </a>

        <h1>Role Details</h1>
        <p>View information and assigned permissions</p>
    </div>

    <!-- Role Card -->
    <div class="role-card mb-4">
        <div>
            <h2 class="role-name">${role.roleName}</h2>
            <div class="role-meta">
                <span class="badge-custom">${features.size()} permission(s)</span>
            </div>
        </div>
    </div>

    <!-- Permissions list -->
    <div class="card">
        <div class="card-body p-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h3 class="h5 fw-semibold text-dark">Permissions</h3>
                <span class="badge-custom">${features.size()} permission(s)</span>
            </div>

            <div class="row g-3">
                <c:choose>
                    <c:when test="${not empty features}">
                        <c:forEach var="feature" items="${features}">
                            <div class="col-md-6">
                                <div class="d-flex align-items-start permission-box">
                                    <i class="bi bi-check-circle-fill feature-icon"></i>
                                    <div>
                                        <div class="fw-semibold text-dark">${feature.featureURL}</div>
                                        <div class="text-muted-small">${feature.description}</div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>

                    <c:otherwise>
                        <div class="col-12">
                            <div class="alert alert-warning text-center mb-0">
                                This role has no permissions assigned.
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>