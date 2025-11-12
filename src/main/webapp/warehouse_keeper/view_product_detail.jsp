<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.productName} - Product Details</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <!-- Link to your Global Stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">

    <style>
        :root {
            --primary-color: #4f46e5;
            --primary-hover: #4338ca;
            --success-color: #10b981;
            --info-color: #3b82f6;
            --gradient-start: #667eea;
            --gradient-end: #764ba2;
        }

        .page-header {
            background: linear-gradient(135deg, var(--gradient-start) 0%, var(--gradient-end) 100%);
            border-radius: 16px;
            padding: 32px;
            margin-bottom: 32px;
            box-shadow: 0 10px 40px rgba(102, 126, 234, 0.2);
            color: white;
            position: relative;
            overflow: hidden;
        }

        .page-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
        }

        .page-header h1 {
            font-weight: 700;
            font-size: 2rem;
            margin: 0;
            position: relative;
            z-index: 1;
        }

        .page-header-subtitle {
            opacity: 0.9;
            margin-top: 8px;
            font-size: 0.95rem;
        }

        .product-id-badge {
            background: rgba(255, 255, 255, 0.2);
            padding: 8px 16px;
            border-radius: 10px;
            font-weight: 600;
            position: relative;
            z-index: 1;
        }

        .detail-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
            border: none;
            overflow: hidden;
            margin-bottom: 24px;
        }

        .product-image-section {
            background: #f9fafb;
            padding: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 400px;
        }

        .product-img {
            max-height: 350px;
            max-width: 100%;
            object-fit: contain;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }

        .product-img:hover {
            transform: scale(1.05);
        }

        .product-img-placeholder {
            width: 300px;
            height: 300px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: white;
            border: 2px dashed #e5e7eb;
            border-radius: 12px;
            color: #9ca3af;
        }

        .product-img-placeholder i {
            font-size: 5rem;
        }

        .product-info-section {
            padding: 32px;
        }

        .product-title {
            font-size: 2rem;
            font-weight: 700;
            color: #111827;
            margin-bottom: 16px;
        }

        .product-description {
            color: #6b7280;
            font-size: 1rem;
            line-height: 1.6;
            margin-bottom: 24px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 16px;
            margin-bottom: 32px;
        }

        .stat-box {
            background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 100%);
            padding: 20px;
            border-radius: 12px;
            text-align: center;
            transition: all 0.3s ease;
        }

        .stat-box:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
        }

        .stat-label {
            font-size: 0.875rem;
            color: #6b7280;
            font-weight: 500;
            margin-bottom: 8px;
            display: block;
        }

        .stat-value {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--primary-color);
        }

        .type-badge {
            background: linear-gradient(135deg, var(--gradient-start), var(--gradient-end));
            color: white;
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-block;
        }

        .action-buttons {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .btn-action {
            border-radius: 10px;
            padding: 12px 24px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: none;
        }

        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }

        .btn-action.btn-primary {
            background: linear-gradient(135deg, var(--gradient-start), var(--gradient-end));
        }

        .btn-action.btn-info {
            background: var(--info-color);
        }

        .btn-action.btn-secondary {
            background: #6b7280;
        }

        .section-header {
            background: linear-gradient(to right, #f9fafb, white);
            padding: 20px 24px;
            border-bottom: 2px solid #e5e7eb;
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: #111827;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title i {
            color: var(--primary-color);
        }

        .spec-table {
            width: 100%;
            margin: 0;
        }

        .spec-table thead {
            background: #f9fafb;
        }

        .spec-table thead th {
            padding: 16px 24px;
            font-weight: 600;
            color: #6b7280;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.5px;
            border-bottom: 2px solid #e5e7eb;
        }

        .spec-table tbody tr {
            border-bottom: 1px solid #e5e7eb;
            transition: all 0.2s ease;
        }

        .spec-table tbody tr:hover {
            background: #f9fafb;
        }

        .spec-table tbody tr:last-child {
            border-bottom: none;
        }

        .spec-table td {
            padding: 16px 24px;
        }

        .spec-name {
            font-weight: 600;
            color: #374151;
        }

        .spec-value {
            color: #6b7280;
        }

        .empty-state {
            padding: 48px 24px;
            text-align: center;
            color: #9ca3af;
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 16px;
        }

        .empty-state p {
            margin: 0;
            font-size: 1rem;
        }

        .alert-custom {
            background: linear-gradient(135deg, #e0e7ff 0%, #ddd6fe 100%);
            border: none;
            border-radius: 12px;
            color: #4f46e5;
            font-weight: 500;
            padding: 16px 20px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .alert-custom i {
            font-size: 1.5rem;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .detail-card {
            animation: fadeIn 0.5s ease-out;
        }

        .main-content{
            margin: 15px;
        }
    </style>
</head>
<body>
<jsp:include page="../components/sidebar.jsp"/>
<div class="main-content">
    <jsp:include page="../components/header.jsp"/>

    <div class="page-content">
        <div class="page-header">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1><i class="fas fa-box-open me-2"></i>Product Details</h1>
                    <p class="page-header-subtitle mb-0">Complete information about this product</p>
                </div>
                <div class="product-id-badge">
                    ID: ${product.productID}
                </div>
            </div>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert-custom">
                <i class="fas fa-info-circle"></i>
                <span>${errorMessage}</span>
            </div>
        </c:if>

        <!-- Product Detail Card -->
        <div class="detail-card">
            <div class="row g-0">
                <!-- Product Image -->
                <div class="col-lg-5">
                    <div class="product-image-section">
                        <c:choose>
                            <c:when test="${not empty product.productImage}">
                                <img src="${pageContext.request.contextPath}/assets/${product.productImage}"
                                     alt="${product.productName}"
                                     class="product-img">
                            </c:when>
                            <c:otherwise>
                                <div class="product-img-placeholder">
                                    <i class="fas fa-image"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Product Information -->
                <div class="col-lg-7">
                    <div class="product-info-section">
                        <h2 class="product-title">${product.productName}</h2>

                        <div class="mb-4">
                            <span class="type-badge">${product.type.typeName}</span>
                        </div>

                        <div class="mb-4">
                            <h5 class="fw-semibold mb-2">Description</h5>
                            <p class="product-description">
                                <c:choose>
                                    <c:when test="${not empty product.productDescription}">
                                        ${product.productDescription}
                                    </c:when>
                                    <c:otherwise>
                                        <em>No description available for this product.</em>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>

                        <!-- Quick Stats -->
                        <div class="stats-grid">
                            <div class="stat-box">
                                <span class="stat-label">Product ID</span>
                                <div class="stat-value">${product.productID}</div>
                            </div>
                            <div class="stat-box">
                                <span class="stat-label">Category</span>
                                <div class="stat-value">${product.type.typeName}</div>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/warehouse/editProduct?productId=${product.productID}"
                               class="btn btn-action btn-primary">
                                <i class="fas fa-edit me-2"></i>Edit Product
                            </a>
                            <a href="${pageContext.request.contextPath}/warehouse/productInventory?productId=${product.productID}"
                               class="btn btn-action btn-info">
                                <i class="fas fa-boxes me-2"></i>View Inventory
                            </a>
                            <a href="${pageContext.request.contextPath}/warehouse_keeper/view_product_warehouse"
                               class="btn btn-action btn-secondary">
                                <i class="fas fa-arrow-left me-2"></i>Back to List
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Product Specifications -->
        <div class="detail-card">
            <div class="section-header">
                <h3 class="section-title">
                    <i class="fas fa-list-ul"></i>
                    Product Specifications
                </h3>
            </div>
            <c:choose>
                <c:when test="${not empty product.productSpecifications}">
                    <table class="spec-table">
                        <thead>
                        <tr>
                            <th>Specification</th>
                            <th>Value</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${product.productSpecifications}" var="spec">
                            <tr>
                                <td class="spec-name">${spec.specification.specificationName}</td>
                                <td class="spec-value">${spec.specification.specificationValue}</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-info-circle"></i>
                        <p>No specifications available for this product.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
