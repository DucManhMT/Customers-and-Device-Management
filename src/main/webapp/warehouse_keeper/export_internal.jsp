<%--
  Created by IntelliJ IDEA.
  User: DucManhMT
  Date: 11/7/2025
  Time: 8:06 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Internal Export Requests</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%-- Bootstrap 5 CSS --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <%-- Font Awesome for icons --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .main-content {
            padding: 2rem;
        }
        .request-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
            gap: 1.5rem;
        }
        .request-card {
            border: 1px solid #dee2e6;
            border-radius: 0.5rem;
            transition: box-shadow 0.2s ease;
        }
        .request-card:hover {
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        .status-badge {
            font-size: 0.9em;
        }
        .modal-body .table-responsive {
            max-height: 400px;
        }
    </style>
</head>
<body>
<%-- Include Header and Sidebar --%>
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>

<div class="main-content">
    <div class="container-fluid">
        <h2 class="mb-4">Internal Export Requests</h2>

        <div class="request-grid">
            <c:if test="${empty warehouseRequests}">
                <div class="alert alert-info w-100">There are no pending export requests for your warehouse.</div>
            </c:if>

            <c:forEach var="req" items="${warehouseRequests}">
                <div class="card request-card">
                    <div class="card-header bg-light d-flex justify-content-between align-items-center">
                        <span>Request Date: ${req.date}</span>
                        <c:set var="statusClass" value="bg-secondary"/>
                        <c:if test="${req.warehouseRequestStatus == 'Pending'}"><c:set var="statusClass" value="bg-warning text-dark"/></c:if>
                        <c:if test="${req.warehouseRequestStatus == 'Processing'}"><c:set var="statusClass" value="bg-info text-dark"/></c:if>
                        <c:if test="${req.warehouseRequestStatus == 'Accepted'}"><c:set var="statusClass" value="bg-success"/></c:if>
                        <c:if test="${req.warehouseRequestStatus == 'Rejected'}"><c:set var="statusClass" value="bg-danger"/></c:if>
                        <span class="badge ${statusClass} status-badge">${req.warehouseRequestStatus}</span>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <small class="text-muted">From</small>
                                    <p class="fw-bold mb-0">${req.sourceWarehouse != null ? req.sourceWarehouse.warehouseName : 'Not Assigned'}</p>
                                </div>
                                <div class="align-self-center px-2">
                                    <i class="fas fa-arrow-right text-primary"></i>
                                </div>
                                <div class="text-end">
                                    <small class="text-muted">To</small>
                                    <p class="fw-bold mb-0">${req.destinationWarehouse.warehouseName}</p>
                                </div>
                            </div>
                        </div>
                        <hr>
                        <h6 class="card-subtitle mb-2 text-muted">Requested Product:</h6>
                        <div class="d-flex justify-content-between align-items-center p-2 mb-3 bg-light rounded">
                            <span>${req.product.productName}</span>
                            <span class="badge bg-primary rounded-pill">Qty: ${req.quantity}</span>
                        </div>

                        <c:if test="${not empty req.note}">
                            <p class="card-text small fst-italic"><strong>Note:</strong> ${req.note}</p>
                        </c:if>

                        <c:if test="${req.warehouseRequestStatus == 'Accepted'}">
                            <button type="button" class="btn btn-primary w-100" data-bs-toggle="modal"
                                    data-bs-target="#exportModal-${req.warehouseRequestID}">
                                <i class="fas fa-dolly-flatbed me-2"></i>Prepare for Export
                            </button>
                        </c:if>
                        <c:if test="${req.warehouseRequestStatus != 'Accepted'}">
                            <button type="button" class="btn btn-outline-secondary w-100" disabled>
                                Awaiting Approval
                            </button>
                        </c:if>
                    </div>
                </div>

                <!-- Export Modal -->
                <div class="modal fade" id="exportModal-${req.warehouseRequestID}" tabindex="-1"
                     aria-labelledby="exportModalLabel-${req.warehouseRequestID}" aria-hidden="true" data-required-qty="${req.quantity}">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <form action="${pageContext.request.contextPath}/warehouse_keeper/export_internal" method="post">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="exportModalLabel-${req.warehouseRequestID}">
                                        Export: ${req.product.productName} (Qty: ${req.quantity})
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <input type="hidden" name="warehouseRequestID" value="${req.warehouseRequestID}">
                                    <p>Select <strong>${req.quantity}</strong> item(s) from your stock to export.</p>
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead>
                                            <tr>
                                                <th class="text-center">Select</th>
                                                <th>Serial Number</th>
                                                <th>Item Name</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:forEach var="productInStock" items="${availableProducts}">
                                                <c:if test="${productInStock.inventoryItem.product.productID == req.product.productID}">
                                                    <tr>
                                                        <td class="text-center">
                                                            <input class="form-check-input product-checkbox" type="checkbox" name="selectedProducts"
                                                                   value="${productInStock.productWarehouseID}">
                                                        </td>
                                                        <td>${productInStock.inventoryItem.serialNumber}</td>
                                                        <td>${productInStock.inventoryItem.product.productName}</td>
                                                    </tr>
                                                </c:if>
                                            </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                    <div class="mt-2">
                                        Selected: <span class="fw-bold current-selection">0</span> / ${req.quantity}
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                    <button type="submit" class="btn btn-success confirm-export-btn" disabled>
                                        <i class="fas fa-check-circle me-2"></i>Confirm Export
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<%-- Bootstrap 5 JS Bundle --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const exportModals = document.querySelectorAll('.modal[id^="exportModal-"]');

        exportModals.forEach(modal => {
            const requiredQty = parseInt(modal.dataset.requiredQty, 10);
            const checkboxes = modal.querySelectorAll('.product-checkbox');
            const confirmBtn = modal.querySelector('.confirm-export-btn');
            const selectionCounter = modal.querySelector('.current-selection');

            modal.addEventListener('change', function (e) {
                if (e.target.classList.contains('product-checkbox')) {
                    const checkedBoxes = modal.querySelectorAll('.product-checkbox:checked');
                    const selectedCount = checkedBoxes.length;

                    // Update counter
                    selectionCounter.textContent = selectedCount;

                    // Enable/disable confirm button
                    confirmBtn.disabled = (selectedCount !== requiredQty);

                    // Disable other checkboxes if limit is reached
                    if (selectedCount >= requiredQty) {
                        checkboxes.forEach(cb => {
                            if (!cb.checked) {
                                cb.disabled = true;
                            }
                        });
                    } else {
                        // Re-enable all checkboxes if selection is below limit
                        checkboxes.forEach(cb => {
                            cb.disabled = false;
                        });
                    }
                }
            });

            // Reset on modal close
            modal.addEventListener('hidden.bs.modal', function () {
                checkboxes.forEach(cb => {
                    cb.checked = false;
                    cb.disabled = false;
                });
                confirmBtn.disabled = true;
                selectionCounter.textContent = '0';
            });
        });
    });
</script>
</body>
</html>
