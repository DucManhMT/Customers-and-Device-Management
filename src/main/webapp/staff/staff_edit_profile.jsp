<%--
  Created by IntelliJ IDEA.
  User: FPT SHOP
  Date: 11/2/2025
  Time: 1:11 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Edit Profile</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
          rel="stylesheet">
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

        .avatar-wrapper {
            width: 140px;
            height: 140px;
            margin: auto;
            position: relative;
            border-radius: 50%;
            overflow: hidden;
            cursor: pointer;
        }

        .avatar-preview {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: .3s;
        }

        .avatar-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.45);
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: .3s;
        }

        .avatar-wrapper:hover .avatar-overlay {
            opacity: 1;
        }

        .avatar-wrapper:hover .avatar-preview {
            transform: scale(1.05);
        }

        .avatar-icon {
            font-size: 35px;
            color: white;
            opacity: 0;
            transition: .3s;
        }

        .avatar-wrapper:hover .avatar-icon {
            opacity: 1;
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

<div class="account-container">
    <a href="${pageContext.request.contextPath}/staff/profile" class="btn btn-link mb-3">
        <i class="bi bi-arrow-left-circle me-2"></i> Back to Profile
    </a>

    <div class="profile-header">
        <h1 class="mb-2" id="page-title">Edit Account</h1>
    </div>

    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger">${sessionScope.error}</div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.success}">
        <div class="alert alert-success">${sessionScope.success}</div>
        <%
            session.removeAttribute("success");
        %>
        <script>
            setTimeout(function() {
                window.location.href = '${pageContext.request.contextPath}/staff/profile';
            }, 3000);
        </script>
    </c:if>

    <!-- ✅ THÊM multipart/form-data -->
    <form action="${pageContext.request.contextPath}/staff/profile/edit"
          method="post"
          enctype="multipart/form-data">

        <!-- Avatar -->
        <div class="form-card">
            <div class="avatar-wrapper" onclick="document.getElementById('profileImgInput').click();">
                <img id="previewImage"
                     src="${pageContext.request.contextPath}/${staff.image}"
                     class="avatar-preview"/>

                <div class="avatar-overlay">
                    <i class="bi bi-camera-fill avatar-icon"></i>
                </div>
            </div>

            <!-- input file ẩn -->
            <input type="file"
                   id="profileImgInput"
                   name="profileImage"
                   accept="image/*"
                   style="display:none"
                   onchange="previewAvatar(event)">
        </div>


        <!-- Account Info -->
        <div class="form-card">
            <div class="section-header">
                <i class="bi bi-person-circle icon-section"></i>
                <h3 class="section-title mb-0">Account Information</h3>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="accountName" class="form-label">Account Name</label>
                    <input type="text" class="form-control" id="accountName" name="accountName"
                           required value="${staff.staffName}">
                </div>

                <div class="col-md-6 mb-3">
                    <label for="email" class="form-label">Email</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                        <input type="email" class="form-control" id="email" name="accountEmail"
                               required value="${staff.email}">
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="phoneNumber" class="form-label">Phone Number</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                        <input type="tel" class="form-control" id="phoneNumber" name="accountPhone"
                               required value="${staff.phone}">
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
                       required value="${staff.address}">
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
    function previewAvatar(event) {
        const img = document.getElementById('previewImage');
        img.src = URL.createObjectURL(event.target.files[0]);
    }
</script>

</body>
</html>
