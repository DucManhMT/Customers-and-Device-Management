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
            background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
            min-height: 100vh;
            color: #333;
        }

        /* ===== SIDEBAR ===== */
        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            width: 250px;
            background-color: #0b1d44;
            color: #fff;
            padding-top: 1.5rem;
            display: flex;
            flex-direction: column;
            box-shadow: 2px 0 10px rgba(0,0,0,0.3);
        }

        .sidebar .brand {
            font-weight: 600;
            font-size: 1.4rem;
            text-align: center;
            margin-bottom: 2rem;
        }

        .sidebar .nav-link {
            color: #cfd8dc;
            font-size: 1.05rem;
            padding: 12px 20px;
            border-radius: 8px;
            margin: 4px 12px;
            display: flex;
            align-items: center;
            transition: 0.3s ease;
        }

        .sidebar .nav-link i {
            font-size: 1.2rem;
            margin-right: 10px;
        }

        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            background-color: #1a2c68;
            color: #fff;
            transform: translateX(4px);
        }

        .sidebar .logout {
            margin-top: auto;
            margin-bottom: 1rem;
            text-align: center;
        }

        /* ===== MAIN CONTENT ===== */
        .main-content {
            margin-left: 250px;
            padding: 2rem;
            color: #fff;
        }

        .main-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .main-header h1 {
            font-size: 2rem;
            font-weight: 700;
        }

        .main-header .btn {
            border-radius: 25px;
            font-weight: 500;
        }

        .content-box {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            border-radius: 16px;
            padding: 2rem;
            box-shadow: 0 6px 25px rgba(0,0,0,0.15);
        }

        .content-box h3 {
            color: #fff;
            margin-bottom: 1rem;
        }

        .content-box p {
            color: #e2e2e2;
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 992px) {
            .sidebar {
                width: 100%;
                height: auto;
                flex-direction: row;
                justify-content: space-around;
                position: relative;
            }

            .main-content {
                margin-left: 0;
                margin-top: 20px;
            }
        }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="brand">
        <i class="bi bi-gear-wide-connected me-2"></i> Admin Center
    </div>
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link active">
        <i class="bi bi-speedometer2"></i> Dashboard
    </a>
    <a href="${pageContext.request.contextPath}/admin/role_list" class="nav-link">
        <i class="bi bi-person-gear"></i> Role Management
    </a>
    <a href="${pageContext.request.contextPath}/admin/account_list" class="nav-link">
        <i class="bi bi-people-fill"></i> Account Management
    </a>
    <a href="${pageContext.request.contextPath}/admin/settings" class="nav-link">
        <i class="bi bi-sliders"></i> System Settings
    </a>
    <div class="logout">
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light btn-sm">
            <i class="bi bi-box-arrow-right"></i> Logout
        </a>
    </div>
</div>

<div class="main-content">
    <div class="main-header">
        <h1>Welcome, Admin</h1>
        <a href="${pageContext.request.contextPath}/admin/account_list" class="btn btn-light text-primary">
            <i class="bi bi-person-circle"></i> My Account
        </a>
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
