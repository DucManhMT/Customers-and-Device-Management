<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>My Service Requests</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
          rel="stylesheet"/>
    <style>
        body {
            background-color: #f8f9fa;
        }

        h2.page-title {
            font-weight: 600;
            color: #333;
        }

        .card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
        }

        .filter-section {
            background-color: #fff;
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .table th {
            background-color: #f1f3f5;
            font-weight: 600;
        }

        .table td {
            vertical-align: middle;
        }

        .btn-sm {
            border-radius: 12px;
        }

        .alert {
            border-radius: 12px;
        }

        select.form-select {
            min-width: 200px;
        }
    </style>
</head>

<body>
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/customer_sidebar.jsp"/>

<div class="container-fluid px-4 mt-3">
    <!-- Page Header -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="page-title">My Requests</h2>
        <c:if test="${not empty totalRecords}">
            <span class="text-muted">Total Requests: <strong>${totalRecords}</strong></span>
        </c:if>
    </div>

    <!-- Error Alert -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <!-- Filter Section -->
    <form method="get" action="./requests" onkeydown="if(event.key==='Enter'){event.preventDefault();}">
        <div class="filter-section">
            <div class="row align-items-center g-3">
                <div class="col-md-2">
                    <jsp:include page="../components/sort.jsp"/>
                </div>

                <div class="col-md-3">
                    <jsp:include page="../components/request-status-select.jsp"/>
                </div>

                <div class="col-md-4 d-flex align-items-center">
                    <label for="contractId" class="me-2 fw-semibold">Select Contract:</label>
                    <select id="contractId" name="contractId" class="form-select">
                        <option value="">All</option>
                        <c:forEach var="contract" items="${contracts}">
                            <option value="${contract.contractID}"
                                    <c:if test="${contract.contractID == contractId}">selected</c:if>>
                                    ${contract.contractCode}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-2 text-end">
                    <jsp:include page="../components/do-filter.jsp"/>
                </div>
            </div>
        </div>

        <!-- Table Section -->
        <div class="card">
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead class="table-light">
                    <tr>
                        <th class="text-center" style="width: 60px;">No</th>
                        <th>Contract Code</th>
                        <th>Description</th>
                        <th>Status</th>
                        <th>Creation Date</th>
                        <th>Finish Date</th>
                        <th class="text-center" style="width: 250px;">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${requests}" var="request" varStatus="status">
                        <tr>
                            <td class="text-center">${status.index + 1 + (currentPage - 1) * recordsPerPage}</td>
                            <td>
                                <a href="../contract/detail?contractId=${request.contract.contractID}"
                                   class="text-decoration-none text-primary fw-semibold">
                                        ${request.contract.contractCode}
                                </a>
                            </td>
                            <td>${request.requestDescription}</td>
                            <td>
                                <span class="badge
                                    <c:choose>
                                        <c:when test='${request.requestStatus eq "Pending"}'>bg-warning text-dark</c:when>
                                        <c:when test='${request.requestStatus eq "Processing"}'>bg-primary</c:when>
                                        <c:when test='${request.requestStatus eq "Tech_Finished"}'>bg-info text-dark</c:when>
                                        <c:when test='${request.requestStatus eq "Finished"}'>bg-success</c:when>
                                        <c:when test='${request.requestStatus eq "Rejected"}'>bg-danger</c:when>
                                        <c:otherwise>bg-secondary</c:otherwise>
                                    </c:choose>">
                                        ${request.requestStatus}
                                </span>
                            </td>
                            <td>${request.startDate}</td>
                            <td><c:out value="${empty request.finishedDate ? '-' : request.finishedDate}"/></td>
                            <td class="text-center">
                                <a href="./requests/detail?requestId=${request.requestID}"
                                   class="btn btn-info btn-sm me-1">View</a>
                                <a href="./requests/timeline?requestId=${request.requestID}"
                                   class="btn btn-primary btn-sm me-1">Timeline</a>
                                <c:if test="${request.requestStatus eq 'Finished'}">
                                    <a href="./feedback/create?requestId=${request.requestID}"
                                       class="btn btn-success btn-sm">Feedback</a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty requests}">
                        <tr>
                            <td colspan="7" class="text-center text-muted py-4">No requests found.</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Pagination -->
        <div class="mt-3">
            <jsp:include page="../components/paging-bottom.jsp"/>
        </div>
    </form>

    <!-- Scroll Button -->
    <jsp:include page="../components/scroll-button.jsp"/>
</div>

<script src="${pageContext.request.contextPath}/js/bootstrap/bootstrap.bundle.min.js"></script>
</body>
</html>
