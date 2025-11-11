<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventory Dashboard</title>
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
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
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

        .filter-section {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
            margin-bottom: 24px;
            border: 1px solid #e5e7eb;
        }

        .filter-buttons .btn {
            border-radius: 10px;
            font-weight: 500;
            padding: 10px 24px;
            background: white;
            color: var(--primary-color);
            border: 2px solid var(--primary-color);
            transition: all 0.3s ease;
        }

        .filter-buttons .btn:hover {
            background: var(--primary-color);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
        }

        .inventory-card {
            background-color: white;
            border-radius: 16px;
            padding: 32px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
            border: none;
        }

        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 24px;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
        }

        .stats-card h3 {
            font-size: 2rem;
            font-weight: 700;
            margin: 0;
        }

        .stats-card p {
            margin: 0;
            opacity: 0.9;
            font-size: 0.9rem;
        }

        /* Product Grid */
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 24px;
        }

        .product-card {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            display: flex;
            flex-direction: column;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            overflow: hidden;
            height: 100%;
        }

        .product-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.12);
            border-color: var(--primary-color);
        }

        .product-card-header {
            padding: 16px;
            display: flex;
            justify-content: space-between;
            gap: 8px;
            background: linear-gradient(to bottom, #f9fafb, white);
            border-bottom: 1px solid #e5e7eb;
        }

        .product-card-header .btn-tag {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 6px 14px;
            font-size: 0.875rem;
            font-weight: 500;
            color: #6b7280;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease;
            flex: 1;
            justify-content: center;
        }

        .product-card-header .btn-tag:hover {
            background: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
            transform: scale(1.05);
        }

        .product-card-header .btn-tag.btn-view:hover {
            background: var(--success-color);
            border-color: var(--success-color);
        }

        .product-card-img-container {
            width: 100%;
            height: 240px;
            padding: 16px;
            background: #f9fafb;
        }

        .product-card-img {
            height: 100%;
            width: 100%;
            object-fit: cover;
            border-radius: 12px;
            background: white;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }

        .product-card:hover .product-card-img {
            transform: scale(1.05);
        }

        .product-card-img-placeholder {
            height: 100%;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #9ca3af;
            border: 2px dashed #e5e7eb;
            border-radius: 12px;
            background: white;
        }

        .product-card-img-placeholder i {
            font-size: 3rem;
        }

        .product-card-content {
            padding: 20px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }

        .product-card-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: #111827;
            margin-bottom: 8px;
            line-height: 1.4;
        }

        .product-type-badge {
            background: linear-gradient(135deg, var(--gradient-start), var(--gradient-end));
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .product-card-specifications {
            background: #f9fafb;
            border-radius: 8px;
            padding: 12px;
            margin-top: 12px;
        }

        .spec-item {
            display: flex;
            justify-content: space-between;
            padding: 4px 0;
            font-size: 0.875rem;
        }

        .spec-label {
            color: #6b7280;
            font-weight: 500;
        }

        .spec-value {
            color: #111827;
            font-weight: 600;
        }

        .product-card-footer {
            margin-top: auto;
            padding-top: 16px;
            border-top: 2px solid #f3f4f6;
        }

        .stock-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 0.95rem;
        }

        .stock-badge.in-stock {
            background: #dcfce7;
            color: var(--success-color);
        }

        .stock-badge.low-stock {
            background: #fef3c7;
            color: var(--warning-color);
        }

        .stock-badge.out-of-stock {
            background: #fee2e2;
            color: var(--danger-color);
        }

        .btn-create-request {
            background: linear-gradient(135deg, var(--gradient-start), var(--gradient-end));
            color: white;
            border: none;
            border-radius: 12px;
            padding: 12px 28px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }

        .btn-create-request:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
            color: white;
        }

        /* Pagination */
        .pagination .page-link {
            border-radius: 8px;
            margin: 0 4px;
            border: 1px solid #e5e7eb;
            color: #6b7280;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .pagination .page-link:hover {
            background: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
        }

        .pagination .page-item.active .page-link {
            background: var(--primary-color);
            border-color: var(--primary-color);
        }

        /* Form Controls */
        .form-control, .form-select {
            border-radius: 10px;
            border: 1px solid #e5e7eb;
            padding: 10px 16px;
            transition: all 0.2s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1);
        }

        .btn-primary {
            background: var(--primary-color);
            border: none;
            border-radius: 10px;
            padding: 10px 24px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background: var(--primary-hover);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
        }

        /* Empty State */
        .alert-info {
            background: linear-gradient(135deg, #e0e7ff 0%, #ddd6fe 100%);
            border: none;
            border-radius: 12px;
            color: #4f46e5;
            font-weight: 500;
            padding: 20px;
        }

        /* Loading Animation */
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

        .product-card {
            animation: fadeIn 0.5s ease-out;
        }

        .main-content{
            margin: 20px;
        }
    </style>
</head>
<body>
<jsp:include page="../components/sidebar.jsp"/>
<div class="main-content">
    <jsp:include page="../components/header.jsp"/>

    <div class="page-content">
        <div class="page-header">
            <div>
                <h1><i class="fas fa-warehouse me-2"></i>${warehouse.warehouseName}</h1>
                <p class="page-header-subtitle mb-0">Manage your Warehouse and track product availability</p>
            </div>
            <div class="filter-buttons d-flex gap-2 position-relative" style="z-index: 1;">
                <button class="btn" data-bs-toggle="collapse" href="#filterCollapse">
                    <i class="fas fa-filter me-2"></i>Filter & Search
                </button>
            </div>
        </div>

        <div class="collapse" id="filterCollapse">
            <div class="filter-section">
                <h5 class="mb-3"><i class="fas fa-search me-2"></i>Search & Filter Products</h5>
                <form action="${pageContext.request.contextPath}/warehouse_keeper/view_product_warehouse" method="GET">
                    <div class="row g-3 align-items-end">
                        <div class="col-md-5">
                            <label for="productName" class="form-label fw-semibold">
                                <i class="fas fa-box me-1"></i>Product Name
                            </label>
                            <input type="text" id="productName" name="productName" class="form-control"
                                   placeholder="Enter product name..." value="${productName}">
                        </div>
                        <div class="col-md-5">
                            <label for="productType" class="form-label fw-semibold">
                                <i class="fas fa-tags me-1"></i>Product Type
                            </label>
                            <select id="productType" name="productType" class="form-select">
                                <option value="">All Types</option>
                                <c:forEach items="${uniqueProductTypes}" var="type">
                                    <option value="${type.typeName}" ${productType == type.typeName ? 'selected' : ''}>${type.typeName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="fas fa-check me-1"></i>Apply
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <div class="inventory-card">
            <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
                <div>
                    <h4 class="mb-1 fw-bold">Product In Warehouse</h4>
                    <p class="text-muted mb-0">Total: <span class="fw-bold text-primary">${totalProducts}</span> products</p>
                </div>
                <a href="${pageContext.request.contextPath}/warehouse_keeper/create_transfer_request"
                   class="btn btn-create-request">
                    <i class="fas fa-plus me-2"></i>Create Transfer Request
                </a>
            </div>

            <c:if test="${empty products}">
                <div class="alert alert-info text-center">
                    <i class="fas fa-info-circle me-2"></i>
                        ${empty errorMessage ? 'No products found in your warehouse.' : errorMessage}
                </div>
            </c:if>

            <div class="product-grid">
                <c:forEach var="product" items="${products}">
                    <div class="product-card">
                        <div class="product-card-header">
                            <a href="editProductWarehouse?productID=${product.productID}" class="btn-tag">
                                <i class="fas fa-pencil-alt"></i>Edit
                            </a>
                            <a href="${pageContext.request.contextPath}/warehouse_keeper/view_product_detail?productId=${product.productID}"
                               class="btn-tag btn-view">
                                <i class="fas fa-eye"></i>View
                            </a>
                        </div>
                        <div class="product-card-img-container">
                            <c:choose>
                                <c:when test="${not empty product.productImage}">
                                    <img src="${pageContext.request.contextPath}/assets/${product.productImage}"
                                         class="product-card-img"
                                         alt="${product.productName}">
                                </c:when>
                                <c:otherwise>
                                    <div class="product-card-img-placeholder">
                                        <i class="fas fa-box"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="product-card-content">
                            <div>
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <h3 class="product-card-title mb-0">${product.productName}</h3>
                                    <span class="product-type-badge">${product.type.typeName}</span>
                                </div>
                                <p class="text-muted small mb-0">
                                    <c:choose>
                                        <c:when test="${not empty product.productDescription}">
                                            ${product.productDescription}
                                        </c:when>
                                        <c:otherwise>
                                            <em>No description available</em>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                            <div class="mt-auto">
                                <c:if test="${not empty product.productSpecifications}">
                                    <div class="product-card-specifications">
                                        <c:forEach var="spec" items="${product.productSpecifications}">
                                            <div class="spec-item">
                                                <span class="spec-label">${spec.specification.specificationName}</span>
                                                <span class="spec-value">${spec.specification.specificationValue}</span>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:if>
                                <div class="product-card-footer">
                                    <c:set var="stockCount" value="${productCounts[product.productID]}"/>
                                    <c:choose>
                                        <c:when test="${stockCount > 10}">
                                            <span class="stock-badge in-stock">
                                                <i class="fas fa-check-circle"></i>
                                                In Stock: ${stockCount}
                                            </span>
                                        </c:when>
                                        <c:when test="${stockCount > 0}">
                                            <span class="stock-badge low-stock">
                                                <i class="fas fa-exclamation-triangle"></i>
                                                Low Stock: ${stockCount}
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="stock-badge out-of-stock">
                                                <i class="fas fa-times-circle"></i>
                                                Out of Stock
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="d-flex align-items-center justify-content-between mt-4 pt-4 border-top">
                <div class="d-flex align-items-center gap-2">
                    <span class="text-muted">Items per page:</span>
                    <form action="${pageContext.request.contextPath}/warehouse_keeper/view_product_warehouse"
                          method="GET" class="mb-0">
                        <input type="hidden" name="page" value="1"/>
                        <input type="hidden" name="productName" value="${productName}"/>
                        <input type="hidden" name="productType" value="${productType}"/>
                        <input type="hidden" name="warehouse" value="${param.warehouse}"/>
                        <select name="pageSize" onchange="this.form.submit()" class="form-select form-select-sm" style="width: auto;">
                            <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                            <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                            <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                            <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                        </select>
                    </form>
                </div>
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Page navigation">
                        <ul class="pagination mb-0">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link"
                                   href="?page=${currentPage - 1}&pageSize=${pageSize}&productName=${productName}&productType=${productType}">
                                    <i class="fas fa-chevron-left"></i>
                                </a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link"
                                       href="?page=${i}&pageSize=${pageSize}&productName=${productName}&productType=${productType}">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link"
                                   href="?page=${currentPage + 1}&pageSize=${pageSize}&productName=${productName}&productType=${productType}">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
