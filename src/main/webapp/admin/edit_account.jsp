<%--
  Created by IntelliJ IDEA.
  User: FPT SHOP
  Date: 10/27/2025
  Time: 5:47 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Edit Account</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            background-color: #f8f9fa;
        }

        .account-container {
            max-width: 900px;
            margin: 50px auto;
            background-color: #fff;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        .profile-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .form-card {
            background-color: #ffffff;
            padding: 25px;
            border: 1px solid #dee2e6;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .section-header {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .section-title {
            font-weight: 600;
            color: #0d6efd;
        }

        .icon-section {
            font-size: 1.5rem;
            margin-right: 10px;
            color: #0d6efd;
        }

        .password-strength {
            height: 5px;
            background-color: #e9ecef;
            border-radius: 5px;
            margin-top: 5px;
            overflow: hidden;
        }

        .password-strength-bar {
            height: 5px;
            background-color: #198754;
            width: 0;
            transition: width 0.3s;
        }

        .btn {
            min-width: 150px;
        }

        .btn-link {
            text-decoration: none;
        }
    </style>
</head>

<body>
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>
<div class="account-container">
    <a href="${pageContext.request.contextPath}/admin/account_list" class="btn btn-link mb-3">
        <i class="bi bi-arrow-left-circle me-2"></i> Back to Account List
    </a>

    <div class="profile-header">
        <h1 class="mb-2" id="page-title">Edit Account</h1>
    </div>
    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger">${sessionScope.error}</div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <form action="${pageContext.request.contextPath}/admin/account_list/edit_account" method="post">
        <!-- hidden values -->
        <input type="hidden" name="id" value="${username}">
        <input type="hidden" name="role" value="${roleID}">

        <!-- Account Information -->
        <div class="form-card">
            <div class="section-header">
                <i class="bi bi-person-circle icon-section"></i>
                <h3 class="section-title mb-0">Account Information</h3>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="accountName" class="form-label">Account Name</label>
                    <input type="text" class="form-control" id="accountName" name="accountName"
                           required value="${accountName}">
                </div>
                <div class="col-md-6 mb-3">
                    <label for="email" class="form-label">Email</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                        <input type="email" class="form-control" id="email" name="accountEmail"
                               required value="${accountEmail}">
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="phoneNumber" class="form-label">Phone Number</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                        <input type="tel" class="form-control" id="phoneNumber" name="accountPhone"
                               value="${accountPhone}">
                    </div>
                </div>
            </div>
        </div>

        <!-- Address -->
        <div class="form-card">
            <div class="section-header">
                <i class="bi bi-geo-alt-fill icon-section"></i>
                <h3 class="section-title mb-0">Address</h3>
            </div>
            <div class="mb-3">
                <label for="accountAddress" class="form-label">Detailed Address</label>
                <input type="text" class="form-control" id="accountAddress" name="accountAddress"
                       required value="${accountAddress}">
            </div>
        </div>

        <!-- Password -->
        <div class="form-card">
            <div class="section-header">
                <i class="bi bi-shield-lock-fill icon-section"></i>
                <h3 class="section-title mb-0">Password</h3>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="newPassword" class="form-label">New Password</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-lock"></i></span>
                        <input type="password" class="form-control" id="newPassword" name="newPassword">
                        <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('newPassword')">
                            <i class="bi bi-eye"></i>
                        </button>
                    </div>
                </div>

                <div class="col-md-6 mb-3">
                    <label for="confirmPassword" class="form-label">Confirm Password</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                        <input type="password" class="form-control" id="confirmPassword">
                        <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('confirmPassword')">
                            <i class="bi bi-eye"></i>
                        </button>
                    </div>
                </div>
            </div>
            <div id="passwordError" class="alert alert-danger d-none" role="alert"></div>

        </div>

        <!-- Role -->
        <div class="form-card">
            <div class="section-header">
                <i class="bi bi-person-badge icon-section"></i>
                <h3 class="section-title mb-0">Role</h3>
            </div>
            <div id="role">
                <select id="roleSelect" class="form-select" name="roleSelect"
                        <c:if test="${role.roleID == 2}">disabled</c:if>>
                    <c:forEach var="r" items="${allRole}">
                        <option value="${r.roleID}"
                                <c:if test="${r.roleID == role.roleID}">selected</c:if>>
                                ${r.roleName}
                        </option>
                    </c:forEach>
                </select>

                <c:if test="${role.roleID == 2}">
                    <input type="hidden" name="role" value="${role.roleID}">
                </c:if>
            </div>
        </div>

        <!-- Buttons -->
        <div class="form-card">
            <div class="d-flex justify-content-between align-items-center">
                <button type="reset" class="btn btn-secondary">
                    <i class="bi bi-arrow-clockwise me-2"></i> Reset
                </button>

                <button type="submit" class="btn btn-primary" id="update-btn">
                    <i class="bi bi-check-circle me-2"></i> Update Information
                </button>
            </div>
        </div>
    </form>
</div>


<script>
    function togglePassword(id) {
        const field = document.getElementById(id);
        field.type = field.type === "password" ? "text" : "password";
    }

    document.querySelector("form").addEventListener("submit", function (e) {
        const newPass = document.getElementById("newPassword").value.trim();
        const confirmPass = document.getElementById("confirmPassword").value.trim();
        const alertBox = document.getElementById("passwordError");

        // Ẩn thông báo cũ
        alertBox.classList.add("d-none");
        alertBox.textContent = "";

        if (newPass !== "" || confirmPass !== "") {
            if (newPass.length < 6) {
                e.preventDefault();
                alertBox.textContent = "Password must be at least 6 characters long.";
                alertBox.classList.remove("d-none");
                return false;
            }

            if (newPass !== confirmPass) {
                e.preventDefault();
                alertBox.textContent = "Passwords do not match. Please re-enter.";
                alertBox.classList.remove("d-none");
                return false;
            }
        }
    });
</script>


</body>
</html>
