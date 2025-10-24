<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<html>
<head>
    <title>Request Creation</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
          rel="stylesheet"/>

</head>
<body class="bg-light">
<jsp:include page="../components/customer_header.jsp"/>
<div class="container mt-5">

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow-sm rounded-3">
                <div class="card-header text-center bg-primary text-white">
                    <h4>Create New Request</h4>
                </div>
                <div class="card-body">
                    <form action="../requests/create" method="post">
                        <!-- Contract List -->
                        <div class="mb-3">
                            <label class="form-label">Contract List</label>
                            <select name="contractId" class="form-select">
                                <option value="">Select contract</option>
                                <c:forEach var="contract" items="${contracts}">
                                    <option value="${contract.contractID}"
                                            <c:if test="${contract.contractID == contractId}">selected</c:if>>
                                            ${contract.contractID}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Description -->
                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <input type="text" name="description"
                                   value="${description}"
                                   class="form-control"
                                   placeholder="Enter request description"/>
                        </div>
                        <!-- Messages -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger mt-3">${error}</div>
                        </c:if>
                        <c:if test="${not empty success}">
                            <div class="alert alert-success mt-3">${success}</div>
                        </c:if>
                        <!-- Submit button -->
                        <div class="d-grid">
                            <button type="submit" class="btn btn-success">
                                Create Request
                            </button>
                            <button class="mt-1 btn btn-danger" onclick="window.history.back(); return false;">
                                Cancel
                            </button>
                        </div>
                    </form>


                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
