<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: anhtu
  Date: 10/8/2025
  Time: 9:42 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>

<html>
<head>
    <title>Request Detail</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
          rel="stylesheet"/>
</head>
<body>
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/customer_sidebar.jsp"/>
<div class="container py-5">
    <c:choose>
            <c:when test="${request.requestStatus == 'Pending'}">
              <c:set var="statusClass" value="bg-warning text-dark" />
            </c:when>
            <c:when test="${request.requestStatus == 'Processing'}">
              <c:set var="statusClass" value="bg-primary" />
            </c:when>
            <c:when test="${request.requestStatus == 'Tech_Finished'}">
              <c:set var="statusClass" value="bg-info" />
            </c:when>
            <c:when test="${request.requestStatus == 'Finished'}">
              <c:set var="statusClass" value="bg-success" />
            </c:when>
            <c:when test="${request.requestStatus == 'Rejected'}">
              <c:set var="statusClass" value="bg-danger" />
            </c:when>
          </c:choose>
    <div class="container py-5">
        <div class="card shadow-sm">
            <div class="card-header bg-primary text-white">
                <h3 class="mb-0">Request Detail</h3>
            </div>
            <c:choose>
                <c:when test="${not empty error}">
                    <div class="alert alert-danger mt-3">${error}</div>
                </c:when>
                <c:otherwise>
                    <div class="card-body">

                        <div class="mb-4">
                            <h5 class="border-bottom pb-2 text-secondary">Request Information</h5>
                            <p><strong>Contract Code:</strong>
                                <a href="../../contract/detail?contractId=${request.contract.contractID}"
                                   class="text-decoration-none">
                                        ${request.contract.contractCode}
                                </a>
                            </p>
                            <p><strong>Description:</strong> ${request.requestDescription}</p>
                            <p>
              <strong>Status:</strong>
              <span class="badge ${statusClass}">${request.requestStatus}</span>
            </p>
                            <p><strong>Note:</strong> ${request.note}</p>
                            <p><strong>Create Date:</strong> ${request.startDate}</p>
                            <p><strong>Finish Date:</strong> ${request.finishedDate}</p>
                        </div>


                        <div class="d-flex justify-content-end gap-2">
                            <a href="../requests/timeline?requestId=${request.requestID}" class="btn btn-success">View
                                Timeline</a>
                            <a href="../feedback/create" class="btn btn-info">Feedback</a>
                            <a href="../requests" class="btn btn-secondary">Back to List</a>
                        </div>

                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
