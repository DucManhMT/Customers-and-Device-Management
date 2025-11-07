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
    <title>Create Transfer Request</title>
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

        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.5rem;
        }

        .product-card {
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            border: 1px solid #e9ecef;
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        }

        .product-card .card-body {
            display: flex;
            flex-direction: column;
        }

        .product-card .card-title {
            font-size: 1.1rem;
            font-weight: 600;
        }

        .product-card .btn-add-to-cart {
            margin-top: auto; /* Pushes button to the bottom */
        }

        .cart-container {
            position: sticky;
            top: 90px; /* Header height + padding */
            height: calc(100vh - 110px);
        }

        .cart-items {
            max-height: calc(100% - 250px); /* Adjust based on header/footer height */
            overflow-y: auto;
        }

        .cart-item .form-control {
            width: 70px;
        }

        .cart-item .fw-bold {
            display: inline-block;
            background-color: #e9ecef;
            color: #495057;
            padding: 3px 8px;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 600;
        }

        .cart-item .me-2.flex-grow-1 {
            margin-top: 0 !important;
            margin-bottom: 0 !important;
        }
    </style>
</head>
<body>
<%-- Include Header --%>
<jsp:include page="../components/header.jsp"/>

<%-- Include Warehouse Keeper Sidebar --%>
<c:set var="activePage" value="warehouses" scope="request"/>
<jsp:include page="../components/warehouse_keeper_sidebar.jsp"/>

