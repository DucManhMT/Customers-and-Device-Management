<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Warehouse Details</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-light">

<div class="container py-5">
    <!-- Header with breadcrumb -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="mb-0">Warehouse Details</h1>
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/warehouse_keeper/warehousekeeper_actioncenter">Dashboard</a></li>
                <li class="breadcrumb-item active" aria-current="page">Details</li>
            </ol>
        </nav>
    </div>

    <!-- Main warehouse information -->
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-primary text-white">
            <h2 class="h5 mb-0"><i class="fas fa-warehouse me-2"></i> Primary Information</h2>
        </div>
        <div class="card-body">
            <div class="row g-4">
                <div class="col-md-6">
                    <ul class="list-group">
                        <li class="list-group-item d-flex justify-content-between">
                            <span class="fw-bold">Warehouse ID:</span>
                            <span>${warehouse.warehouseID}</span>
                        </li>
                        <li class="list-group-item d-flex justify-content-between">
                            <span class="fw-bold">Name:</span>
                            <span>${warehouse.warehouseName}</span>
                        </li>
                        <li class="list-group-item d-flex justify-content-between">
                            <span class="fw-bold">Manager:</span>
                            <span>${warehouse.managerAccount.username}</span>
                        </li>
                    </ul>
                </div>
                <div class="col-md-6">
                    <ul class="list-group">
                        <li class="list-group-item d-flex justify-content-between">
                            <span class="fw-bold">Location:</span>
                            <span>${warehouse.location}</span>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <!-- Action buttons -->
    <div class="d-flex justify-content-between">
        <a href="${pageContext.request.contextPath}/warehouse_keeper/view_product_warehouse" class="btn btn-secondary">
            <i class="fas fa-arrow-left me-2"></i>Back to List
        </a>
        <div>
            <a href="${pageContext.request.contextPath}/warehouse_keeper/view_inventory"
               class="btn btn-info me-2">
                <i class="fas fa-boxes me-2"></i>View Inventory
            </a>
            <a href="${pageContext.request.contextPath}/warehouse/edit?id=${warehouse.warehouseID}"
               class="btn btn-primary">
                <i class="fas fa-edit me-2"></i>Edit Warehouse
            </a>
        </div>
    </div>
</div>

<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
