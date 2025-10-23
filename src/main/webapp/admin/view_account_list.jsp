<%--
  Created by IntelliJ IDEA.
  User: FPT SHOP
  Date: 10/15/2025
  Time: 11:17 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Account List</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
<jsp:include page="../components/admin_header.jsp"/>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-12 main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="mb-1">Account Management</h2>
                </div>

                <button class="btn btn-primary" onclick="showAddAccountModal()">
                    <i class="bi bi-plus-circle me-2"></i>Add New Account
                </button>
            </div>

            <!-- Search and Filters -->
            <form id="searchForm" method="get">
                <div class="p-4 border-bottom">
                    <div class="row align-items-center">
                        <div class="col-md-2">
                            <div class="input-group mb-2">
                                <span class="input-group-text bg-white border-end-0">
                                    <i class="bi bi-person-badge"></i>
                                </span>
                                <input type="text" class="form-control border-start-0 search-box"
                                       placeholder="Search by username..."
                                       id="searchUsernameInput"
                                       name="searchUsername"
                                       value="${searchUsername}">
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="input-group mb-2">
                                <span class="input-group-text bg-white border-end-0">
                                    <i class="bi bi-person"></i>
                                </span>
                                <input type="text" class="form-control border-start-0 search-box"
                                       placeholder="Search by name..."
                                       id="searchNameInput"
                                       name="searchName"
                                       value="${searchName}">
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="input-group mb-2">
                                <span class="input-group-text bg-white border-end-0">
                                    <i class="bi bi-envelope"></i>
                                </span>
                                <input type="text" class="form-control border-start-0 search-box"
                                       placeholder="Search by email..."
                                       id="searchEmailInput"
                                       name="searchEmail"
                                       value="${searchEmail}">
                            </div>
                        </div>
                        <div class="col-md-2">
                            <select class="form-select" id="roleFilter" name="roleFilter">
                                <option value="">All Roles</option>
                                <c:forEach var="role" items="${roleList}">
                                    <option value="${role.roleID}"
                                            <c:if test="${roleFilter == role.roleID}">selected</c:if>
                                    >
                                        <c:out value="${role.roleName}"/>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <select class="form-select" id="statusFilter" name="statusFilter">
                                <option value="">All Status</option>
                                <option value="Active" <c:if test="${statusFilter == 'Active'}">selected</c:if>>Active
                                </option>
                                <option value="Deactive" <c:if test="${statusFilter == 'Deactive'}">selected</c:if>>
                                    Deactive
                                </option>
                            </select>
                        </div>
                        <div class="col-md-2 d-flex gap-2">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="bi bi-search"></i> Search
                            </button>
                            <button type="button" class="btn btn-secondary w-100"
                                    onclick="window.location.href='${pageContext.request.contextPath}/admin/account_list'">
                                <i class="bi bi-arrow-clockwise"></i> Reset
                            </button>
                        </div>
                    </div>
                </div>
            </form>

            <!-- Accounts Table -->
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                    <tr>
                        <th>Username</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Actions</th>
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
                            <td>
                                <a href="#" class="btn btn-sm btn-info me-2 text-white">
                                    <i class="bi bi-eye"></i> View Detail
                                </a>
                                <a href="#" class="btn btn-sm btn-primary me-2">
                                    <i class="bi bi-pencil-square"></i> Edit
                                </a>
                                    <%--                                <form action="${pageContext.request.contextPath}/admin/role_list" method="post" style="display:inline;">--%>
                                    <%--                                    <input type="hidden" name="action" value="delete"/>--%>
                                    <%--                                    <input type="hidden" name="id" value="${role.roleID}"/>--%>
                                <button type="submit" class="btn btn-sm btn-danger">
                                    <i class="bi bi-trash"></i> Delete
                                </button>
                                    <%--                                </form>--%>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <form method="get" action="${pageContext.request.contextPath}/admin/account_list">
                <input type="hidden" name="searchUsername" value="${searchUsername}"/>
                <input type="hidden" name="searchName" value="${searchName}"/>
                <input type="hidden" name="searchEmail" value="${searchEmail}"/>
                <input type="hidden" name="roleFilter" value="${roleFilter}"/>
                <input type="hidden" name="statusFilter" value="${statusFilter}"/>
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
                               href="${pageContext.request.contextPath}/admin/account_list?page=${currentPage - 1}&itemsPerPage=${itemsPerPage}
                               &searchUsername=${searchUsername}&searchName=${searchName}
                               &searchEmail=${searchEmail}&roleFilter=${roleFilter}&statusFilter=${statusFilter}">
                                Previous
                            </a>
                        </li>
                    </c:if>
                    <!-- Page numbers -->
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/admin/account_list?page=${i}&itemsPerPage=${itemsPerPage}
                               &searchUsername=${searchUsername}&searchName=${searchName}
                               &searchEmail=${searchEmail}&roleFilter=${roleFilter}&statusFilter=${statusFilter}">
                                    ${i}
                            </a>
                        </li>
                    </c:forEach>
                    <!-- Next -->
                    <c:if test="${currentPage < totalPages}">
                        <li class="page-item">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/admin/account_list?page=${currentPage + 1}&itemsPerPage=${itemsPerPage}
                               &searchUsername=${searchUsername}&searchName=${searchName}
                               &searchEmail=${searchEmail}&roleFilter=${roleFilter}&statusFilter=${statusFilter}">
                                Next
                            </a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </div>
    </div>
</div>

</body>
</html>