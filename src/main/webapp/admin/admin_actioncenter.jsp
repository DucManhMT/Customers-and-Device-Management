<%--
  Created by IntelliJ IDEA.
  User: MasterLong
  Date: 10/10/2025
  Time: 8:16 AM
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin Action Center</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: #f8fafc;
            color: #1e293b;
        }



        /* ===== MAIN CONTENT ===== */
        .main-content {
            padding: 2rem 3rem;
            min-height: 100vh;
            background: #f1f5f9;
        }

        .main-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            border-bottom: 2px solid #e2e8f0;
            padding-bottom: 1rem;
        }

        .main-header h1 {
            font-size: 1.8rem;
            font-weight: 700;
            color: #1e3a8a;
        }

        .main-header .btn {
            border-radius: 25px;
            font-weight: 500;
            background-color: #1976d2;
            color: #fff;
            border: none;
            padding: 8px 18px;
            transition: 0.3s;
        }

        .main-header .btn:hover {
            background-color: #1565c0;
        }

        .content-box {
            background: #fff;
            border-radius: 16px;
            padding: 2rem;
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
            transition: transform 0.2s;
        }

        .content-box:hover {
            transform: translateY(-2px);
        }

        .content-box h3 {
            color: #0d47a1;
            margin-bottom: 1rem;
        }

        .content-box p {
            color: #475569;
        }

        ul li {
            margin-bottom: 8px;
        }

    </style>

</head>
<body>
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>

<div class="main-content">
    <div class="main-header">
        <h1>Welcome, Admin</h1>

    </div>

    <div class="content-box">
        <h3>Overview</h3>
        <p>Manage your users, roles, and configurations efficiently. Use the sidebar on the left to navigate between sections.</p>
        <ul>
            <li><strong>Role Management:</strong> View and edit user roles.</li>
            <li><strong>Account Management:</strong> Manage user accounts and permissions.</li>
        </ul>
    </div>
</div>

<script src="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
