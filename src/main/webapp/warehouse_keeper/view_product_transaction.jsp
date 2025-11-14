<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Transactions - Warehouse Management</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css">

    <style>
        :root {
            --primary-color: #4a90e2;
            --success-color: #28a745;
            --danger-color: #dc3545;
            --warning-color: #ffc107;
            --info-color: #17a2b8;
        }

        body {
            background: #ffffff;
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .main-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            padding: 30px;
            margin: 20px auto;
        }

        .page-header {
            border-bottom: 3px solid var(--primary-color);
            padding-bottom: 20px;
            margin-bottom: 30px;
        }

        .page-header h1 {
            color: #2c3e50;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 15px;
        }

        .page-header h1 i {
            color: var(--primary-color);
            font-size: 2.5rem;
        }

        .filter-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            color: white;
        }

        .filter-card h5 {
            font-weight: 600;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .filter-card .form-control,
        .filter-card .form-select {
            border-radius: 10px;
            border: none;
            padding: 10px 15px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .filter-card label {
            font-weight: 500;
            margin-bottom: 8px;
        }

        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            padding: 20px;
            color: white;
            text-align: center;
            margin-bottom: 20px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }

        .stats-card:hover {
            transform: translateY(-5px);
        }

        .stats-card h3 {
            font-size: 2.5rem;
            font-weight: 700;
            margin: 10px 0;
        }

        .stats-card p {
            margin: 0;
            font-size: 1.1rem;
            opacity: 0.9;
        }

        .table-container {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
        }

        .table {
            margin-bottom: 0;
        }

        .table thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .table thead th {
            border: none;
            padding: 18px 15px;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
            white-space: nowrap;
        }

        .table tbody tr {
            transition: all 0.3s ease;
        }

        .table tbody tr:hover {
            background-color: #f8f9ff;
            transform: scale(1.01);
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
        }

        .table tbody td {
            padding: 15px;
            vertical-align: middle;
            border-bottom: 1px solid #e9ecef;
        }

        .badge {
            padding: 8px 15px;
            font-size: 0.85rem;
            font-weight: 600;
            border-radius: 20px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .badge-import {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
        }

        .badge-export {
            background: linear-gradient(135deg, #ee0979 0%, #ff6a00 100%);
            color: white;
        }

        .product-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .product-image {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 10px;
            border: 2px solid #e9ecef;
        }

        .product-name {
            font-weight: 600;
            color: #2c3e50;
        }

        .serial-number {
            font-family: 'Courier New', monospace;
            background: #f8f9fa;
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 0.85rem;
            color: #495057;
        }

        .warehouse-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 5px 12px;
            background: #e9ecef;
            border-radius: 8px;
            font-size: 0.9rem;
            color: #495057;
        }

        .btn-filter {
            background: white;
            color: #667eea;
            border: 2px solid white;
            border-radius: 10px;
            padding: 10px 30px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-filter:hover {
            background: transparent;
            color: white;
            border-color: white;
        }

        .btn-reset {
            background: transparent;
            color: white;
            border: 2px solid white;
            border-radius: 10px;
            padding: 10px 30px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-reset:hover {
            background: white;
            color: #667eea;
        }

        .no-data {
            text-align: center;
            padding: 50px;
            color: #6c757d;
        }

        .no-data i {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        .transaction-id {
            font-weight: 700;
            color: var(--primary-color);
            font-size: 1.1rem;
        }

        .note-cell {
            max-width: 200px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .note-cell:hover {
            white-space: normal;
            overflow: visible;
        }

        @media (max-width: 768px) {
            .main-container {
                padding: 15px;
            }

            .table {
                font-size: 0.85rem;
            }

            .stats-card h3 {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>

<div class="container-fluid">
    <div class="main-container">
        <!-- Page Header -->
        <div class="page-header">
            <h1>
                <i class="bi bi-arrow-left-right"></i>
                Product Transactions
            </h1>
            <p class="text-muted mb-0">Track and manage all warehouse product transactions</p>
        </div>

        <!-- Statistics Cards -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="stats-card">
                    <i class="bi bi-card-list" style="font-size: 2rem;"></i>
                    <h3>${fn:length(productTransactions)}</h3>
                    <p>Total Transactions</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card" style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);">
                    <i class="bi bi-box-arrow-in-down" style="font-size: 2rem;"></i>
                    <h3>
                        <c:set var="importCount" value="0"/>
                        <c:forEach items="${productTransactions}" var="transaction">
                            <c:if test="${transaction.transactionStatus == 'Import'}">
                                <c:set var="importCount" value="${importCount + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${importCount}
                    </h3>
                    <p>Import Transactions</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card" style="background: linear-gradient(135deg, #ee0979 0%, #ff6a00 100%);">
                    <i class="bi bi-box-arrow-up" style="font-size: 2rem;"></i>
                    <h3>
                        <c:set var="exportCount" value="0"/>
                        <c:forEach items="${productTransactions}" var="transaction">
                            <c:if test="${transaction.transactionStatus == 'Export'}">
                                <c:set var="exportCount" value="${exportCount + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${exportCount}
                    </h3>
                    <p>Export Transactions</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card" style="background: linear-gradient(135deg, #28a745 0%, #20c997 100%);">
                    <i class="bi bi-check-circle" style="font-size: 2rem;"></i>
                    <h3>
                        <c:set var="successCount" value="0"/>
                        <c:forEach items="${productTransactions}" var="exportTrans">
                            <c:if test="${exportTrans.transactionStatus == 'Export'}">
                                <c:set var="hasMatch" value="false"/>
                                <c:forEach items="${productTransactions}" var="importTrans">
                                    <c:if test="${importTrans.transactionStatus == 'Import'
                                        && exportTrans.warehouseRequest != null
                                        && importTrans.warehouseRequest != null
                                        && exportTrans.warehouseRequest.warehouseRequestID == importTrans.warehouseRequest.warehouseRequestID
                                        && exportTrans.inventoryItem.itemId == importTrans.inventoryItem.itemId
                                        && exportTrans.sourceWarehouse.warehouseID == importTrans.destinationWarehouse.warehouseID
                                        && exportTrans.destinationWarehouse.warehouseID == importTrans.sourceWarehouse.warehouseID}">
                                        <c:set var="hasMatch" value="true"/>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${hasMatch}">
                                    <c:set var="successCount" value="${successCount + 1}"/>
                                </c:if>
                            </c:if>
                        </c:forEach>
                        ${successCount}
                    </h3>
                    <p>Completed Exports</p>
                </div>
            </div>
        </div>

        <!-- Filter Section -->
        <div class="filter-card">
            <h5><i class="bi bi-funnel-fill"></i> Filter Transactions</h5>
            <form id="filterForm" method="get">
                <div class="row">
                    <div class="col-md-3 mb-3">
                        <label for="filterType">Transaction Type</label>
                        <select class="form-select" id="filterType" name="type">
                            <option value="">All Types</option>
                            <option value="Import">Import</option>
                            <option value="Export">Export</option>
                        </select>
                    </div>
                    <div class="col-md-3 mb-3">
                        <label for="filterProduct">Product Name</label>
                        <input type="text" class="form-control" id="filterProduct" name="product"
                               placeholder="Search product...">
                    </div>
                    <div class="col-md-3 mb-3">
                        <label for="filterWarehouse">Warehouse</label>
                        <input type="text" class="form-control" id="filterWarehouse" name="warehouse"
                               placeholder="Search warehouse...">
                    </div>
                    <div class="col-md-3 mb-3">
                        <label for="filterDate">Transaction Date</label>
                        <input type="date" class="form-control" id="filterDate" name="date">
                    </div>
                </div>
                <div class="text-end">
                    <button type="button" class="btn btn-reset" onclick="resetFilters()">
                        <i class="bi bi-arrow-counterclockwise"></i> Reset
                    </button>
                    <button type="button" class="btn btn-filter" onclick="applyFilters()">
                        <i class="bi bi-search"></i> Apply Filters
                    </button>
                </div>
            </form>
        </div>

        <!-- Transactions Table -->
        <div class="table-container">
            <c:choose>
                <c:when test="${empty productTransactions}">
                    <div class="no-data">
                        <i class="bi bi-inbox"></i>
                        <h4>No Transactions Found</h4>
                        <p>There are no product transactions to display at this time.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="table table-hover" id="transactionsTable">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Product</th>
                            <th>Serial Number</th>
                            <th>Type</th>
                            <th>Source</th>
                            <th>Destination</th>
                            <th>Date</th>
                            <th>Request ID</th>
                            <th>Note</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${productTransactions}" var="transaction">
                            <tr>
                                <td class="transaction-id">#${transaction.transactionID}</td>
                                <td>
                                    <div class="product-info">
                                        <c:if test="${not empty transaction.inventoryItem.product.productImage}">
                                            <img src="${pageContext.request.contextPath}${transaction.inventoryItem.product.productImage}"
                                                 alt="${transaction.inventoryItem.product.productName}"
                                                 class="product-image">
                                        </c:if>
                                        <div>
                                            <div class="product-name">${transaction.inventoryItem.product.productName}</div>
                                            <small class="text-muted">ID: ${transaction.inventoryItem.product.productID}</small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <span class="serial-number">${transaction.inventoryItem.serialNumber}</span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${transaction.transactionStatus == 'Import'}">
                                            <span class="badge badge-import">
                                                <i class="bi bi-box-arrow-in-down"></i> Import
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-export">
                                                <i class="bi bi-box-arrow-up"></i> Export
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty transaction.sourceWarehouse}">
                                            <span class="warehouse-badge">
                                                <i class="bi bi-building"></i>
                                                ${transaction.sourceWarehouse.warehouseName}
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty transaction.destinationWarehouse}">
                                            <span class="warehouse-badge">
                                                <i class="bi bi-building"></i>
                                                ${transaction.destinationWarehouse.warehouseName}
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <i class="bi bi-calendar3"></i>
                                        ${transaction.transactionDate}
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty transaction.warehouseRequest}">
                                            <span class="badge bg-info">
                                                #${transaction.warehouseRequest.warehouseRequestID}
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">N/A</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty transaction.note}">
                                            <div class="note-cell" title="${transaction.note}">
                                                    ${transaction.note}
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<!-- DataTables JS -->
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>

<script>
    $(document).ready(function() {
        // Initialize DataTable with advanced features
        $('#transactionsTable').DataTable({
            "pageLength": 10,
            "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
            "order": [[0, "desc"]],
            "language": {
                "search": "Search:",
                "lengthMenu": "Show _MENU_ entries",
                "info": "Showing _START_ to _END_ of _TOTAL_ transactions",
                "infoEmpty": "Showing 0 to 0 of 0 transactions",
                "infoFiltered": "(filtered from _MAX_ total transactions)",
                "paginate": {
                    "first": "First",
                    "last": "Last",
                    "next": "Next",
                    "previous": "Previous"
                }
            },
            "responsive": true,
            "dom": '<"row"<"col-sm-12 col-md-6"l><"col-sm-12 col-md-6"f>>rtip'
        });
    });

    function applyFilters() {
        const type = document.getElementById('filterType').value.toLowerCase();
        const product = document.getElementById('filterProduct').value.toLowerCase();
        const warehouse = document.getElementById('filterWarehouse').value.toLowerCase();
        const date = document.getElementById('filterDate').value;

        const table = $('#transactionsTable').DataTable();

        $.fn.dataTable.ext.search.push(
            function(settings, data, dataIndex) {
                const rowType = data[3].toLowerCase();
                const rowProduct = data[1].toLowerCase();
                const rowSource = data[4].toLowerCase();
                const rowDestination = data[5].toLowerCase();
                const rowDate = data[6];

                let typeMatch = !type || rowType.includes(type);
                let productMatch = !product || rowProduct.includes(product);
                let warehouseMatch = !warehouse || rowSource.includes(warehouse) || rowDestination.includes(warehouse);
                let dateMatch = !date || rowDate.includes(date);

                return typeMatch && productMatch && warehouseMatch && dateMatch;
            }
        );

        table.draw();
        $.fn.dataTable.ext.search.pop();
    }

    function resetFilters() {
        document.getElementById('filterForm').reset();
        $('#transactionsTable').DataTable().search('').draw();
    }

    // Auto-apply filters on Enter key
    document.querySelectorAll('#filterForm input').forEach(input => {
        input.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                applyFilters();
            }
        });
    });
</script>
</body>
</html>