<%--
  Created by IntelliJ IDEA.
  User: FPT SHOP
  Date: 11/12/2025
  Time: 11:50 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Customer Contract</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">

    <script src="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/js/bootstrap.bundle.min.js"></script>

    <script>
        var contextPath = "${pageContext.request.contextPath}";
    </script>

    <style>
        /* Layout consistent with other pages (xanh-tím header, card shadows, responsive) */
        body {
            margin-left: 260px !important;
            padding-top: 70px !important;
            background: linear-gradient(135deg, #f5f7fa 0%, #eef4ff 100%);
            min-height: 100vh;
            font-family: system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial;
            color: #1e1e1e;
        }

        .container-fluid {
            max-width: 1200px;
            padding: 28px;
        }

        /* Page header */
        .header-section {
            margin-bottom: 18px;
        }
        .page-header-compact {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 18px 20px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(102,126,234,0.16);
            position: relative;
            overflow: hidden;
        }
        .page-header-compact::before {
            content: '';
            position: absolute;
            top: -40%;
            right: -40%;
            width: 180%;
            height: 180%;
            background: radial-gradient(circle, rgba(255,255,255,0.06) 0%, transparent 70%);
            animation: rotate 20s linear infinite;
            opacity: .5;
        }
        @keyframes rotate { from { transform:rotate(0deg);} to { transform:rotate(360deg);} }

        .page-title { margin:0; font-weight:700; font-size:1.25rem; }
        .page-actions { text-align: right; }

        /* Search panel */
        .search-card {
            background: white;
            border-radius: 12px;
            padding: 18px;
            box-shadow: 0 8px 24px rgba(35,44,78,0.06);
            margin-bottom: 18px;
        }
        .search-card .form-label { font-weight:600; }
        .search-card .btn-primary {
            background: linear-gradient(135deg,#2b6cb0 0%,#6b46c1 100%);
            border: none;
        }
        .search-card .btn-danger {
            background: linear-gradient(135deg,#ef4444,#e11d48);
            border: none;
        }

        /* Summary card */
        .summary-card {
            background: white;
            border-radius: 12px;
            padding: 16px;
            box-shadow: 0 8px 24px rgba(35,44,78,0.06);
            margin-bottom: 18px;
            text-align: center;
        }
        .summary-card h3 { color: #16a34a; margin-bottom:6px; font-size:1.6rem; }

        /* Table */
        .contract-card {
            background: transparent;
        }
        .card-header-custom {
            margin-bottom: 10px;
        }
        .table-responsive {
            background: white;
            border-radius: 12px;
            padding: 12px;
            box-shadow: 0 8px 24px rgba(35,44,78,0.04);
        }
        table.table {
            margin-bottom: 0;
            border-collapse: separate;
            border-spacing: 0;
        }
        table.table thead th {
            background: linear-gradient(to bottom, #f8f9ff, #eef4ff);
            position: sticky;
            top: 0;
            z-index: 5;
            font-weight: 700;
        }
        table.table tbody tr:hover {
            background: linear-gradient(to right, #fbfdff, #eef7ff);
        }
        table.table td, table.table th {
            vertical-align: middle;
            padding: 12px 14px;
        }

        /* Buttons */
        .btn-view {
            background: linear-gradient(135deg,#5b6ee1,#6b46c1);
            color: #fff;
            border: none;
        }

        /* Modal sizes */
        .modal-content { border-radius: 12px; overflow: hidden; }
        .alert-warning { margin-top: 12px; }

        /* Pagination controls */
        .form-select { border-radius: 8px; }
        .pagination .page-link { border-radius: 8px; }

        /* Responsive adjustments */
        @media (max-width: 992px) {
            body { margin-left: 0 !important; padding-top: 90px !important; }
            .container-fluid { padding: 16px; }
            .page-actions { margin-top: 12px; text-align: left; }
        }
    </style>
</head>
<body>
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>

<div class="container-fluid">
    <div class="header-section">
        <div class="page-header-compact d-flex justify-content-between align-items-center">
            <div>
                <h1 class="page-title">${customer.customerName}'s Contract History</h1>
                <div class="text-white-75" style="opacity:.95;"></div>
            </div>

        </div>
    </div>

    <!-- Search -->
    <div class="search-card">
        <h5 class="mb-3"><i class="bi bi-search me-2"></i>Search Contracts</h5>
        <form action="${pageContext.request.contextPath}/customer_supporter/customers_list/contracts" method="get" class="row g-3">
            <input type="hidden" name="id" value="${param.id}">

            <div class="col-md-4">
                <label class="form-label">Contract Code</label>
                <input type="text" class="form-control" name="contractCode" placeholder="Enter contract code..." value="${contractCodeSearch != null ? contractCodeSearch : ''}">
            </div>
            <div class="col-md-4">
                <label class="form-label">Start Date</label>
                <input type="date" class="form-control" name="startDate" value="${startDateSearch != null ? startDateSearch : ''}">
            </div>
            <div class="col-md-4 d-flex align-items-end gap-2">
                <button type="submit" class="btn btn-primary w-50">
                    <i class="bi bi-search me-1"></i>Search
                </button>
                <a href="${pageContext.request.contextPath}/customer_supporter/customers_list/contracts" class="btn btn-danger w-50">
                    <i class="bi bi-arrow-clockwise me-1"></i>Reset
                </a>
            </div>
        </form>
    </div>

    <!-- Summary -->
    <div class="summary-card">
        <div class="row">
            <div class="col-md-12">
                <h3 id="totalContracts">${count}</h3>
                <small class="text-muted">Total Contracts</small>
            </div>
        </div>
    </div>

    <!-- Contracts Table -->
    <div class="contract-card">
        <div class="card-header-custom">
            <h5 class="mb-0"><i class="bi bi-table me-2"></i>Contract List</h5>
        </div>

        <div class="table-responsive">
            <table class="table table-hover mb-0" id="contractsTable">
                <thead>
                <tr>
                    <th>Contract ID</th>
                    <th>Start Date</th>
                    <th>End Date</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody id="contractsTableBody">
                <c:forEach items="${contracts}" var="contract">
                    <tr class="align-middle">
                        <td><c:out value="${contract.contractCode}"/></td>
                        <td><c:out value="${contract.startDate}"/></td>
                        <td><c:out value="${contract.expiredDate}"/></td>
                        <td>
                            <button type="button" class="btn btn-sm btn-view me-2"
                                    onclick="viewDetails('${contract.contractCode}', '${contract.contractImage}')">
                                <i class="bi bi-eye"></i> View
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Pagination Controls -->
    <form method="get" action="${pageContext.request.contextPath}/customer_supporter/customers_list/contracts" class="mt-3 d-flex align-items-center gap-3">
        <input type="hidden" name="id" value="${param.id}">
        <span>Show:</span>
        <select name="itemsPerPage" class="form-select form-select-sm" style="width: auto;" onchange="this.form.submit()">
            <option value="5"  ${recordsPerPage == 5 ? 'selected' : ''}>5</option>
            <option value="10" ${recordsPerPage == 10 ? 'selected' : ''}>10</option>
            <option value="15" ${recordsPerPage == 15 ? 'selected' : ''}>15</option>
            <option value="20" ${recordsPerPage == 20 ? 'selected' : ''}>20</option>
        </select>
    </form>

    <!-- Pagination -->
    <nav class="mt-4">
        <ul class="pagination justify-content-center">
            <c:if test="${currentPage > 1}">
                <li class="page-item">
                    <a class="page-link" href="${pageContext.request.contextPath}/customer_supporter/customers_list/contracts?page=${currentPage - 1}&itemsPerPage=${recordsPerPage}&contractCode=${contractCodeSearch}&startDate=${startDateSearch}&id=${param.id}">Previous</a>
                </li>
            </c:if>

            <c:forEach begin="1" end="${totalPages}" var="i">
                <li class="page-item ${i == currentPage ? 'active' : ''}">
                    <a class="page-link" href="${pageContext.request.contextPath}/customer_supporter/customers_list/contracts?page=${i}&itemsPerPage=${recordsPerPage}&contractCode=${contractCodeSearch}&startDate=${startDateSearch}&id=${param.id}">${i}</a>
                </li>
            </c:forEach>

            <c:if test="${currentPage < totalPages}">
                <li class="page-item">
                    <a class="page-link" href="${pageContext.request.contextPath}/customer_supporter/customers_list/contracts?page=${currentPage + 1}&itemsPerPage=${recordsPerPage}&contractCode=${contractCodeSearch}&startDate=${startDateSearch}&id=${param.id}">Next</a>
                </li>
            </c:if>
        </ul>
    </nav>
</div>

<!-- Modal contract -->
<div class="modal fade" id="contractModal" tabindex="-1" aria-labelledby="contractModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Contract Image</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-center">
                <embed id="contractPDF" type="application/pdf" width="100%" height="600px" style="display: none;">
                <div id="noPDFNotice" class="alert alert-warning mt-3" style="display: none;">
                    Contract file not found or cannot be displayed.
                </div>
                <a id="downloadContractBtn" class="btn btn-success mt-3" href="#" download style="display: none;">
                    <i class="bi bi-download"></i> Download Contract
                </a>
            </div>
        </div>
    </div>
</div>

<!-- Keep existing script but ensure path exists -->
<script src="${pageContext.request.contextPath}/js/view-contract-detail.js"></script>
</body>
</html>
