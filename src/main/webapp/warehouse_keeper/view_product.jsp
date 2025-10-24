<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Product</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .card {
            animation: fadeIn 0.5s ease-out;
        }
    </style>
</head>
<body class="bg-light">
<jsp:include page="../components/warehouse_keeper_header.jsp"/>
<div class="container py-4">
    <!-- Header -->
    <div class="card shadow-sm p-3 mb-4">
        <h1 class="h3 fw-bold text-dark mb-0">View Product In Warehouse</h1>
    </div>

    <!-- Function Buttons -->
    <div class="card shadow-sm p-3 mb-4">
        <h2 class="h5 fw-semibold text-dark mb-3">Inventory Actions</h2>
        <div class="d-flex flex-wrap gap-2">
            <a href="" class="btn btn-success d-flex align-items-center">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                     class="bi bi-box-arrow-in-down me-2" viewBox="0 0 16 16">
                    <path fill-rule="evenodd"
                          d="M3.5 10a.5.5 0 0 1-.5-.5v-8a.5.5 0 0 1 .5-.5h9a.5.5 0 0 1 .5.5v8a.5.5 0 0 1-.5.5h-2a.5.5 0 0 0 0 1h2A1.5 1.5 0 0 0 14 9.5v-8A1.5 1.5 0 0 0 12.5 0h-9A1.5 1.5 0 0 0 2 1.5v8A1.5 1.5 0 0 0 3.5 11h2a.5.5 0 0 0 0-1h-2z"/>
                    <path fill-rule="evenodd"
                          d="M7.646 15.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 14.293V5.5a.5.5 0 0 0-1 0v8.793l-2.146-2.147a.5.5 0 0 0-.708.708l3 3z"/>
                </svg>
                Import Products
            </a>
            <a href="" class="btn btn-warning d-flex align-items-center">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                     class="bi bi-box-arrow-up me-2" viewBox="0 0 16 16">
                    <path fill-rule="evenodd"
                          d="M3.5 10a.5.5 0 0 1-.5-.5v-8a.5.5 0 0 1 .5-.5h9a.5.5 0 0 1 .5.5v8a.5.5 0 0 1-.5.5h-2a.5.5 0 0 0 0 1h2A1.5 1.5 0 0 0 14 9.5v-8A1.5 1.5 0 0 0 12.5 0h-9A1.5 1.5 0 0 0 2 1.5v8A1.5 1.5 0 0 0 3.5 11h2a.5.5 0 0 0 0-1h-2Z"/>
                    <path fill-rule="evenodd"
                          d="M7.646 4.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1-.708.708L8.5 5.707V14.5a.5.5 0 0 1-1 0V5.707L5.354 7.854a.5.5 0 1 1-.708-.708l3-3Z"/>
                </svg>
                Export Products
            </a>
            <a href="" class="btn btn-info d-flex align-items-center">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                     class="bi bi-arrow-left-right me-2" viewBox="0 0 16 16">
                    <path fill-rule="evenodd"
                          d="M1 11.5a.5.5 0 0 0 .5.5h11.793l-3.147 3.146a.5.5 0 0 0 .708.708l4-4a.5.5 0 0 0 0-.708l-4-4a.5.5 0 0 0-.708.708L13.293 11H1.5a.5.5 0 0 0-.5.5zm14-7a.5.5 0 0 1-.5.5H2.707l3.147 3.146a.5.5 0 1 1-.708.708l-4-4a.5.5 0 0 1 0-.708l4-4a.5.5 0 1 1 .708.708L2.707 4H14.5a.5.5 0 0 1 .5.5z"/>
                </svg>
                Transfer Items
            </a>
            <a href="${pageContext.request.contextPath}/warehouse_keeper/view_warehouse_detail"
               class="btn btn-info d-flex align-items-center">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                     class="bi bi-building me-2" viewBox="0 0 16 16">
                    <path d="M4 2.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1Zm3 0a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1Zm3.5-.5a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h1a.5.5 0 0 0 .5-.5v-1a.5.5 0 0 0-.5-.5h-1ZM4 5.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1ZM7.5 5a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h1a.5.5 0 0 0 .5-.5v-1a.5.5 0 0 0-.5-.5h-1Zm2.5.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1ZM4.5 8a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h1a.5.5 0 0 0 .5-.5v-1a.5.5 0 0 0-.5-.5h-1Zm2.5.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1Zm3.5-.5a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h1a.5.5 0 0 0 .5-.5v-1a.5.5 0 0 0-.5-.5h-1Z"/>
                    <path d="M2 1a1 1 0 0 1 1-1h10a1 1 0 0 1 1 1v14a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1V1Zm11 0H3v14h3v-2.5a.5.5 0 0 1 .5-.5h3a.5.5 0 0 1 .5.5V15h3V1Z"/>
                </svg>
                Warehouse Detail
            </a>
        </div>
    </div>

    <!-- Filters -->
    <div class="card shadow-sm p-3 mb-4">
        <h2 class="h5 fw-semibold text-dark mb-3">Filter</h2>
        <form action="${pageContext.request.contextPath}/warehouse_keeper/view_product_warehouse" method="GET"
              id="filterForm">
            <input type="hidden" name="pageSize" value="${pageSize}">
            <input type="hidden" name="page" value="${currentPage}">
            <div class="row g-3 align-items-end">
                <div class="col-md">
                    <label for="productName" class="form-label">ProductName</label>
                    <input type="text" id="productName" name="productName" class="form-control"
                           placeholder="Enter product name...">
                </div>
                <div class="col-md">
                    <label for="productType" class="form-label">Product Type</label>
                    <select id="productType" name="productType" class="form-select">
                        <option value="">All type</option>
                        <c:forEach items="${uniqueProductTypes}" var="type">
                            <option value="${type.typeName}" ${productType == type.typeName ? 'selected' : ''}>${type.typeName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-auto">
                    <button type="submit" class="btn btn-primary w-100">Apply Filters</button>
                </div>
            </div>
        </form>
    </div>

    <!-- Page Size Selector -->
    <div class="card shadow-sm p-3 mb-4">
        <div class="d-flex justify-content-between align-items-center">
            <div class="d-flex align-items-center gap-2">
                <span class="text-muted small">Display:</span>
                <form action="${pageContext.request.contextPath}/warehouse_keeper/view_product_warehouse" method="GET"
                      class="mb-0">
                    <input type="hidden" name="productName" value="${productName}">
                    <input type="hidden" name="productType" value="${productType}">
                    <input type="hidden" name="page" value="${currentPage}">
                    <select name="pageSize" id="pageSize" class="form-select form-select-sm"
                            onchange="this.form.submit()">
                        <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                        <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                        <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                        <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                    </select>
                </form>
            </div>
            <div class="text-muted small">
                Total: <span class="fw-semibold text-primary">${totalProducts}</span> products
            </div>
        </div>
    </div>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-warning text-center" role="alert">
                ${errorMessage}
        </div>
    </c:if>

    <!-- Products Table -->
    <div class="card shadow-sm p-3 mb-4">
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-light">
                <tr>
                    <th scope="col">Name</th>
                    <th scope="col">Description</th>
                    <th scope="col">Type</th>
                    <th scope="col">Specification</th>
                    <th scope="col">Stock</th>
                    <th scope="col">Action</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="productWarehouse" items="${products}">
                    <tr>
                        <td>${productWarehouse.productName}</td>
                        <td class="text-muted">${productWarehouse.productDescription}</td>
                        <td>${productWarehouse.type.typeName}</td>
                        <td>
                            <c:forEach var="spec" items="${productWarehouse.productSpecifications}">
                                <div class="text-nowrap">
                                    <span class="fw-medium">${spec.specification.specificationName}:</span>
                                    <span class="text-muted">${spec.specification.specificationValue}</span>
                                </div>
                            </c:forEach>
                        </td>
                        <td class="fw-semibold">${productCounts[productWarehouse.productID]}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/warehouse_keeper/view_product_detail?productId=${productWarehouse.productID}"
                               class="btn btn-sm btn-info">View Detail</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Pagination -->
    <div class="card shadow-sm p-3">
        <c:set var="startItem" value="${totalProducts == 0 ? 0 : (currentPage - 1) * pageSize + 1}"/>
        <c:set var="endItem"
               value="${currentPage * pageSize > totalProducts ? totalProducts : currentPage * pageSize}"/>

        <div class="d-flex flex-column flex-md-row justify-content-between align-items-center gap-2">
            <div class="text-muted small">
                Page <span class="fw-semibold">${currentPage}</span> of <span class="fw-semibold">${totalPages}</span>
                (Displaying ${startItem} - ${endItem} of ${totalProducts} items)
            </div>

            <div class="d-flex align-items-center gap-2">
                <nav aria-label="Page navigation">
                    <ul class="pagination pagination-sm mb-0">
                        <!-- Previous -->
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/warehouse_keeper/view_product_warehouse?page=${currentPage - 1}&pageSize=${pageSize}&productName=${productName}&productType=${productType}">Previous</a>
                        </li>

                        <!-- Page Numbers Logic -->
                        <c:set var="maxVisiblePages" value="5"/>
                        <c:set var="startPage" value="${currentPage - 2}"/>
                        <c:set var="endPage" value="${currentPage + 2}"/>
                        <c:if test="${startPage < 1}"><c:set var="endPage" value="${endPage - (startPage - 1)}"/><c:set
                                var="startPage" value="1"/></c:if>
                        <c:if test="${endPage > totalPages}"><c:set var="startPage"
                                                                    value="${startPage - (endPage - totalPages)}"/><c:set
                                var="endPage" value="${totalPages}"/></c:if>
                        <c:if test="${startPage < 1}"><c:set var="startPage" value="1"/></c:if>

                        <c:if test="${startPage > 1}">
                            <li class="page-item"><a class="page-link"
                                                     href="${pageContext.request.contextPath}/warehouse_keeper/view_product_warehouse?page=1&pageSize=${pageSize}&productName=${productName}&productType=${productType}">1</a>
                            </li>
                            <c:if test="${startPage > 2}">
                                <li class="page-item disabled"><span class="page-link">...</span></li>
                            </c:if>
                        </c:if>

                        <c:forEach begin="${startPage}" end="${endPage}" var="i">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link"
                                   href="${pageContext.request.contextPath}/warehouse_keeper/view_product_warehouse?page=${i}&pageSize=${pageSize}&productName=${productName}&productType=${productType}">${i}</a>
                            </li>
                        </c:forEach>

                        <c:if test="${endPage < totalPages}">
                            <c:if test="${endPage < totalPages - 1}">
                                <li class="page-item disabled"><span class="page-link">...</span></li>
                            </c:if>
                            <li class="page-item"><a class="page-link"
                                                     href="${pageContext.request.contextPath}/warehouse_keeper/view_product_warehouse?page=${totalPages}&pageSize=${pageSize}&productName=${productName}&productType=${productType}">${totalPages}</a>
                            </li>
                        </c:if>

                        <!-- Next -->
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/warehouse_keeper/view_product_warehouse?page=${currentPage + 1}&pageSize=${pageSize}&productName=${productName}&productType=${productType}">Next</a>
                        </li>
                    </ul>
                </nav>

                <!-- Go to Page -->
                <form action="${pageContext.request.contextPath}/warehouse_keeper/view_product_warehouse" method="GET"
                      class="d-flex align-items-center gap-1 mb-0">
                    <input type="hidden" name="pageSize" value="${pageSize}">
                    <input type="hidden" name="productName" value="${productName}">
                    <input type="hidden" name="productType" value="${productType}">
                    <input type="number" name="page" min="1" max="${totalPages}"
                           class="form-control form-control-sm" style="width: 70px;" placeholder="Page">
                    <button type="submit" class="btn btn-sm btn-outline-secondary">Go</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>