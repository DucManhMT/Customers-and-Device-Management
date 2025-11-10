<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Add New Product</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>


<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow-sm">
                <div class="card-header bg-light py-3">
                    <h1 class="h4 mb-0">Add a New Product</h1>
                </div>
                <div>
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger text-center m-3" role="alert">
                                ${errorMessage}
                        </div>
                    </c:if>

                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success text-center m-3" role="alert">
                                ${successMessage}
                        </div>
                    </c:if>
                </div>
                <div class="card-body">
                    <%-- Product Type --%>
                    <div class="mb-3">
                        <label for="type" class="form-label">Product Type</label>
                        <form action="${pageContext.request.contextPath}/warehouse_keeper/add_product" method="GET">
                            <select class="form-select" id="type" name="typeID" required onchange="this.form.submit()">
                                <option value="" disabled selected>-- Select a Type --</option>
                                <c:forEach var="type" items="${types}">
                                    <option value="${type.typeID}" ${selectedType.typeID == type.typeID ? 'selected' : ''}>${type.typeName}</option>
                                </c:forEach>
                            </select>
                        </form>
                    </div>

                        <form action="${pageContext.request.contextPath}/warehouse_keeper/add_product" method="post"
                              enctype="multipart/form-data">
                            <input type="hidden" name="typeID" value="${selectedType.typeID}">
                                <%-- Product Name --%>
                            <div class="mb-3">
                                <label for="productName" class="form-label">Product Name</label>
                                <input type="text" class="form-control" id="productName" name="productName" required>
                            </div>

                                <%-- Product Description --%>
                            <div class="mb-3">
                                <label for="productDescription" class="form-label">Description</label>
                                <textarea class="form-control" id="productDescription" name="productDescription"
                                          rows="3"></textarea>
                            </div>

                                <%-- Product Image Upload --%>
                            <div class="mb-3">
                                <label for="productImage" class="form-label">Product Image</label>
                                <input class="form-control" type="file" id="productImage" name="productImage"
                                       accept="image/*">
                            </div>

                                <%-- Dynamic Specifications --%>
                            <div class="mb-4">
                                <label class="form-label">Specifications</label>
                                <div id="specifications-container">
                                        <%-- Initial specification row will be added by script --%>
                                </div>
                                <button type="button" id="add-spec-btn" class="btn btn-sm btn-outline-secondary mt-2">
                                    Add Specification
                                </button>
                            </div>

                                <%-- Submit Button --%>
                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary">Add Product</button>
                            </div>
                        </form>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- Hidden template for new specification rows --%>
<div id="spec-template" style="display: none;">
    <div class="row g-2 mb-2 spec-row align-items-center">
        <div class="col">
            <select class="form-select" name="specIDs">
                <option value="" disabled selected>-- Select Specification --</option>
                <c:forEach var="specType" items="${selectedType.specificationTypes}">
                    <c:forEach var="spec" items="${specType.specifications}">
                        <option value="${spec.specificationID}">${spec.specificationName}: ${spec.specificationValue}</option>
                    </c:forEach>
                </c:forEach>
            </select>
        </div>
        <div class="col-auto">
            <button type="button" class="btn btn-sm btn-danger remove-spec-btn">&times;</button>
        </div>
    </div>
</div>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const container = document.getElementById('specifications-container');
        const addButton = document.getElementById('add-spec-btn');
        const template = document.getElementById('spec-template');

        const addSpecRow = () => {
            const newRow = template.firstElementChild.cloneNode(true);
            container.appendChild(newRow);
        };

        addButton.addEventListener('click', addSpecRow);

        container.addEventListener('click', function (e) {
            if (e.target && e.target.classList.contains('remove-spec-btn')) {
                e.target.closest('.spec-row').remove();
            }
        });

        // Add one initial row to start with
        addSpecRow();
    });
</script>

</body>
</html>
