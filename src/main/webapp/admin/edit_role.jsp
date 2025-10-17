<%--
  Created by IntelliJ IDEA.
  User: FPT SHOP
  Date: 10/11/2025
  Time: 10:18 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Edit Role</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
<div class="main-content">
    <div class="container">
        <!-- Header -->
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

        <div class="row">
            <!-- Role Details -->
            <div class="col-lg-8">
                <form id="roleForm" method="post" action="EditRole">
                    <input type="hidden" name="roleID" value="${role.roleID}" />

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
                        </div>
                    </div>

                    <!-- Permissions -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <h5 class="card-title mb-0">
                                <i class="bi bi-shield-check me-2"></i>Permissions
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="permission-group">

                                <c:forEach var="feature" items="${features}">
                                    <div class="permission-item mb-2">
                                        <div class="form-check">
                                            <input class="form-check-input"
                                                   type="checkbox"
                                                   name="featureIds"
                                                   value="${feature.featureID}"
                                                   id="feature_${feature.featureID}"
                                                   <c:if test="${selectedFeatureIds.contains(feature.featureID)}">checked</c:if>>
                                            <label class="form-check-label" for="feature_${feature.featureID}">
                                                <strong>${feature.featureURL}</strong>
                                                <small class="text-muted d-block">${feature.description}</small>
                                            </label>
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
<%--                                        <form method="post" action="RemoveAccountRole" style="margin:0;">--%>
<%--                                            <input type="hidden" name="username" value="${account.username}" />--%>
<%--                                            <input type="hidden" name="roleID" value="${role.roleID}" />--%>
<%--                                            <button type="submit" class="btn btn-sm btn-outline-danger"--%>
<%--                                                    onclick="return confirm('Remove role from this account?');">--%>
<%--                                                <i class="bi bi-person-dash"></i>--%>
<%--                                            </button>--%>
<%--                                        </form>--%>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${empty accounts}">
                                <div class="list-group-item text-center text-muted">No account for this role</div>
                            </c:if>

                        </div>
                    </div>
                </div>
<%--                <div class="card-footer bg-light">--%>
<%--                    <button class="btn btn-outline-primary btn-sm w-100" onclick="addAccountToRole()">--%>
<%--                        <i class="bi bi-person-plus me-1"></i>Add Account to Role--%>
<%--                    </button>--%>
<%--                </div>--%>
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

</body>
</html>
