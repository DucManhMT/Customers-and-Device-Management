<%--
  Created by IntelliJ IDEA.
  User: FPT SHOP
  Date: 10/17/2025
  Time: 1:05 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Create Contract</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
<header>

    <nav class="navbar navbar-expand-lg navbar-dark"
         style="background: rgba(255,255,255,0.1); backdrop-filter: blur(10px);">
        <div class="container">
            <a class="navbar-brand fw-bold" href="#">
                <i class="bi bi-headset me-2"></i>
                Customer Support Portal
            </a>
            <div class="navbar-nav ms-auto">
                    <span class="navbar-text">
                        <i class="bi bi-person-circle me-1"></i>
                        Support Agent
                    </span>
            </div>
        </div>
    </nav>
</header>

<main class="container">

    <div class="upload-container">

        <div class="text-center mb-4">
            <h2 class="fw-bold text-primary mb-3">
                <i class="bi bi-file-earmark-text me-2"></i>
                Contract Document Upload
            </h2>

            <p class="text-muted">Upload customer contract images for review and processing</p>
        </div>

        <!-- ✅ Nút Back to Menu -->
        <div class="text-center mb-4">
            <a href="${pageContext.request.contextPath}/customer_supporter/customersupporter_actioncenter"
               class="btn btn-outline-primary">
                <i class="bi bi-arrow-left-circle"></i> Back to Menu
            </a>
        </div>


        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>


        <!-- ✅ FORM CHÍNH: chỉ thêm action, method, enctype -->
        <form id="uploadForm" action="${pageContext.request.contextPath}/customer_supporter/create_contract"
              method="post" enctype="multipart/form-data">
            <div class="mb-4">
                <label for="userName" class="form-label fw-semibold">
                    <i class="bi bi-person me-2"></i>
                    Customer Username
                </label>
                <input type="text" class="form-control" id="userName" name="userName"
                       placeholder="Enter customer username" required>
            </div>
            <!-- ✅ Khu vực chọn file -->
            <div class="upload-zone" id="uploadZone">
                <div class="upload-icon">
                    <i class="bi bi-cloud-upload"></i>
                </div>
                <h4 class="mb-3">Drop contract images here</h4>
                <p class="text-muted mb-3">or click to browse files</p>
                <button type="button" class="btn btn-primary" onclick="document.getElementById('fileInput').click()">
                    <i class="bi bi-folder2-open me-2"></i>
                    Choose Files
                </button>

                <!-- ✅ input file thật -->
                <input type="file" id="fileInput" name="contractImage" class="d-none" accept="image/*" required>

                <div class="mt-3">
                    <small class="text-muted">
                        Supported formats: JPG, PNG, GIF, WebP (Max 10MB per file)
                    </small>
                </div>
            </div>

            <!-- ✅ Nút hành động -->
            <div class="mt-4">
                <button type="reset" class="btn btn-outline-secondary me-2">
                    <i class="bi bi-arrow-clockwise me-1"></i>
                    Clear
                </button>
                <button type="submit" class="btn btn-primary" id="submitBtn">
                    <i class="bi bi-upload me-2"></i>
                    Upload Contract
                </button>
            </div>
        </form>
        <div id="alertContainer"></div>
        <%--            <div class="progress-container" id="progressContainer">--%>
        <%--                <label for="uploadProgress" class="form-label">Upload Progress</label>--%>
        <%--                <div class="progress" style="height: 8px;">--%>
        <%--                    <div class="progress-bar progress-bar-striped progress-bar-animated"--%>
        <%--                         id="uploadProgress" role="progressbar" style="width: 0%"></div>--%>
        <%--                </div>--%>
        <%--            </div>--%>

        <%--            <div class="file-preview" id="filePreview">--%>
        <%--                <h5 class="mb-3">--%>
        <%--                    <i class="bi bi-eye me-2"></i>--%>
        <%--                    Preview--%>
        <%--                </h5>--%>
        <%--                <div id="previewContainer" class="row g-3"></div>--%>
        <%--            </div>--%>


    </div>

</main>
</body>
</html>