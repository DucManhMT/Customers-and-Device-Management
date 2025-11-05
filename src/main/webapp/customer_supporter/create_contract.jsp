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
    <style>
        body {
            box-sizing: border-box;
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .upload-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 2rem;
            margin: 2rem auto;
            max-width: 800px;
        }

        .upload-zone {
            border: 3px dashed #dee2e6;
            border-radius: 10px;
            padding: 3rem 2rem;
            text-align: center;
            transition: all 0.3s ease;
            background: #f8f9fa;
            cursor: pointer;
        }

        .upload-zone:hover {
            border-color: #667eea;
            background: #f0f2ff;
        }


        .upload-icon {
            font-size: 4rem;
            color: #667eea;
            margin-bottom: 1rem;
        }




        .btn-primary {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
            border-radius: 25px;
            padding: 12px 30px;
            font-weight: 600;
        }

        .btn-primary:hover {
            background: linear-gradient(45deg, #5a6fd8, #6a4190);
            transform: translateY(-2px);
        }

        iframe {
            border: 2px solid #dee2e6;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }


    </style>
</head>
<body>
<c:set var="activePage" value="createContract" scope="request" />
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/supporter_sidebar.jsp"/>



<main class="container">

    <div class="upload-container">

        <div class="text-center mb-4">
            <h2 class="fw-bold text-primary mb-3">
                <i class="bi bi-file-earmark-text me-2"></i>
                Contract Document Upload
            </h2>

            <p class="text-muted">Upload customer contract images for review and processing</p>
        </div>

        <div class="text-center mb-4">
            <a href="${pageContext.request.contextPath}/customer_supporter/customersupporter_actioncenter"
               class="btn btn-outline-primary">
                <i class="bi bi-arrow-left-circle"></i> Back to Menu
            </a>
        </div>


        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>


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
             <div class="mb-4">
                <label for="startDate" class="form-label fw-semibold">
                    <i class="bi bi-calendar-check me-2"></i>
                    Start Date
                </label>
                <input type="date" class="form-control" id="startDate" name="startDate" required>
                <small class="text-muted">Select the contract start date</small>
            </div>

            <div class="mb-4">
                <label for="expireDate" class="form-label fw-semibold">
                    <i class="bi bi-calendar-event me-2"></i>
                    Expire Date
                </label>
                <input type="date" class="form-control" id="expireDate" name="expireDate" required>
                <small class="text-muted">Select the contract expiration date</small>
            </div>


            <div class="upload-zone text-center" id="uploadZone" onclick="document.getElementById('fileInput').click()">
                <div class="upload-icon">
                    <i class="bi bi-cloud-upload"></i>
                </div>
                <h4 class="mb-3">Click to browse PDF file</h4>

                <input type="file" id="fileInput" name="contractImage" class="d-none" accept="application/pdf" required>

                <div class="mt-3">
                    <small class="text-muted">Supported format: PDF (Max 10MB per file)</small>
                </div>
            </div>

            <div id="pdfPreviewContainer" class="mt-4" style="display:none;">
                <h5><i class="bi bi-eye me-2"></i>Preview</h5>
                <iframe id="pdfPreview" width="100%" height="600px" style="border: 1px solid #ccc; border-radius: 8px;"></iframe>
            </div>

            <div class="mt-4">
                <a href="${pageContext.request.contextPath}/customer_supporter/create_contract"
                   class="btn btn-outline-secondary me-2">
                    <i class="bi bi-arrow-clockwise me-1"></i>
                    Clear
                </a>
                <button type="submit" class="btn btn-primary" id="submitBtn">
                    <i class="bi bi-upload me-2"></i>
                    Upload Contract
                </button>
            </div>
        </form>

        <script>
            const fileInput = document.getElementById("fileInput");
            const pdfPreviewContainer = document.getElementById("pdfPreviewContainer");
            const pdfPreview = document.getElementById("pdfPreview");

            fileInput.addEventListener("change", () => {
                const file = fileInput.files[0];
                if (file && file.type === "application/pdf") {
                    const fileURL = URL.createObjectURL(file);
                    pdfPreview.src = fileURL;
                    pdfPreviewContainer.style.display = "block";
                } else {
                    pdfPreviewContainer.style.display = "none";
                    alert("Please select a valid PDF file.");
                }
            });
        </script>

</body>
</html>