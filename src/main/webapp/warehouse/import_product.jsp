<%--
  Created by IntelliJ IDEA.
  User: MasterLong
  Date: 10/12/2025
  Time: 8:44 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Import Products - Warehouse</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!-- Bootstrap 5 CSS -->
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
            rel="stylesheet"
            integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
            crossorigin="anonymous"
    />

    <style>
        .table td, .table th { vertical-align: middle; }
        .serial-pill {
            display: inline-flex;
            align-items: center;
            gap: .35rem;
            padding: .25rem .5rem;
            border-radius: 999px;
            background: #e3f2fd;
            border: 1px solid #bbdefb;
            margin: .25rem .25rem .25rem 0;
            font-size: .875rem;
        }
        .import-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .qty-badge {
            font-size: 1rem;
            padding: .5rem .75rem;
        }
    </style>
</head>
<body class="bg-light">
<div class="container-fluid py-4">
    <!-- Header -->
    <div class="row mb-4">
        <div class="col">
            <div class="card import-header border-0 shadow-sm">
                <div class="card-body py-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h1 class="h4 mb-1">Import Products to Warehouse</h1>
                            <p class="mb-0 opacity-75">Manage product imports and serial numbers</p>
                        </div>
                        <div class="d-flex gap-2">
                            <a href="all-products.jsp" class="btn btn-light btn-sm">
                                <i class="bi bi-plus-circle me-1"></i>Add Products
                            </a>
                            <button type="button" class="btn btn-outline-light btn-sm" onclick="clearAllImports()">
                                <i class="bi bi-trash me-1"></i>Clear All
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!--
      Expected request attributes:
      - importProducts: java.util.List<Product> with getters: id, code, name, description, category
      - serialsMap (optional): java.util.Map<ID, java.util.List<String>> mapping product id -> list of serials
      On submit, this form will post per-product serials as multiple parameters named "serials-<productId>"
    -->
    <form method="post" action="process-import.jsp" id="importForm">
        <div class="row">
            <div class="col">
                <div class="card shadow-sm">
                    <div class="card-header bg-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Products to Import</h5>
                        <span class="badge bg-primary" id="totalProductsCount">
              <c:choose>
                  <c:when test="${not empty importProducts}">
                      ${fn:length(importProducts)} products
                  </c:when>
                  <c:otherwise>
                      0 products
                  </c:otherwise>
              </c:choose>
            </span>
                    </div>

                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${empty importProducts}">
                                <div class="text-center py-5">
                                    <div class="mb-3">
                                        <i class="bi bi-inbox display-1 text-muted"></i>
                                    </div>
                                    <h5 class="text-muted">No products selected for import</h5>
                                    <p class="text-muted mb-3">Click "Add Products" to select products from the warehouse catalog</p>
                                    <a href="${pageContext.request.contextPath}/warehouse/add_import_product" class="btn btn-primary">
                                        <i class="bi bi-plus-circle me-2"></i>Add Products
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead class="table-light">
                                        <tr>
                                            <th style="width: 12%;">Code</th>
                                            <th style="width: 25%;">Product Name</th>
                                            <th style="width: 20%;">Category</th>
                                            <th style="width: 12%;">Quantity</th>
                                            <th style="width: 15%;">Actions</th>
                                            <th style="width: 16%;">Serials Preview</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach items="${importProducts}" var="product" varStatus="status">
                                            <tr data-product-id="${product.id}" class="import-row">
                                                <td>
                                                    <span class="fw-semibold text-primary">${product.code}</span>
                                                </td>
                                                <td>
                                                    <div>
                                                        <div class="fw-medium">${product.name}</div>
                                                        <c:if test="${not empty product.description}">
                                                            <small class="text-muted">${fn:substring(product.description, 0, 50)}
                                                                <c:if test="${fn:length(product.description) > 50}">...</c:if>
                                                            </small>
                                                        </c:if>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="badge bg-secondary">${product.category}</span>
                                                </td>
                                                <td>
                                                    <span class="badge bg-success qty-badge qty-display">0</span>
                                                    <!-- Hidden inputs for form submission -->
                                                    <input type="hidden" class="qty-hidden" name="quantity-${product.id}" value="0">
                                                </td>
                                                <td>
                                                    <div class="btn-group" role="group">
                                                        <button type="button"
                                                                class="btn btn-sm btn-outline-primary js-open-serials-modal"
                                                                data-product-id="${product.id}"
                                                                data-product-name="${product.name}"
                                                                data-product-code="${product.code}">
                                                            <i class="bi bi-tags me-1"></i>Serials
                                                        </button>
                                                        <button type="button"
                                                                class="btn btn-sm btn-outline-danger js-remove-product"
                                                                data-product-id="${product.id}"
                                                                title="Remove from import list">
                                                            <i class="bi bi-trash"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="js-serials-preview text-muted small">
                                                        <span class="fst-italic">No serials</span>
                                                    </div>
                                                </td>

                                                <!-- Hidden inputs holder for this product's serials -->
                                                <td class="d-none">
                                                    <div id="hidden-serials-inputs-${product.id}" class="hidden-serials-inputs">
                                                        <c:if test="${not empty serialsMap and not empty serialsMap[product.id]}">
                                                            <c:forEach items="${serialsMap[product.id]}" var="serial">
                                                                <input type="hidden" name="serials-${product.id}" value="${serial}">
                                                            </c:forEach>
                                                        </c:if>
                                                    </div>
                                                    <input type="hidden" name="productIds" value="${product.id}">
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <c:if test="${not empty importProducts}">
                        <div class="card-footer bg-light">
                            <div class="d-flex justify-content-between align-items-center">
                                <div class="text-muted">
                                    <small>Total items: <span id="totalItemsCount">0</span></small>
                                </div>
                                <div class="d-flex gap-2">
                                    <a href="warehouse-dashboard.jsp" class="btn btn-outline-secondary">
                                        <i class="bi bi-arrow-left me-1"></i>Back to Dashboard
                                    </a>
                                    <button type="submit" class="btn btn-success" id="submitBtn">
                                        <i class="bi bi-download me-1"></i>Process Import
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </form>
</div>

