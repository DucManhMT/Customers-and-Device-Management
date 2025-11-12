<%--
  Created by IntelliJ IDEA.
  User: MasterLong
  Date: 10/6/2025
  Time: 1:05 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Staff Login Page</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body {
            background: #ffffff;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            position: relative;
        }

        /* Subtle background pattern */
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-image:
                    linear-gradient(90deg, rgba(16, 185, 129, 0.02) 1px, transparent 1px),
                    linear-gradient(rgba(59, 130, 246, 0.02) 1px, transparent 1px);
            background-size: 50px 50px;
            pointer-events: none;
        }

        .container {
            position: relative;
            z-index: 1;
        }

        .login-container {
            background: #ffffff;
            border-radius: 20px;
            padding: 50px 45px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
            max-width: 460px;
            margin: 30px auto;
            border: 1px solid rgba(16, 185, 129, 0.1);
        }

        .login-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .icon-wrapper {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 20px;
        }

        .login-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #10b981 0%, #3b82f6 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 8px 20px rgba(16, 185, 129, 0.3);
        }

        .login-icon i {
            color: white;
            font-size: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            padding: 0;
        }

        h2 {
            color: #2d3748;
            font-weight: 700;
            margin-bottom: 8px;
            font-size: 28px;
        }

        .subtitle {
            color: #718096;
            font-size: 14px;
            margin-bottom: 0;
        }

        .staff-badge {
            display: inline-block;
            background: linear-gradient(135deg, #10b981 0%, #3b82f6 100%);
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin-top: 8px;
            letter-spacing: 0.5px;
        }

        .form-label {
            color: #4a5568;
            font-weight: 600;
            font-size: 14px;
            margin-bottom: 8px;
        }

        .input-group-custom {
            margin-bottom: 24px;
        }

        .input-with-icon {
            display: flex;
            align-items: center;
            gap: 0;
        }

        .icon-box {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #10b981 0%, #3b82f6 100%);
            border-radius: 12px 0 0 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .icon-box i {
            color: white;
            font-size: 20px;
        }

        .form-control {
            border: 2px solid #e2e8f0;
            border-left: none;
            border-radius: 0 12px 12px 0;
            padding: 14px 16px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: #f7fafc;
            height: 50px;
            flex: 1;
        }

        .form-control:focus {
            border-color: #10b981;
            border-left: none;
            box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.1);
            background: #ffffff;
            outline: none;
        }

        .form-control::placeholder {
            color: #cbd5e0;
        }

        .error-message {
            background: #fff5f5;
            border-left: 4px solid #fc8181;
            color: #c53030;
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 14px;
            margin-top: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .error-message i {
            font-size: 18px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #10b981 0%, #3b82f6 100%);
            border: none;
            border-radius: 12px;
            padding: 14px;
            font-weight: 600;
            font-size: 16px;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);
            margin-top: 10px;
            color: #ffffff;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(16, 185, 129, 0.4);
            background: linear-gradient(135deg, #059669 0%, #2563eb 100%);
        }

        .btn-primary:active {
            transform: translateY(0);
        }

        .links-row {
            margin-top: 24px;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 15px;
        }

        .links-row a {
            color: #10b981;
            font-size: 14px;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s ease;
            position: relative;
        }

        .links-row a:hover {
            color: #059669;
        }

        .links-row a::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 0;
            height: 2px;
            background: linear-gradient(90deg, #10b981 0%, #3b82f6 100%);
            transition: width 0.3s ease;
        }

        .links-row a:hover::after {
            width: 100%;
        }

        .divider {
            text-align: center;
            margin: 30px 0 20px;
            position: relative;
        }

        .divider::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 1px;
            background: #e2e8f0;
        }

        .divider span {
            background: white;
            padding: 0 15px;
            color: #a0aec0;
            font-size: 13px;
            position: relative;
            font-weight: 500;
        }

        .back-home {
            text-align: center;
            margin-top: 20px;
        }

        .back-home a {
            color: #718096;
            font-size: 14px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.3s ease;
        }

        .back-home a:hover {
            color: #10b981;
            gap: 10px;
        }

        .back-home a i {
            transition: transform 0.3s ease;
        }

        .back-home a:hover i {
            transform: translateX(-3px);
        }

        /* Responsive adjustments */
        @media (max-width: 576px) {
            .login-container {
                padding: 35px 25px;
                margin: 20px;
            }

            .links-row {
                flex-direction: column;
                gap: 12px;
                text-align: center;
            }

            h2 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="login-container">

        <div class="login-header">
            <div class="icon-wrapper">
                <div class="login-icon">
                    <i class="bi bi-briefcase"></i>
                </div>
            </div>
            <h2>Staff Portal</h2>
            <p class="subtitle">Login to access your dashboard</p>
            <span class="staff-badge"><i class="bi bi-shield-check"></i> AUTHORIZED ACCESS</span>
        </div>

        <form action="${pageContext.request.contextPath}/staff_login_controller" method="post">
            <div class="input-group-custom">
                <label for="username" class="form-label">Username</label>
                <div class="input-with-icon">
                    <div class="icon-box">
                        <i class="bi bi-person-badge"></i>
                    </div>
                    <input type="text" class="form-control" id="username" name="username"
                           placeholder="Enter your staff username" autocomplete="username" required>
                </div>
                <% if (session.getAttribute("error") != null) { %>
                <div class="error-message">
                    <i class="bi bi-exclamation-circle"></i>
                    <span><%= session.getAttribute("error") %></span>
                </div>
                <%
                    session.removeAttribute("error");
                %>
                <% } %>
            </div>

            <div class="input-group-custom">
                <label for="password" class="form-label">Password</label>
                <div class="input-with-icon">
                    <div class="icon-box">
                        <i class="bi bi-lock-fill"></i>
                    </div>
                    <input type="password" class="form-control" id="password" name="password"
                           placeholder="Enter your password" autocomplete="current-password" required>
                </div>
            </div>

            <div class="d-grid">
                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-box-arrow-in-right me-2"></i>Login
                </button>
            </div>

            <div class="links-row">
                <a href="${pageContext.request.contextPath}/auth/forgot_password">
                    <i class="bi bi-key me-1"></i>Forgot Password?
                </a>
            </div>

            <div class="divider">
                <span>OR</span>
            </div>

            <div class="back-home">
                <a href="${pageContext.request.contextPath}">
                    <i class="bi bi-arrow-left"></i>Back to home
                </a>
            </div>
        </form>
    </div>
</div>

<!-- Bootstrap JS Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>