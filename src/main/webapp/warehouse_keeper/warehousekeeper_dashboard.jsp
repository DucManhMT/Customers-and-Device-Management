<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="crm.common.model.enums.ProductStatus" %>
<%@ page import="crm.common.model.enums.ProductRequestStatus" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Warehouse Keeper Dashboard</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.js"></script>

    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .stat-card {
            border-radius: 10px;
            border: none;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin-bottom: 2.5rem;
            height: 100%;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .stat-card .card-body {
            padding: 1.5rem;
        }

        .stat-icon {
            font-size: 3rem;
            opacity: 0.8;
        }

        .stat-value {
            font-size: 2.5rem;
            font-weight: bold;
            margin: 0.5rem 0;
        }

        .stat-label {
            color: rgba(255, 255, 255, 0.9);
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .card-imported {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .card-exported {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
        }

        .card-total {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
        }

        .card-requests {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            color: white;
        }

        .card-pending {
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            color: white;
        }

        .card-items {
            background: linear-gradient(135deg, #30cfd0 0%, #330867 100%);
            color: white;
        }

        .chart-container {
            background: white;
            border-radius: 10px;
            padding: 2rem;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 2.5rem;
            min-height: 450px;
        }

        .section-title {
            color: #667eea;
            font-weight: 600;
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #667eea;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .alert-warning-custom {
            background: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 1rem;
            border-radius: 5px;
            margin-bottom: 2.5rem;
        }

        .empty-state {
            padding: 3rem;
            text-align: center;
            color: #95a5a6;
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .chart-canvas {
            max-height: 400px;
        }

        .dashboard-title {
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 2rem;
            padding-bottom: 0.75rem;
            border-bottom: 3px solid #667eea;
        }

        .row.stat-cards {
            row-gap: 1.5rem;
        }

        .chart-row {
            margin-top: 2rem;
        }
    </style>
</head>
<body>
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>
<!-- Calculate statistics from lists -->
<jsp:useBean id="now" class="java.util.Date"/>

<!-- Count products imported this month -->
<c:set var="currentYear" value="${now.year + 1900}"/>
<c:set var="currentMonth" value="${now.month}"/>
<c:set var="importedThisMonth" value="0"/>
<c:forEach items="${productsImported}" var="importLog">
    <c:if test="${not empty importLog.importedDate}">
        <jsp:useBean id="importDate" class="java.util.Date"/>
        <c:set target="${importDate}" property="time" value="${importLog.importedDate.atZone(java.time.ZoneId.systemDefault()).toInstant().toEpochMilli()}"/>
        <c:if test="${importDate.year + 1900 == currentYear and importDate.month == currentMonth}">
            <c:set var="importedThisMonth" value="${importedThisMonth + 1}"/>
        </c:if>
    </c:if>
</c:forEach>

<!-- Count products exported this month -->
<c:set var="exportedThisMonth" value="0"/>
<c:forEach items="${productExporteds}" var="exportLog">
    <c:if test="${not empty exportLog.warehouseLog and not empty exportLog.warehouseLog.logDate}">
        <jsp:useBean id="exportDate" class="java.util.Date"/>
        <c:set target="${exportDate}" property="time" value="${exportLog.warehouseLog.logDate.atStartOfDay(java.time.ZoneId.systemDefault()).toInstant().toEpochMilli()}"/>
        <c:if test="${exportDate.year + 1900 == currentYear and exportDate.month == currentMonth}">
            <c:set var="exportedThisMonth" value="${exportedThisMonth + 1}"/>
        </c:if>
    </c:if>
</c:forEach>

<!-- Count total products in warehouse (IN_STOCK or RESERVED) -->
<c:set var="totalInWarehouse" value="0"/>
<c:forEach items="${productWarehouses}" var="pw">
    <c:if test="${pw.productStatus eq ProductStatus.In_Stock or pw.productStatus eq ProductStatus.Exported}">
        <c:set var="totalInWarehouse" value="${totalInWarehouse + 1}"/>
    </c:if>
</c:forEach>

<!-- Count pending requests -->
<c:set var="pendingCount" value="0"/>
<c:forEach items="${productRequests}" var="request">
    <c:if test="${request.status eq ProductRequestStatus.Pending}">
        <c:set var="pendingCount" value="${pendingCount + 1}"/>
    </c:if>
</c:forEach>

<div class="container-fluid py-4">
    <!-- Dashboard Title -->
    <h2 class="dashboard-title">
        <i class="bi bi-speedometer2"></i> Warehouse Dashboard
    </h2>

    <!-- Warning Alert for Pending Requests -->
    <c:if test="${pendingCount > 0}">
        <div class="alert-warning-custom">
            <div class="d-flex align-items-center">
                <i class="bi bi-exclamation-triangle-fill me-3" style="font-size: 1.5rem; color: #ffc107;"></i>
                <div>
                    <strong>Action Required!</strong>
                    You have <strong>${pendingCount}</strong> pending request<c:if test="${pendingCount > 1}">s</c:if> waiting for processing.
                </div>
            </div>
        </div>
    </c:if>

    <!-- Statistics Cards -->
    <div class="row stat-cards g-4">
        <!-- Products Imported -->
        <div class="col-xl-4 col-md-6">
            <div class="card stat-card card-imported">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="stat-label">Products Imported</div>
                            <div class="stat-value">
                                <fmt:formatNumber value="${importedThisMonth}" groupingUsed="true"/>
                            </div>
                            <small><i class="bi bi-calendar-week"></i> This Month</small>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-box-arrow-in-down"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Products Exported -->
        <div class="col-xl-4 col-md-6">
            <div class="card stat-card card-exported">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="stat-label">Products Exported</div>
                            <div class="stat-value">
                                <fmt:formatNumber value="${exportedThisMonth}" groupingUsed="true"/>
                            </div>
                            <small><i class="bi bi-calendar-week"></i> This Month</small>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-box-arrow-up"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Total Products in Warehouse -->
        <div class="col-xl-4 col-md-6">
            <div class="card stat-card card-total">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="stat-label">Current Stock</div>
                            <div class="stat-value">
                                <fmt:formatNumber value="${totalInWarehouse}" groupingUsed="true"/>
                            </div>
                            <small><i class="bi bi-archive"></i> In Warehouse</small>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-boxes"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Total Requests -->
        <div class="col-xl-4 col-md-6">
            <div class="card stat-card card-requests">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="stat-label">Total Requests</div>
                            <div class="stat-value">
                                <fmt:formatNumber value="${fn:length(productRequests)}" groupingUsed="true"/>
                            </div>
                            <small><i class="bi bi-clock-history"></i> All Time</small>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-clipboard-check"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Pending Requests -->
        <div class="col-xl-4 col-md-6">
            <div class="card stat-card card-pending">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="stat-label">Pending Actions</div>
                            <div class="stat-value">
                                <fmt:formatNumber value="${pendingCount}" groupingUsed="true"/>
                            </div>
                            <small><i class="bi bi-hourglass-split"></i> Awaiting Processing</small>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-exclamation-circle"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Total Items -->
        <div class="col-xl-4 col-md-6">
            <div class="card stat-card card-items">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="stat-label">Unique Items</div>
                            <div class="stat-value">
                                <fmt:formatNumber value="${fn:length(products)}" groupingUsed="true"/>
                            </div>
                            <small><i class="bi bi-list-ul"></i> Product Types</small>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-grid-3x3"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Charts Section -->
    <div class="row chart-row g-4">
        <!-- Import/Export Activity Chart -->
        <div class="col-lg-6">
            <div class="chart-container">
                <h3 class="section-title">
                    <i class="bi bi-graph-up"></i> Import & Export Activity
                </h3>
                <c:choose>
                    <c:when test="${not empty productsImported or not empty productExporteds}">
                        <canvas id="importExportChart" class="chart-canvas"></canvas>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="bi bi-bar-chart"></i>
                            <p class="mb-0">No activity data available</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Warehouse Distribution Chart -->
        <div class="col-lg-6">
            <div class="chart-container">
                <h3 class="section-title">
                    <i class="bi bi-pie-chart"></i> Warehouse Distribution
                </h3>
                <c:choose>
                    <c:when test="${not empty productWarehouses}">
                        <canvas id="warehouseDistributionChart" class="chart-canvas"></canvas>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="bi bi-pie-chart"></i>
                            <p class="mb-0">No warehouse data available</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Chart.js Global Configuration
    Chart.defaults.font.family = "'Segoe UI', Tahoma, Geneva, Verdana, sans-serif";
    Chart.defaults.color = '#666';

    // 1. Import/Export Activity Chart (Bar Chart)
    <c:if test="${not empty productsImported or not empty productExporteds}">
    const importExportCtx = document.getElementById('importExportChart').getContext('2d');

    // Prepare data for imports by date
    const importDates = {};
    <c:forEach items="${productsImported}" var="importLog">
    <c:if test="${not empty importLog.importedDate}">
    const importDateObj = new Date(${importLog.importedDate.year}, ${importLog.importedDate.monthValue - 1}, ${importLog.importedDate.dayOfMonth});
    const importDateStr = importDateObj.toISOString().split('T')[0];
    importDates[importDateStr] = (importDates[importDateStr] || 0) + 1;
    </c:if>
    </c:forEach>

    // Prepare data for exports by date
    const exportDates = {};
    <c:forEach items="${productExporteds}" var="exportLog">
    <c:if test="${not empty exportLog.warehouseLog and not empty exportLog.warehouseLog.logDate}">
    const exportDateObj = new Date(${exportLog.warehouseLog.logDate.year}, ${exportLog.warehouseLog.logDate.monthValue - 1}, ${exportLog.warehouseLog.logDate.dayOfMonth});
    const exportDateStr = exportDateObj.toISOString().split('T')[0];
    exportDates[exportDateStr] = (exportDates[exportDateStr] || 0) + 1;
    </c:if>
    </c:forEach>

    // Get all unique dates and sort them
    const allDates = [...new Set([...Object.keys(importDates), ...Object.keys(exportDates)])].sort();
    const importData = allDates.map(date => importDates[date] || 0);
    const exportData = allDates.map(date => exportDates[date] || 0);

    // Take last 10 dates if more than 10
    const displayDates = allDates.slice(-10);
    const displayImportData = displayDates.map(date => importDates[date] || 0);
    const displayExportData = displayDates.map(date => exportDates[date] || 0);

    new Chart(importExportCtx, {
        type: 'bar',
        data: {
            labels: displayDates.map(date => {
                const d = new Date(date);
                return d.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
            }),
            datasets: [{
                label: 'Imports',
                data: displayImportData,
                backgroundColor: 'rgba(102, 126, 234, 0.8)',
                borderColor: 'rgba(102, 126, 234, 1)',
                borderWidth: 2,
                borderRadius: 5
            }, {
                label: 'Exports',
                data: displayExportData,
                backgroundColor: 'rgba(240, 147, 251, 0.8)',
                borderColor: 'rgba(240, 147, 251, 1)',
                borderWidth: 2,
                borderRadius: 5
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: {
                legend: {
                    display: true,
                    position: 'top',
                    labels: {
                        padding: 15,
                        font: {
                            size: 13,
                            weight: '600'
                        }
                    }
                },
                tooltip: {
                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                    padding: 12,
                    titleFont: {
                        size: 14,
                        weight: 'bold'
                    },
                    bodyFont: {
                        size: 13
                    },
                    callbacks: {
                        label: function(context) {
                            return context.dataset.label + ': ' + context.parsed.y + ' items';
                        }
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        stepSize: 1,
                        font: {
                            size: 12
                        }
                    },
                    grid: {
                        color: 'rgba(0, 0, 0, 0.05)'
                    }
                },
                x: {
                    ticks: {
                        font: {
                            size: 12
                        }
                    },
                    grid: {
                        display: false
                    }
                }
            }
        }
    });
    </c:if>

    // 2. Warehouse Distribution Chart (Doughnut Chart)
    <c:if test="${not empty productWarehouses}">
    const warehouseDistCtx = document.getElementById('warehouseDistributionChart').getContext('2d');

    // Count products by warehouse
    const warehouseCounts = {};
    const warehouseNames = {};
    <c:forEach items="${productWarehouses}" var="pw">
    <c:if test="${not empty pw.warehouse}">
    const whId = ${pw.warehouse.warehouseID};
    const whName = '${fn:escapeXml(pw.warehouse.warehouseName)}';
    warehouseCounts[whId] = (warehouseCounts[whId] || 0) + 1;
    warehouseNames[whId] = whName;
    </c:if>
    </c:forEach>

    const warehouseLabels = Object.values(warehouseNames);
    const warehouseData = Object.values(warehouseCounts);

    new Chart(warehouseDistCtx, {
        type: 'doughnut',
        data: {
            labels: warehouseLabels,
            datasets: [{
                data: warehouseData,
                backgroundColor: [
                    'rgba(102, 126, 234, 0.8)',
                    'rgba(240, 147, 251, 0.8)',
                    'rgba(79, 172, 254, 0.8)',
                    'rgba(67, 233, 123, 0.8)',
                    'rgba(250, 112, 154, 0.8)',
                    'rgba(48, 207, 208, 0.8)'
                ],
                borderColor: [
                    'rgba(102, 126, 234, 1)',
                    'rgba(240, 147, 251, 1)',
                    'rgba(79, 172, 254, 1)',
                    'rgba(67, 233, 123, 1)',
                    'rgba(250, 112, 154, 1)',
                    'rgba(48, 207, 208, 1)'
                ],
                borderWidth: 3,
                hoverOffset: 10
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: {
                legend: {
                    display: true,
                    position: 'right',
                    labels: {
                        padding: 15,
                        font: {
                            size: 13,
                            weight: '600'
                        },
                        generateLabels: function(chart) {
                            const data = chart.data;
                            if (data.labels.length && data.datasets.length) {
                                return data.labels.map((label, i) => {
                                    const value = data.datasets[0].data[i];
                                    return {
                                        text: label + ' (' + value + ')',
                                        fillStyle: data.datasets[0].backgroundColor[i],
                                        hidden: false,
                                        index: i
                                    };
                                });
                            }
                            return [];
                        }
                    }
                },
                tooltip: {
                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                    padding: 12,
                    titleFont: {
                        size: 14,
                        weight: 'bold'
                    },
                    bodyFont: {
                        size: 13
                    },
                    callbacks: {
                        label: function(context) {
                            const label = context.label || '';
                            const value = context.parsed || 0;
                            const total = context.dataset.data.reduce((a, b) => a + b, 0);
                            const percentage = ((value / total) * 100).toFixed(1);
                            return label + ': ' + value + ' items (' + percentage + '%)';
                        }
                    }
                }
            }
        }
    });
    </c:if>

    // Auto-refresh every 5 minutes (300000 ms)
    setTimeout(function() {
        location.reload();
    }, 300000);
</script>
</body>
</html>