<!-- Serials Management Modal -->
<div class="modal fade" id="serialsModal" tabindex="-1" aria-labelledby="serialsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="serialsModalLabel">
                    <i class="bi bi-tags me-2"></i>Manage Serial Numbers
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body">
                <div class="mb-3">
                    <div class="d-flex align-items-center gap-2 mb-2">
                        <strong>Product:</strong>
                        <span class="badge bg-secondary" id="modalProductCode"></span>
                        <span id="modalProductName" class="text-primary fw-medium"></span>
                    </div>
                </div>

                <div id="serialsAlert" class="alert alert-danger d-none" role="alert"></div>

                <!-- Add Serial Input -->
                <div class="card mb-3">
                    <div class="card-header bg-light">
                        <h6 class="mb-0">Add New Serial</h6>
                    </div>
                    <div class="card-body">
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-upc-scan"></i></span>
                            <input type="text"
                                   id="serialInput"
                                   class="form-control"
                                   placeholder="Enter serial number (e.g., SN123456)"
                                   maxlength="50" />
                            <button type="button" id="addSerialBtn" class="btn btn-primary">
                                <i class="bi bi-plus-lg"></i> Add
                            </button>
                        </div>
                        <div class="form-text">Press Enter or click Add to include the serial number</div>
                    </div>
                </div>

                <!-- Current Serials -->
                <div class="card">
                    <div class="card-header bg-light d-flex justify-content-between align-items-center">
                        <h6 class="mb-0">Current Serial Numbers</h6>
                        <span class="badge bg-info" id="serialsCount">0</span>
                    </div>
                    <div class="card-body">
                        <div id="serialsContainer" class="d-flex flex-wrap gap-2 min-height-50">
                            <!-- Serials will be populated here by JavaScript -->
                        </div>
                    </div>
                </div>

                <div class="mt-3">
                    <small class="text-muted">
                        <i class="bi bi-info-circle me-1"></i>
                        Each serial number must be unique. The quantity will automatically update based on the number of serials added.
                    </small>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-outline-danger" id="clearAllSerialsBtn">
                    <i class="bi bi-trash me-1"></i>Clear All
                </button>
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                    Cancel
                </button>
                <button type="button" class="btn btn-primary" data-bs-dismiss="modal">
                    <i class="bi bi-check-lg me-1"></i>Done
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap 5 JS Bundle -->
<script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>

<!-- Bootstrap Icons -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

