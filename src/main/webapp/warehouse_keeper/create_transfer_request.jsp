<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 10/10/2025
  Time: 5:35 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Internal Export</title>
    <%-- Bootstrap 5 CSS --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<div class="container my-5">
    <h1 class="mb-4">Create Transfer Request</h1>

    <%-- Warehouse Selection --%>
    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/warehouse_keeper/create_transfer_request" method="get" class="row g-3 align-items-end">
                <div class="col-md">
                    <label for="warehouse" class="form-label fw-semibold">Select Source Warehouse:</label>
                    <select name="selectedWarehouseID" id="warehouse" class="form-select">
                        <option value="">-- Choose a warehouse --</option>
                        <c:forEach var="w" items="${warehouses}">
                            <option value="${w.warehouseID}" ${selectedWarehouseID == w.warehouseID ? 'selected' : ''}>${w.warehouseName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-auto">
                    <button type="submit" class="btn btn-primary w-100">Show Products</button>
                </div>
            </form>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger mt-3" role="alert">
                        ${errorMessage}
                </div>
            </c:if>
        </div>
    </div>


    <%-- Product Listing and Export Form --%>
    <c:if test="${not empty selectedWarehouseID}">
        <div class="card shadow-sm">
            <div class="card-header bg-light py-3">
                <h2 class="h5 mb-0">Products in Selected Warehouse</h2>
            </div>
            <div class="card-body">
                    <%-- Filter Form --%>
                <form action="${pageContext.request.contextPath}/warehouse_keeper/create_transfer_request" method="GET" id="filterForm" class="mb-4 p-3 border rounded">
                    <input type="hidden" name="pageSize" value="${pageSize}">
                    <input type="hidden" name="page" value="1"> <%-- Reset to page 1 on new filter --%>
                    <input type="hidden" name="selectedWarehouseID" value="${selectedWarehouseID}">
                    <div class="row g-3 align-items-end">
                        <div class="col-md">
                            <label for="productName" class="form-label">Product Name</label>
                            <input type="text" id="productName" name="productName" class="form-control"
                                   value="${productName}" placeholder="Enter product name...">
                        </div>
                        <div class="col-md">
                            <label for="productType" class="form-label">Product Type</label>
                            <select id="productType" name="productType" class="form-select">
                                <option value="">All Types</option>
                                <c:forEach items="${uniqueProductTypes}" var="type">
                                    <option value="${type.typeID}" ${productType == type.typeID ? 'selected' : ''}>${type.typeName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-auto">
                            <button type="submit" class="btn btn-outline-secondary w-100">Apply Filters</button>
                        </div>
                    </div>
                </form>

                <c:choose>
                    <c:when test="${not empty productsInSelectedWarehouse}">
                        <form action="${pageContext.request.contextPath}/warehouse_keeper/create_transfer_request" method="post" id="exportForm">
                            <input type="hidden" name="sourceWarehouseID" value="${managerWarehouse.warehouseID}">
                            <input type="hidden" name="selectedWarehouseID" value="${selectedWarehouseID}">
                            <input type="hidden" id="allSelectedItemIDs" name="allSelectedItemIDs" value="${param.selectedItemIDs}">
                            <input type="hidden" id="allSelectedItemQuantities" name="allSelectedItemQuantities" value="${param.allSelectedItemQuantities}">


                                <%-- Product Table --%>
                            <div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead class="table-light">
                                    <tr>
                                        <th>Select</th>
                                        <th>Product Name</th>
                                        <th>Description</th>
                                        <th>Type</th>
                                        <th>Specifications</th>
                                        <th>Stock In warehouse</th>
                                        <th>Quantity to Request</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="p" items="${productsInSelectedWarehouse}">
                                        <tr>
                                            <td>
                                                <input type="checkbox" name="selectedItemIDs" value="${p.productID}"
                                                       class="form-check-input item-checkbox">
                                            </td>
                                            <td>${p.productName}</td>
                                            <td class="text-muted small">${p.productDescription}</td>
                                            <td><span
                                                    class="badge bg-secondary">${p.type.typeName}</span>
                                            </td>
                                            <td>
                                                <c:forEach var="spec"
                                                           items="${p.productSpecifications}">
                                                    <div class="small">
                                                        <span class="fw-medium">${spec.specification.specificationName}:</span>
                                                        <span class="text-muted">${spec.specification.specificationValue}</span>
                                                    </div>
                                                </c:forEach>
                                            </td>
                                            <td>${productCounts[p.productID]}</td>
                                            <td>
                                                <input type="number" name="quantity_${p.productID}" min="1"
                                                       max="${productCounts[p.productID]}"
                                                       class="form-control quantity-input" placeholder="Qty"
                                                       style="width: 80px;" disabled>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                                <%-- Note and Submit --%>
                            <div class="mt-4">
                                <div class="mb-3">
                                    <label for="note" class="form-label">Note for Export:</label>
                                    <textarea id="note" name="note" rows="3" class="form-control"
                                              placeholder="Add any relevant notes for this export...">${param.note}</textarea>
                                </div>
                                <button type="submit" class="btn btn-success">Create Export Request</button>
                            </div>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-info text-center">No products found matching your criteria.</div>
                    </c:otherwise>
                </c:choose>
            </div>

                <%-- Footer with Pagination and Page Size --%>
            <c:if test="${totalPages > 0}">
                <div class="card-footer bg-light">
                    <div class="d-flex flex-column flex-md-row justify-content-between align-items-center gap-3">
                            <%-- Page Size Selector --%>
                        <div class="d-flex align-items-center gap-2">
                            <span class="text-muted small">Display:</span>
                            <form action="${pageContext.request.contextPath}/warehouse_keeper/create_transfer_request" method="GET" id="pageSizeForm" class="mb-0">
                                <input type="hidden" name="productName" value="${productName}">
                                <input type="hidden" name="productType" value="${productType}">
                                <input type="hidden" name="page" value="1">
                                <input type="hidden" name="selectedWarehouseID" value="${selectedWarehouseID}">
                                <select name="pageSize" id="pageSize" class="form-select form-select-sm"
                                        onchange="this.form.submit()">
                                    <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                                    <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                    <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                                    <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                                </select>
                            </form>
                        </div>

                            <%-- Pagination Controls --%>
                        <nav aria-label="Page navigation">
                            <ul class="pagination pagination-sm mb-0">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link"
                                       href="${pageContext.request.contextPath}/warehouse_keeper/create_transfer_request?page=${currentPage - 1}&pageSize=${pageSize}&productName=${productName}&productType=${productType}&selectedWarehouseID=${selectedWarehouseID}">Previous</a>
                                </li>
                                <c:set var="maxVisiblePages" value="5"/>
                                <c:set var="startPage" value="${currentPage - 2 > 1 ? currentPage - 2 : 1}"/>
                                <c:set var="endPage"
                                       value="${startPage + maxVisiblePages - 1 < totalPages ? startPage + maxVisiblePages - 1 : totalPages}"/>
                                <c:if test="${endPage - startPage + 1 < maxVisiblePages && startPage > 1}"><c:set
                                        var="startPage"
                                        value="${endPage - maxVisiblePages + 1 > 1 ? endPage - maxVisiblePages + 1 : 1}"/></c:if>

                                <c:if test="${startPage > 1}">
                                    <li class="page-item"><a class="page-link"
                                                             href="${pageContext.request.contextPath}/warehouse_keeper/create_transfer_request?page=1&pageSize=${pageSize}&productName=${productName}&productType=${productType}&selectedWarehouseID=${selectedWarehouseID}">1</a>
                                    </li>
                                    <c:if test="${startPage > 2}">
                                        <li class="page-item disabled"><span class="page-link">...</span></li>
                                    </c:if>
                                </c:if>

                                <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link"
                                           href="${pageContext.request.contextPath}/warehouse_keeper/create_transfer_request?page=${i}&pageSize=${pageSize}&productName=${productName}&productType=${productType}&selectedWarehouseID=${selectedWarehouseID}">${i}</a>
                                    </li>
                                </c:forEach>

                                <c:if test="${endPage < totalPages}">
                                    <c:if test="${endPage < totalPages - 1}">
                                        <li class="page-item disabled"><span class="page-link">...</span></li>
                                    </c:if>
                                    <li class="page-item"><a class="page-link"
                                                             href="${pageContext.request.contextPath}/warehouse_keeper/create_transfer_request?page=${totalPages}&pageSize=${pageSize}&productName=${productName}&productType=${productType}&selectedWarehouseID=${selectedWarehouseID}">${totalPages}</a>
                                    </li>
                                </c:if>

                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link"
                                       href="${pageContext.request.contextPath}/warehouse_keeper/create_transfer_request?page=${currentPage + 1}&pageSize=${pageSize}&productName=${productName}&productType=${productType}&selectedWarehouseID=${selectedWarehouseID}">Next</a>
                                </li>
                            </ul>
                        </nav>

                            <%-- Page Info --%>
                        <div class="text-muted small">
                            Page ${currentPage} of ${totalPages} (${totalProducts} items)
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
    </c:if>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const allSelectedIDsInput = document.getElementById('allSelectedItemIDs');
        const allSelectedQuantitiesInput = document.getElementById('allSelectedItemQuantities');
        const itemCheckboxes = document.querySelectorAll('.item-checkbox');
        const quantityInputs = document.querySelectorAll('.quantity-input');

        // Map to store quantities: key = productID, value = quantity
        const quantitiesMap = new Map();

        // --- Initialize state from hidden inputs on page load ---
        function initializeState() {
            const initialIDs = allSelectedIDsInput.value ? allSelectedIDsInput.value.split(',') : [];
            const initialQuantities = allSelectedQuantitiesInput.value ? allSelectedQuantitiesInput.value.split(',') : [];

            initialIDs.forEach((id, index) => {
                if (id) {
                    quantitiesMap.set(id, initialQuantities[index] || '');
                }
            });

            // Set values and states for inputs on the current page
            document.querySelectorAll('#exportForm tbody tr').forEach(row => {
                const checkbox = row.querySelector('.item-checkbox');
                const quantityInput = row.querySelector('.quantity-input');
                if (checkbox && quantityInput) {
                    const productID = checkbox.value;
                    if (quantitiesMap.has(productID)) {
                        checkbox.checked = true;
                        quantityInput.disabled = false;
                        quantityInput.value = quantitiesMap.get(productID);
                    }
                }
            });
        }

        // --- Update map and hidden inputs based on user interaction ---
        function updateSelections() {
            // Update map from inputs on the current page
            document.querySelectorAll('#exportForm tbody tr').forEach(row => {
                const checkbox = row.querySelector('.item-checkbox');
                const quantityInput = row.querySelector('.quantity-input');
                if (checkbox && quantityInput) {
                    const productID = checkbox.value;
                    if (checkbox.checked) {
                        quantitiesMap.set(productID, quantityInput.value);
                    } else {
                        quantitiesMap.delete(productID);
                    }
                }
            });

            // Update hidden inputs from the map
            const ids = Array.from(quantitiesMap.keys());
            const quantities = Array.from(quantitiesMap.values());
            allSelectedIDsInput.value = ids.join(',');
            allSelectedQuantitiesInput.value = quantities.join(',');
        }

        // --- Event Listeners ---

        // Enable/disable quantity input when checkbox is toggled
        itemCheckboxes.forEach(checkbox => {
            checkbox.addEventListener('change', function () {
                const row = this.closest('tr');
                const quantityInput = row.querySelector('.quantity-input');
                quantityInput.disabled = !this.checked;
                if (this.checked) {
                    quantityInput.focus();
                } else {
                    quantityInput.value = ''; // Clear value when unchecked
                }
                updateSelections();
            });
        });

        // Update selections when a quantity is changed
        quantityInputs.forEach(input => {
            input.addEventListener('input', updateSelections);
        });

        // --- Preserve selections for navigation (pagination, filters) ---
        function appendSelectionsToLinks(form) {
            updateSelections(); // Ensure data is up-to-date before navigating

            const selectedIDs = allSelectedIDsInput.value;
            const selectedQuantities = allSelectedQuantitiesInput.value;

            if (selectedIDs) {
                // Add/update hidden input for IDs
                let hiddenIDs = form.querySelector('input[name="selectedItemIDs"]');
                if (!hiddenIDs) {
                    hiddenIDs = document.createElement('input');
                    hiddenIDs.type = 'hidden';
                    hiddenIDs.name = 'selectedItemIDs';
                    form.appendChild(hiddenIDs);
                }
                hiddenIDs.value = selectedIDs;

                // Add/update hidden input for quantities
                let hiddenQuantities = form.querySelector('input[name="allSelectedItemQuantities"]');
                if (!hiddenQuantities) {
                    hiddenQuantities = document.createElement('input');
                    hiddenQuantities.type = 'hidden';
                    hiddenQuantities.name = 'allSelectedItemQuantities';
                    form.appendChild(hiddenQuantities);
                }
                hiddenQuantities.value = selectedQuantities;
            }
        }

        document.querySelectorAll('.pagination a.page-link').forEach(link => {
            link.addEventListener('click', function (e) {
                e.preventDefault();
                updateSelections();
                const selectedIDs = allSelectedIDsInput.value;
                const selectedQuantities = allSelectedQuantitiesInput.value;
                const url = new URL(link.href);
                if (selectedIDs) {
                    url.searchParams.set('selectedItemIDs', selectedIDs);
                    url.searchParams.set('allSelectedItemQuantities', selectedQuantities);
                }
                window.location.href = url.toString();
            });
        });

        const pageSizeForm = document.getElementById('pageSizeForm');
        if(pageSizeForm) {
            pageSizeForm.addEventListener('submit', function(e) {
                appendSelectionsToLinks(this);
            });
        }

        const filterForm = document.getElementById('filterForm');
        if (filterForm) {
            filterForm.addEventListener('submit', function(e) {
                appendSelectionsToLinks(this);
            });
        }

        const exportForm = document.getElementById('exportForm');
        if (exportForm) {
            exportForm.addEventListener('submit', function () {
                updateSelections();
            });
        }

        // --- Initial call to set up the page ---
        initializeState();
    });
</script>

<%-- Bootstrap 5 JS Bundle --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
