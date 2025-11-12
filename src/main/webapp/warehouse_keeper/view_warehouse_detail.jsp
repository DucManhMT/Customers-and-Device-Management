<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Warehouse Details - Warehouse Management</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-color: #4f46e5;
            --primary-hover: #4338ca;
            --success-color: #10b981;
            --info-color: #3b82f6;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --gradient-start: #667eea;
            --gradient-end: #764ba2;
        }

        * {
            font-family: 'Inter', sans-serif;
        }

        body {
            background: #f8f9fa;
        }

        .main-content {
            padding: 2rem;
            margin-top: 70px;
        }

        /* Page Header */
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
            position: relative;
            z-index: 1;
        }

        .breadcrumb {
            background: rgba(255, 255, 255, 0.2);
            padding: 8px 16px;
            border-radius: 10px;
            margin: 0;
            position: relative;
            z-index: 1;
        }

        .breadcrumb-item a {
            color: white;
            text-decoration: none;
            font-weight: 500;
        }

        .breadcrumb-item.active {
            color: rgba(255, 255, 255, 0.8);
        }

        .breadcrumb-item + .breadcrumb-item::before {
            color: rgba(255, 255, 255, 0.6);
        }

        /* Alert */
        .alert-custom {
            border: none;
            border-radius: 12px;
            padding: 16px 20px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 500;
            animation: slideDown 0.3s ease;
        }

        .alert-custom i {
            font-size: 1.5rem;
        }

        .alert-danger-custom {
            background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
            color: #991b1b;
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

        /* Info Cards Grid */
        .info-cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 24px;
            margin-bottom: 32px;
        }

        .info-card {
            background: white;
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
            border: 1px solid #e5e7eb;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .info-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            transition: width 0.3s ease;
        }

        .info-card.primary::before {
            background: linear-gradient(135deg, var(--gradient-start), var(--gradient-end));
        }

        .info-card.success::before {
            background: linear-gradient(135deg, var(--success-color), #059669);
        }

        .info-card.info::before {
            background: linear-gradient(135deg, var(--info-color), #2563eb);
        }

        .info-card.warning::before {
            background: linear-gradient(135deg, var(--warning-color), #d97706);
        }

        .info-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1);
        }

        .info-card:hover::before {
            width: 8px;
        }

        .info-card-icon {
            width: 56px;
            height: 56px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 16px;
        }

        .info-card.primary .info-card-icon {
            background: linear-gradient(135deg, #e0e7ff, #ddd6fe);
            color: var(--primary-color);
        }

        .info-card.success .info-card-icon {
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            color: var(--success-color);
        }

        .info-card.info .info-card-icon {
            background: linear-gradient(135deg, #dbeafe, #bfdbfe);
            color: var(--info-color);
        }

        .info-card.warning .info-card-icon {
            background: linear-gradient(135deg, #fef3c7, #fde68a);
            color: var(--warning-color);
        }

        .info-card-label {
            font-size: 0.875rem;
            color: #6b7280;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
        }

        .info-card-value {
            font-size: 1.25rem;
            font-weight: 700;
            color: #111827;
            line-height: 1.4;
        }

        /* Details Section */
        .details-section {
            background: white;
            border-radius: 16px;
            padding: 32px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
            border: 1px solid #e5e7eb;
            margin-bottom: 32px;
        }

        .section-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 24px;
            padding-bottom: 16px;
            border-bottom: 2px solid #f3f4f6;
        }

        .section-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            background: linear-gradient(135deg, var(--gradient-start), var(--gradient-end));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.25rem;
        }

        .section-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #111827;
            margin: 0;
        }

        .detail-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }

        .detail-item {
            background: #f9fafb;
            padding: 16px;
            border-radius: 12px;
            border-left: 4px solid var(--primary-color);
            transition: all 0.2s ease;
        }

        .detail-item:hover {
            background: #f3f4f6;
            transform: translateX(4px);
        }

        .detail-label {
            font-size: 0.875rem;
            color: #6b7280;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .detail-label i {
            font-size: 0.75rem;
            color: var(--primary-color);
        }

        .detail-value {
            font-size: 1.05rem;
            font-weight: 600;
            color: #111827;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
        }

        .btn-action {
            border-radius: 10px;
            padding: 12px 24px;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .btn-back {
            background: #6b7280;
            color: white;
        }

        .btn-back:hover {
            background: #4b5563;
            color: white;
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, var(--gradient-start), var(--gradient-end));
            color: white;
        }

        .btn-primary-custom:hover {
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }

        .btn-info-custom {
            background: var(--info-color);
            color: white;
        }

        .btn-info-custom:hover {
            background: #2563eb;
            color: white;
        }

        .action-group {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 1rem;
            }

            .info-cards-grid {
                grid-template-columns: 1fr;
            }

            .detail-grid {
                grid-template-columns: 1fr;
            }

            .action-buttons {
                flex-direction: column;
            }

            .action-group {
                width: 100%;
                flex-direction: column;
            }

            .btn-action {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>

<div class="main-content">
    <!-- Page Header -->
    <div class="page-header">
        <div class="d-flex justify-content-between align-items-start">
            <div>
                <h1><i class="fas fa-warehouse me-2"></i>Warehouse Details</h1>
                <p class="page-header-subtitle mb-0">Complete information about the warehouse</p>
            </div>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/warehouse_keeper/warehousekeeper_actioncenter">
                            <i class="fas fa-home me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="breadcrumb-item active">Details</li>
                </ol>
            </nav>
        </div>
    </div>

    <!-- Error Message -->
    <c:if test="${not empty errorMessage}">
        <div class="alert-custom alert-danger-custom">
            <i class="fas fa-exclamation-circle"></i>
            <span>${errorMessage}</span>
        </div>
    </c:if>

    <!-- Info Cards Grid -->
    <div class="info-cards-grid">
        <div class="info-card primary">
            <div class="info-card-icon">
                <i class="fas fa-hashtag"></i>
            </div>
            <div class="info-card-label">Warehouse ID</div>
            <div class="info-card-value">#${warehouse.warehouseID}</div>
        </div>

        <div class="info-card success">
            <div class="info-card-icon">
                <i class="fas fa-warehouse"></i>
            </div>
            <div class="info-card-label">Warehouse Name</div>
            <div class="info-card-value">${warehouse.warehouseName}</div>
        </div>

        <div class="info-card info">
            <div class="info-card-icon">
                <i class="fas fa-user-tie"></i>
            </div>
            <div class="info-card-label">Manager</div>
            <div class="info-card-value">${warehouse.managerAccount.username}</div>
        </div>

        <div class="info-card warning">
            <div class="info-card-icon">
                <i class="fas fa-map-marker-alt"></i>
            </div>
            <div class="info-card-label">Location</div>
            <div class="info-card-value">${warehouse.location}</div>
        </div>
    </div>
    <!-- Action Buttons -->
    <div class="action-buttons">
        <a href="${pageContext.request.contextPath}/warehouse_keeper/view_product_warehouse"
           class="btn-action btn-back">
            <i class="fas fa-arrow-left"></i>
            Back to List
        </a>

        <div class="action-group">
            <a href="${pageContext.request.contextPath}/warehouse_keeper/view_inventory"
               class="btn-action btn-info-custom">
                <i class="fas fa-boxes"></i>
                View Inventory
            </a>
            <a href="${pageContext.request.contextPath}/warehouse/edit?id=${warehouse.warehouseID}"
               class="btn-action btn-primary-custom">
                <i class="fas fa-edit"></i>
                Edit Warehouse
            </a>
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
