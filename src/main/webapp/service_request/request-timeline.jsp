<%--
  Created by IntelliJ IDEA.
  User: anhtu
  Date: 10/8/2025
  Time: 9:56 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Request Timeline</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
          rel="stylesheet"/>
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
<%
    if (request.getAttribute("request") == null) {
        java.util.Map<String, Object> r = new java.util.HashMap<>();
        r.put("status", "In Progress");

        java.util.List<java.util.Map<String, String>> logs = new java.util.ArrayList<>();

        java.util.Map<String, String> log1 = new java.util.LinkedHashMap<>();
        log1.put("actionDate", "2025-10-08 09:56");
        log1.put("info", "Request created");
        logs.add(log1);

        java.util.Map<String, String> log2 = new java.util.LinkedHashMap<>();
        log2.put("actionDate", "2025-10-08 10:15");
        log2.put("info", "Assigned to technician");
        logs.add(log2);

        java.util.Map<String, String> log3 = new java.util.LinkedHashMap<>();
        log3.put("actionDate", "2025-10-08 11:30");
        log3.put("info", "Work in progress");
        logs.add(log3);

        java.util.Map<String, String> log4 = new java.util.LinkedHashMap<>();
        log4.put("actionDate", "2025-10-08 13:05");
        log4.put("info", "Awaiting customer confirmation");
        logs.add(log4);

        r.put("logs", logs);

        request.setAttribute("request", r);
    }
%>
<div class="container py-5">
    <div class="card shadow-sm">
        <div class="card-header bg-primary text-white">
            <h3 class="mb-0">Request Timeline</h3>
        </div>
        <div class="card-body">

            <p><strong>Status:</strong>
                <span class="badge bg-info text-dark">${request.status}</span>
            </p>

            <div class="timeline mt-4">
                <c:forEach items="${request.logs}" var="item" varStatus="status">
                    <div class="timeline-item">
                        <div class="card">
                            <div class="card-body py-2">
                                <p class="mb-1 fw-semibold">
                                        ${item.actionDate}
                                </p>
                                <p class="mb-0 text-muted">${item.info}</p>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="d-flex justify-content-end mt-4">
                <a href="./list" class="btn btn-secondary">Back to Detail</a>
            </div>

        </div>
    </div>
    <jsp:include page="../components/scroll-button.jsp"/>
</div>
</body>
</html>

