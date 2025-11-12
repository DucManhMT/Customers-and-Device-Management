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
            overflow: hidden;
        }

        .chart-wrapper {
            position: relative;
            height: 350px;
            width: 100%;
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

<!-- Simple count logic -->
<c:set var="importedTotal" value="${fn:length(productsImported)}"/>
<c:set var="exportedTotal" value="${fn:length(productExporteds)}"/>

<!-- Count total products in warehouse -->
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
                                <fmt:formatNumber value="${importedTotal}" groupingUsed="true"/>
                            </div>
                            <small><i class="bi bi-calendar-week"></i> Total Records</small>
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
                                <fmt:formatNumber value="${exportedTotal}" groupingUsed="true"/>
                            </div>
                            <small><i class="bi bi-calendar-week"></i> Total Records</small>
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
        <!-- Import Activity Chart -->
        <div class="col-12 col-lg-6">
            <div class="chart-container">
                <h3 class="section-title">
                    <i class="bi bi-box-arrow-in-down"></i> Import Activity
                </h3>
                <c:choose>
                    <c:when test="${not empty productsImported}">
                        <div class="chart-wrapper">
                            <canvas id="importChart"></canvas>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="bi bi-bar-chart"></i>
                            <p class="mb-0">No import data available</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Export Activity Chart -->
        <div class="col-12 col-lg-6">
            <div class="chart-container">
                <h3 class="section-title">
                    <i class="bi bi-box-arrow-up"></i> Export Activity
                </h3>
                <c:choose>
                    <c:when test="${not empty productExporteds}">
                        <div class="chart-wrapper">
                            <canvas id="exportChart"></canvas>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="bi bi-bar-chart"></i>
                            <p class="mb-0">No export data available</p>
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
    Chart.defaults.font.family = "'Segoe UI', Tahoma, Geneva, Verdana, sans-serif";
    Chart.defaults.color = '#666';

    // 1. Import Chart
    <c:if test="${not empty productsImported}">
    {
        const ctx = document.getElementById('importChart');
        if (ctx) {
            const dates = {};

            <c:forEach items="${productsImported}" var="item" varStatus="status">
            <c:if test="${not empty item.importedDate}">
            {
                const dateKey = '${item.importedDate.year}-${item.importedDate.monthValue}-${item.importedDate.dayOfMonth}';
                dates[dateKey] = (dates[dateKey] || 0) + 1;
            }
            </c:if>
            </c:forEach>

            const sortedDates = Object.keys(dates).sort();
            const last10 = sortedDates.slice(-10);

            const labels = last10.map(d => {
                const parts = d.split('-');
                const date = new Date(parts[0], parts[1] - 1, parts[2]);
                return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
            });

            const data = last10.map(d => dates[d]);

            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Products Imported',
                        data: data,
                        backgroundColor: 'rgba(102, 126, 234, 0.2)',
                        borderColor: 'rgba(102, 126, 234, 1)',
                        borderWidth: 3,
                        fill: true,
                        tension: 0.4,
                        pointRadius: 5,
                        pointHoverRadius: 7,
                        pointBackgroundColor: 'rgba(102, 126, 234, 1)',
                        pointBorderColor: '#fff',
                        pointBorderWidth: 2
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            backgroundColor: 'rgba(0, 0, 0, 0.8)',
                            padding: 12,
                            titleFont: { size: 14, weight: 'bold' },
                            bodyFont: { size: 13 },
                            callbacks: {
                                label: function(context) {
                                    return 'Imported: ' + context.parsed.y + ' items';
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                stepSize: 1,
                                font: { size: 12 }
                            },
                            grid: {
                                color: 'rgba(0, 0, 0, 0.05)'
                            }
                        },
                        x: {
                            ticks: {
                                font: { size: 12 }
                            },
                            grid: {
                                display: false
                            }
                        }
                    },
                    layout: {
                        padding: 10
                    }
                }
            });
        }
    }
    </c:if>

    // 2. Export Chart
    <c:if test="${not empty productExporteds}">
    {
        const ctx = document.getElementById('exportChart');
        if (ctx) {
            const dates = {};

            <c:forEach items="${productExporteds}" var="item" varStatus="status">
            <c:if test="${not empty item.warehouseLog and not empty item.warehouseLog.logDate}">
            {
                const dateKey = '${item.warehouseLog.logDate.year}-${item.warehouseLog.logDate.monthValue}-${item.warehouseLog.logDate.dayOfMonth}';
                dates[dateKey] = (dates[dateKey] || 0) + 1;
            }
            </c:if>
            </c:forEach>

            const sortedDates = Object.keys(dates).sort();
            const last10 = sortedDates.slice(-10);

            const labels = last10.map(d => {
                const parts = d.split('-');
                const date = new Date(parts[0], parts[1] - 1, parts[2]);
                return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
            });

            const data = last10.map(d => dates[d]);

            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Products Exported',
                        data: data,
                        backgroundColor: 'rgba(240, 147, 251, 0.2)',
                        borderColor: 'rgba(240, 147, 251, 1)',
                        borderWidth: 3,
                        fill: true,
                        tension: 0.4,
                        pointRadius: 5,
                        pointHoverRadius: 7,
                        pointBackgroundColor: 'rgba(240, 147, 251, 1)',
                        pointBorderColor: '#fff',
                        pointBorderWidth: 2
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            backgroundColor: 'rgba(0, 0, 0, 0.8)',
                            padding: 12,
                            titleFont: { size: 14, weight: 'bold' },
                            bodyFont: { size: 13 },
                            callbacks: {
                                label: function(context) {
                                    return 'Exported: ' + context.parsed.y + ' items';
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                stepSize: 1,
                                font: { size: 12 }
                            },
                            grid: {
                                color: 'rgba(0, 0, 0, 0.05)'
                            }
                        },
                        x: {
                            ticks: {
                                font: { size: 12 }
                            },
                            grid: {
                                display: false
                            }
                        }
                    },
                    layout: {
                        padding: 10
                    }
                }
            });
        }
    }
    </c:if>
</script>
</body>
</html>