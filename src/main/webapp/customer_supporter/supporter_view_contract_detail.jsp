<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contract Detail</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <script src="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var contextPath = "${pageContext.request.contextPath}";
    </script>
</head>
<body>
<c:set var="activePage" value="viewContractDetail" scope="request"/>
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>
<div class="container-fluid p-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="mb-0">Contract Detail</h2>
        <button type="button" class="btn btn-outline-secondary" onclick="history.back()">
            <i class="bi bi-arrow-left"></i> Back
        </button>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger"><i class="bi bi-exclamation-triangle"></i> ${error}</div>
    </c:if>

    <c:if test="${not empty contract}">
        <div class="row g-3">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">Contract Information</div>
                    <div class="card-body">
                        <div class="mb-2"><strong>Contract ID:</strong> <span>#${contract.contractID}</span></div>
                        <div class="mb-2"><strong>Contract Code:</strong> <span>${contract.contractCode}</span></div>
                        <div class="mb-2"><strong>Start Date:</strong> <span>${contract.startDate}</span></div>
                        <div class="mb-2"><strong>Expired Date:</strong> <span>${contract.expiredDate}</span></div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">Customer Information</div>
                    <div class="card-body">
                        <div class="mb-2"><strong>Customer ID:</strong>
                            <span><c:choose><c:when
                                    test='${not empty customer and not empty customer.customerID}'>#${customer.customerID}</c:when><c:otherwise>N/A</c:otherwise></c:choose></span>
                        </div>
                        <div class="mb-2"><strong>Customer Name:</strong>
                            <span><c:choose><c:when
                                    test='${not empty customer and not empty customer.customerName}'>${customer.customerName}</c:when><c:otherwise>N/A</c:otherwise></c:choose></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card mt-4">
            <div class="card-header"><i class="bi bi-file-earmark-pdf"></i> Contract File</div>
            <div class="card-body text-center">
                <embed id="contractPDF" type="application/pdf" width="100%" height="600px" style="display: none;">
                <div id="noPDFNotice" class="alert alert-warning mt-3" style="display: none;">
                    Contract file not found or cannot be displayed.
                </div>
                <a id="downloadContractBtn" class="btn btn-success mt-3" href="#" download style="display: none;">
                    <i class="bi bi-download"></i> Download Contract
                </a>
                <div class="mt-3">
                    <button class="btn btn-info text-white" type="button"
                            onclick="viewDetails('${contract.contractCode}', '${contract.contractImage}')">
                        <i class="bi bi-eye"></i> View Contract
                    </button>
                </div>
            </div>
        </div>

        <div class="card mt-4">
            <div class="card-header"><i class="bi bi-box-seam"></i> Linked Products</div>
            <div class="card-body">
                <c:choose>
                    <c:when test='${not empty contractItems}'>
                        <div class="table-responsive">
                            <table class="table table-striped align-middle">
                                <thead>
                                <tr>
                                    <th style="width: 10%">Product ID</th>
                                    <th style="width: 40%">Product Name</th>
                                    <th style="width: 50%">Item Serial</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="item" items="${contractItems}">
                                    <tr>
                                        <td>
                                            <c:choose>
                                                <c:when test='${not empty item.product and not empty item.product.productID}'>
                                                    ${item.product.productID}
                                                </c:when>
                                                <c:otherwise>N/A</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test='${not empty item.product and not empty item.product.productName}'>
                                                    ${item.product.productName}
                                                </c:when>
                                                <c:otherwise>N/A</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${item.serialNumber}</td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-info mb-0"><i class="bi bi-info-circle"></i> No products linked to this contract.</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </c:if>
</div>
<script src="${pageContext.request.contextPath}/js/view-contract-detail.js"></script>
</body>
</html>
