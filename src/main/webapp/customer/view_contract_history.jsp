<!-- <%--
  Created by IntelliJ IDEA.
  User: FPT SHOP
  Date: 10/4/2025
  Time: 6:26 PM
  To change this template use File | Settings | File Templates.
--%> -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>


<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contract History</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <script src="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var contextPath = "${pageContext.request.contextPath}";
    </script>

    <%--    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ViewContractHistory.css">--%>
</head>

<body>
<jsp:include page="../components/customer_header.jsp"/>
<div class="container-fluid">

    <div class="main-container">
        <div class="header-section">
            <div class="row align-items-center position-relative">
                <div class="col-md-8">
                    <h1 class="mb-2">
                        Contract History
                    </h1>
                </div>
                <div class="col-md-4 text-end">
                    <a href="${pageContext.request.contextPath}/customer/customer_actioncenter"
                       class="btn btn-outline-primary">
                        <i class="bi bi-arrow-left-circle"></i> Back to Menu
                    </a>
                </div>
            </div>
        </div>

        <div class="p-4">
            <div class="search-section">
                <h5 class="mb-3"><i class="bi bi-search me-2"></i>Search Contracts</h5>
                <form action="${pageContext.request.contextPath}/customer/contract_history" method="get"
                      class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label">Contract Code</label>
                        <input type="text" class="form-control" name="contractCode"
                               placeholder="Enter contract code...">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Start Date</label>
                        <input type="date" class="form-control" name="startDate">
                    </div>
                    <div class="col-md-4 d-flex align-items-end gap-2">
                        <button type="submit" class="btn btn-primary w-50">
                            <i class="bi bi-search me-1"></i>Search
                        </button>
                        <a href="${pageContext.request.contextPath}/customer/contract_history"
                           class="btn btn-danger w-50">
                            <i class="bi bi-arrow-clockwise me-1"></i>Reset
                        </a>
                    </div>
                </form>

            </div>
        </div>
    </div>

    <div class="contract-summary">
        <div class="card">
            <div class="col-md text-center">
                <h3 class="text-success mb-1" id="totalContracts">${count}</h3>
                <small class="text-muted">Total Contracts</small>
            </div>

        </div>
    </div>

    <!-- Contracts Table -->
    <div class="contract-card">
        <div class="card-header-custom">
            <h5 class="mb-0">
                <i class="bi bi-table me-2"></i>
                Contract List
            </h5>
        </div>
        <div class="table-responsive">
            <table class="table table-hover mb-0" id="contractsTable">
                <thead class="table-dark">
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
                        <td>${contract.contractCode}</td>
                        <td>${contract.startDate}</td>
                        <td>${contract.expiredDate}</td>
                        <td>
                            <button class="btn btn-sm btn-info text-white me-2"
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
    <form method="get" action="${pageContext.request.contextPath}/customer/contract_history">
        <div class="d-flex align-items-center">
            <span class="me-3">Show:</span>
            <select name="itemsPerPage" class="form-select form-select-sm" style="width: auto;"
                    onchange="this.form.submit()">
                <option value="5"  ${recordsPerPage == 5 ? 'selected' : ''}>5</option>
                <option value="10" ${recordsPerPage == 10 ? 'selected' : ''}>10</option>
                <option value="15" ${recordsPerPage == 15 ? 'selected' : ''}>15</option>
                <option value="20" ${recordsPerPage == 20 ? 'selected' : ''}>20</option>
            </select>
        </div>
    </form>
    <!-- Pagination -->
    <nav class="mt-4">
        <ul class="pagination justify-content-center">

            <!-- Previous -->
            <c:if test="${currentPage > 1}">
                <li class="page-item">
                    <a class="page-link"
                       href="${pageContext.request.contextPath}/customer/contract_history?page=${currentPage - 1}&itemsPerPage=${recordsPerPage}&contractCode=${contractCodeSearch}&startDate=${startDateSearch}">
                        Previous
                    </a>
                </li>
            </c:if>

            <!-- Các số trang -->
            <c:forEach begin="1" end="${totalPages}" var="i">
                <li class="page-item ${i == currentPage ? 'active' : ''}">
                    <a class="page-link"
                       href="${pageContext.request.contextPath}/customer/contract_history?page=${i}&itemsPerPage=${recordsPerPage}&contractCode=${contractCodeSearch}&startDate=${startDateSearch}">
                            ${i}
                    </a>
                </li>
            </c:forEach>

            <!-- Next -->
            <c:if test="${currentPage < totalPages}">
                <li class="page-item">
                    <a class="page-link"
                       href="${pageContext.request.contextPath}/customer/contract_history?page=${currentPage + 1}&itemsPerPage=${recordsPerPage}&contractCode=${contractCode}&startDate=${startDateSearch}">
                        Next
                    </a>
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
                <h5 class="modal-title" id="contractModalLabel">Contract Image</h5>
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

<script src="${pageContext.request.contextPath}/js/view-contract-detail.js" ></script>
</body>

</html>