<script>
    // Store serials per product in-memory
    const serialsStore = {};
    let currentProductId = null;
    let serialsModalInstance = null;

    // Utility functions
    function showAlert(msg) {
        const alert = document.getElementById('serialsAlert');
        alert.textContent = msg || '';
        alert.classList.remove('d-none');
    }

    function hideAlert() {
        const alert = document.getElementById('serialsAlert');
        alert.classList.add('d-none');
        alert.textContent = '';
    }

    function getProductRow(productId) {
        return document.querySelector('tr[data-product-id="' + CSS.escape(productId) + '"]');
    }

    function updateQuantityDisplay(productId) {
        const row = getProductRow(productId);
        if (!row) return;

        const qty = (serialsStore[productId] || []).length;
        const qtyDisplay = row.querySelector('.qty-display');
        const qtyHidden = row.querySelector('.qty-hidden');

        if (qtyDisplay) qtyDisplay.textContent = qty;
        if (qtyHidden) qtyHidden.value = qty;

        // Update serials preview
        const preview = row.querySelector('.js-serials-preview');
        if (preview) {
            const serials = serialsStore[productId] || [];
            if (serials.length === 0) {
                preview.innerHTML = '<span class="fst-italic">No serials</span>';
            } else if (serials.length <= 2) {
                preview.innerHTML = serials.map(s => '<code class="small">' + escapeHtml(s) + '</code>').join(', ');
            } else {
                preview.innerHTML = serials.slice(0, 2).map(s => '<code class="small">' + escapeHtml(s) + '</code>').join(', ') +
                    ' <span class="text-primary">+' + (serials.length - 2) + ' more</span>';
            }
        }

        updateTotalCounts();
    }

    function updateTotalCounts() {
        const totalItems = Object.values(serialsStore).reduce((sum, serials) => sum + serials.length, 0);
        const totalItemsElement = document.getElementById('totalItemsCount');
        if (totalItemsElement) {
            totalItemsElement.textContent = totalItems;
        }
    }

    function syncHiddenInputs(productId) {
        const container = document.getElementById('hidden-serials-inputs-' + productId);
        if (!container) return;

        // Clear existing hidden inputs
        container.innerHTML = '';

        // Add serials
        (serialsStore[productId] || []).forEach(serial => {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'serials-' + productId;
            input.value = serial;
            container.appendChild(input);
        });

        // Keep product ID
        const productIdInput = document.createElement('input');
        productIdInput.type = 'hidden';
        productIdInput.name = 'productIds';
        productIdInput.value = productId;
        container.appendChild(productIdInput);
    }

    function renderSerialsInModal() {
        const container = document.getElementById('serialsContainer');
        const countBadge = document.getElementById('serialsCount');
        container.innerHTML = '';

        const serials = serialsStore[currentProductId] || [];
        countBadge.textContent = serials.length;

        if (serials.length === 0) {
            const emptyState = document.createElement('div');
            emptyState.className = 'text-muted text-center w-100 py-3';
            emptyState.innerHTML = '<i class="bi bi-inbox display-6 d-block mb-2"></i>No serial numbers added yet';
            container.appendChild(emptyState);
            return;
        }

        serials.forEach((serial, index) => {
            const pill = document.createElement('div');
            pill.className = 'serial-pill d-flex align-items-center';

            const serialText = document.createElement('span');
            serialText.className = 'me-2';
            serialText.textContent = serial;

            const removeBtn = document.createElement('button');
            removeBtn.type = 'button';
            removeBtn.className = 'btn btn-outline-danger btn-sm py-0 px-1';
            removeBtn.title = 'Remove serial';
            removeBtn.innerHTML = '<i class="bi bi-x"></i>';
            removeBtn.addEventListener('click', () => removeSerial(index));

            pill.appendChild(serialText);
            pill.appendChild(removeBtn);
            container.appendChild(pill);
        });
    }

    function openSerialsModal(productId, productName, productCode) {
        currentProductId = productId;
        document.getElementById('modalProductName').textContent = productName || 'Unknown Product';
        document.getElementById('modalProductCode').textContent = productCode || 'N/A';
        document.getElementById('serialInput').value = '';
        hideAlert();
        renderSerialsInModal();

        if (!serialsModalInstance) {
            serialsModalInstance = new bootstrap.Modal(document.getElementById('serialsModal'));
        }
        serialsModalInstance.show();

        // Focus on input when modal is shown
        setTimeout(() => {
            document.getElementById('serialInput').focus();
        }, 150);
    }

    function addSerial() {
        const input = document.getElementById('serialInput');
        const serial = (input.value || '').trim();

        if (!serial) {
            showAlert('Please enter a serial number.');
            return;
        }

        // Validate serial format (optional - adjust as needed)
        if (!/^[A-Za-z0-9\-_.#]+$/.test(serial)) {
            showAlert('Serial number can only contain letters, numbers, hyphens, underscores, dots, and hash symbols.');
            return;
        }

        const existingSerials = serialsStore[currentProductId] || [];

        // Check for duplicates (case-insensitive)
        if (existingSerials.some(s => s.toLowerCase() === serial.toLowerCase())) {
            showAlert('This serial number already exists for this product.');
            return;
        }

        hideAlert();
        existingSerials.push(serial);
        serialsStore[currentProductId] = existingSerials;

        input.value = '';
        renderSerialsInModal();
        syncHiddenInputs(currentProductId);
        updateQuantityDisplay(currentProductId);

        // Keep focus on input for rapid entry
        input.focus();
    }

    function removeSerial(index) {
        if (!currentProductId || !serialsStore[currentProductId]) return;

        serialsStore[currentProductId].splice(index, 1);
        renderSerialsInModal();
        syncHiddenInputs(currentProductId);
        updateQuantityDisplay(currentProductId);
    }

    function clearAllSerials() {
        if (!currentProductId) return;

        serialsStore[currentProductId] = [];
        renderSerialsInModal();
        syncHiddenInputs(currentProductId);
        updateQuantityDisplay(currentProductId);
    }

    function removeProduct(productId) {
        const row = getProductRow(productId);
        if (!row) return;

        if (confirm('Are you sure you want to remove this product from the import list?')) {
            // Remove from serials store
            delete serialsStore[productId];

            // Remove row from table
            row.remove();

            // Check if table is now empty
            const remainingRows = document.querySelectorAll('.import-row');
            if (remainingRows.length === 0) {
                location.reload(); // Reload to show empty state
            } else {
                updateTotalCounts();
                // Update product count badge
                const countBadge = document.getElementById('totalProductsCount');
                if (countBadge) {
                    countBadge.textContent = remainingRows.length + ' products';
                }
            }
        }
    }

    function clearAllImports() {
        if (confirm('Are you sure you want to clear all products from the import list? This will remove all products and their serial numbers.')) {
            // Clear all data
            Object.keys(serialsStore).forEach(productId => {
                delete serialsStore[productId];
            });

            // Redirect to reload the page
            window.location.href = window.location.pathname;
        }
    }

    function initializeFromExistingData() {
        // Load existing serials from hidden inputs
        document.querySelectorAll('.hidden-serials-inputs').forEach(container => {
            const productId = container.id.replace('hidden-serials-inputs-', '');
            const serialInputs = container.querySelectorAll('input[name^="serials-"]');
            const serials = [];

            serialInputs.forEach(input => {
                if (input.value.trim()) {
                    serials.push(input.value.trim());
                }
            });

            serialsStore[productId] = serials;
            updateQuantityDisplay(productId);
        });
    }

    function attachEventHandlers() {
        // Open serials modal buttons
        document.querySelectorAll('.js-open-serials-modal').forEach(btn => {
            btn.addEventListener('click', () => {
                openSerialsModal(
                    btn.dataset.productId,
                    btn.dataset.productName,
                    btn.dataset.productCode
                );
            });
        });

        // Remove product buttons
        document.querySelectorAll('.js-remove-product').forEach(btn => {
            btn.addEventListener('click', () => {
                removeProduct(btn.dataset.productId);
            });
        });

        // Modal controls
        document.getElementById('addSerialBtn').addEventListener('click', addSerial);
        document.getElementById('clearAllSerialsBtn').addEventListener('click', clearAllSerials);

        // Enter key support for serial input
        document.getElementById('serialInput').addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                e.preventDefault();
                addSerial();
            }
        });

        // Form submission validation
        document.getElementById('importForm').addEventListener('submit', (e) => {
            const totalItems = Object.values(serialsStore).reduce((sum, serials) => sum + serials.length, 0);
            if (totalItems === 0) {
                e.preventDefault();
                alert('Please add at least one serial number before processing the import.');
                return false;
            }

            return confirm('Are you sure you want to process this import? This action cannot be undone.');
        });
    }

    function escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    // Initialize when DOM is ready
    document.addEventListener('DOMContentLoaded', () => {
        initializeFromExistingData();
        attachEventHandlers();
    });
</script>
</body>
</html>
