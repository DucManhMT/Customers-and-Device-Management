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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .product-img {
            max-height: 300px;
            object-fit: contain;
        }

        .spec-table td, .spec-table th {
            padding: 0.5rem;
        }
    </style>
</head>
<body class="bg-light">
<div class="container py-3">
    <!-- Navigation breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-2">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a
                    href="${pageContext.request.contextPath}/warehouse_keeper/warehousekeeper_actioncenter">Home</a>
            </li>
            <li class="breadcrumb-item"><a
                    href="${pageContext.request.contextPath}/warehouse_keeper/view_product_warehouse">Products</a></li>
            <li class="breadcrumb-item active">${product.productName}</li>
        </ol>
    </nav>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-info alert-dismissible fade show" role="alert">
                ${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <!-- Product Detail Card -->
    <div class="card shadow-sm mb-3">
        <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
            <h1 class="h5 mb-0">Product Details</h1>
            <span class="badge bg-light text-primary">ID: ${product.productID}</span>
        </div>

        <div class="card-body">
            <div class="row">
                <!-- Product Image -->
                <div class="col-md-4 text-center mb-3">
                    <c:choose>
                        <c:when test="${not empty product.productImage}">
                            <img src="${product.productImage}" alt="${product.productName}"
                                 class="img-fluid product-img border rounded">
                        </c:when>
                        <c:otherwise>
                            <div class="border rounded p-5 d-flex align-items-center justify-content-center bg-light"
                                 style="height: 300px">
                                <i class="fas fa-image fa-4x text-secondary"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Product Information -->
                <div class="col-md-8">
                    <h2 class="h4 mb-3">${product.productName}</h2>

                    <div class="mb-3">
                        <h3 class="h6">Description:</h3>
                        <p>${product.productDescription}</p>
                    </div>

                    <!-- Quick Stats -->
                    <div class="row g-2 mb-3">
                        <div class="col-6 col-md-4">
                            <div class="border rounded p-2 text-center">
                                <div class="small text-muted">Product ID</div>
                                <div class="fw-bold">${product.productID}</div>
                            </div>
                        </div>
                        <div class="col-6 col-md-4">
                            <div class="border rounded p-2 text-center">
                                <div class="small text-muted">Type</div>
                                <div class="fw-bold">${product.type.typeName}</div>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/warehouse/editProduct?productId=${product.productID}"
                           class="btn btn-primary">
                            <i class="fas fa-edit me-1"></i> Edit
                        </a>
                        <a href="${pageContext.request.contextPath}/warehouse/productInventory?productId=${product.productID}"
                           class="btn btn-info">
                            <i class="fas fa-boxes me-1"></i> View Inventory
                        </a>
                        <a href="${pageContext.request.contextPath}/warehouse_keeper/view_product_warehouse"
                           class="btn btn-secondary">
                            <i class="fas fa-arrow-left me-1"></i> Back
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Product Specifications -->
    <div class="card shadow-sm mb-3">
        <div class="card-header bg-light">
            <h3 class="h6 mb-0"><i class="fas fa-list-ul me-1"></i> Product Specifications</h3>
        </div>
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${not empty product.productSpecifications}">
                    <table class="table table-striped table-sm mb-0 spec-table">
                        <thead>
                        <tr>
                            <th>Specification</th>
                            <th>Value</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${product.productSpecifications}" var="spec">
                            <tr>
                                <td>${spec.specification.specificationName}</td>
                                <td>${spec.specification.specificationValue}</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="p-3 text-center text-muted">
                        <i class="fas fa-info-circle me-1"></i> No specifications available for this product.
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