<div class="main-content">
    <div class="container-fluid">
        <h1 class="mb-4">Create Transfer Request</h1>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
        </c:if>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>

        <div class="row g-4">
            <%-- Left Column: Product Grid --%>
            <div class="col-lg-8">
                <div class="card shadow-sm">
                    <div class="card-header bg-light py-3">
                        <h2 class="h5 mb-0">Products</h2>
                    </div>
                    <div class="card-body">
                        <%-- Filter Form --%>
                        <form action="${pageContext.request.contextPath}/warehouse_keeper/create_transfer_request"
                              method="GET" class="row g-3 align-items-center mb-4">
                            <div class="col-md-5">
                                <input type="text" class="form-control" name="productName"
                                       placeholder="Filter by product name..." value="${productName}">
                            </div>
                            <div class="col-md-4">
                                <select name="productType" class="form-select">
                                    <option value="">All Types</option>
                                    <c:forEach var="type" items="${uniqueProductTypes}">
                                        <option value="${type.typeID}" ${type.typeID == productType ? 'selected' : ''}>
                                                ${type.typeName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-3 d-flex">
                                <button type="submit" class="btn btn-primary me-2 flex-grow-1">Filter</button>
                                <a href="${pageContext.request.contextPath}/warehouse_keeper/create_transfer_request"
                                   class="btn btn-secondary flex-grow-1">Clear</a>
                            </div>
                        </form>
                        <hr/>
                        <%-- Product Grid --%>
                        <div class="product-grid">
                            <c:forEach var="p" items="${products}">
                                <div class="card product-card">
                                    <div class="card-body">
                                        <h5 class="card-title">${p.productName}</h5>
                                        <p class="card-text text-muted small">${p.productDescription}</p>
                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                            <span class="badge bg-secondary">${p.type.typeName}</span>
                                        </div>
                                        <c:forEach var="spec" items="${p.productSpecifications}">
                                            <p class="card-text small mb-2"><strong>${spec.specification.specificationName} :</strong> ${spec.specification.specificationValue}</p>
                                        </c:forEach>
                                        <button class="btn btn-outline-primary btn-sm btn-add-to-cart"
                                                data-product-id="${p.productID}"
                                                data-product-name="${p.productName}">
                                            <i class="fas fa-plus"></i> Add to Request
                                        </button>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        <c:if test="${empty products}">
                            <div class="alert alert-info text-center m-3">No products found.</div>
                        </c:if>
                    </div>
                </div>
            </div>

            <%-- Right Column: Transfer Cart --%>
            <div class="col-lg-4">
                <div class="cart-container">
                    <div class="card shadow-sm h-100">
                        <div class="card-header bg-dark text-white">
                            <h5 class="mb-0"><i class="fas fa-shopping-cart me-2"></i>Transfer Request Cart</h5>
                        </div>
                        <form id="transfer-request-form"
                              action="${pageContext.request.contextPath}/warehouse_keeper/create_transfer_request"
                              method="POST" class="d-flex flex-column h-100">
                            <div class="card-body flex-grow-1 cart-items" id="cart-items-container">
                                <div id="cart-empty-msg" class="text-center text-muted mt-4">
                                    <p><i class="fas fa-box-open fa-2x mb-2"></i></p>
                                    <p>Your request cart is empty.</p>
                                    <p class="small">Click "Add to Request" on a product to get started.</p>
                                </div>
                                <%-- Cart items will be injected here by JavaScript --%>
                            </div>

                            <div class="card-footer bg-light">
                                <div class="mb-3">
                                    <label for="note" class="form-label">Note:</label>
                                    <textarea id="note" name="note" rows="2" class="form-control"
                                              placeholder="Add an optional note..."></textarea>
                                </div>
                                <button type="submit" id="create-request-btn" class="btn btn-success w-100" disabled>
                                    Create Transfer Request
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const cart = new Map(); // Use a Map to store cart items: { productId => { name, quantity } }
        const addToCartButtons = document.querySelectorAll('.btn-add-to-cart');
        const cartContainer = document.getElementById('cart-items-container');
        const emptyCartMsg = document.getElementById('cart-empty-msg');
        const createRequestBtn = document.getElementById('create-request-btn');
        const form = document.getElementById('transfer-request-form');

        function renderCart() {
            // Clear current cart view (except the empty message)
            const items = cartContainer.querySelectorAll('.cart-item');
            items.forEach(item => item.remove());

            if (cart.size === 0) {
                emptyCartMsg.style.display = 'block';
                createRequestBtn.disabled = true;
            } else {
                emptyCartMsg.style.display = 'none';
                createRequestBtn.disabled = false;

                cart.forEach((item, productId) => {
                    const name = item.name || 'Unknown Product';
                    const quantity = item.quantity || 1;

                    // 1. Create the main cart item container
                    const cartItemEl = document.createElement('div');
                    cartItemEl.classList.add('d-flex', 'justify-content-between', 'align-items-center', 'mb-3', 'cart-item');

                    // --- LEFT SIDE (Product Name) ---
                    const nameContainer = document.createElement('div');
                    nameContainer.classList.add('me-2', 'flex-grow-1');

                    const nameText = document.createElement('div');
                    nameText.classList.add('fw-bold');
                    // Safely insert the text content
                    nameText.textContent = name;

                    nameContainer.appendChild(nameText);

                    // --- RIGHT SIDE (Input and Button) ---
                    const controlsContainer = document.createElement('div');
                    controlsContainer.classList.add('d-flex', 'align-items-center');

                    // Create Quantity Input
                    const quantityInput = document.createElement('input');
                    quantityInput.type = 'number';
                    quantityInput.classList.add('form-control', 'form-control-sm', 'quantity-input');
                    quantityInput.name = `quantity_${productId}`;
                    quantityInput.value = quantity;
                    quantityInput.min = '1';
                    quantityInput.dataset.productId = productId;
                    quantityInput.required = true;

                    // Create Remove Button
                    const removeButton = document.createElement('button');
                    removeButton.type = 'button';
                    removeButton.classList.add('btn', 'btn-outline-danger', 'btn-sm', 'ms-2', 'remove-item-btn');
                    removeButton.dataset.productId = productId;
                    removeButton.innerHTML = '<i class="fas fa-trash-alt"></i>'; // Icon HTML is safe

                    // Assemble the right side
                    controlsContainer.appendChild(quantityInput);
                    controlsContainer.appendChild(removeButton);

                    // Assemble the whole cart item
                    cartItemEl.appendChild(nameContainer);
                    cartItemEl.appendChild(controlsContainer);

                    // Add to the cart display
                    cartContainer.appendChild(cartItemEl);
                });
            }
            updateButtonStates();
            // Re-apply the Flexbox fix after rendering
            // This is optional but ensures the layout is honored
            const styleFix = document.createElement('style');
            styleFix.textContent = '.cart-item .flex-grow-1 { min-width: 150px; }';
            document.head.appendChild(styleFix);
        }

        function updateButtonStates() {
            addToCartButtons.forEach(btn => {
                const productId = btn.dataset.productId;
                if (cart.has(productId)) {
                    btn.innerHTML = '<i class="fas fa-check"></i> Added';
                    btn.classList.remove('btn-outline-primary');
                    btn.classList.add('btn-primary');
                    btn.disabled = true;
                } else {
                    btn.innerHTML = '<i class="fas fa-plus"></i> Add to Request';
                    btn.classList.remove('btn-primary');
                    btn.classList.add('btn-outline-primary');
                    btn.disabled = false;
                }
            });
        }

        // Event listener for "Add to Cart" buttons
        addToCartButtons.forEach(button => {
            button.addEventListener('click', () => {
                const productId = button.dataset.productId;
                const productName = button.dataset.productName.replace(/\s+/g, ' ').trim();

                if (!cart.has(productId)) {
                    cart.set(productId, {
                        name: productName,
                        quantity: 1
                    });
                    renderCart();
                }
            });
        });

        // Event delegation for dynamic elements in the cart
        cartContainer.addEventListener('click', (e) => {
            // Handle remove button clicks
            const removeBtn = e.target.closest('.remove-item-btn');
            if (removeBtn) {
                const productId = removeBtn.dataset.productId;
                if (cart.has(productId)) {
                    cart.delete(productId);
                    renderCart();
                }
            }
        });

        cartContainer.addEventListener('input', (e) => {
            // Handle quantity changes
            if (e.target.classList.contains('quantity-input')) {
                const input = e.target;
                const productId = input.dataset.productId;
                const item = cart.get(productId);

                if (item) {
                    let newQuantity = parseInt(input.value, 10);
                    if (isNaN(newQuantity) || newQuantity < 1) {
                        newQuantity = 1;
                    }
                    input.value = newQuantity;
                    item.quantity = newQuantity;
                }
            }
        });

        form.addEventListener('submit', function (e) {
            // Before submitting, create hidden inputs for the cart data
            const ids = [];
            const quantities = [];
            cart.forEach((item, productId) => {
                ids.push(productId);
                quantities.push(item.quantity);
            });

            // Create and append hidden inputs for the servlet
            const idsInput = document.createElement('input');
            idsInput.type = 'hidden';
            idsInput.name = 'allSelectedItemIDs';
            idsInput.value = ids.join(',');
            form.appendChild(idsInput);

            const quantitiesInput = document.createElement('input');
            quantitiesInput.type = 'hidden';
            quantitiesInput.name = 'allSelectedItemQuantities';
            quantitiesInput.value = quantities.join(',');
            form.appendChild(quantitiesInput);
        });

        // Initial render
        renderCart();
    });
</script>

<%-- Bootstrap 5 JS Bundle --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
