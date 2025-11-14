<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Create Contract - Supporter</title>

    <!-- Bootstrap + Icons -->
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        /* Keep look consistent with other admin/supporter pages */
        body {
            margin-left: 260px !important;
            padding-top: 70px !important;
            background: linear-gradient(135deg, #f5f7fa 0%, #eef4ff 100%);
            min-height: 100vh;
            font-family: system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial;
            color: #1e1e1e;
        }

        main.container {
            max-width: 900px;
            padding: 28px;
        }

        .upload-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 12px 30px rgba(35,44,78,0.06);
            padding: 28px;
        }

        .upload-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-bottom: 18px;
        }

        .upload-header h2 {
            margin: 0;
            font-weight: 700;
        }

        .btn-back {
            background: rgba(43,76,176,0.12);
            color: #2b6cb0;
            border: none;
            padding: 8px 12px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }
        .btn-back:hover { opacity: .95; }

        .form-label { font-weight: 600; }

        .upload-zone {
            border: 2px dashed #e6e9f8;
            border-radius: 10px;
            padding: 36px 20px;
            text-align: center;
            transition: all 0.18s ease;
            background: #fbfdff;
            cursor: pointer;
        }
        .upload-zone:hover {
            border-color: #667eea;
            background: #f0f4ff;
        }

        .upload-icon {
            font-size: 3.2rem;
            color: #667eea;
            margin-bottom: 8px;
        }

        input[type="file"].d-none { display: none; }

        iframe#pdfPreview {
            border: 1px solid #e6e9f0;
            border-radius: 8px;
        }

        .actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 18px;
        }

        .btn-primary {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
            color: white;
            padding: 10px 18px;
            border-radius: 10px;
            font-weight: 600;
        }
        .btn-outline-secondary {
            border-radius: 10px;
            color: #6c757d;
            border-color: #6c757d;
            background: white;
            padding: 10px 18px;
        }

        .help-text { color: #6c757d; font-size: .9rem; margin-top: .25rem; }

        /* Inline success alert */
        .upload-success {
            border-radius: 10px;
            box-shadow: 0 8px 24px rgba(35,44,78,0.06);
            padding: 14px;
            margin-bottom: 18px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
        }
        .upload-success .left { display:flex; align-items:center; gap:12px; }
        .upload-success .right { display:flex; gap:8px; align-items:center; }

        @media (max-width: 992px) {
            body { margin-left: 0 !important; padding-top: 90px !important; }
            main.container { padding: 16px; }
        }

        /* small inline validation styling for modal serial input */
        .modal-serial-input.is-invalid {
            border-color: #dc3545;
        }
        .invalid-feedback { display:block; color:#dc3545; font-size:0.85rem; margin-top:4px; }
    </style>
</head>
<body>
<c:set var="activePage" value="createContract" scope="request" />
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>

<main class="container">
    <div class="upload-container">

        <div class="upload-header">
            <div>
                <h2><i class="bi bi-file-earmark-text me-2"></i>Create Contract</h2>
                <div class="text-muted" style="margin-top:4px;">Upload and attach a contract PDF for a customer</div>
            </div>

            <div>
                <a href="${pageContext.request.contextPath}/customer_supporter/customersupporter_actioncenter" class="btn-back">
                    <i class="bi bi-arrow-left-circle"></i> Back to Menu
                </a>
            </div>
        </div>


        <!-- Inline success alert shown when redirected with ?success=1&contractPDF=... -->
        <c:if test="${param.success == '1'}">
            <div id="successAlert" class="upload-success" style="background: linear-gradient(90deg,#ecfdf5,#e6fffa); border:1px solid #bbf7d0;">
                <div class="left">
                    <i class="bi bi-check-circle-fill text-success" style="font-size:1.6rem;"></i>
                    <div>
                        <div style="font-weight:700; color:#065f46;">Upload successful</div>
                        <div class="text-muted small">The contract was uploaded and saved.</div>
                    </div>
                </div>

                <div class="right">
                    <c:if test="${not empty param.contractPDF}">
                        <a id="viewPdfBtn" class="btn btn-sm btn-outline-primary" href="${param.contractPDF}" target="_blank">
                            <i class="bi bi-eye me-1"></i> View
                        </a>
                        <a id="downloadPdfBtn" class="btn btn-sm btn-outline-success" href="${param.contractPDF}" download>
                            <i class="bi bi-download me-1"></i> Download
                        </a>
                    </c:if>
                </div>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <form id="uploadForm" action="${pageContext.request.contextPath}/customer_supporter/create_contract"
              method="post" enctype="multipart/form-data" novalidate>
            <div class="row g-3">
                <div class="col-md-6">
                    <label for="userName" class="form-label">Customer Username</label>
                    <input type="text" class="form-control" id="userName" name="userName"
                           placeholder="Enter customer username" value="${account.username}" readonly>
                </div>
                <div class="col-md-6">
                    <label for="customerName" class="form-label">Customer Name</label>
                    <input type="text" class="form-control" id="customerName" name="customerName"
                           placeholder="Enter customer name" value="${customerName}" readonly>
                </div>
            </div>

            <div class="row g-3 mt-2">
                <div class="col-md-6">
                    <label for="startDate" class="form-label">Start Date</label>
                    <input type="date" class="form-control" id="startDate" name="startDate" value="${param.startDate != null ? param.startDate : ''}" required>
                    <div class="form-text help-text">Choose contract start date.</div>
                </div>

                <div class="col-md-6">
                    <label for="expireDate" class="form-label">Expire Date</label>
                    <input type="date" class="form-control" id="expireDate" name="expireDate" value="${param.expireDate != null ? param.expireDate : ''}" required>
                    <div class="form-text help-text">Choose contract expiration date.</div>
                </div>
            </div>

            <!-- Product List (part of POST form) -->
            <div class="d-flex justify-content-between align-items-center mt-4 mb-2">
                <h5 class="mb-0">Products</h5>
                <div>
                    <!-- open modal -->
                    <button type="button" id="openProductModalBtn" class="btn btn-outline-primary btn-sm" data-bs-toggle="modal" data-bs-target="#productModal">
                        <i class="bi bi-plus-circle me-1"></i> Add product
                    </button>
                </div>
            </div>

            <div id="productListContainer">
                <table id="productTable" class="table table-bordered align-middle">
                    <thead>
                    <tr>
                        <th>Product Name</th>
                        <th>Serial</th>
                        <th style="width:100px;">Action</th>
                    </tr>
                    </thead>
                    <tbody id="productTableBody">
                    <!-- Initially empty. JS will add selected products from the modal.
                         Each added row will include hidden inputs:
                         <input type="hidden" name="productId[]" value="...">
                         <input type="hidden" name="serialNumber[]" value="...">
                    -->
                    </tbody>
                </table>
                <div id="noProductPlaceholder" class="text-muted small">No products selected.</div>
            </div>

            <div class="mt-4">
                <div id="uploadZone" class="upload-zone" onclick="document.getElementById('fileInput').click()">
                    <div class="upload-icon"><i class="bi bi-cloud-upload"></i></div>
                    <h5 class="mb-2">Click to upload PDF</h5>
                    <div class="text-muted">Only PDF files are supported. Max size: 10MB.</div>
                    <input type="file" id="fileInput" name="contractImage" accept="application/pdf" class="d-none" required>
                </div>
                <div id="fileName" class="mt-2 text-muted small" style="display:none;"></div>
            </div>

            <div id="pdfPreviewContainer" class="mt-4" style="display:none;">
                <h5 class="mb-2"><i class="bi bi-eye me-2"></i>Preview</h5>
                <iframe id="pdfPreview" width="100%" height="560px" style="display:block;"></iframe>
            </div>

            <div class="actions">
                <a href="${pageContext.request.contextPath}/customer_supporter/create_contract?id=${account.username}" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-clockwise me-1"></i>Clear
                </a>
                <button type="submit" id="submitBtn" class="btn btn-primary">
                    <i class="bi bi-upload me-1"></i>Upload Contract
                </button>
            </div>
        </form>
    </div>
</main>

<!-- Product Modal -->
<div class="modal fade" id="productModal" tabindex="-1" aria-labelledby="productModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Select Products</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-2 d-flex gap-2">
                    <input type="text" id="productSearchInput" class="form-control" placeholder="Search product name...">
                </div>

                <div class="table-responsive" style="max-height:420px; overflow:auto;">
                    <table class="table table-hover table-sm" id="modalProductTable">
                        <thead>
                        <tr>
                            <th>Product Name</th>
                            <th style="width:320px;">Serial (enter serial to create inventory item)</th>
                            <th style="width:120px;">Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="prod" items="${products}">
                            <tr data-productid="${prod.productID}"
                                data-productname="<c:out value='${prod.productName}'/>">
                                <td class="modal-prod-name"><c:out value="${prod.productName}"/></td>
                                <td>
                                    <input type="text" class="form-control form-control-sm modal-serial-input"
                                           placeholder="Enter serial number for this product">
                                </td>
                                <td>
                                    <button type="button" class="btn btn-sm btn-outline-primary modal-add-one-btn">Add</button>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

            </div>
            <div class="modal-footer">
                <div class="me-auto text-muted small">When you Add a product, a new InventoryItem will be created from the Product using the serial number you provided and linked to the contract.</div>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- JS: preview, modal product selection and other behaviors -->
<script>
    (function () {
        // Preview PDF
        const fileInput = document.getElementById('fileInput');
        const pdfPreview = document.getElementById('pdfPreview');
        const pdfPreviewContainer = document.getElementById('pdfPreviewContainer');
        const fileNameEl = document.getElementById('fileName');
        const maxSizeBytes = 10 * 1024 * 1024; // 10MB

        if (fileInput) {
            fileInput.addEventListener('change', () => {
                const file = fileInput.files[0];
                if (!file) {
                    pdfPreviewContainer.style.display = 'none';
                    fileNameEl.style.display = 'none';
                    return;
                }

                if (file.type !== 'application/pdf') {
                    alert('Please select a PDF file.');
                    fileInput.value = '';
                    return;
                }

                if (file.size > maxSizeBytes) {
                    alert('File is too large. Maximum allowed size is 10MB.');
                    fileInput.value = '';
                    return;
                }

                const fileUrl = URL.createObjectURL(file);
                if (pdfPreview) pdfPreview.src = fileUrl;
                pdfPreviewContainer.style.display = 'block';
                fileNameEl.style.display = 'block';
                fileNameEl.textContent = 'Selected file: ' + file.name;
            });
        }

        // Auto-hide success alert
        const successAlert = document.getElementById('successAlert');
        if (successAlert) {
            setTimeout(() => {
                successAlert.style.transition = 'opacity 0.5s ease';
                successAlert.style.opacity = '0';
                setTimeout(() => successAlert.remove(), 600);
            }, 6000);
            successAlert.scrollIntoView({behavior: 'smooth', block: 'center'});
        }

        // Product modal interactions
        const modalProductTable = document.getElementById('modalProductTable');
        const productSearchInput = document.getElementById('productSearchInput');
        const productTableBody = document.getElementById('productTableBody');
        const noProductPlaceholder = document.getElementById('noProductPlaceholder');

        function updateNoProductPlaceholder() {
            const hasRows = productTableBody.querySelectorAll('tr').length > 0;
            noProductPlaceholder.style.display = hasRows ? 'none' : 'block';
        }

        updateNoProductPlaceholder();

        // Filter modal list
        if (productSearchInput) {
            productSearchInput.addEventListener('input', () => {
                const q = productSearchInput.value.trim().toLowerCase();
                const rows = modalProductTable.querySelectorAll('tbody tr');
                rows.forEach(r => {
                    const name = (r.querySelector('.modal-prod-name')?.textContent || '').toLowerCase();
                    const visible = name.includes(q);
                    r.style.display = visible ? '' : 'none';
                });
            });
        }

        // Helper: show inline error next to serial input
        function showInlineModalError(inputEl, msg) {
            clearInlineModalError(inputEl);
            inputEl.classList.add('is-invalid');
            const div = document.createElement('div');
            div.className = 'invalid-feedback';
            div.textContent = msg;
            inputEl.parentElement.appendChild(div);
            inputEl.focus();
        }
        function clearInlineModalError(inputEl) {
            if (!inputEl) return;
            inputEl.classList.remove('is-invalid');
            const prev = inputEl.parentElement.querySelector('.invalid-feedback');
            if (prev) prev.remove();
        }

        // Add one from modal row (Add button) -> server-side duplicate check before adding
        modalProductTable.addEventListener('click', (e) => {
            const addBtn = e.target.closest('.modal-add-one-btn');
            if (!addBtn) return;
            const row = addBtn.closest('tr');
            if (!row) return;

            const productId = row.getAttribute('data-productid');
            const productName = row.getAttribute('data-productname') || (row.querySelector('.modal-prod-name')?.textContent || '');
            const serialInput = row.querySelector('.modal-serial-input');
            const serial = serialInput ? serialInput.value.trim() : '';

            clearInlineModalError(serialInput);

            if (!serial) {
                showInlineModalError(serialInput, 'Please enter a serial number for the selected product before adding.');
                return;
            }

            // Prevent duplicates by productId + serial combination in current UI list
            const existing = productTableBody.querySelector('tr[data-productid="' + productId + '"][data-serial="' + encodeURIComponent(serial) + '"]');
            if (existing) {
                showInlineModalError(serialInput, 'This product with the same serial is already added to the list.');
                return;
            }

            // Call server endpoint to check duplicate serial:
            // endpoint uses SerialGenerator.generateSerial(productId, serial) internally and checks InventoryItem
            const checkUrl = '${pageContext.request.contextPath}/warehouse_keeper/check_serial_duplicate';
            const payload = new URLSearchParams();
            payload.append('productId', productId);
            payload.append('serial', serial);

            addBtn.disabled = true;
            fetch(checkUrl, {
                method: 'POST',
                body: payload,
                credentials: 'same-origin',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' }
            }).then(res => {
                addBtn.disabled = false;
                if (!res.ok) throw new Error('Network response was not ok');
                return res.json();
            }).then(data => {
                if (data && data.exists) {
                    showInlineModalError(serialInput, 'Serial already exists in inventory.');
                    return;
                }
                // not exists -> add to table
                addProductToTable(productId, productName, serial);
                if (serialInput) serialInput.value = '';
            }).catch(err => {
                addBtn.disabled = false;
                console.error('Error checking serial:', err);
                // fallback: ask user to confirm adding temporarily (server final check will still run)
                if (confirm('Could not verify serial on server. Add anyway? The server will still validate on submit.')) {
                    addProductToTable(productId, productName, serial);
                    if (serialInput) serialInput.value = '';
                } else {
                    // do nothing
                }
            });
        });

        // Helper: add product to main product table
        function addProductToTable(productId, productName, serial) {
            const tr = document.createElement('tr');
            tr.setAttribute('data-productid', productId);
            tr.setAttribute('data-serial', encodeURIComponent(serial));

            const tdName = document.createElement('td');
            tdName.innerHTML = '<input type="hidden" name="productId[]" value="' + escapeAttr(productId) + '">'
                + '<input type="hidden" name="serialNumber[]" value="' + escapeAttr(serial) + '">'
                + '<span>' + escapeHtml(productName) + '</span>';
            tr.appendChild(tdName);

            const tdSerial = document.createElement('td');
            tdSerial.textContent = serial;
            tr.appendChild(tdSerial);

            const tdAction = document.createElement('td');
            tdAction.innerHTML = '<button type="button" class="btn btn-sm btn-outline-danger remove-row-btn"><i class="bi bi-trash"></i></button>';
            tr.appendChild(tdAction);

            productTableBody.appendChild(tr);
            updateNoProductPlaceholder();
        }

        // Remove row handler (delegation)
        productTableBody.addEventListener('click', (e) => {
            const btn = e.target.closest('.remove-row-btn');
            if (!btn) return;
            const tr = btn.closest('tr');
            if (tr) tr.remove();
            updateNoProductPlaceholder();
        });

        // Simple HTML escape for inserted text
        function escapeHtml(str) {
            if (str === undefined || str === null) return '';
            return String(str).replace(/[&<>"']/g, function (m) {
                return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'})[m];
            });
        }
        function escapeAttr(str) {
            return escapeHtml(str).replace(/"/g, '&quot;');
        }

        // If user loads page with no server-side selected products, show placeholder
        updateNoProductPlaceholder();

    })();
</script>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>