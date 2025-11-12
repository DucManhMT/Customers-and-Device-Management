<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Create Contract - Supporter</title>

    <!-- Bootstrap + Icons -->
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        /* Keep look consistent with other admin/supporter pages */
        body {
            margin-left: 260px !important;
            padding-top: 70px !important;
            background: linear-gradient(135deg, #f5f7fa 0%, #eef4ff 100%);
            min-height: 100vh;
            font-family: system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial;
            color: #1e1e1e;
        }

        main.container {
            max-width: 900px;
            padding: 28px;
        }

        .upload-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 12px 30px rgba(35,44,78,0.06);
            padding: 28px;
        }

        .upload-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-bottom: 18px;
        }

        .upload-header h2 {
            margin: 0;
            font-weight: 700;
        }

        .btn-back {
            background: rgba(43,76,176,0.12);
            color: #2b6cb0;
            border: none;
            padding: 8px 12px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }
        .btn-back:hover { opacity: .95; }

        .form-label { font-weight: 600; }

        .upload-zone {
            border: 2px dashed #e6e9f8;
            border-radius: 10px;
            padding: 36px 20px;
            text-align: center;
            transition: all 0.18s ease;
            background: #fbfdff;
            cursor: pointer;
        }
        .upload-zone:hover {
            border-color: #667eea;
            background: #f0f4ff;
        }

        .upload-icon {
            font-size: 3.2rem;
            color: #667eea;
            margin-bottom: 8px;
        }

        input[type="file"].d-none { display: none; }

        iframe#pdfPreview {
            border: 1px solid #e6e9f0;
            border-radius: 8px;
        }

        .actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 18px;
        }

        .btn-primary {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
            color: white;
            padding: 10px 18px;
            border-radius: 10px;
            font-weight: 600;
        }
        .btn-outline-secondary {
            border-radius: 10px;
            color: #6c757d;
            border-color: #6c757d;
            background: white;
            padding: 10px 18px;
        }

        .help-text { color: #6c757d; font-size: .9rem; margin-top: .25rem; }

        /* Inline success alert */
        .upload-success {
            border-radius: 10px;
            box-shadow: 0 8px 24px rgba(35,44,78,0.06);
            padding: 14px;
            margin-bottom: 18px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
        }
        .upload-success .left { display:flex; align-items:center; gap:12px; }
        .upload-success .right { display:flex; gap:8px; align-items:center; }

        @media (max-width: 992px) {
            body { margin-left: 0 !important; padding-top: 90px !important; }
            main.container { padding: 16px; }
        }
    </style>
</head>
<body>
<c:set var="activePage" value="createContract" scope="request" />
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>

<main class="container">
    <div class="upload-container">

        <div class="upload-header">
            <div>
                <h2><i class="bi bi-file-earmark-text me-2"></i>Create Contract</h2>
                <div class="text-muted" style="margin-top:4px;">Upload and attach a contract PDF for a customer</div>
            </div>

            <div>
                <a href="${pageContext.request.contextPath}/customer_supporter/customersupporter_actioncenter" class="btn-back">
                    <i class="bi bi-arrow-left-circle"></i> Back to Menu
                </a>
            </div>
        </div>

        <!-- Inline success alert shown when redirected with ?success=1&contractPDF=... -->
        <c:if test="${param.success == '1'}">
            <div id="successAlert" class="upload-success" style="background: linear-gradient(90deg,#ecfdf5,#e6fffa); border:1px solid #bbf7d0;">
                <div class="left">
                    <i class="bi bi-check-circle-fill text-success" style="font-size:1.6rem;"></i>
                    <div>
                        <div style="font-weight:700; color:#065f46;">Upload successful</div>
                        <div class="text-muted small">The contract was uploaded and saved.</div>
                    </div>
                </div>

                <div class="right">
                    <c:if test="${not empty param.contractPDF}">
                        <a id="viewPdfBtn" class="btn btn-sm btn-outline-primary" href="${param.contractPDF}" target="_blank">
                            <i class="bi bi-eye me-1"></i> View
                        </a>
                        <a id="downloadPdfBtn" class="btn btn-sm btn-outline-success" href="${param.contractPDF}" download>
                            <i class="bi bi-download me-1"></i> Download
                        </a>
                    </c:if>

                    <a href="${pageContext.request.contextPath}/customer_supporter/create_contract" class="btn btn-sm btn-secondary">
                        <i class="bi bi-plus-circle me-1"></i> Upload another
                    </a>
                </div>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <form id="uploadForm" action="${pageContext.request.contextPath}/customer_supporter/create_contract"
              method="post" enctype="multipart/form-data" novalidate>
            <div class="row g-3">
                <div class="col-md-6">
                <label for="userName" class="form-label">Customer Username</label>
                <input type="text" class="form-control" id="userName" name="userName"
                       placeholder="Enter customer username" value="${account.username}" readonly>
                </div>
                <div class="col-md-6">
                    <label for="userName" class="form-label">Customer Name</label>
                    <input type="text" class="form-control" id="userName" name="userName"
                           placeholder="Enter customer username" value="${customerName}" readonly>
                </div>
            </div>

            <div class="row g-3">
                <div class="col-md-6">
                    <label for="startDate" class="form-label">Start Date</label>
                    <input type="date" class="form-control" id="startDate" name="startDate" value="${param.startDate != null ? param.startDate : ''}" required>
                    <div class="form-text help-text">Choose contract start date.</div>
                </div>

                <div class="col-md-6">
                    <label for="expireDate" class="form-label">Expire Date</label>
                    <input type="date" class="form-control" id="expireDate" name="expireDate" value="${param.expireDate != null ? param.expireDate : ''}" required>
                    <div class="form-text help-text">Choose contract expiration date.</div>
                </div>
            </div>

            <div class="mt-4">
                <div id="uploadZone" class="upload-zone" onclick="document.getElementById('fileInput').click()">
                    <div class="upload-icon"><i class="bi bi-cloud-upload"></i></div>
                    <h5 class="mb-2">Click to upload PDF</h5>
                    <div class="text-muted">Only PDF files are supported. Max size: 10MB.</div>
                    <input type="file" id="fileInput" name="contractImage" accept="application/pdf" class="d-none" required>
                </div>
                <div id="fileName" class="mt-2 text-muted small" style="display:none;"></div>
            </div>

            <div id="pdfPreviewContainer" class="mt-4" style="display:none;">
                <h5 class="mb-2"><i class="bi bi-eye me-2"></i>Preview</h5>
                <iframe id="pdfPreview" width="100%" height="560px" style="display:block;"></iframe>

            </div>

            <div class="actions">
                <a href="${pageContext.request.contextPath}/customer_supporter/create_contract" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-clockwise me-1"></i>Clear
                </a>
                <button type="submit" id="submitBtn" class="btn btn-primary">
                    <i class="bi bi-upload me-1"></i>Upload Contract
                </button>
            </div>
        </form>
    </div>
</main>

<!-- JS: preview and auto-hide success alert -->
<script>
    (function () {
        const fileInput = document.getElementById('fileInput');
        const pdfPreview = document.getElementById('pdfPreview');
        const pdfPreviewContainer = document.getElementById('pdfPreviewContainer');
        const fileNameEl = document.getElementById('fileName');
        const downloadBtn = document.getElementById('downloadContractBtn');
        const maxSizeBytes = 10 * 1024 * 1024; // 10MB

        fileInput.addEventListener('change', () => {
            const file = fileInput.files[0];
            if (!file) {
                pdfPreviewContainer.style.display = 'none';
                fileNameEl.style.display = 'none';
                return;
            }

            if (file.type !== 'application/pdf') {
                alert('Please select a PDF file.');
                fileInput.value = '';
                return;
            }

            if (file.size > maxSizeBytes) {
                alert('File is too large. Maximum allowed size is 10MB.');
                fileInput.value = '';
                return;
            }

            const fileUrl = URL.createObjectURL(file);
            pdfPreview.src = fileUrl;
            pdfPreviewContainer.style.display = 'block';
            fileNameEl.style.display = 'block';
            fileNameEl.textContent = 'Selected file: ' + file.name;
            downloadBtn.href = fileUrl;
            downloadBtn.style.display = 'inline-block';
        });

        // Auto-hide the inline success alert after 6 seconds
        const successAlert = document.getElementById('successAlert');
        if (successAlert) {
            setTimeout(() => {
                successAlert.style.transition = 'opacity 0.5s ease';
                successAlert.style.opacity = '0';
                setTimeout(() => successAlert.remove(), 600);
            }, 6000);

            // Scroll to alert so user sees it
            successAlert.scrollIntoView({behavior: 'smooth', block: 'center'});
        }
    })();
</script>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>