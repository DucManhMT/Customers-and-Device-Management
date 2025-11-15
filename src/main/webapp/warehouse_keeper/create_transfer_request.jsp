<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Transfer Request</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        :root {
            --primary-color: #4a90e2;
            --success-color: #22c55e;
            --danger-color: #ef4444;
            --card-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            --card-shadow-hover: 0 8px 24px rgba(0, 0, 0, 0.12);
        }

        body {
            background-color: #f8f9fa;
        }

        .main-content {
            padding: 2rem;
        }

        .page-header {
            background: white;
            border-radius: 12px;
            padding: 1.5rem 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--card-shadow);
        }

        .page-header h1 {
            margin: 0;
            color: #1e293b;
            font-weight: 700;
            font-size: 1.75rem;
        }

        .filter-section {
            background: #f8fafc;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            border: 1px solid #e2e8f0;
        }

        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-top: 1.5rem;
        }

        .product-card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            overflow: hidden;
            transition: all 0.3s ease;
            box-shadow: var(--card-shadow);
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--card-shadow-hover);
            border-color: var(--primary-color);
        }

        .product-card .card-body {
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
        }

        .product-card .card-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 0.5rem;
        }

        .product-card .card-text {
            color: #64748b;
            font-size: 0.9rem;
            line-height: 1.5;
        }

        .product-type-badge {
            display: inline-block;
            background: linear-gradient(135deg, var(--primary-color), #667eea);
            color: white;
            padding: 0.35rem 0.75rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .spec-item {
            background: #f8fafc;
            padding: 0.5rem 0.75rem;
            border-radius: 6px;
            font-size: 0.85rem;
            border-left: 3px solid var(--primary-color);
        }

        .spec-item strong {
            color: #1e293b;
        }

        .btn-add-to-cart {
            margin-top: auto;
            border-radius: 8px;
            padding: 0.65rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-add-to-cart:not(.btn-primary):hover {
            background: var(--primary-color);
            color: white;
            transform: scale(1.02);
        }

        .cart-container {
            position: sticky;
            top: 90px;
            height: calc(100vh - 110px);
        }

        .cart-card {
            background: white;
            border: none;
            border-radius: 12px;
            box-shadow: var(--card-shadow);
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .cart-header {
            background: linear-gradient(135deg, var(--primary-color), #667eea);
            color: white;
            padding: 1.5rem;
            border-radius: 12px 12px 0 0;
        }

        .cart-header h5 {
            margin: 0;
            font-weight: 700;
        }

        .cart-items {
            flex-grow: 1;
            overflow-y: auto;
            padding: 1.5rem;
            max-height: calc(100vh - 450px);
        }

        .cart-empty-state {
            text-align: center;
            padding: 3rem 1rem;
            color: #94a3b8;
        }

        .cart-empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .cart-item {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 0.75rem;
            transition: all 0.2s ease;
        }

        .cart-item:hover {
            border-color: var(--primary-color);
            box-shadow: 0 2px 8px rgba(74, 144, 226, 0.1);
        }

        .cart-item-name {
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 0.5rem;
            font-size: 0.95rem;
        }

        .quantity-control {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .quantity-input {
            width: 70px;
            text-align: center;
            border-radius: 6px;
            border: 1px solid #cbd5e1;
            padding: 0.5rem;
            font-weight: 600;
        }

        .quantity-input:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
        }

        .btn-remove {
            background: transparent;
            border: 1px solid #fecaca;
            color: var(--danger-color);
            padding: 0.5rem 0.75rem;
            border-radius: 6px;
            transition: all 0.2s ease;
        }

        .btn-remove:hover {
            background: var(--danger-color);
            color: white;
            border-color: var(--danger-color);
        }

        .cart-footer {
            background: #f8fafc;
            padding: 1.5rem;
            border-radius: 0 0 12px 12px;
            border-top: 1px solid #e2e8f0;
        }

        .btn-create-request {
            background: linear-gradient(135deg, var(--success-color), #16a34a);
            border: none;
            color: white;
            padding: 0.875rem;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-create-request:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(34, 197, 94, 0.3);
        }

        .btn-create-request:disabled {
            background: #cbd5e1;
            cursor: not-allowed;
        }

        .filter-btn {
            border-radius: 8px;
            padding: 0.625rem 1.25rem;
            font-weight: 600;
            transition: all 0.2s ease;
        }

        .filter-btn:hover {
            transform: translateY(-1px);
        }

        .form-control, .form-select {
            border-radius: 8px;
            border: 1px solid #cbd5e1;
            padding: 0.625rem 1rem;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
        }

        textarea.form-control {
            resize: vertical;
            min-height: 80px;
        }

        .empty-products {
            text-align: center;
            padding: 3rem;
            background: white;
            border-radius: 12px;
            border: 2px dashed #cbd5e1;
        }

        .empty-products i {
            font-size: 3rem;
            color: #cbd5e1;
            margin-bottom: 1rem;
        }

        .alert {
            border: none;
            border-radius: 12px;
            padding: 1rem 1.5rem;
            animation: slideDown 0.3s ease;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @media (max-width: 991px) {
            .cart-container {
                position: static;
                height: auto;
                margin-top: 2rem;
            }

            .cart-items {
                max-height: 400px;
            }
        }

        @media (max-width: 768px) {
            .main-content {
                padding: 1rem;
            }

            .product-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>

<div class="main-content">
    <div class="container-fluid">
        <div class="page-header">
            <h1><i class="fas fa-exchange-alt me-2"></i>Create Transfer Request</h1>
        </div>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle me-2"></i>${successMessage}
            </div>
        </c:if>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
            </div>
        </c:if>

        <div class="row g-4">
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm" style="border-radius: 12px;">
                    <div class="card-body p-4">
                        <h5 class="mb-4"><i class="fas fa-box-open me-2 text-primary"></i>Available Products</h5>

                        <div class="filter-section">
                            <form action="${pageContext.request.contextPath}/warehouse_keeper/create_transfer_request"
                                  method="GET" class="row g-3">
                                <div class="col-md-5">
                                    <input type="text" class="form-control" name="productName"
                                           placeholder="Search by product name..." value="${productName}">
                                </div>
                                <div class="col-md-4">
                                    <select name="productType" class="form-select">
                                        <option value="">All Product Types</option>
                                        <c:forEach var="type" items="${uniqueProductTypes}">
                                            <option value="${type.typeID}" ${type.typeID == productType ? 'selected' : ''}>
                                                    ${type.typeName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-3 d-flex gap-2">
                                    <button type="submit" class="btn btn-primary filter-btn flex-grow-1">
                                        <i class="fas fa-filter me-1"></i>Filter
                                    </button>
                                    <a href="${pageContext.request.contextPath}/warehouse_keeper/create_transfer_request"
                                       class="btn btn-secondary filter-btn">
                                        <i class="fas fa-redo me-1"></i>
                                    </a>
                                </div>
                            </form>
                        </div>

                        <c:choose>
                            <c:when test="${empty products}">
                                <div class="empty-products">
                                    <i class="fas fa-box-open"></i>
                                    <h5>No Products Found</h5>
                                    <p class="text-muted mb-0">Try adjusting your filters or check back later.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="product-grid">
                                    <c:forEach var="p" items="${products}">
                                        <div class="card product-card">
                                            <div class="card-body">
                                                <h5 class="card-title">${p.productName}</h5>
                                                <p class="card-text">${p.productDescription}</p>
                                                <div class="mb-3">
                                                    <span class="product-type-badge">${p.type.typeName}</span>
                                                </div>
                                                <c:forEach var="spec" items="${p.productSpecifications}">
                                                    <div class="spec-item">
                                                        <strong>${spec.specification.specificationName}:</strong> ${spec.specification.specificationValue}
                                                    </div>
                                                </c:forEach>
                                                <button class="btn btn-outline-primary btn-add-to-cart"
                                                        data-product-id="${p.productID}"
                                                        data-product-name="${p.productName}">
                                                    <i class="fas fa-plus me-1"></i>Add to Request
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="cart-container">
                    <div class="cart-card">
                        <div class="cart-header">
                            <h5><i class="fas fa-shopping-cart me-2"></i>Transfer Request Cart</h5>
                        </div>

                        <form id="transfer-request-form"
                              action="${pageContext.request.contextPath}/warehouse_keeper/create_transfer_request"
                              method="POST" class="d-flex flex-column h-100">

                            <div class="cart-items" id="cart-items-container">
                                <div id="cart-empty-msg" class="cart-empty-state">
                                    <i class="fas fa-inbox"></i>
                                    <h6>Your cart is empty</h6>
                                    <p class="small text-muted mb-0">Add products to create a transfer request</p>
                                </div>
                            </div>

                            <div class="cart-footer">
                                <div class="mb-3">
                                    <label for="note" class="form-label fw-semibold">
                                        <i class="fas fa-sticky-note me-1"></i>Note (Optional)
                                    </label>
                                    <textarea id="note" name="note" class="form-control"
                                              placeholder="Add any additional information..."></textarea>
                                </div>
                                <button type="submit" id="create-request-btn" class="btn btn-create-request w-100"
                                        disabled>
                                    <i class="fas fa-paper-plane me-2"></i>Create Transfer Request
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
        const cart = new Map();
        const addToCartButtons = document.querySelectorAll('.btn-add-to-cart');
        const cartContainer = document.getElementById('cart-items-container');
        const emptyCartMsg = document.getElementById('cart-empty-msg');
        const createRequestBtn = document.getElementById('create-request-btn');
        const form = document.getElementById('transfer-request-form');
        const filterForm = document.querySelector('.filter-section form');

        // Load cart from URL parameters
        function loadCart() {
            const urlParams = new URLSearchParams(window.location.search);
            const cartData = urlParams.get('cartData');

            if (cartData) {
                try {
                    const items = JSON.parse(decodeURIComponent(cartData));
                    items.forEach(item => {
                        cart.set(item.productId, {
                            name: item.name,
                            quantity: item.quantity
                        });
                    });
                } catch (e) {
                    console.error('Error loading cart:', e);
                }
            }
        }

        // Add cart data to filter form
        function attachCartToFilterForm() {
            const existingCartInput = filterForm.querySelector('input[name="cartData"]');
            if (existingCartInput) {
                existingCartInput.remove();
            }

            if (cart.size > 0) {
                const cartData = [];
                cart.forEach((item, productId) => {
                    cartData.push({
                        productId: productId,
                        name: item.name,
                        quantity: item.quantity
                    });
                });

                const cartInput = document.createElement('input');
                cartInput.type = 'hidden';
                cartInput.name = 'cartData';
                cartInput.value = encodeURIComponent(JSON.stringify(cartData));
                filterForm.appendChild(cartInput);
            }
        }

        function renderCart() {
            const items = cartContainer.querySelectorAll('.cart-item');
            items.forEach(item => item.remove());

            if (cart.size === 0) {
                emptyCartMsg.style.display = 'block';
                createRequestBtn.disabled = true;
            } else {
                emptyCartMsg.style.display = 'none';
                createRequestBtn.disabled = false;

                cart.forEach((item, productId) => {
                    const cartItemEl = document.createElement('div');
                    cartItemEl.className = 'cart-item';

                    const itemName = document.createElement('div');
                    itemName.className = 'cart-item-name';
                    itemName.textContent = item.name || 'Unknown Product';

                    const controlsDiv = document.createElement('div');
                    controlsDiv.className = 'quantity-control';

                    const quantityInput = document.createElement('input');
                    quantityInput.type = 'number';
                    quantityInput.className = 'quantity-input form-control';
                    quantityInput.name = `quantity_${productId}`;
                    quantityInput.value = item.quantity;
                    quantityInput.min = '1';
                    quantityInput.dataset.productId = productId;
                    quantityInput.required = true;

                    const removeBtn = document.createElement('button');
                    removeBtn.type = 'button';
                    removeBtn.className = 'btn btn-remove remove-item-btn';
                    removeBtn.dataset.productId = productId;
                    removeBtn.innerHTML = '<i class="fas fa-trash-alt"></i>';

                    controlsDiv.appendChild(quantityInput);
                    controlsDiv.appendChild(removeBtn);

                    cartItemEl.appendChild(itemName);
                    cartItemEl.appendChild(controlsDiv);

                    cartContainer.appendChild(cartItemEl);
                });
            }
            updateButtonStates();
            attachCartToFilterForm();
        }

        function updateButtonStates() {
            addToCartButtons.forEach(btn => {
                const productId = btn.dataset.productId;
                if (cart.has(productId)) {
                    btn.innerHTML = '<i class="fas fa-check me-1"></i>Added';
                    btn.classList.remove('btn-outline-primary');
                    btn.classList.add('btn-primary');
                    btn.disabled = true;
                } else {
                    btn.innerHTML = '<i class="fas fa-plus me-1"></i>Add to Request';
                    btn.classList.remove('btn-primary');
                    btn.classList.add('btn-outline-primary');
                    btn.disabled = false;
                }
            });
        }

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

        cartContainer.addEventListener('click', (e) => {
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
                    attachCartToFilterForm();
                }
            }
        });

        form.addEventListener('submit', function (e) {
            const ids = [];
            const quantities = [];
            cart.forEach((item, productId) => {
                ids.push(productId);
                quantities.push(item.quantity);
            });

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

        // Initialize
        loadCart();
        renderCart();
    });

</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
