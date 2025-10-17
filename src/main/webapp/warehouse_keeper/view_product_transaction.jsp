<%--
  Created for viewing all product transactions
  User: Master-Long-3112
  Date: 2025-10-17
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Transactions</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        .transaction-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .table-container {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .status-badge {
            padding: 0.35rem 0.65rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }
        .status-completed {
            background-color: #d1e7dd;
            color: #0f5132;
        }
        .status-cancelled {
            background-color: #f8d7da;
            color: #842029;
        }
        .status-processing {
            background-color: #cfe2ff;
            color: #084298;
        }
        .table thead th {
            background-color: #f8f9fa;
            font-weight: 600;
            border-bottom: 2px solid #dee2e6;
        }
        .table tbody tr:hover {
            background-color: #f8f9fa;
        }
    </style>
</head>
<body class="bg-light">

<div class="container-fluid py-4">
    <!-- Header -->
    <div class="row mb-4">
        <div class="col">
            <div class="card transaction-header border-0 shadow-sm">
                <div class="card-body py-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h1 class="h3 mb-1">
                                <i class="fas fa-exchange-alt me-2"></i>Product Transactions
                            </h1>
                            <p class="mb-0 opacity-75">View all product transaction records</p>
                        </div>
                        <div class="d-flex gap-2">
                            <a href="${pageContext.request.contextPath}/warehouse/dashboard" class="btn btn-light btn-sm">
                                <i class="fas fa-home me-1"></i>Dashboard
                            </a>
                            <button type="button" class="btn btn-outline-light btn-sm" onclick="window.print()">
                                <i class="fas fa-print me-1"></i>Print
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Statistics Cards -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body text-center">
                    <i class="fas fa-list-alt text-primary fs-2 mb-2"></i>
                    <h4 class="mb-0">${not empty transactions ? transactions.size() : 0}</h4>
                    <small class="text-muted">Total Transactions</small>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body text-center">
                    <i class="fas fa-check-circle text-success fs-2 mb-2"></i>
                    <h4 class="mb-0" id="completedCount">0</h4>
                    <small class="text-muted">Completed</small>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body text-center">
                    <i class="fas fa-clock text-warning fs-2 mb-2"></i>
                    <h4 class="mb-0" id="pendingCount">0</h4>
                    <small class="text-muted">Pending</small>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body text-center">
                    <i class="fas fa-sync text-info fs-2 mb-2"></i>
                    <h4 class="mb-0" id="processingCount">0</h4>
                    <small class="text-muted">Processing</small>
                </div>
            </div>
        </div>
    </div>

    <!-- Success/Error Messages -->
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i>${successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Transactions Table -->
    <div class="table-container">
        <div class="card border-0">
            <div class="card-header bg-white py-3">
                <div class="row align-items-center">
                    <div class="col">
                        <h5 class="mb-0">
                            <i class="fas fa-table me-2"></i>Transaction Records
                        </h5>
                    </div>
                    <div class="col-auto">
                        <input type="text" class="form-control form-control-sm" id="searchInput"
                               placeholder="Search transactions..." onkeyup="filterTable()">
                    </div>
                </div>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0" id="transactionTable">
                        <thead>
                        <tr>
                            <th scope="col" class="text-center" style="width: 10%;">Transaction ID</th>
                            <th scope="col" style="width: 15%;">Transaction Date</th>
                            <th scope="col" style="width: 15%;">Source Warehouse</th>
                            <th scope="col" style="width: 15%;">Destination Warehouse</th>
                            <th scope="col" class="text-center" style="width: 10%;">Item ID</th>
                            <th scope="col" class="text-center" style="width: 12%;">Status</th>
                            <th scope="col" style="width: 18%;">Note</th>
                            <th scope="col" class="text-center" style="width: 5%;">Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty transactions}">
                                <c:forEach var="transaction" items="${transactions}">
                                    <tr>
                                        <td class="text-center">
                                            <strong>#${transaction.transactionID}</strong>
                                        </td>
                                        <td>
                                            <i class="far fa-calendar-alt me-1"></i>
                                            <fmt:formatDate value="${transaction.transactionDate}"
                                                            pattern="dd/MM/yyyy HH:mm" />
                                        </td>
                                        <td>
                                            <i class="fas fa-warehouse me-1 text-primary"></i>
                                            <c:choose>
                                                <c:when test="${not empty transaction.sourceWarehouseEntity}">
                                                    ${transaction.sourceWarehouseEntity.warehouseName}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">N/A</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <i class="fas fa-warehouse me-1 text-success"></i>
                                            <c:choose>
                                                <c:when test="${not empty transaction.destinationWarehouseEntity}">
                                                    ${transaction.destinationWarehouseEntity.warehouseName}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">N/A</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${not empty transaction.inventoryItem}">
                                                    <code>#${transaction.inventoryItem.itemId}</code>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">N/A</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${transaction.transactionStatus == 'COMPLETED'}">
                                                        <span class="status-badge status-completed">
                                                            <i class="fas fa-check me-1"></i>Completed
                                                        </span>
                                                </c:when>
                                                <c:when test="${transaction.transactionStatus == 'PENDING'}">
                                                        <span class="status-badge status-pending">
                                                            <i class="fas fa-hourglass-half me-1"></i>Pending
                                                        </span>
                                                </c:when>
                                                <c:when test="${transaction.transactionStatus == 'CANCELLED'}">
                                                        <span class="status-badge status-cancelled">
                                                            <i class="fas fa-times me-1"></i>Cancelled
                                                        </span>
                                                </c:when>
                                                <c:when test="${transaction.transactionStatus == 'PROCESSING'}">
                                                        <span class="status-badge status-processing">
                                                            <i class="fas fa-spinner me-1"></i>Processing
                                                        </span>
                                                </c:when>
                                                <c:otherwise>
                                                        <span class="status-badge" style="background-color: #e9ecef; color: #495057;">
                                                                ${transaction.transactionStatus}
                                                        </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty transaction.note}">
                                                    <small>${transaction.note}</small>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <div class="dropdown">
                                                <button class="btn btn-sm btn-outline-secondary dropdown-toggle"
                                                        type="button" data-bs-toggle="dropdown">
                                                    <i class="fas fa-ellipsis-v"></i>
                                                </button>
                                                <ul class="dropdown-menu">
                                                    <li>
                                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/transaction/view?id=${transaction.transactionID}">
                                                            <i class="fas fa-eye me-2"></i>View Details
                                                        </a>
                                                    </li>
                                                    <li>
                                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/transaction/edit?id=${transaction.transactionID}">
                                                            <i class="fas fa-edit me-2"></i>Edit
                                                        </a>
                                                    </li>
                                                </ul>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="8" class="text-center py-5">
                                        <div class="text-muted">
                                            <i class="fas fa-inbox fs-1 mb-3 d-block"></i>
                                            <h5>No Transactions Found</h5>
                                            <p>There are no product transactions to display at this time.</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Filter table function
    function filterTable() {
        const input = document.getElementById('searchInput');
        const filter = input.value.toUpperCase();
        const table = document.getElementById('transactionTable');
        const rows = table.getElementsByTagName('tr');

        for (let i = 1; i < rows.length; i++) {
            const row = rows[i];
            const cells = row.getElementsByTagName('td');
            let found = false;

            for (let j = 0; j < cells.length; j++) {
                const cell = cells[j];
                if (cell) {
                    const textValue = cell.textContent || cell.innerText;
                    if (textValue.toUpperCase().indexOf(filter) > -1) {
                        found = true;
                        break;
                    }
                }
            }

            row.style.display = found ? '' : 'none';
        }
    }

    // Calculate status counts
    document.addEventListener('DOMContentLoaded', function() {
        const rows = document.querySelectorAll('#transactionTable tbody tr');
        let completed = 0, pending = 0, processing = 0;

        rows.forEach(row => {
            const statusCell = row.querySelector('td:nth-child(6)');
            if (statusCell) {
                const statusText = statusCell.textContent.toUpperCase();
                if (statusText.includes('COMPLETED')) completed++;
                if (statusText.includes('PENDING')) pending++;
                if (statusText.includes('PROCESSING')) processing++;
            }
        });

        document.getElementById('completedCount').textContent = completed;
        document.getElementById('pendingCount').textContent = pending;
        document.getElementById('processingCount').textContent = processing;
    });
</script>

</body>
</html>