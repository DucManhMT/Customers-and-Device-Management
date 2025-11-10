<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 10/10/2025
  Time: 2:53 AM
  To change this template use File | Settings | File Templates.
--%>
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
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&display=swap" rel="stylesheet">

    <!-- Link to your Global Stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">

    <style>
        /* Styles specific to the Inventory page */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .page-header h1 {
            font-weight: 700;
            color: var(--sidebar-bg);
            margin: 20px;
        }

        .filter-buttons .btn {
            border-radius: 20px;
            font-weight: 500;
            background-color: var(--main-bg);
            color: var(--sidebar-bg);
            margin-right: 20px;

        }

        .inventory-card {
            background-color: var(--card-bg);
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            border: none;
            margin: 20px;
        }

        /* --- STYLES FOR PRODUCT GRID --- */
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }

        .product-card {
            background-color: #fff;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            display: flex;
            flex-direction: column;
            transition: box-shadow 0.2s ease-in-out, transform 0.2s ease-in-out;
            overflow: hidden; /* Ensures content respects the border-radius */
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
        }

        .product-card-header {
            padding: 12px 16px;
            display: flex;
            justify-content: space-between;
        }

        .product-card-header .btn-tag {
            background-color: #fff;
            border: 1px solid var(--border-color);
            border-radius: 20px;
            padding: 4px 12px;
            font-size: 1rem;
            font-weight: 500;
            color: var(--text-dark);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: background-color 0.2s;
        }

        .product-card-header .btn-tag:hover {
            background-color: #e9ecef;
        }

        .product-card-img-container {
            width: 100%;
            height: 100%;
            padding: 10px;
            overflow: hidden;
        }

        .product-card-img {
            height: 100%;
            width: 100%;
            object-fit: cover; /* This is key: it scales the image to fill the container without stretching */
            border: 2px solid var(--border-color); /* Border directly on the image */
            border-radius: 12px; /* Rounded corners on the image */
            background-color: #fff;
        }

        .product-card-img-placeholder {
            height: 100%;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-muted-light);
            border: 1px solid var(--border-color); /* Matching border for placeholder */
            border-radius: 12px; /* Matching corners for placeholder */
            background-color: #fff; /* Matching background for placeholder */
        }

        .product-card-img-placeholder i {
            font-size: 2.5rem;
        }

        .product-card-content {
            padding: 16px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }

        .product-card-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--sidebar-bg);
        }

        .product-card-specifications {
            font-size: 0.85rem;
            margin-top: 12px;
            padding-top: 12px;
            border-top: 1px solid #f0f2f5;
        }

        .product-card-footer {
            margin-top: 16px;
            padding-top: 16px;
            border-top: 1px solid #f0f2f5;
        }

        .grid-top span{
            font-weight: 600;
            font-size: 20px;
            color: var(--sidebar-bg);
        }

        .grid-top .btn{
            border-radius: 20px;
            font-weight: 400;
            background-color: #fafafa;
            color: var(--sidebar-bg);
        }
    </style>
</head>
<body>
<jsp:include page="../components/sidebar.jsp"/>

