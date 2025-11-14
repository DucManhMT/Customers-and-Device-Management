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
<c:set var="account" value='${sessionScope.account}'/>
<c:choose>
    <c:when test='${not empty account and not empty account.role and account.role.roleName eq "Customer"}'>
        <jsp:include page="../components/customer_sidebar.jsp"/>
    </c:when>
    <c:otherwise>
        <jsp:include page="../components/sidebar.jsp"/>
    </c:otherwise>
    
</c:choose>
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
                    <c:when test='${not empty productContracts}'>
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
                                <c:forEach var="pc" items="${productContracts}">
                                    <tr>
                                        <td><c:out value='${pc.inventoryItem.product.productID}' default='N/A'/></td>
                                        <td><c:out value='${pc.inventoryItem.product.productName}' default='N/A'/></td>
                                        <td><c:out value='${pc.inventoryItem.serialNumber}' default='N/A'/></td>
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

        <div class="card mt-4">
            <div class="card-header"><i class="bi bi-journal-text"></i> Related Requests</div>
            <div class="card-body">
                <c:choose>
                    <c:when test='${not empty requests}'>
                        <div class="table-responsive">
                            <table class="table table-striped align-middle mb-0">
                                <thead class="table-light">
                                <tr>
                                    <th style="width: 15%">Request ID</th>
                                    <th style="width: 25%">Status</th>
                                    <th style="width: 30%">Start Date</th>
                                    <th style="width: 30%">Finish Date</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="r" items="${requests}">
                                    <tr>
                                        <td><c:out value='${r.requestID}' default='N/A'/></td>
                                        <td>
                                            <span class="badge
                                                <c:choose>
                                                    <c:when test='${r.requestStatus eq "Pending"}'>bg-warning text-dark</c:when>
                                                    <c:when test='${r.requestStatus eq "Processing"}'>bg-primary</c:when>
                                                    <c:when test='${r.requestStatus eq "Tech_Finished"}'>bg-info text-dark</c:when>
                                                    <c:when test='${r.requestStatus eq "Finished"}'>bg-success</c:when>
                                                    <c:when test='${r.requestStatus eq "Rejected"}'>bg-danger</c:when>
                                                    <c:otherwise>bg-secondary</c:otherwise>
                                                </c:choose>">
                                                ${r.requestStatus}
                                            </span>
                                        </td>
                                        <td><c:out value='${r.startDate}' default='-'/></td>
                                        <td><c:out value='${empty r.finishedDate ? "-" : r.finishedDate}'/></td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-info mb-0"><i class="bi bi-info-circle"></i> No requests for this contract.</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </c:if>
</div>
<script src="${pageContext.request.contextPath}/js/view-contract-detail.js"></script>
</body>
</html>
