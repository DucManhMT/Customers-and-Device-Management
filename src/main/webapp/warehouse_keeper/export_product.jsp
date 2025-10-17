<%--
  Created by IntelliJ IDEA.
  User: MasterLong
  Date: 10/17/2025
  Time: 5:37 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Warehouse Export Requests</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
</head>
<body>
<div class="container-fluid py-4">
    <div class="row">
        <div class="col-12">
            <div class="card shadow">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0">
                        <i class="bi bi-box-seam"></i> Warehouse Export Requests
                    </h4>
                </div>
                <div class="card-body">
                    <!-- Alert Messages -->
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="bi bi-check-circle"></i> ${successMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle"></i> ${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- Search and Filter Section -->
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <input type="text" class="form-control" id="searchInput" placeholder="Search by request ID or customer...">
                        </div>
                        <div class="col-md-4">
                            <select class="form-select" id="statusFilter">
                                <option value="">All Status</option>
                                <option value="pending">Pending</option>
                                <option value="confirmed">Confirmed</option>
                                <option value="completed">Completed</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <button class="btn btn-secondary w-100" onclick="resetFilters()">
                                <i class="bi bi-arrow-clockwise"></i> Reset
                            </button>
                        </div>
                    </div>

                    <!-- Warehouse Requests Table -->
                    <div class="table-responsive">
                        <table class="table table-hover table-bordered align-middle">
                            <thead class="table-light">
                            <tr>
                                <th style="width: 5%">#</th>
                                <th style="width: 12%">Request ID</th>
                                <th style="width: 18%">Customer</th>
                                <th style="width: 15%">Product</th>
                                <th style="width: 8%">Quantity</th>
                                <th style="width: 12%">Request Date</th>
                                <th style="width: 10%">Status</th>
                                <th style="width: 20%">Action</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${empty warehouseRequests}">
                                    <tr>
                                        <td colspan="8" class="text-center py-4">
                                            <i class="bi bi-inbox" style="font-size: 3rem; color: #ccc;"></i>
                                            <p class="mt-2 text-muted">No warehouse requests found</p>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="request" items="${warehouseRequests}" varStatus="status">
                                        <tr>
                                            <td class="text-center">${status.index + 1}</td>
                                            <td><strong>${request.requestId}</strong></td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <i class="bi bi-person-circle me-2"></i>
                                                        ${request.customerName}
                                                </div>
                                            </td>
                                            <td>${request.productName}</td>
                                            <td class="text-center">
                                                <span class="badge bg-secondary">${request.quantity}</span>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${request.requestDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${request.status == 'pending'}">
                                                                <span class="badge bg-warning text-dark">
                                                                    <i class="bi bi-clock"></i> Pending
                                                                </span>
                                                    </c:when>
                                                    <c:when test="${request.status == 'confirmed'}">
                                                                <span class="badge bg-success">
                                                                    <i class="bi bi-check-circle"></i> Confirmed
                                                                </span>
                                                    </c:when>
                                                    <c:when test="${request.status == 'completed'}">
                                                                <span class="badge bg-info">
                                                                    <i class="bi bi-check-all"></i> Completed
                                                                </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">${request.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="d-flex gap-2 justify-content-end">
                                                    <button class="btn btn-sm btn-info"
                                                            onclick="viewDetails('${request.requestId}')"
                                                            title="View Details">
                                                        <i class="bi bi-eye"></i>
                                                    </button>
                                                    <c:if test="${request.status == 'pending'}">
                                                        <button class="btn btn-sm btn-success"
                                                                onclick="confirmExport('${request.requestId}', '${request.customerName}', '${request.productName}')"
                                                                title="Confirm Export">
                                                            <i class="bi bi-check-circle"></i> Confirm
                                                        </button>
                                                    </c:if>
                                                    <c:if test="${request.status == 'confirmed'}">
                                                                <span class="badge bg-success p-2">
                                                                    <i class="bi bi-check2"></i> Confirmed
                                                                </span>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${not empty warehouseRequests}">
                        <nav aria-label="Page navigation">
                            <ul class="pagination justify-content-center">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage - 1}">Previous</a>
                                </li>
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="?page=${i}">${i}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage + 1}">Next</a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Confirmation Modal -->
<div class="modal fade" id="confirmModal" tabindex="-1" aria-labelledby="confirmModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-warning">
                <h5 class="modal-title" id="confirmModalLabel">
                    <i class="bi bi-exclamation-triangle"></i> Confirm Export
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p class="mb-3">Are you sure you want to confirm this export request?</p>
                <div class="card bg-light">
                    <div class="card-body">
                        <p class="mb-1"><strong>Request ID:</strong> <span id="modalRequestId"></span></p>
                        <p class="mb-1"><strong>Customer:</strong> <span id="modalCustomer"></span></p>
                        <p class="mb-0"><strong>Product:</strong> <span id="modalProduct"></span></p>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="bi bi-x-circle"></i> Cancel
                </button>
                <form id="confirmForm" method="POST" action="${pageContext.request.contextPath}/warehouse/confirm-export" style="display: inline;">
                    <input type="hidden" name="requestId" id="confirmRequestId">
                    <button type="submit" class="btn btn-success">
                        <i class="bi bi-check-circle"></i> Confirm Export
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom JavaScript -->
<script>
    // Confirm Export Function
    function confirmExport(requestId, customerName, productName) {
        document.getElementById('modalRequestId').textContent = requestId;
        document.getElementById('modalCustomer').textContent = customerName;
        document.getElementById('modalProduct').textContent = productName;
        document.getElementById('confirmRequestId').value = requestId;

        const confirmModal = new bootstrap.Modal(document.getElementById('confirmModal'));
        confirmModal.show();
    }

    // View Details Function
    function viewDetails(requestId) {
        window.location.href = '${pageContext.request.contextPath}/warehouse/view-request?id=' + requestId;
    }

    // Search Functionality
    document.getElementById('searchInput').addEventListener('keyup', function() {
        const searchValue = this.value.toLowerCase();
        const tableRows = document.querySelectorAll('tbody tr');

        tableRows.forEach(row => {
            const text = row.textContent.toLowerCase();
            row.style.display = text.includes(searchValue) ? '' : 'none';
        });
    });

    // Status Filter
    document.getElementById('statusFilter').addEventListener('change', function() {
        const filterValue = this.value.toLowerCase();
        const tableRows = document.querySelectorAll('tbody tr');

        tableRows.forEach(row => {
            if (filterValue === '') {
                row.style.display = '';
            } else {
                const statusCell = row.querySelector('td:nth-child(7)');
                if (statusCell) {
                    const statusText = statusCell.textContent.toLowerCase();
                    row.style.display = statusText.includes(filterValue) ? '' : 'none';
                }
            }
        });
    });

    // Reset Filters
    function resetFilters() {
        document.getElementById('searchInput').value = '';
        document.getElementById('statusFilter').value = '';
        const tableRows = document.querySelectorAll('tbody tr');
        tableRows.forEach(row => row.style.display = '');
    }

    // Auto-dismiss alerts after 5 seconds
    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(alert => {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        });
    }, 5000);
</script>
</body>
</html>