<div class="main-content">
    <jsp:include page="../components/header.jsp"/>

    <div class="page-content">
        <div class="page-header">
            <h1>Inventory (${totalProducts})</h1>
            <div class="filter-buttons d-flex gap-2">
                <button class="btn btn-light border" data-bs-toggle="collapse" href="#filterCollapse"><i
                        class="fas fa-filter me-1"></i> Filter
                </button>
            </div>
        </div>

        <div class="collapse" id="filterCollapse">
            <div class="inventory-card mb-3">
                <form action="${pageContext.request.contextPath}/warehouse_keeper/view_inventory" method="GET">
                    <div class="row g-3 align-items-end">
                        <div class="col-md">
                            <label for="productName" class="form-label">Product Name</label>
                            <input type="text" id="productName" name="productName" class="form-control"
                                   value="${productName}">
                        </div>
                        <div class="col-md">
                            <label for="productType" class="form-label">Product Type</label>
                            <select id="productType" name="productType" class="form-select">
                                <option value="">All</option>
                                <c:forEach items="${uniqueProductTypes}" var="type">
                                    <option value="${type.typeName}" ${productType == type.typeName ? 'selected' : ''}>${type.typeName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md">
                            <label for="warehouse" class="form-label">Warehouse</label>
                            <select id="warehouse" name="warehouse" class="form-select">
                                <option value="">All</option>
                                <c:forEach items="${warehouses}" var="w">
                                    <option value="${w.warehouseName}" ${param.warehouse == w.warehouseName ? 'selected' : ''}>${w.warehouseName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-auto">
                            <button type="submit" class="btn btn-primary">Apply</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <div class="inventory-card">

            <c:if test="${empty inventorySummary}">
                <div class="alert alert-info w-100 text-center">
                        ${empty errorMessage ? 'No products found in inventory.' : errorMessage}
                </div>
            </c:if>

            <div class="d-flex justify-content-between align-items-center mb-4">
                <div class="grid-top d-flex justify-content-between align-items-center w-100">
                    <span>Total Product (${totalProducts})</span>
                    <a href="${pageContext.request.contextPath}/warehouse_keeper/add_product"
                       class="btn btn-light border"><i
                            class="fas fa-plus me-1"></i> Add Product</a>
                </div>
            </div>
            <!-- NEW PRODUCT GRID LAYOUT -->
            <div class="product-grid">


                <c:forEach var="item" items="${inventorySummary}">
                    <div class="product-card">
                        <div class="product-card-header">
                            <a href="editProductWarehouse?productID=${item.product.productID}" class="btn-tag"><i
                                    class="fas fa-pencil-alt"></i> Edit</a>
                            <a href="${pageContext.request.contextPath}/warehouse_keeper/view_product_detail?productId=${item.product.productID}"
                               class="btn-tag"><i class="fas fa-eye"></i> View</a>
                        </div>
                        <div class="product-card-img-container">
                            <c:choose>
                                <c:when test="${not empty item.product.productImage}">
                                    <img src="${pageContext.request.contextPath}/assets/${item.product.productImage}"
                                         class="product-card-img"
                                         alt="${item.product.productName}">
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
                                    <h3 class="product-card-title mb-0">${item.product.productName}</h3>
                                    <span class="badge bg-secondary-subtle text-secondary-emphasis rounded-pill">${item.product.type.typeName}</span>
                                </div>
                                <p class="text-muted small mb-3">${item.product.productDescription}</p>
                                <c:if test="${empty item.product.productDescription}">
                                    <p class="text-muted small mb-3">No description</p>
                                </c:if>
                            </div>
                            <div class="mt-auto">
                                <div class="product-card-specifications">
                                    <c:forEach var="spec" items="${item.product.productSpecifications}"
                                               varStatus="loop">
                                        <div class="text-nowrap small ${!loop.last ? 'mb-1' : ''}">
                                            <span class="fw-medium">${spec.specification.specificationName}:</span>
                                            <span class="text-muted">${spec.specification.specificationValue}</span>
                                        </div>
                                    </c:forEach>
                                </div>
                                <div class="product-card-footer d-flex justify-content-between align-items-center">
                                    <div>
                                        <div class="small text-muted">Stock: <span
                                                class="fw-bold text-dark">${item.count}</span></div>
                                        <div class="small text-muted">Warehouse: <span
                                                class="fw-bold text-dark">${item.warehouse.warehouseName}</span></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="d-flex align-items-center justify-content-between">
                <div>
                    <span class="text-muted small">Display:</span>
                    <form action="${pageContext.request.contextPath}/warehouse_keeper/view_inventory" method="GET"
                          class="mb-0">
                        <input type="hidden" name="page" value="1"/>
                        <input type="hidden" name="productName" value="${productName}"/>
                        <input type="hidden" name="productType" value="${productType}"/>
                        <input type="hidden" name="warehouse" value="${param.warehouse}"/>
                        <select name="pageSize" onchange="this.form.submit()" class="form-select form-select-sm">
                            <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                            <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                            <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                            <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                        </select>
                    </form>
                </div>
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Page navigation" class="mt-4 d-flex justify-content-end">
                        <ul class="pagination">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link"
                                   href="?page=${currentPage - 1}&pageSize=${pageSize}&productName=${productName}&productType=${productType}&warehouse=${param.warehouse}">Previous</a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link"
                                       href="?page=${i}&pageSize=${pageSize}&productName=${productName}&productType=${productType}&warehouse=${param.warehouse}">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link"
                                   href="?page=${currentPage + 1}&pageSize=${pageSize}&productName=${productName}&productType=${productType}&warehouse=${param.warehouse}">Next</a>
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