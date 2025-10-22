<%--
  Created by IntelliJ IDEA.
  User: anhtu
  Date: 10/8/2025
  Time: 10:20 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Process Request</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
          rel="stylesheet"/>
</head>
<body>
<div class="container py-5">
    <jsp:include page="../components/header.jsp"/>
    <div class="card shadow-sm">

        <div class="card-header bg-primary text-white">
            <h3 class="mb-0">Process Request</h3>
        </div>
        <div class="card-body">

            <form action="./process" method="post" class="needs-validation" novalidate>
                <input type="hidden" name="requestId" value="${request.requestID}"/>
                <div class="mb-3">
                    <label for="note" class="form-label fw-semibold">Note</label>
                    <textarea id="note" name="note" class="form-control" rows="3"
                              placeholder="Enter processing note or update here..."></textarea>
                    <div class="invalid-feedback">
                        Please provide a note before submitting.
                    </div>
                </div>

                <div class="mb-3">
                    <label for="action" class="form-label fw-semibold">Status</label>
                    <select id="status" name="status" class="form-select" style="width: 200px; display: inline-block;">
                        <option value="">Select Status</option>
                        <option value="Approved" ${status == 'Approved' ? 'selected' : ''}>Approved</option>
                        <option value="Rejected" ${status == 'Rejected' ? 'selected' : ''}>Rejected</option>
                    </select>
                </div>

                <!-- Messages -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger mt-3">${error}</div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="alert alert-success mt-3">${success}</div>
                </c:if>

                <div class="d-flex justify-content-end gap-2">
                    <button type="submit" class="btn btn-success">Submit</button>
                    <a href="./list" class="btn btn-secondary">Cancel</a>
                </div>
            </form>

        </div>
    </div>
</div>
</body>
</html>
