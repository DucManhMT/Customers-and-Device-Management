<%--
  Created by IntelliJ IDEA.
  User: MasterLong
  Date: 10/12/2025
  Time: 9:49 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <title>Add Products to Import - Warehouse</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>

    <!-- Bootstrap 5 CSS -->
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
            rel="stylesheet"
            integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
            crossorigin="anonymous"
    />

    <style>
        .product-card {
            transition: all 0.2s ease;
            cursor: pointer;
            border: 2px solid transparent;
        }

        .product-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .product-card.selected {
            border-color: #0d6efd;
            background-color: #f8f9ff;
        }

        .product-card.already-imported {
            opacity: 0.6;
            background-color: #f8f9fa;
        }

        .product-card.already-imported:hover {
            transform: none;
        }

        .header-gradient {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }

        .search-box {
            border-radius: 50px;
        }

        .category-filter {
            border-radius: 20px;
        }

        .selection-summary {
            position: sticky;
            top: 20px;
            z-index: 100;
        }

        .product-image {
            width: 100%;
            height: 120px;
            object-fit: cover;
            border-radius: 8px;
        }

        .product-code {
            font-family: 'Courier New', monospace;
            font-size: 0.85rem;
        }
    </style>
</head>
<body class="bg-light">
<div class="container-fluid py-4">
    <jsp:include page="../components/header.jsp"/>
    <!-- Header -->
    <div class="row mb-4">
        <div class="col">
            <div class="card header-gradient border-0 shadow-sm">
                <div class="card-body py-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h1 class="h4 mb-1">
                                <i class="bi bi-plus-square me-2"></i>Add Products to Import
                            </h1>
                            <p class="mb-0 opacity-75">Select products from warehouse catalog to add to import list</p>
                        </div>
                        <div class="d-flex gap-2">
                            <a href="${pageContext.request.contextPath}/warehouse_keeper/import_product"
                               class="btn btn-light btn-sm">
                                <i class="bi bi-arrow-left me-1"></i>Back to Import
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <!-- Filters and Search Sidebar -->
        <div class="col-lg-3 mb-4">
            <div class="selection-summary">
                <!-- Selection Summary -->
                <div class="card shadow-sm mb-3">
                    <div class="card-header bg-primary text-white">
                        <h6 class="mb-0">
                            <i class="bi bi-check2-square me-2"></i>Selection Summary
                        </h6>
                    </div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span>Selected Products:</span>
                            <span class="badge bg-primary" id="selectedCount">0</span>
                        </div>
                        <div class="d-grid gap-2">
                            <button type="button" class="btn btn-success btn-sm" id="doneBtn" disabled>
                                <i class="bi bi-check-lg me-1"></i>Add Selected Products
                            </button>
                            <button type="button" class="btn btn-outline-secondary btn-sm" id="clearSelectionBtn">
                                <i class="bi bi-x-circle me-1"></i>Clear Selection
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Search and Filters -->
                <div class="card shadow-sm">
                    <div class="card-header">
                        <h6 class="mb-0">
                            <i class="bi bi-funnel me-2"></i>Search & Filter
                        </h6>
                    </div>
                    <div class="card-body">
                        <!-- Search -->
                        <div class="mb-3">
                            <label class="form-label small fw-medium">Search Products</label>
                            <div class="input-group">
                <span class="input-group-text">
                  <i class="bi bi-search"></i>
                </span>
                                <input type="text"
                                       id="searchInput"
                                       class="form-control search-box"
                                       placeholder="Product name, code..."
                                       autocomplete="off">
                            </div>
                        </div>

                        <!-- Type Filter -->
                        <div class="mb-3">
                            <label class="form-label small fw-medium">Type</label>
                            <select id="typeFilter" class="form-select category-filter">
                                <option value="">All Types</option>
                                <c:forEach items="${types}" var="type">
                                    <option value="${type.typeName}">${type.typeName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Stock Status Filter -->
                        <div class="mb-3">
                            <label class="form-label small fw-medium">Status</label>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="hideImportedFilter" checked>
                                <label class="form-check-label small" for="hideImportedFilter">
                                    Hide already imported
                                </label>
                            </div>
                        </div>

                        <!-- Search Button -->
                        <div class="d-grid mt-2">
                            <button type="button" class="btn btn-primary btn-sm" id="searchBtn">
                                <i class="bi bi-search me-1"></i>Search Products
                            </button>
                        </div>

                        <!-- Quick Actions -->
                        <div class="d-grid gap-2">
                            <button type="button" class="btn btn-outline-primary btn-sm" id="selectAllVisibleBtn">
                                <i class="bi bi-check-all me-1"></i>Select All Visible
                            </button>
                            <button type="button" class="btn btn-outline-secondary btn-sm" id="clearFiltersBtn">
                                <i class="bi bi-arrow-clockwise me-1"></i>Reset Filters
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Products Grid -->
        <div class="col-lg-9">
            <!-- Products Count and View Options -->
            <div class="row mb-3">
                <div class="col">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h5 class="mb-0">Available Products</h5>
                            <small class="text-muted">
                                Showing <span id="visibleCount">${fn:length(availableProducts)}</span>
                                of <span id="totalCount">${fn:length(availableProducts)}</span> products
                            </small>
                        </div>
                        <div class="btn-group" role="group">
                            <input type="radio" class="btn-check" name="viewMode" id="gridView" checked>
                            <label class="btn btn-outline-secondary btn-sm" for="gridView">
                                <i class="bi bi-grid-3x3-gap"></i>
                            </label>
                            <input type="radio" class="btn-check" name="viewMode" id="listView">
                            <label class="btn btn-outline-secondary btn-sm" for="listView">
                                <i class="bi bi-list-ul"></i>
                            </label>
                        </div>
                    </div>
                </div>
            </div>

            <!--
              Expected request attributes:
              - availableProducts: java.util.List<Product> with getters: productID, productName, productDescription, type.typeName
              - types: java.util.List<Type> - available types for filtering
              - importedProductIds: java.util.Set<Integer> - IDs of products already in import list

              Session attributes used:
              - importProductList: java.util.List<Product> - products already in import list (for count display only)
            -->

            <!-- Products Container -->
            <div id="productsContainer">
                <c:choose>
                    <c:when test="${empty availableProducts}">
                        <div class="text-center py-5">
                            <i class="bi bi-inbox display-1 text-muted"></i>
                            <h5 class="text-muted mt-3">No Products Available</h5>
                            <p class="text-muted">There are no products available in the warehouse catalog.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Grid View -->
                        <div id="gridViewContainer" class="row">
                            <c:forEach items="${availableProducts}" var="product">
                                <!-- Check if product is already in import list using the set from request -->
                                <c:set var="isAlreadyImported"
                                       value="${importedProductIds.contains(product.productID)}"/>

                                <div class="col-xl-3 col-lg-4 col-md-6 mb-4 product-item"
                                     data-product-id="${product.productID}"
                                     data-product-name="${product.productName}"
                                     data-product-description="${product.productDescription}"
                                     data-type-id="${product.type.typeID}"
                                     data-type-name="${product.type.typeName}"
                                     data-imported="${isAlreadyImported}">

                                    <div class="card product-card h-100 ${isAlreadyImported ? 'already-imported' : ''}"
                                         onclick="toggleProductSelection('${product.productID}')">

                                        <!-- Product Image -->
                                        <div class="position-relative">
                                            <c:choose>
                                                <c:when test="${not empty product.productImage}">
                                                    <img src="${product.productImage}"
                                                         class="card-img-top product-image"
                                                         alt="${product.productName}">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="card-img-top product-image bg-light d-flex align-items-center justify-content-center">
                                                        <i class="bi bi-image text-muted" style="font-size: 2rem;"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>

                                            <!-- Selection Checkbox -->
                                            <div class="position-absolute top-0 end-0 p-2">
                                                <div class="form-check">
                                                    <input class="form-check-input product-checkbox"
                                                           type="checkbox"
                                                           id="product-${product.productID}"
                                                        ${isAlreadyImported ? 'disabled' : ''}>
                                                </div>
                                            </div>

                                            <!-- Already Imported Badge -->
                                            <c:if test="${isAlreadyImported}">
                                                <div class="position-absolute bottom-0 start-0 p-2">
                          <span class="badge bg-warning">
                            <i class="bi bi-check-circle me-1"></i>Already Added
                          </span>
                                                </div>
                                            </c:if>
                                        </div>

                                        <div class="card-body">
                                            <div class="d-flex justify-content-between flex-column align-items-start mb-2">
                                                <p class="badge bg-secondary product-code">${product.productDescription}</p>
                                                <p class="badge bg-info">${product.type.typeName}</p>
                                            </div>

                                            <h6 class="card-title mb-2">${product.productName}</h6>

                                            <c:if test="${not empty product.productDescription}">
                                                <p class="card-text small text-muted mb-2">
                                                        ${fn:length(product.productDescription) > 80 ?
                                                                fn:substring(product.productDescription, 0, 80).concat('...') :
                                                                product.productDescription}
                                                </p>
                                            </c:if>

                                            <div class="row text-center small">
                                                <div class="col-6">
                                                        <%--                                                    <div class="text-muted">Stock</div>--%>
                                                        <%--                                                    <div class="fw-medium">${product.stockQuantity}</div>--%>
                                                </div>
                                                    <%--                                                <c:if test="${not empty product.price}">--%>
                                                    <%--                                                    <div class="col-6">--%>
                                                    <%--                                                        <div class="text-muted">Price</div>--%>
                                                    <%--                                                        <div class="fw-medium">$${product.price}</div>--%>
                                                    <%--                                                    </div>--%>
                                                    <%--                                                </c:if>--%>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- List View -->
                        <div id="listViewContainer" class="d-none">
                            <div class="card">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead class="table-light">
                                        <tr>
                                            <th style="width: 50px;">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox"
                                                           id="selectAllCheckbox">
                                                </div>
                                            </th>
                                            <th>Code</th>
                                            <th>Product Name</th>
                                            <th>Type</th>
                                            <th>Status</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach items="${availableProducts}" var="product">
                                            <!-- Check if product is already in import list using the set from request -->
                                            <c:set var="isAlreadyImported"
                                                   value="${importedProductIds.contains(product.productID)}"/>

                                            <tr class="product-item-row ${isAlreadyImported ? 'table-secondary' : ''}"
                                                data-product-id="${product.productID}"
                                                data-product-name="${fn:toLowerCase(product.productName)}"
                                                data-product-description="${fn:toLowerCase(product.productDescription)}"
                                                data-type-id="${product.type.typeID}"
                                                data-type-name="${product.type.typeName}"
                                                data-imported="${isAlreadyImported}"
                                                onclick="toggleProductSelection('${product.productID}')"
                                                style="cursor: pointer;">

                                                <td>
                                                    <div class="form-check">
                                                        <input class="form-check-input product-checkbox-list"
                                                               type="checkbox"
                                                               id="product-list-${product.productID}"
                                                            ${isAlreadyImported ? 'disabled' : ''}>
                                                    </div>
                                                </td>
                                                <td><code class="small">${product.productDescription}</code></td>
                                                <td>
                                                    <div class="fw-medium">${product.productName}</div>
                                                    <c:if test="${not empty product.productDescription}">
                                                        <small class="text-muted">
                                                                ${fn:length(product.productDescription) > 50 ?
                                                                        fn:substring(product.productDescription, 0, 50).concat('...') :
                                                                        product.productDescription}
                                                        </small>
                                                    </c:if>
                                                </td>
                                                <td><span class="badge bg-secondary">${product.type.typeName}</span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${isAlreadyImported}">
                              <span class="badge bg-warning">
                                <i class="bi bi-check-circle me-1"></i>Added
                              </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-success">Available</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- No Results Message -->
            <div id="noResultsMessage" class="text-center py-5 d-none">
                <i class="bi bi-search display-1 text-muted"></i>
                <h5 class="text-muted mt-3">No Products Found</h5>
                <p class="text-muted">Try adjusting your search criteria or filters.</p>
            </div>
        </div>
    </div>
</div>

<!-- Confirmation Modal -->
<div class="modal fade" id="confirmationModal" tabindex="-1" aria-labelledby="confirmationModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="confirmationModalLabel">
                    <i class="bi bi-check-square me-2"></i>Confirm Selection
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>You have selected <strong id="confirmCount">0</strong> products to add to the import list.</p>
                <p class="mb-0">Are you sure you want to proceed?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-success" id="confirmAddBtn">
                    <i class="bi bi-plus-square me-1"></i>Add Products
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
    // Selected products set
    const selectedProducts = new Set();
    let confirmationModalInstance = null;

    // Utility functions
    function updateSelectionCount() {
        const count = selectedProducts.size;
        document.getElementById('selectedCount').textContent = count;
        document.getElementById('doneBtn').disabled = count === 0;
    }

    function updateVisibleCount() {
        const visibleItems = document.querySelectorAll('.product-item:not(.d-none)').length;
        const visibleRows = document.querySelectorAll('.product-item-row:not(.d-none)').length;
        const total = Math.max(visibleItems, visibleRows);
        document.getElementById('visibleCount').textContent = total;

        // Also update the selection summary with import status info
        updateImportStatus();
    }

    function updateImportStatus() {
        // Count already imported items that are visible
        const visibleImported = document.querySelectorAll('.product-item:not(.d-none)[data-imported="true"]').length +
            document.querySelectorAll('.product-item-row:not(.d-none)[data-imported="true"]').length;

        if (visibleImported > 0) {
            // Show a small indicator of how many are already imported
            const existingIndicator = document.getElementById('importedIndicator');
            if (!existingIndicator) {
                const indicator = document.createElement('div');
                indicator.id = 'importedIndicator';
                indicator.className = 'small text-muted mt-1';
                indicator.innerHTML = '<i class="bi bi-info-circle me-1"></i>' + visibleImported + ' already in import list';
                document.querySelector('.selection-summary .card-body').appendChild(indicator);
            } else {
                existingIndicator.innerHTML = '<i class="bi bi-info-circle me-1"></i>' + visibleImported + ' already in import list';
            }
        }
    }

    function toggleProductSelection(productId) {
        // Check if product is already imported
        const productElement = document.querySelector(`[data-product-id="${productId}"]`);
        if (productElement && productElement.dataset.imported === 'true') {
            // Show a friendly message instead of doing nothing
            const toast = document.createElement('div');
            toast.className = 'toast-container position-fixed bottom-0 end-0 p-3';
            toast.style.zIndex = '1055';
            toast.innerHTML = `
                <div class="toast show" role="alert">
                    <div class="toast-header">
                        <i class="bi bi-info-circle text-info me-2"></i>
                        <strong class="me-auto">Already Added</strong>
                        <button type="button" class="btn-close" data-bs-dismiss="toast"></button>
                    </div>
                    <div class="toast-body">
                        This product is already in your import list.
                    </div>
                </div>
            `;
            document.body.appendChild(toast);

            // Auto remove after 3 seconds
            setTimeout(() => {
                if (toast.parentNode) {
                    toast.parentNode.removeChild(toast);
                }
            }, 3000);

            return; // Can't select already imported products
        }

        const checkbox = document.getElementById('product-' + productId);
        const checkboxList = document.getElementById('product-list-' + productId);
        const card = checkbox ? checkbox.closest('.product-card') : null;

        if (selectedProducts.has(productId)) {
            // Deselect
            selectedProducts.delete(productId);
            if (checkbox) checkbox.checked = false;
            if (checkboxList) checkboxList.checked = false;
            if (card) card.classList.remove('selected');
        } else {
            // Select
            selectedProducts.add(productId);
            if (checkbox) checkbox.checked = true;
            if (checkboxList) checkboxList.checked = true;
            if (card) card.classList.add('selected');
        }

        updateSelectionCount();
    }

    function clearSelection() {
        selectedProducts.clear();
        document.querySelectorAll('.product-checkbox, .product-checkbox-list').forEach(cb => {
            cb.checked = false;
        });
        document.querySelectorAll('.product-card.selected').forEach(card => {
            card.classList.remove('selected');
        });
        updateSelectionCount();
    }

    function selectAllVisible() {
        const visibleProducts = document.querySelectorAll('.product-item:not(.d-none):not([data-imported="true"])');
        const visibleRows = document.querySelectorAll('.product-item-row:not(.d-none):not([data-imported="true"])');

        // Combine both grid and list view items
        const allVisible = [...visibleProducts, ...visibleRows];

        allVisible.forEach(item => {
            const productId = item.dataset.productId;
            if (productId && !selectedProducts.has(productId)) {
                toggleProductSelection(productId);
            }
        });
    }

    function applyFilters() {
        const searchTerm = document.getElementById('searchInput').value.toLowerCase().trim();
        const selectedType = document.getElementById('typeFilter').value;
        const hideImported = document.getElementById('hideImportedFilter').checked;

        // Filter grid view items
        document.querySelectorAll('.product-item').forEach(item => {
            const productName = item.dataset.productName || '';
            const productDescription = item.dataset.productDescription || '';
            const typeName = item.dataset.typeName || '';
            const isImported = item.dataset.imported === 'true';

            let show = true;

            // Search filter
            if (searchTerm && !productName.toLowerCase().includes(searchTerm) && !productDescription.toLowerCase().includes(searchTerm)) {
                show = false;
            }

            // Type filter
            if (selectedType && typeName !== selectedType) {
                show = false;
            }

            // Hide imported filter
            if (hideImported && isImported) {
                show = false;
            }

            item.classList.toggle('d-none', !show);
        });

        // Filter list view items
        document.querySelectorAll('.product-item-row').forEach(row => {
            const productName = row.dataset.productName || '';
            const productDescription = row.dataset.productDescription || '';
            const typeName = row.dataset.typeName || '';
            const isImported = row.dataset.imported === 'true';

            let show = true;

            // Search filter
            if (searchTerm && !productName.includes(searchTerm) && !productDescription.includes(searchTerm)) {
                show = false;
            }

            // Type filter
            if (selectedType && typeName !== selectedType) {
                show = false;
            }

            // Hide imported filter
            if (hideImported && isImported) {
                show = false;
            }

            row.classList.toggle('d-none', !show);
        });

        updateVisibleCount();
        checkNoResults();
    }

    function checkNoResults() {
        const visibleItems = document.querySelectorAll('.product-item:not(.d-none)').length;
        const visibleRows = document.querySelectorAll('.product-item-row:not(.d-none)').length;
        const hasVisible = visibleItems > 0 || visibleRows > 0;

        document.getElementById('noResultsMessage').classList.toggle('d-none', hasVisible);
        document.getElementById('productsContainer').classList.toggle('d-none', !hasVisible);
    }

    function clearFilters() {
        document.getElementById('searchInput').value = '';
        document.getElementById('typeFilter').value = '';
        document.getElementById('hideImportedFilter').checked = true;
        applyFilters();
    }

    function switchViewMode(mode) {
        const gridContainer = document.getElementById('gridViewContainer');
        const listContainer = document.getElementById('listViewContainer');

        if (mode === 'list') {
            gridContainer.classList.add('d-none');
            listContainer.classList.remove('d-none');
        } else {
            gridContainer.classList.remove('d-none');
            listContainer.classList.add('d-none');
        }

        updateVisibleCount();
    }

    function showConfirmation() {
        document.getElementById('confirmCount').textContent = selectedProducts.size;
        if (!confirmationModalInstance) {
            confirmationModalInstance = new bootstrap.Modal(document.getElementById('confirmationModal'));
        }
        confirmationModalInstance.show();
    }

    function addSelectedProducts() {
        if (selectedProducts.size === 0) {
            alert('Please select at least one product.');
            return;
        }

        console.log('=== Adding Selected Products ===');
        console.log('Selected product IDs:', Array.from(selectedProducts));

        // Create a form to submit selected product IDs
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/warehouse_keeper/import_product';
        form.style.display = 'none';

        // Add selected product IDs as an array
        selectedProducts.forEach(productId => {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'productIds';
            input.value = productId;
            form.appendChild(input);
            console.log('Adding product ID to form:', productId);
        });

        // Add action parameter - this is crucial
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'addProducts';
        form.appendChild(actionInput);

        document.body.appendChild(form);

        // Show loading state
        const confirmBtn = document.getElementById('confirmAddBtn');
        if (confirmBtn) {
            const originalText = confirmBtn.innerHTML;
            confirmBtn.innerHTML = '<i class="bi bi-hourglass-split me-1"></i>Adding Products...';
            confirmBtn.disabled = true;
        }

        console.log('Form action:', form.action);
        console.log('Form method:', form.method);
        console.log('Submitting form with action: addProducts');

        form.submit();
    }

    function attachEventHandlers() {
        // Search button - apply all filters
        document.getElementById('searchBtn').addEventListener('click', () => {
            applyFilters();
            // Add visual feedback
            const searchBtn = document.getElementById('searchBtn');
            const originalText = searchBtn.innerHTML;
            searchBtn.innerHTML = '<i class="bi bi-hourglass-split me-1"></i>Searching...';
            searchBtn.disabled = true;

            setTimeout(() => {
                searchBtn.innerHTML = originalText;
                searchBtn.disabled = false;
            }, 300);
        });


        // View mode switches
        document.getElementById('gridView').addEventListener('change', () => switchViewMode('grid'));
        document.getElementById('listView').addEventListener('change', () => switchViewMode('list'));

        // Action buttons
        document.getElementById('doneBtn').addEventListener('click', showConfirmation);
        document.getElementById('clearSelectionBtn').addEventListener('click', clearSelection);
        document.getElementById('selectAllVisibleBtn').addEventListener('click', selectAllVisible);
        document.getElementById('clearFiltersBtn').addEventListener('click', clearFilters);

        // Modal confirmation
        document.getElementById('confirmAddBtn').addEventListener('click', () => {
            addSelectedProducts();
            // Don't hide modal immediately - let the form submission handle the redirect
        });

        // Checkbox event handlers for grid view
        document.querySelectorAll('.product-checkbox').forEach(checkbox => {
            checkbox.addEventListener('change', (e) => {
                e.stopPropagation();
                const productId = checkbox.id.replace('product-', '');
                if (checkbox.checked && !selectedProducts.has(productId)) {
                    toggleProductSelection(productId);
                } else if (!checkbox.checked && selectedProducts.has(productId)) {
                    toggleProductSelection(productId);
                }
            });
        });

        // Checkbox event handlers for list view
        document.querySelectorAll('.product-checkbox-list').forEach(checkbox => {
            checkbox.addEventListener('change', (e) => {
                e.stopPropagation();
                const productId = checkbox.id.replace('product-list-', '');
                if (checkbox.checked && !selectedProducts.has(productId)) {
                    toggleProductSelection(productId);
                } else if (!checkbox.checked && selectedProducts.has(productId)) {
                    toggleProductSelection(productId);
                }
            });
        });

        // Select all checkbox in list view header
        const selectAllCheckbox = document.getElementById('selectAllCheckbox');
        if (selectAllCheckbox) {
            selectAllCheckbox.addEventListener('change', () => {
                if (selectAllCheckbox.checked) {
                    selectAllVisible();
                } else {
                    clearSelection();
                }
            });
        }

        // Keyboard shortcuts
        document.addEventListener('keydown', (e) => {
            if (e.ctrlKey || e.metaKey) {
                switch (e.key) {
                    case 'a':
                        e.preventDefault();
                        selectAllVisible();
                        break;
                    case 'Enter':
                        e.preventDefault();
                        if (selectedProducts.size > 0) {
                            showConfirmation();
                        }
                        break;
                }
            }
            if (e.key === 'Escape') {
                clearSelection();
            }
        });
    }

    // Initialize page
    document.addEventListener('DOMContentLoaded', () => {
        // Clear any cached selections when page loads
        selectedProducts.clear();

        updateSelectionCount();
        updateVisibleCount();
        attachEventHandlers();

        // Set focus on search input
        document.getElementById('searchInput').focus();

        // Show summary of import list status if any products are already imported
        const importListCount = ${not empty sessionScope.importProductList ? fn:length(sessionScope.importProductList) : 0};
        if (importListCount > 0) {
            const summaryElement = document.createElement('div');
            summaryElement.className = 'alert alert-info alert-dismissible fade show mb-3';
            summaryElement.innerHTML = `
                <i class="bi bi-info-circle me-2"></i>
                You currently have <strong>${importListCount}</strong> products in your import list.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            `;
            document.querySelector('.container-fluid').insertBefore(summaryElement, document.querySelector('.row'));
        }

        console.log('=== Add Import Product Page Loaded ===');
        console.log('Import list count:', importListCount);
        console.log('Selected products cleared on page load');
    });
</script>
</body>
</html>
