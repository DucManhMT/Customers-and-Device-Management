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
    <title>Login Page</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customer_login.css">
</head>
<body>

<div class="container">
    <div class="login-container">

        <h2 class="text-center mb-4">Customer Login</h2>

        <form action="${pageContext.request.contextPath}/customer_login_controller" method="post">
            <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <input type="text" class="form-control" id="username" name="username" placeholder="Enter your username" autocomplete="true" required>
                <h6 class="text-danger">
                    ${requestScope.error != null ? requestScope.error : ""}
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" autocomplete="true" required>
            </div>

<%--            <div class="mb-3 form-check">--%>
<%--                <input type="checkbox" class="form-check-input" id="rememberMe" name="rememberMe">--%>
<%--                <label class="form-check-label" for="rememberMe">Remember me</label>--%>
<%--            </div>--%>

            <div class="d-grid">
                <button type="submit" class="btn btn-primary">Login</button>
            </div>

            <div class="links-row">
                <a href="forgotPassword.jsp" class="text-decoration-none">Forgot Password?</a>
                <a href="${pageContext.request.contextPath}/auth/customer_register" class="text-decoration-none">Register New Account</a>
            </div>
            <div class="links-row d-flex justify-content-center">
                <a href="${pageContext.request.contextPath}">Back to home</a>
            </div>
        </form>
    </div>
</div>

<!-- Bootstrap JS Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
