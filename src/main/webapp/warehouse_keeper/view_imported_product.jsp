<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Import History</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">

    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .main-container {
            background-color: #ffffff;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0,0,0,0.08);
            padding: 30px;
            margin-top: 30px;
            margin-bottom: 30px;
        }

        .page-header {
            border-bottom: 3px solid #0d6efd;
            padding-bottom: 15px;
            margin-bottom: 30px;
        }

        .page-header h2 {
            color: #0d6efd;
            font-weight: 600;
            margin: 0;
        }

        .page-header .subtitle {
            color: #6c757d;
            font-size: 14px;
            margin-top: 5px;
        }

        .filter-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 25px;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }

        .filter-card .form-label {
            color: #ffffff;
            font-weight: 500;
            font-size: 13px;
            margin-bottom: 5px;
        }

        .filter-card .form-control,
        .filter-card .form-select {
            border: none;
            border-radius: 8px;
            padding: 10px 15px;
            font-size: 14px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .filter-card .btn {
            padding: 10px 25px;
            font-weight: 500;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .filter-card .btn-light {
            background-color: #ffffff;
            border: none;
            color: #667eea;
        }

        .filter-card .btn-light:hover {
            background-color: #f8f9fa;
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        }

        .filter-card .btn-outline-light {
            border: 2px solid #ffffff;
            color: #ffffff;
        }

        .filter-card .btn-outline-light:hover {
            background-color: #ffffff;
            color: #667eea;
        }

        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 10px;
            padding: 20px;
            color: white;
            margin-bottom: 20px;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }

        .stats-card h3 {
            font-size: 32px;
            font-weight: 700;
            margin: 0;
        }

        .stats-card p {
            margin: 5px 0 0 0;
            opacity: 0.9;
            font-size: 14px;
        }

        .table-container {
            background-color: #ffffff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .table {
            margin: 0;
        }

        .table thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .table thead th {
            border: none;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 12px;
            letter-spacing: 0.5px;
            padding: 15px 12px;
            white-space: nowrap;
        }

        .table tbody tr {
            transition: all 0.3s ease;
            border-bottom: 1px solid #f0f0f0;
        }

        .table tbody tr:hover {
            background-color: #f8f9ff;
            transform: scale(1.01);
            box-shadow: 0 2px 8px rgba(102, 126, 234, 0.15);
        }

        .table tbody td {
            padding: 15px 12px;
            vertical-align: middle;
            font-size: 14px;
            color: #495057;
        }

        .badge-custom {
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 500;
            font-size: 12px;
        }

        .badge-warehouse {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
        }

        .badge-item {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
        }

        .badge-location {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            color: white;
        }

        .date-badge {
            background-color: #e7f3ff;
            color: #0d6efd;
            padding: 5px 12px;
            border-radius: 6px;
            font-weight: 500;
            font-size: 13px;
        }

        .serial-code {
            font-family: 'Courier New', monospace;
            color: #667eea;
            background-color: #f0f0ff;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
            border: 1px solid #e0e0ff;
        }

        .product-name {
            font-weight: 500;
            color: #2c3e50;
        }

        .no-data {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }

        .no-data i {
            font-size: 64px;
            color: #dee2e6;
            margin-bottom: 20px;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button.current {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
            border-color: #667eea !important;
            color: white !important;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
            border-color: #667eea !important;
            color: white !important;
        }

        .dataTables_wrapper .dataTables_filter input {
            border-radius: 8px;
            padding: 8px 15px;
            border: 1px solid #dee2e6;
        }

        .dataTables_wrapper .dataTables_length select {
            border-radius: 8px;
            padding: 5px 10px;
            border: 1px solid #dee2e6;
        }

        @media print {
            .filter-card, .page-header button, .no-print {
                display: none !important;
            }

            body {
                background-color: white;
            }

            .main-container {
                box-shadow: none;
            }
        }

        @media (max-width: 768px) {
            .main-container {
                padding: 15px;
            }

            .table-container {
                overflow-x: auto;
            }

            .filter-card .col-md-3 {
                margin-bottom: 10px;
            }

            .stats-card h3 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
<c:set var="activePage" value="viewimportproduct" scope="request"/>
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>
<div class="container-fluid">
    <div class="main-container">
        <!-- Header -->
        <div class="page-header">
            <div class="d-flex justify-content-between align-items-center flex-wrap">
                <div>
                    <h2><i class="bi bi-box-seam me-2"></i>Product Import History</h2>
                    <p class="subtitle">Manage and track imported products in warehouse</p>
                </div>
                <div class="no-print">
                    <button class="btn btn-outline-primary" onclick="window.print()">
                        <i class="bi bi-printer me-2"></i>Print Report
                    </button>
                </div>
            </div>
        </div>

        <!-- Stats -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="stats-card">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h3>${importedProducts.size()}</h3>
                            <p>Total Imports</p>
                        </div>
                        <i class="bi bi-box-seam" style="font-size: 48px; opacity: 0.3;"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stats-card" style="background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h3><jsp:useBean id="now" class="java.util.Date"/><fmt:formatDate value="${now}" pattern="dd"/></h3>
                            <p>Current Day</p>
                        </div>
                        <i class="bi bi-calendar-check" style="font-size: 48px; opacity: 0.3;"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stats-card" style="background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h3 style="color: #495057;"><fmt:formatDate value="${now}" pattern="MM/yyyy"/></h3>
                            <p style="color: #495057;">Current Month</p>
                        </div>
                        <i class="bi bi-graph-up" style="font-size: 48px; opacity: 0.3; color: #495057;"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filters -->
        <div class="filter-card no-print">
            <h5 class="text-white mb-3"><i class="bi bi-funnel me-2"></i>Filters</h5>
            <div class="row g-3" id="filterForm">
                <div class="col-md-3">
                    <label class="form-label">From Date</label>
                    <input type="date" class="form-control" id="filterFromDate">
                </div>
                <div class="col-md-3">
                    <label class="form-label">To Date</label>
                    <input type="date" class="form-control" id="filterToDate">
                </div>
                <div class="col-md-2">
                    <label class="form-label">Warehouse</label>
                    <select class="form-select" id="filterWarehouse">
                        <option value="">All</option>
                        <c:forEach items="${importedProducts}" var="log">
                            <option value="${log.warehouse.warehouseName}">${log.warehouse.warehouseName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Location</label>
                    <select class="form-select" id="filterLocation">
                        <option value="">All</option>
                        <c:forEach items="${importedProducts}" var="log">
                            <c:if test="${not empty log.warehouse.location}">
                                <option value="${log.warehouse.location}">${log.warehouse.location}</option>
                            </c:if>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">&nbsp;</label>
                    <div class="d-grid gap-2">
                        <button class="btn btn-light" onclick="applyFilters()">
                            <i class="bi bi-search me-2"></i>Filter
                        </button>
                        <button class="btn btn-outline-light btn-sm" onclick="resetFilters()">
                            <i class="bi bi-arrow-clockwise me-1"></i>Reset
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Table -->
        <div class="table-container">
            <c:choose>
                <c:when test="${empty importedProducts}">
                    <div class="no-data">
                        <i class="bi bi-inbox"></i>
                        <h4>No Data Available</h4>
                        <p>No products have been imported to the warehouse yet</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="table table-hover" id="importedTable">
                        <thead>
                        <tr>
                            <th><i class="bi bi-hash me-1"></i>No.</th>
                            <th><i class="bi bi-calendar-event me-1"></i>Import Date</th>
                            <th><i class="bi bi-building me-1"></i>Warehouse</th>
                            <th><i class="bi bi-geo-alt me-1"></i>Location</th>
                            <th><i class="bi bi-upc-scan me-1"></i>Serial Number</th>
                            <th><i class="bi bi-box me-1"></i>Product Name</th>
                            <th><i class="bi bi-info-circle me-1"></i>Description</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${importedProducts}" var="log" varStatus="status">
                            <tr>
                                <td><strong>${status.index + 1}</strong></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty log.importedDate}">
                                                    <span class="date-badge">
                                                        <i class="bi bi-clock me-1"></i>
                                                        <c:set var="dateStr" value="${log.importedDate.toString()}" />
                                                        <c:set var="formattedDate" value="${dateStr.replace('T', ' ')}" />
                                                        ${formattedDate.substring(0, 16)}
                                                    </span>
                                        </c:when>
                                        <c:otherwise>
                                            <small class="text-muted"><em>N/A</em></small>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                            <span class="badge badge-custom badge-warehouse">
                                                <i class="bi bi-building me-1"></i>
                                                ${log.warehouse.warehouseName}
                                            </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty log.warehouse.location}">
                                                    <span class="badge badge-custom badge-location">
                                                        <i class="bi bi-geo-alt-fill me-1"></i>
                                                        ${log.warehouse.location}
                                                    </span>
                                        </c:when>
                                        <c:otherwise>
                                            <small class="text-muted"><em>Not updated</em></small>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                            <span class="serial-code">
                                                <i class="bi bi-upc me-1"></i>
                                                ${log.inventoryItem.serialNumber}
                                            </span>
                                </td>
                                <td>
                                            <span class="product-name">
                                                <i class="bi bi-box-seam me-1"></i>
                                                ${log.inventoryItem.product.productName}
                                            </span>
                                </td>
                                <td>
                                    <small class="text-muted">
                                        <c:choose>
                                            <c:when test="${not empty log.inventoryItem.product.productDescription}">
                                                ${log.inventoryItem.product.productDescription}
                                            </c:when>
                                            <c:otherwise>
                                                <em>No description</em>
                                            </c:otherwise>
                                        </c:choose>
                                    </small>
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
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- DataTables JS -->
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

<script>
    $(document).ready(function() {
        // Initialize DataTable
        var table = $('#importedTable').DataTable({
            language: {
                "decimal": "",
                "emptyTable": "No data available",
                "info": "Showing _START_ to _END_ of _TOTAL_ entries",
                "infoEmpty": "Showing 0 to 0 of 0 entries",
                "infoFiltered": "(filtered from _MAX_ total entries)",
                "infoPostFix": "",
                "thousands": ",",
                "lengthMenu": "Show _MENU_ entries",
                "loadingRecords": "Loading...",
                "processing": "Processing...",
                "search": "Search:",
                "zeroRecords": "No matching records found",
                "paginate": {
                    "first": "First",
                    "last": "Last",
                    "next": "Next",
                    "previous": "Previous"
                },
                "aria": {
                    "sortAscending": ": activate to sort column ascending",
                    "sortDescending": ": activate to sort column descending"
                }
            },
            pageLength: 10,
            order: [[1, 'desc']],
            responsive: true,
            dom: '<"row"<"col-sm-12 col-md-6"l><"col-sm-12 col-md-6"f>>' +
                '<"row"<"col-sm-12"tr>>' +
                '<"row"<"col-sm-12 col-md-5"i><"col-sm-12 col-md-7"p>>'
        });

        // Remove duplicate options in filter selects
        removeDuplicateOptions('#filterWarehouse');
        removeDuplicateOptions('#filterLocation');
    });

    function removeDuplicateOptions(selectId) {
        var uniqueValues = [];
        $(selectId + ' option').each(function() {
            var value = $(this).val();
            if (value && uniqueValues.indexOf(value) === -1) {
                uniqueValues.push(value);
            } else if (value && uniqueValues.indexOf(value) !== -1) {
                $(this).remove();
            }
        });
    }

    function applyFilters() {
        var fromDate = $('#filterFromDate').val();
        var toDate = $('#filterToDate').val();
        var warehouse = $('#filterWarehouse').val();
        var location = $('#filterLocation').val();

        $.fn.dataTable.ext.search.push(
            function(settings, data, dataIndex) {
                // Column indices: 0=No, 1=Date, 2=Warehouse, 3=Location, 4=Serial, 5=Product, 6=Description
                var dateStr = data[1];
                var warehouseStr = data[2];
                var locationStr = data[3];

                // Filter by date - extract date from the cell (format: YYYY-MM-DD HH:MM)
                var dateMatch = dateStr.match(/(\d{4})-(\d{2})-(\d{2})\s+(\d{2}):(\d{2})/);
                if (dateMatch && (fromDate || toDate)) {
                    var rowDate = new Date(dateMatch[1], dateMatch[2] - 1, dateMatch[3]);

                    if (fromDate) {
                        var from = new Date(fromDate);
                        if (rowDate < from) return false;
                    }

                    if (toDate) {
                        var to = new Date(toDate);
                        to.setHours(23, 59, 59, 999); // End of day
                        if (rowDate > to) return false;
                    }
                }

                // Filter by warehouse
                if (warehouse && !warehouseStr.includes(warehouse)) {
                    return false;
                }

                // Filter by location
                if (location && !locationStr.includes(location)) {
                    return false;
                }

                return true;
            }
        );

        var table = $('#importedTable').DataTable();
        table.draw();
        $.fn.dataTable.ext.search.pop();
    }

    // Reset filters
    function resetFilters() {
        $('#filterFromDate').val('');
        $('#filterToDate').val('');
        $('#filterWarehouse').val('');
        $('#filterLocation').val('');

        var table = $('#importedTable').DataTable();
        table.search('').draw();
    }
</script>
</body>
</html>