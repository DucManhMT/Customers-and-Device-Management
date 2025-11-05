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

        /* ===== SIDEBAR ===== */
        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            width: 260px;
            background: linear-gradient(180deg, #0d47a1 0%, #1976d2 100%);
            color: #fff;
            padding-top: 1.5rem;
            display: flex;
            flex-direction: column;
            box-shadow: 2px 0 8px rgba(0,0,0,0.2);
        }

        .sidebar .brand {
            font-weight: 700;
            font-size: 1.5rem;
            text-align: center;
            margin-bottom: 2rem;
            letter-spacing: 0.5px;
        }

        .sidebar .brand i {
            margin-right: 8px;
        }

        .sidebar .nav-link {
            color: #e3f2fd;
            font-size: 1.05rem;
            padding: 12px 20px;
            border-radius: 10px;
            margin: 4px 14px;
            display: flex;
            align-items: center;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .sidebar .nav-link i {
            font-size: 1.2rem;
            margin-right: 10px;
        }

        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            background-color: rgba(255,255,255,0.2);
            transform: translateX(5px);
            color: #fff;
        }

        .sidebar .logout {
            margin-top: auto;
            margin-bottom: 1rem;
            text-align: center;
        }

        .sidebar .logout .btn {
            border-radius: 25px;
            background-color: #fff;
            color: #1976d2;
            border: none;
            transition: 0.3s;
        }

        .sidebar .logout .btn:hover {
            background-color: #e3f2fd;
        }

        /* ===== MAIN CONTENT ===== */
        .main-content {
            margin-left: 260px;
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
<jsp:include page="../components/admin_sidebar.jsp"/>

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
            <li><strong>System Settings:</strong> Configure application parameters.</li>
        </ul>
    </div>
</div>

<script src="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
