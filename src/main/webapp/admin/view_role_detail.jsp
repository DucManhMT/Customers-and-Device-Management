<%--
  Created by IntelliJ IDEA.
  User: FPT SHOP
  Date: 10/13/2025
  Time: 11:17 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Role Detail</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
<div class="container py-4">
    <div class="row justify-content-center">
        <div class="col-lg-10">
            <!-- Header -->
            <div class="mb-4">
                <a href="${pageContext.request.contextPath}/ViewRoleList" class="btn-back d-inline-flex align-items-center mb-3">
                    <i class="bi bi-arrow-left me-2"></i>
                    Back to Roles
                </a>
                <h1 class="display-6 fw-bold text-dark mb-2">Role Details</h1>
                <p class="text-muted">View role information and associated permissions</p>
            </div>

            <!-- Role Information Card -->
            <div class="card mb-4">
                <div class="card-body p-4">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <h2 class="h3 fw-semibold text-dark mb-3">${role.roleName}</h2>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Permissions Section -->
            <div class="card">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h3 class="h4 fw-semibold text-dark mb-0">Permissions</h3>
                        <span class="badge bg-light text-dark">
                            ${features.size()} permission(s) assigned
                        </span>
                    </div>

                    <div class="row g-3">
                        <c:choose>
                            <c:when test="${not empty features}">
                                <c:forEach var="feature" items="${features}">
                                    <div class="col-md-6">
                                        <div class="d-flex align-items-start mb-3 border rounded p-3">
                                            <i class="bi bi-check-circle-fill text-success me-3 fs-4"></i>
                                            <div>
                                                <div class="fw-semibold text-dark">${feature.featureURL}</div>
                                                <div class="text-muted small">${feature.description}</div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="col-12">
                                    <div class="alert alert-warning mb-0">
                                        This role has no permissions assigned.
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
