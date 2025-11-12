<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Action Center</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
          rel="stylesheet"/>
    <style>
        body {
            background-color: #f8f9fa;
        }

        .main-content {
            margin-left: 260px;
            padding: 40px;
        }

        .card {
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .nav-link-custom {
            display: inline-block;
            margin: 10px 15px 0 0;
        }

        .username {
            font-weight: 600;
            color: #0d6efd;
        }
    </style>
</head>
<body>
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/customer_sidebar.jsp"/>

<div class="main-content" style="margin-left: 0px;">
    <div class="container ">
        <div class="card p-2">
            <h1 class="mb-3">Customer Action Center</h1>
            <p class="text-muted mb-4">
                Welcome, <span class="username">${sessionScope.account.username}</span>.<br>
                Manage your account, view your contract history, and handle customer requests.
            </p>

            <div class="d-flex flex-wrap">
                <a href="${pageContext.request.contextPath}/customer/contract_history"
                   class="btn btn-outline-primary nav-link-custom">
                    📜 Contract History
                </a>
                <a href="./requests/create"
                   class="btn btn-outline-success nav-link-custom">
                    ➕ Create Request
                </a>
                <a href="./requests"
                   class="btn btn-outline-info nav-link-custom">
                    📂 View Requests
                </a>
                <a href="${pageContext.request.contextPath}/customer/profile?id=${account.username}"
                   class="btn btn-outline-dark nav-link-custom">
                    👤 Profile
                </a>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
