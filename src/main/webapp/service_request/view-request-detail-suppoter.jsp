<%@ page import="java.util.Map" %><%--
  Created by IntelliJ IDEA.
  User: anhtu
  Date: 10/5/2025
  Time: 4:05 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<html>
<head>
    <title>View Request Detail</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
          rel="stylesheet"/>
</head>
<body>
<jsp:include page="../components/header.jsp"/>
<div class="container py-5">
    <div class="card shadow-sm">
        <div class="card-header bg-primary text-white">
            <h3 class="mb-0">Request Detail</h3>
        </div>
        <div class="card-body">


            <div class="mb-4">
                <h5 class="border-bottom pb-2 text-secondary">Customer Information</h5>
                <p><strong>Customer Name:</strong>
                    <a href="/requests/list">
                        ${request.contract.customer.customerName}
                    </a>
                </p>
                <p><strong>Address:</strong> ${request.contract.customer.address}</p>
                <p><strong>Phone:</strong> ${request.contract.customer.phone}</p>
                <p><strong>Email:</strong> ${request.contract.customer.email}</p>
            </div>


            <div class="mb-4">
                <h5 class="border-bottom pb-2 text-secondary">Request Information</h5>
                <p><strong>Contract ID:</strong>
                    <a href="./requests/list">
                        ${request.contract.contractID}
                    </a>
                </p>
                <p><strong>Description:</strong> ${request.requestDescription}</p>
                <p><strong>Status:</strong>
                    <span class="text-warning" style="font-weight: bold">${request.requestStatus}</span>
                </p>
                <p><strong>Note:</strong> ${request.note}</p>
                <p><strong>Create Date:</strong> ${request.startDate}</p>
                <p><strong>Finish Date:</strong> ${request.finishedDate}</p>
            </div>


            <div class="d-flex justify-content-end gap-2">
                <c:if test="${request.requestStatus == 'Pending'}">
                    <a href="./process?requestId=${request.requestID}" class="btn btn-warning">Process Request</a>
                </c:if>
                <a href="../../staff/requests/timeline?requestId=${request.requestID}"
                   class="btn btn-primary">Timeline</a>
                <a href="./list" class="btn btn-secondary">Back to List</a>
            </div>

        </div>
    </div>
</div>
</body>
</html>
