<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: MasterLong
  Date: 11/12/2025
  Time: 8:35 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Change Password</title>
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

        .password-container {
            background: #ffffff;
            border-radius: 20px;
            padding: 50px 45px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
            max-width: 500px;
            margin: 30px auto;
            border: 1px solid rgba(16, 185, 129, 0.1);
        }

        .password-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .icon-wrapper {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 20px;
        }

        .password-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #10b981 0%, #3b82f6 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 8px 20px rgba(16, 185, 129, 0.3);
        }

        .password-icon i {
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

        /* Alert Messages */
        .alert-message {
            border-radius: 12px;
            padding: 14px 18px;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 14px;
            font-weight: 500;
            animation: slideDown 0.3s ease;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .alert-success {
            background: #d1fae5;
            border-left: 4px solid #10b981;
            color: #065f46;
        }

        .alert-success i {
            color: #10b981;
            font-size: 20px;
        }

        .alert-error {
            background: #fff5f5;
            border-left: 4px solid #fc8181;
            color: #c53030;
        }

        .alert-error i {
            color: #fc8181;
            font-size: 20px;
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
            position: relative;
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
            padding: 14px 45px 14px 16px;
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

        /* Toggle Password Visibility */
        .toggle-password {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #a0aec0;
            font-size: 18px;
            transition: color 0.3s ease;
            z-index: 10;
        }

        .toggle-password:hover {
            color: #10b981;
        }

        .password-hint {
            font-size: 12px;
            color: #718096;
            margin-top: 8px;
            line-height: 1.4;
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
            width: 100%;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(16, 185, 129, 0.4);
            background: linear-gradient(135deg, #059669 0%, #2563eb 100%);
        }

        .btn-primary:active {
            transform: translateY(0);
        }

        .btn-secondary {
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 14px;
            font-weight: 600;
            font-size: 16px;
            transition: all 0.3s ease;
            color: #718096;
            width: 100%;
            margin-top: 10px;
        }

        .btn-secondary:hover {
            background: #f7fafc;
            border-color: #cbd5e0;
            color: #4a5568;
        }

        .back-link {
            text-align: center;
            margin-top: 30px;
        }

        .back-link a {
            color: #10b981;
            font-size: 14px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.3s ease;
        }

        .back-link a:hover {
            color: #059669;
            gap: 10px;
        }

        .back-link a i {
            transition: transform 0.3s ease;
        }

        .back-link a:hover i {
            transform: translateX(-3px);
        }

        /* Responsive adjustments */
        @media (max-width: 576px) {
            .password-container {
                padding: 35px 25px;
                margin: 20px;
            }

            h2 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="password-container">

        <div class="password-header">
            <div class="icon-wrapper">
                <div class="password-icon">
                    <i class="bi bi-shield-lock"></i>
                </div>
            </div>
            <h2>Change Password</h2>
            <p class="subtitle">Keep your account secure</p>
        </div>

        <!-- Success Message -->
        <c:if test="${not empty sessionScope.success}">
            <div class="alert-message alert-success">
                <i class="bi bi-check-circle-fill"></i>
                <span>${sessionScope.success}</span>
            </div>
            <c:remove var="success" scope="session"/>
        </c:if>

        <!-- Error Message -->
        <c:if test="${not empty sessionScope.error}">
            <div class="alert-message alert-error">
                <i class="bi bi-exclamation-circle-fill"></i>
                <span>${sessionScope.error}</span>
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <form action="${pageContext.request.contextPath}/auth/change_password_controller" method="post" id="changePasswordForm">

            <!-- Old Password -->
            <div class="input-group-custom">
                <label for="oldPassword" class="form-label">Current Password</label>
                <div class="input-with-icon">
                    <div class="icon-box">
                        <i class="bi bi-lock"></i>
                    </div>
                    <input type="password" class="form-control" id="oldPassword" name="oldPassword"
                           placeholder="Enter your current password" required>
                    <i class="bi bi-eye toggle-password" onclick="togglePassword('oldPassword', this)"></i>
                </div>
            </div>

            <!-- New Password -->
            <div class="input-group-custom">
                <label for="newPassword" class="form-label">New Password</label>
                <div class="input-with-icon">
                    <div class="icon-box">
                        <i class="bi bi-key"></i>
                    </div>
                    <input type="password" class="form-control" id="newPassword" name="newPassword"
                           placeholder="Enter your new password (minimum 6 characters)" required>
                    <i class="bi bi-eye toggle-password" onclick="togglePassword('newPassword', this)"></i>
                </div>
            </div>

            <!-- Confirm New Password -->
            <div class="input-group-custom">
                <label for="confirmPassword" class="form-label">Confirm New Password</label>
                <div class="input-with-icon">
                    <div class="icon-box">
                        <i class="bi bi-key-fill"></i>
                    </div>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                           placeholder="Confirm your new password" required>
                    <i class="bi bi-eye toggle-password" onclick="togglePassword('confirmPassword', this)"></i>
                </div>
                <div class="password-hint" id="matchHint"></div>
            </div>

            <div class="d-grid">
                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-shield-check me-2"></i>Update Password
                </button>
            </div>

            <div class="d-grid">
                <button type="button" class="btn btn-secondary" onclick="window.history.back()">
                    <i class="bi bi-x-circle me-2"></i>Cancel
                </button>
            </div>
        </form>

        <!-- Back Link -->
        <div class="back-link">
            <a href="${pageContext.request.contextPath}/dashboard">
                <i class="bi bi-arrow-left"></i>Back to Dashboard
            </a>
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Toggle password visibility
    function togglePassword(inputId, icon) {
        const input = document.getElementById(inputId);
        if (input.type === 'password') {
            input.type = 'text';
            icon.classList.remove('bi-eye');
            icon.classList.add('bi-eye-slash');
        } else {
            input.type = 'password';
            icon.classList.remove('bi-eye-slash');
            icon.classList.add('bi-eye');
        }
    }

    // Check if passwords match
    function checkPasswordMatch() {
        const newPassword = document.getElementById('newPassword').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const matchHint = document.getElementById('matchHint');

        if (confirmPassword.length === 0) {
            matchHint.textContent = '';
            return;
        }

        if (newPassword === confirmPassword) {
            matchHint.textContent = '✓ Passwords match';
            matchHint.style.color = '#10b981';
        } else {
            matchHint.textContent = '✗ Passwords do not match';
            matchHint.style.color = '#fc8181';
        }
    }

    // Event listener for password match
    document.getElementById('newPassword').addEventListener('input', function() {
        checkPasswordMatch();
    });

    document.getElementById('confirmPassword').addEventListener('input', function() {
        checkPasswordMatch();
    });

    // Form validation
    document.getElementById('changePasswordForm').addEventListener('submit', function(e) {
        const newPassword = document.getElementById('newPassword').value;
        const confirmPassword = document.getElementById('confirmPassword').value;

        if (newPassword !== confirmPassword) {
            e.preventDefault();
            alert('New passwords do not match!');
            return false;
        }

        if (newPassword.length < 6) {
            e.preventDefault();
            alert('Password must be at least 6 characters long!');
            return false;
        }
    });

    // Auto-hide success/error messages after 5 seconds
    window.addEventListener('load', function() {
        const alerts = document.querySelectorAll('.alert-message');
        alerts.forEach(alert => {
            setTimeout(() => {
                alert.style.transition = 'opacity 0.5s ease';
                alert.style.opacity = '0';
                setTimeout(() => alert.remove(), 500);
            }, 5000);
        });
    });
</script>
</body>
</html>