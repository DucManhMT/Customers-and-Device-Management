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
<%@ page import="crm.common.model.enums.ProductRequestStatus" %>
<%@ page import="crm.common.model.enums.ProductStatus" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Warehouse Export Requests</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/warehouse_keeper/export_product.css">
</head>
<body>
<div class="container-fluid py-4">
    <div class="row">
        <div class="col-12">
            <div class="card shadow mb-4">
                <div class="card-header bg-primary text-white">
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="d-flex align-items-center gap-3">
                            <!-- Back Button -->
                            <a href="${pageContext.request.contextPath}/warehouse_keeper/view_warehouse_product_requests"
                               class="btn btn-light back-button">
                                <i class="bi bi-arrow-left-circle"></i> Back
                            </a>
                            <!-- Page Title -->
                            <h4 class="mb-0">
                                <i class="bi bi-box-seam"></i> Warehouse Export Request
                            </h4>
                        </div>
                        <!-- Export Counter -->
                        <div>
                                <span class="badge bg-light text-dark export-count-badge">
                                    <i class="bi bi-cart-check"></i> Exported: <span id="exportedCount">0</span> / <span id="requiredQty">${not empty productRequests ? productRequests.quantity : 0}</span>
                                </span>
                        </div>
                    </div>
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

                    <!-- Main Request Information -->
                    <div class="table-responsive">
                        <table class="table table-hover table-bordered align-middle">
                            <thead class="table-light">
                            <tr>
                                <th style="width: 12%">Request ID</th>
                                <th style="width: 15%">Product</th>
                                <th style="width: 8%">Quantity</th>
                                <th style="width: 12%">Request Date</th>
                                <th style="width: 10%">Status</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${empty productRequests}">
                                    <tr>
                                        <td colspan="5" class="text-center py-4">
                                            <i class="bi bi-inbox" style="font-size: 3rem; color: #ccc;"></i>
                                            <p class="mt-2 text-muted">No warehouse requests found</p>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="request" value="${productRequests}"/>
                                    <tr>
                                        <td><strong>${request.request.requestID}</strong></td>
                                        <td>${request.product.productName}</td>
                                        <td class="text-center">
                                            <span class="badge bg-secondary" id="requestedQtyBadge">${request.quantity}</span>
                                        </td>
                                        <td>${request.requestDate}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${request.status == ProductRequestStatus.Pending}">
                                                        <span class="badge bg-warning text-dark">
                                                            <i class="bi bi-clock"></i> Pending
                                                        </span>
                                                </c:when>
                                                <c:when test="${request.status == ProductRequestStatus.Approved}">
                                                        <span class="badge bg-success">
                                                            <i class="bi bi-check-circle"></i> Approved
                                                        </span>
                                                </c:when>
                                                <c:when test="${request.status == ProductRequestStatus.Finished}">
                                                        <span class="badge bg-info">
                                                            <i class="bi bi-check-all"></i> Finished
                                                        </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">${request.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Products to be Exported Section -->
                    <div class="mt-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="mb-0">
                                <i class="bi bi-box-arrow-up"></i> Products to be Exported
                            </h5>
                            <button type="button" class="btn btn-success" id="confirmExportBtn" style="display: none;" onclick="submitExport()">
                                <i class="bi bi-check-circle"></i> Confirm Export
                            </button>
                        </div>

                        <!-- Quantity Warning Alert -->
                        <div id="quantityAlert" class="alert alert-warning d-none mb-3" role="alert">
                            <i class="bi bi-exclamation-triangle-fill"></i>
                            <strong>Limit Reached!</strong> You have added the maximum quantity required for this request.
                        </div>

                        <div id="exportedProductsList" class="border rounded p-3 bg-light">
                            <div id="emptyExportMessage" class="text-center text-muted py-3">
                                <i class="bi bi-inbox" style="font-size: 2rem;"></i>
                                <p class="mb-0">No products added yet. Select items from the warehouse below.</p>
                            </div>
                            <div id="exportedItemsContainer" style="display: none;">
                                <div class="table-responsive">
                                    <table class="table table-sm table-bordered mb-0">
                                        <thead class="table-success">
                                        <tr>
                                            <th style="width: 10%">#</th>
                                            <th style="width: 60%">Serial Number</th>
                                            <th style="width: 20%">Status</th>
                                            <th style="width: 10%">Action</th>
                                        </tr>
                                        </thead>
                                        <tbody id="exportedItemsBody">
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Warehouse Product List Section -->
            <div class="card shadow">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0">
                        <i class="bi bi-database"></i> Available Warehouse Products
                    </h5>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <p class="mb-1"><strong>Total Quantity in Warehouse:</strong>
                            <span class="badge bg-info" id="totalWarehouseQty">
                                    <c:choose>
                                        <c:when test="${not empty warehouseProducts}">
                                            ${warehouseProducts.size()}
                                        </c:when>
                                        <c:otherwise>0</c:otherwise>
                                    </c:choose>
                                </span>
                        </p>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-hover table-bordered align-middle">
                            <thead class="table-light">
                            <tr>
                                <th style="width: 10%">#</th>
                                <th style="width: 60%">Serial Number</th>
                                <th style="width: 20%">Status</th>
                                <th style="width: 10%">Action</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${empty warehouseProducts}">
                                    <tr>
                                        <td colspan="4" class="text-center py-4">
                                            <i class="bi bi-archive" style="font-size: 3rem; color: #ccc;"></i>
                                            <p class="mt-2 text-muted">No products available in warehouse</p>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="product" items="${warehouseProducts}" varStatus="status">
                                        <tr class="warehouse-item" id="warehouse-row-${product.productWarehouseID}">
                                            <td class="text-center">${status.index + 1}</td>
                                            <td>
                                                <strong>${product.inventoryItem.serialNumber}</strong>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${product.productStatus == ProductStatus.In_Stock}">
                                                            <span class="badge bg-success status-badge">
                                                                <i class="bi bi-check-circle"></i> In Stock
                                                            </span>
                                                    </c:when>
                                                    <c:when test="${product.productStatus == ProductStatus.Exported}">
                                                            <span class="badge bg-warning text-dark status-badge">
                                                                <i class="bi bi-box-arrow-up"></i> Exported
                                                            </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary status-badge">${product.productStatus}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${product.productStatus == ProductStatus.In_Stock}">
                                                        <button type="button"
                                                                class="btn btn-sm btn-primary add-btn"
                                                                id="add-btn-${product.productWarehouseID}"
                                                                data-warehouse-id="${product.productWarehouseID}"
                                                                data-item-id="${product.inventoryItem.itemId}"
                                                                data-serial="${product.inventoryItem.serialNumber}"
                                                                onclick="addToExport('${product.productWarehouseID}', '${product.inventoryItem.itemId}', '${product.inventoryItem.serialNumber}')">
                                                            <i class="bi bi-plus-circle"></i> Add
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button type="button" class="btn btn-sm btn-secondary" disabled>
                                                            <i class="bi bi-ban"></i> Unavailable
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Hidden Form for Submission -->
<form id="exportForm" method="POST" action="${pageContext.request.contextPath}/warehouse_keeper/export_product_controller">
    <c:if test="${not empty productRequests}">
        <input type="hidden" name="productRequestID" value="${productRequests.productRequestID}">
    </c:if>
    <div id="exportedItemsInputs"></div>
