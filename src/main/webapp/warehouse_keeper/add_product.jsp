<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Add New Product</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        :root {
            --primary-color: #4a90e2;
            --success-color: #22c55e;
            --danger-color: #ef4444;
            --card-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }

        body {
            background-color: #f8f9fa;
        }

        .main-content {
            padding: 2rem;
        }

        .page-header {
            background: white;
            border-radius: 12px;
            padding: 1.5rem 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--card-shadow);
        }

        .page-header h1 {
            margin: 0;
            color: #1e293b;
            font-weight: 700;
            font-size: 1.75rem;
        }

        .form-card {
            background: white;
            border: none;
            border-radius: 12px;
            box-shadow: var(--card-shadow);
            overflow: hidden;
        }

        .form-card-header {
            background: linear-gradient(135deg, var(--primary-color), #667eea);
            color: white;
            padding: 1.5rem 2rem;
        }

        .form-card-header h2 {
            margin: 0;
            font-size: 1.5rem;
            font-weight: 700;
        }

        .form-card-body {
            padding: 2rem;
        }

        .form-section {
            background: #f8fafc;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            border: 1px solid #e2e8f0;
        }

        .form-section-title {
            font-size: 1rem;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-section-title i {
            color: var(--primary-color);
        }

        .form-label {
            font-weight: 600;
            color: #475569;
            margin-bottom: 0.5rem;
        }

        .form-control, .form-select {
            border-radius: 8px;
            border: 1px solid #cbd5e1;
            padding: 0.75rem 1rem;
            transition: all 0.2s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
        }

        textarea.form-control {
            resize: vertical;
            min-height: 100px;
        }

        .file-upload-wrapper {
            position: relative;
            overflow: hidden;
        }

        .file-upload-label {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
            padding: 2rem;
            border: 2px dashed #cbd5e1;
            border-radius: 10px;
            background: white;
            cursor: pointer;
            transition: all 0.3s ease;
            color: #64748b;
        }

        .file-upload-label:hover {
            border-color: var(--primary-color);
            background: #eff6ff;
            color: var(--primary-color);
        }

        .file-upload-label i {
            font-size: 2rem;
        }

        .file-upload-input {
            position: absolute;
            left: -9999px;
        }

        .file-name-display {
            margin-top: 0.5rem;
            padding: 0.5rem 1rem;
            background: #f1f5f9;
            border-radius: 6px;
            font-size: 0.9rem;
            color: #475569;
            display: none;
        }

        .specs-container {
            background: white;
            border-radius: 10px;
            padding: 1rem;
        }

        .spec-row {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 0.75rem;
            margin-bottom: 0.75rem;
            transition: all 0.2s ease;
        }

        .spec-row:hover {
            border-color: var(--primary-color);
            box-shadow: 0 2px 8px rgba(74, 144, 226, 0.1);
        }

        .btn-add-spec {
            background: linear-gradient(135deg, #eff6ff, #dbeafe);
            border: 1px solid #bfdbfe;
            color: var(--primary-color);
            font-weight: 600;
            padding: 0.625rem 1.25rem;
            border-radius: 8px;
            transition: all 0.2s ease;
        }

        .btn-add-spec:hover {
            background: linear-gradient(135deg, #dbeafe, #bfdbfe);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(74, 144, 226, 0.2);
        }

        .btn-remove-spec {
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: var(--danger-color);
            width: 36px;
            height: 36px;
            border-radius: 8px;
            font-size: 1.25rem;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .btn-remove-spec:hover {
            background: var(--danger-color);
            color: white;
            border-color: var(--danger-color);
        }

        .btn-submit {
            background: linear-gradient(135deg, var(--success-color), #16a34a);
            border: none;
            color: white;
            padding: 0.875rem 2rem;
            border-radius: 10px;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(34, 197, 94, 0.3);
        }

        .alert {
            border: none;
            border-radius: 10px;
            padding: 1rem 1.5rem;
            margin-bottom: 1.5rem;
            animation: slideDown 0.3s ease;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .alert-success {
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            color: #065f46;
            border-left: 4px solid var(--success-color);
        }

        .alert-danger {
            background: linear-gradient(135deg, #fee2e2, #fecaca);
            color: #991b1b;
            border-left: 4px solid var(--danger-color);
        }

        .required-asterisk {
            color: var(--danger-color);
            margin-left: 0.25rem;
        }

        @media (max-width: 768px) {
            .main-content {
                padding: 1rem;
            }

            .form-card-body {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>

<div class="main-content">
    <div class="container-fluid">
        <div class="page-header">
            <h1><i class="fas fa-plus-circle me-2"></i>Add New Product</h1>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-10">
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                    </div>
                </c:if>

                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle me-2"></i>${successMessage}
                    </div>
                </c:if>

                <div class="form-card">
                    <div class="form-card-header">
                        <h2><i class="fas fa-box me-2"></i>Product Information</h2>
                    </div>
                    <div class="form-card-body">
                        <!-- Product Type Selection -->
                        <div class="form-section">
                            <div class="form-section-title">
                                <i class="fas fa-tag"></i>
                                <span>Product Type</span>
                                <span class="required-asterisk">*</span>
                            </div>
                            <form action="${pageContext.request.contextPath}/warehouse_keeper/add_product" method="GET">
                                <select class="form-select" id="type" name="typeID" required onchange="this.form.submit()">
                                    <option value="" disabled selected>-- Select a Product Type --</option>
                                    <c:forEach var="type" items="${types}">
                                        <option value="${type.typeID}" ${selectedType.typeID == type.typeID ? 'selected' : ''}>
                                                ${type.typeName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </form>
                        </div>

                        <!-- Product Details Form -->
                        <form action="${pageContext.request.contextPath}/warehouse_keeper/add_product" method="post"
                              enctype="multipart/form-data">
                            <input type="hidden" name="typeID" value="${selectedType.typeID}">

                            <!-- Basic Information -->
                            <div class="form-section">
                                <div class="form-section-title">
                                    <i class="fas fa-info-circle"></i>
                                    <span>Basic Information</span>
                                </div>

                                <div class="mb-3">
                                    <label for="productName" class="form-label">
                                        Product Name<span class="required-asterisk">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="productName"
                                           name="productName" placeholder="Enter product name" required>
                                </div>

                                <div class="mb-0">
                                    <label for="productDescription" class="form-label">Description</label>
                                    <textarea class="form-control" id="productDescription"
                                              name="productDescription" rows="4"
                                              placeholder="Enter product description..."></textarea>
                                </div>
                            </div>

                            <!-- Product Image -->
                            <div class="form-section">
                                <div class="form-section-title">
                                    <i class="fas fa-image"></i>
                                    <span>Product Image</span>
                                </div>
                                <div class="file-upload-wrapper">
                                    <input class="file-upload-input" type="file" id="productImage"
                                           name="productImage" accept="image/*">
                                    <label for="productImage" class="file-upload-label">
                                        <div class="text-center">
                                            <i class="fas fa-cloud-upload-alt"></i>
                                            <div class="mt-2">
                                                <strong>Click to upload</strong> or drag and drop
                                            </div>
                                            <small class="text-muted">PNG, JPG, GIF up to 10MB</small>
                                        </div>
                                    </label>
                                    <div class="file-name-display" id="fileNameDisplay">
                                        <i class="fas fa-file-image me-2"></i>
                                        <span id="fileName"></span>
                                    </div>
                                </div>
                            </div>

                            <!-- Specifications -->
                            <div class="form-section">
                                <div class="form-section-title">
                                    <i class="fas fa-list-ul"></i>
                                    <span>Product Specifications</span>
                                </div>
                                <div class="specs-container" id="specifications-container">
                                    <!-- Specification rows will be added here -->
                                </div>
                                <button type="button" id="add-spec-btn" class="btn btn-add-spec mt-3">
                                    <i class="fas fa-plus me-2"></i>Add Specification
                                </button>
                            </div>

                            <!-- Submit Button -->
                            <div class="d-grid">
                                <button type="submit" class="btn btn-submit">
                                    <i class="fas fa-check-circle me-2"></i>Add Product
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Hidden template for specification rows -->
<div id="spec-template" style="display: none;">
    <div class="row g-2 spec-row align-items-center">
        <div class="col">
            <select class="form-select" name="specIDs">
                <option value="" disabled selected>-- Select Specification --</option>
                <c:forEach var="specType" items="${selectedType.specificationTypes}">
                    <c:forEach var="spec" items="${specType.specifications}">
                        <option value="${spec.specificationID}">
                                ${spec.specificationName}: ${spec.specificationValue}
                        </option>
                    </c:forEach>
                </c:forEach>
            </select>
        </div>
        <div class="col-auto">
            <button type="button" class="btn btn-remove-spec remove-spec-btn">
                <i class="fas fa-times"></i>
            </button>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const container = document.getElementById('specifications-container');
        const addButton = document.getElementById('add-spec-btn');
        const template = document.getElementById('spec-template');
        const fileInput = document.getElementById('productImage');
        const fileNameDisplay = document.getElementById('fileNameDisplay');
        const fileName = document.getElementById('fileName');

        // File upload display
        fileInput.addEventListener('change', function() {
            if (this.files && this.files[0]) {
                fileName.textContent = this.files[0].name;
                fileNameDisplay.style.display = 'block';
            } else {
                fileNameDisplay.style.display = 'none';
            }
        });

        // Specification management
        const addSpecRow = () => {
            const newRow = template.firstElementChild.cloneNode(true);
            container.appendChild(newRow);
        };

        addButton.addEventListener('click', addSpecRow);

        container.addEventListener('click', function (e) {
            if (e.target && (e.target.classList.contains('remove-spec-btn') ||
                e.target.closest('.remove-spec-btn'))) {
                const row = e.target.closest('.spec-row');
                if (row) {
                    row.remove();
                }
            }
        });

        // Add one initial row to start with
        addSpecRow();
    });
</script>
</body>
</html>
