<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Inventory Manager Dashboard</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-adapter-date-fns@3.0.0/dist/chartjs-adapter-date-fns.bundle.min.js"></script>
    <style>
        body {
            background-color: #f8f9fa;
        }
        .card {
            border: 1px solid #dee2e6;
            border-radius: 12px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            transition: box-shadow 0.3s;
            height: 100%;
        }
        .card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
        }
        .stats-card-success {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
        }
        .stats-card-warning {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
        .stats-card-info {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }
        .stats-icon {
            font-size: 2.5rem;
            opacity: 0.9;
        }
        .stats-number {
            font-size: 2.8rem;
            font-weight: 700;
            margin: 15px 0 5px 0;
        }
        .page-header {
            background: white;
            padding: 25px;
            border-radius: 12px;
            border: 1px solid #dee2e6;
            margin-bottom: 30px;
        }
        .chart-container {
            position: relative;
            height: 350px;
            padding: 20px 10px;
        }
        .card-header {
            background-color: white;
            border-bottom: 2px solid #f0f0f0;
            font-weight: 600;
            color: #2d3748;
            padding: 1rem 1.5rem;
        }
    </style>
</head>

<body>
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>

<div class="container mt-4">
    <div class="page-header">
        <h2 class="mb-1"><i class="fas fa-chart-line me-2" style="color: #667eea;"></i>Inventory Dashboard</h2>
        <p class="text-muted mb-0">Real-time overview of inventory management system</p>
    </div>

    <!-- Statistics Cards Row -->
    <div class="row g-4 mb-4">
        <div class="col-md-3">
            <div class="card stats-card-success text-center">
                <div class="card-body py-4">
                    <i class="fas fa-cubes stats-icon"></i>
                    <div class="stats-number">${totalProducts}</div>
                    <p class="mb-0 fw-semibold">Total Products</p>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card stats-card-warning text-center">
                <div class="card-body py-4">
                    <i class="fas fa-boxes stats-icon"></i>
                    <div class="stats-number">${totalProductStock}</div>
                    <p class="mb-0 fw-semibold">Total Stock</p>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card stats-card-info text-center">
                <div class="card-body py-4">
                    <i class="fas fa-warehouse stats-icon"></i>
                    <div class="stats-number">${warehouseRequestStats['PENDING'] != null ? warehouseRequestStats['PENDING'] : 0}</div>
                    <p class="mb-0 fw-semibold">Pending Warehouse Requests</p>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card stats-card text-center">
                <div class="card-body py-4">
                    <i class="fas fa-clipboard-list stats-icon"></i>
                    <div class="stats-number">${productRequestStats['PENDING'] != null ? productRequestStats['PENDING'] : 0}</div>
                    <p class="mb-0 fw-semibold">Pending Product Requests</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Time Series Charts -->
    <div class="row g-4 mb-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-chart-line me-2" style="color: #667eea;"></i>Requests Over Time</h5>
                </div>
                <div class="card-body">
                    <div class="chart-container" style="height: 400px;">
                        <canvas id="timelineChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Distribution Charts -->
    <div class="row g-4 mb-4">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-warehouse me-2" style="color: #4facfe;"></i>Warehouse Requests Status</h5>
                </div>
                <div class="card-body">
                    <div class="chart-container">
                        <canvas id="warehouseChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-box me-2" style="color: #11998e;"></i>Product Requests Status</h5>
                </div>
                <div class="card-body">
                    <div class="chart-container">
                        <canvas id="productChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Comparison Chart -->
    <div class="row g-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-chart-bar me-2" style="color: #f093fb;"></i>Status Comparison</h5>
                </div>
                <div class="card-body">
                    <div class="chart-container" style="height: 350px;">
                        <canvas id="comparisonChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Professional color palette
    const colors = {
        pending: '#fbbf24',      // Warm amber
        approved: '#10b981',     // Fresh green
        rejected: '#ef4444',     // Soft red
        completed: '#3b82f6',    // Bright blue
        finished: '#8b5cf6',     // Purple
        transporting: '#f59e0b', // Orange
        accepted: '#14b8a6',     // Teal
        default: '#6b7280'       // Neutral gray
    };

    const warehouseData = {
        <c:forEach var="entry" items="${warehouseRequestStats}" varStatus="status">
        '${entry.key}': ${entry.value}<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    };

    const productData = {
        <c:forEach var="entry" items="${productRequestStats}" varStatus="status">
        '${entry.key}': ${entry.value}<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    };

    function getColorByStatus(status) {
        return colors[status.toLowerCase()] || colors.default;
    }

    // Timeline Chart with actual data
    const timelineData = {
        warehouse: {
            <c:forEach var="entry" items="${timelineData.warehouse}" varStatus="status">
            '${entry.key}': ${entry.value}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        },
        product: {
            <c:forEach var="entry" items="${timelineData.product}" varStatus="status">
            '${entry.key}': ${entry.value}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        }
    };

    // Convert to Chart.js format
    const warehouseDates = Object.keys(timelineData.warehouse).map(date => ({
        x: date,
        y: timelineData.warehouse[date]
    }));

    const productDates = Object.keys(timelineData.product).map(date => ({
        x: date,
        y: timelineData.product[date]
    }));

    const timelineCtx = document.getElementById('timelineChart').getContext('2d');
    new Chart(timelineCtx, {
        type: 'line',
        data: {
            datasets: [{
                label: 'Warehouse Requests',
                data: warehouseDates,
                borderColor: '#667eea',
                backgroundColor: 'rgba(102, 126, 234, 0.1)',
                tension: 0.4,
                fill: true,
                borderWidth: 3,
                pointBackgroundColor: '#667eea',
                pointBorderColor: '#fff',
                pointBorderWidth: 2,
                pointRadius: 4
            }, {
                label: 'Product Requests',
                data: productDates,
                borderColor: '#11998e',
                backgroundColor: 'rgba(17, 153, 142, 0.1)',
                tension: 0.4,
                fill: true,
                borderWidth: 3,
                pointBackgroundColor: '#11998e',
                pointBorderColor: '#fff',
                pointBorderWidth: 2,
                pointRadius: 4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'top',
                    labels: {
                        usePointStyle: true,
                        padding: 20,
                        font: { size: 13, weight: '500' }
                    }
                }
            },
            scales: {
                x: {
                    type: 'time',
                    time: {
                        unit: 'day',
                        displayFormats: {
                            day: 'MMM dd'
                        }
                    },
                    grid: { display: false }
                },
                y: {
                    beginAtZero: true,
                    ticks: { stepSize: 1 },
                    grid: { color: '#f3f4f6' }
                }
            }
        }
    });


    // Warehouse Doughnut Chart
    const warehouseCtx = document.getElementById('warehouseChart').getContext('2d');
    new Chart(warehouseCtx, {
        type: 'doughnut',
        data: {
            labels: Object.keys(warehouseData),
            datasets: [{
                data: Object.values(warehouseData),
                backgroundColor: Object.keys(warehouseData).map(status => getColorByStatus(status)),
                borderWidth: 3,
                borderColor: '#fff',
                hoverOffset: 10
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        padding: 20,
                        font: { size: 13 },
                        usePointStyle: true
                    }
                }
            }
        }
    });

    // Product Doughnut Chart
    const productCtx = document.getElementById('productChart').getContext('2d');
    new Chart(productCtx, {
        type: 'doughnut',
        data: {
            labels: Object.keys(productData),
            datasets: [{
                data: Object.values(productData),
                backgroundColor: Object.keys(productData).map(status => getColorByStatus(status)),
                borderWidth: 3,
                borderColor: '#fff',
                hoverOffset: 10
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        padding: 20,
                        font: { size: 13 },
                        usePointStyle: true
                    }
                }
            }
        }
    });

    // Comparison Bar Chart - Modified for status-based coloring
    const comparisonCtx = document.getElementById('comparisonChart').getContext('2d');

    // Get all unique statuses
    const allStatuses = [...new Set([...Object.keys(warehouseData), ...Object.keys(productData)])];

    // Create datasets for each status
    const comparisonDatasets = allStatuses.map(status => ({
        label: status,
        data: [
            warehouseData[status] || 0,
            productData[status] || 0
        ],
        backgroundColor: getColorByStatus(status),
        borderColor: getColorByStatus(status),
        borderWidth: 0,
        borderRadius: 6
    }));

    new Chart(comparisonCtx, {
        type: 'bar',
        data: {
            labels: ['Warehouse Requests', 'Product Requests'],
            datasets: comparisonDatasets
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: { stepSize: 1 },
                    grid: { color: '#f3f4f6' }
                },
                x: {
                    grid: { display: false }
                }
            },
            plugins: {
                legend: {
                    position: 'top',
                    labels: {
                        padding: 20,
                        font: { size: 13, weight: '500' },
                        usePointStyle: true
                    }
                }
            }
        }
    });
</script>
</body>
</html>