</form>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom JavaScript -->
<script>
    // ========================================
    // GLOBAL VARIABLES
    // ========================================
    var requiredQuantity = 0;
    var exportedCount = 0;

    // Store objects with both productWarehouseID and itemId
    var exportedProducts = [];

    // ========================================
    // INITIALIZE ON PAGE LOAD
    // ========================================
    window.addEventListener('DOMContentLoaded', function() {
        // Get required quantity from page
        var qtyElement = document.getElementById('requiredQty');
        if (qtyElement) {
            requiredQuantity = parseInt(qtyElement.innerText) || 0;
        }

        // Auto-dismiss alerts after 5 seconds
        setTimeout(function() {
            var alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                try {
                    new bootstrap.Alert(alert).close();
                } catch (e) {
                    // Ignore if already closed
                }
            });
        }, 5000);
    });

    // ========================================
    // ADD PRODUCT TO EXPORT LIST
    // ========================================
    function addToExport(productWarehouseID, itemId, serialNumber) {
        // Check if limit reached
        if (exportedCount >= requiredQuantity) {
            alert('Cannot add more items! Maximum quantity reached.');
            return;
        }

        // Check if already added
        var alreadyAdded = false;
        for (var i = 0; i < exportedProducts.length; i++) {
            if (exportedProducts[i].productWarehouseID === productWarehouseID) {
                alreadyAdded = true;
                break;
            }
        }

        if (alreadyAdded) {
            alert('This product is already added!');
            return;
        }

        // Add to array with both IDs
        exportedProducts.push({
            productWarehouseID: productWarehouseID,
            itemId: itemId,
            serialNumber: serialNumber
        });

        exportedCount++;

        // Update counter badge
        var countElement = document.getElementById('exportedCount');
        if (countElement) {
            countElement.innerText = exportedCount;
        }

        // Show/hide sections
        var emptyMessage = document.getElementById('emptyExportMessage');
        var container = document.getElementById('exportedItemsContainer');
        var confirmBtn = document.getElementById('confirmExportBtn');

        if (emptyMessage) emptyMessage.style.display = 'none';
        if (container) container.style.display = 'block';
        if (confirmBtn) confirmBtn.style.display = 'block';

        // Check if limit reached
        if (exportedCount >= requiredQuantity) {
            showQuantityAlert();
            disableAllAddButtons();
        }

        // Add row to exported table
        addExportedRow(productWarehouseID, serialNumber);

        // Update warehouse row style
        updateWarehouseRow(productWarehouseID, true);

        // Update add button
        updateAddButton(productWarehouseID, true);
    }

    // ========================================
    // REMOVE PRODUCT FROM EXPORT LIST
    // ========================================
    function removeFromExport(productWarehouseID) {
        // Remove from array
        var newArray = [];
        for (var i = 0; i < exportedProducts.length; i++) {
            if (exportedProducts[i].productWarehouseID !== productWarehouseID) {
                newArray.push(exportedProducts[i]);
            }
        }
        exportedProducts = newArray;

        // Decrease counter
        exportedCount--;

        // Update counter badge
        var countElement = document.getElementById('exportedCount');
        if (countElement) {
            countElement.innerText = exportedCount;
        }

        // Remove row from table
        var row = document.getElementById('exported-item-' + productWarehouseID);
        if (row) {
            row.remove();
        }

        // Renumber remaining rows
        renumberExportedRows();

        // Check if below limit
        if (exportedCount < requiredQuantity) {
            hideQuantityAlert();
            enableAllAddButtons();
        }

        // Update warehouse row style
        updateWarehouseRow(productWarehouseID, false);

        // Update add button
        updateAddButton(productWarehouseID, false);

        // Check if list is empty
        if (exportedCount === 0) {
            var emptyMessage = document.getElementById('emptyExportMessage');
            var container = document.getElementById('exportedItemsContainer');
            var confirmBtn = document.getElementById('confirmExportBtn');

            if (emptyMessage) emptyMessage.style.display = 'block';
            if (container) container.style.display = 'none';
            if (confirmBtn) confirmBtn.style.display = 'none';
        }
    }

    // ========================================
    // ADD ROW TO EXPORTED TABLE
    // ========================================
    function addExportedRow(productWarehouseID, serialNumber) {
        var tbody = document.getElementById('exportedItemsBody');
        if (!tbody) return;

        var row = document.createElement('tr');
        row.id = 'exported-item-' + productWarehouseID;
        row.innerHTML =
            '<td class="text-center">' + exportedCount + '</td>' +
            '<td><strong>' + serialNumber + '</strong></td>' +
            '<td><span class="badge bg-success status-badge"><i class="bi bi-check-circle"></i> In Stock</span></td>' +
            '<td class="text-center">' +
            '<button type="button" class="btn btn-sm btn-danger" onclick="removeFromExport(\'' + productWarehouseID + '\')">' +
            '<i class="bi bi-trash"></i>' +
            '</button>' +
            '</td>';

        tbody.appendChild(row);
    }

    // ========================================
    // RENUMBER EXPORTED ROWS
    // ========================================
    function renumberExportedRows() {
        var tbody = document.getElementById('exportedItemsBody');
        if (!tbody) return;

        var rows = tbody.querySelectorAll('tr');
        rows.forEach(function(row, index) {
            var firstCell = row.querySelector('td:first-child');
            if (firstCell) {
                firstCell.innerText = (index + 1);
            }
        });
    }

    // ========================================
    // UPDATE WAREHOUSE ROW STYLE
    // ========================================
    function updateWarehouseRow(productWarehouseID, isAdded) {
        var row = document.getElementById('warehouse-row-' + productWarehouseID);
        if (!row) return;

        if (isAdded) {
            row.classList.add('row-added');
        } else {
            row.classList.remove('row-added');
        }
    }

    // ========================================
    // UPDATE ADD BUTTON
    // ========================================
    function updateAddButton(productWarehouseID, isAdded) {
        var button = document.getElementById('add-btn-' + productWarehouseID);
        if (!button) return;

        if (isAdded) {
            button.disabled = true;
            button.classList.remove('btn-primary');
            button.classList.add('btn-secondary');
            button.innerHTML = '<i class="bi bi-check2"></i> Added';
        } else {
            button.disabled = false;
            button.classList.remove('btn-secondary');
            button.classList.add('btn-primary');
            button.innerHTML = '<i class="bi bi-plus-circle"></i> Add';
        }
    }

    // ========================================
    // DISABLE ALL ADD BUTTONS
    // ========================================
    function disableAllAddButtons() {
        var buttons = document.querySelectorAll('.add-btn:not(:disabled)');
        buttons.forEach(function(button) {
            button.disabled = true;
            button.classList.remove('btn-primary');
            button.classList.add('btn-secondary');
            button.innerHTML = '<i class="bi bi-ban"></i> Limit';
        });
    }

    // ========================================
    // ENABLE ALL ADD BUTTONS
    // ========================================
    function enableAllAddButtons() {
        var buttons = document.querySelectorAll('.add-btn');
        buttons.forEach(function(button) {
            var warehouseID = button.getAttribute('data-warehouse-id');

            // Check if this product is in exported list
            var isExported = false;
            for (var i = 0; i < exportedProducts.length; i++) {
                if (exportedProducts[i].productWarehouseID === warehouseID) {
                    isExported = true;
                    break;
                }
            }

            // Only enable if not in exported list
            if (!isExported) {
                button.disabled = false;
                button.classList.remove('btn-secondary');
                button.classList.add('btn-primary');
                button.innerHTML = '<i class="bi bi-plus-circle"></i> Add';
            }
        });
    }

    // ========================================
    // SHOW/HIDE QUANTITY ALERT
    // ========================================
    function showQuantityAlert() {
        var alert = document.getElementById('quantityAlert');
        if (alert) {
            alert.classList.remove('d-none');
        }
    }

    function hideQuantityAlert() {
        var alert = document.getElementById('quantityAlert');
        if (alert) {
            alert.classList.add('d-none');
        }
    }

    // ========================================
    // SUBMIT EXPORT FORM
    // ========================================
    function submitExport() {
        // Check if any products selected
        if (exportedProducts.length === 0) {
            alert('Please add at least one product to export!');
            return;
        }

        // Get form and container
        var form = document.getElementById('exportForm');
        var container = document.getElementById('exportedItemsInputs');

        if (!form || !container) {
            alert('Form error. Please refresh the page.');
            return;
        }

        // Clear previous inputs
        container.innerHTML = '';

        // Add hidden input for each product's itemId
        for (var i = 0; i < exportedProducts.length; i++) {
            var input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'itemIds';
            input.value = exportedProducts[i].itemId;
            container.appendChild(input);
        }

        // Submit form
        form.submit();
    }
</script>
</body>
</html>