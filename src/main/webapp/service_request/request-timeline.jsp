<%-- Created by IntelliJ IDEA. User: anhtu Date: 10/8/2025 Time: 9:56 AM To
change this template use File | Settings | File Templates. --%>
<%@ page
        contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"
           uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Request Timeline</title>
    <link
            href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
            rel="stylesheet"
    />
    <style>
        .timeline {
            position: relative;
            padding-left: 2rem;
            border-left: 3px solid #0d6efd;
        }

        .timeline-item {
            position: relative;
            margin-bottom: 1.5rem;
        }

        .timeline-item::before {
            content: "";
            position: absolute;
            left: -10px;
            top: 4px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background-color: #0d6efd;
        }

        .timeline-item:first-child::before {
            background-color: #198754;
        }

        .timeline-item:first-child .card {
            border-left: 4px solid #198754;
        }
    </style>
</head>
<body class="bg-light">
<jsp:include page="../components/customer_header.jsp"/>
<div class="container py-5">
    <div class="card shadow-sm">
        <div class="card-header bg-primary text-white">
            <h3 class="mb-0">Request Timeline</h3>
        </div>
        <c:choose
        ><c:when test="${not empty error}">
            <div class="alert alert-danger m-3" role="alert">${error}</div>
        </c:when>
            <c:otherwise>
                <div class="card-body">
                    <p>
                        <strong>Status:</strong>
                        <span class="badge bg-info text-dark"
                        >${request.requestStatus}</span
                        >
                    </p>

                    <div class="timeline mt-4">
                        <c:forEach
                                items="${request.logs}"
                                var="item"
                                varStatus="status"
                        >
                            <div class="timeline-item">
                                <div class="card">
                                    <div class="card-body py-2">
                                        <p class="mb-1 fw-semibold">${item.actionDate}</p>
                                        <p class="mb-0 text-muted">${item.description}</p>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="d-flex justify-content-end mt-4">
                        <a
                                href="./detail?requestId=${param.requestId}"
                                class="btn btn-secondary"
                        >Back to Detail</a
                        >
                        <a href="../requests" class="btn btn-primary ms-2"
                        >Back to List</a
                        >
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    <jsp:include page="../components/scroll-button.jsp"/>
</div>
</body>
</html>
