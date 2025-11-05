<%--
  Created by IntelliJ IDEA.
  User: FPT SHOP
  Date: 11/5/2025
  Time: 7:02 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Detail</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<style>
    body {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
        height: 100%;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    html {
        height: 100%;
    }

    .profile-container {
        min-height: 100%;
        background: #f8f9fa;
        padding: 40px 20px;
    }

    .profile-content {
        margin: 0 auto;
        width: 100%;
    }

    .profile-header {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        padding: 40px;
        text-align: center;
        color: white;
        border-radius: 15px;
        margin-bottom: 30px;
        box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
    }

    .profile-avatar {
        width: 120px;
        height: 120px;
        border-radius: 50%;
        background: white;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 20px;
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
    }

    .profile-avatar i {
        font-size: 60px;
        color: #667eea;
    }

    .profile-username {
        font-size: 28px;
        font-weight: 700;
        margin: 0;
        text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    .profile-body {
        padding: 0;
    }

    .info-item {
        display: flex;
        align-items: flex-start;
        padding: 25px;
        margin-bottom: 20px;
        background: white;
        border-radius: 12px;
        transition: all 0.3s ease;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        border-left: 4px solid #667eea;
    }

    .info-item:hover {
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        transform: translateY(-2px);
    }

    .info-icon {
        width: 45px;
        height: 45px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 20px;
        flex-shrink: 0;
    }

    .info-icon i {
        color: white;
        font-size: 20px;
    }

    .info-content {
        flex: 1;
    }

    .info-label {
        font-size: 12px;
        color: #6c757d;
        text-transform: uppercase;
        letter-spacing: 1px;
        font-weight: 600;
        margin-bottom: 5px;
    }

    .info-value {
        font-size: 16px;
        color: #212529;
        font-weight: 500;
        word-break: break-word;
    }



    .breadcrumb-container {
        padding: 20px 40px;
        font-size: 18px;
        font-weight: 500;
        background: #f8f9fa;
    }

    .crumb-link {
        color: #007bff;
        text-decoration: none;
    }

    .crumb-link:hover {
        text-decoration: underline;
    }

    .crumb-divider {
        margin: 0 8px;
        color: #6c757d;
    }

    .crumb-current {
        color: #6c757d;
    }



</style>

</head>

<body>
<jsp:include page="../components/header.jsp"/>
<div class="breadcrumb-container">
    <a href="${pageContext.request.contextPath}/admin/account_list" class="crumb-link">
        Account Management
    </a>
    <span class="crumb-divider">/</span>
    <span class="crumb-current">Account Detail</span>
</div>
<div class="profile-container">
    <div class="profile-content">
        <div class="profile-header">
            <div class="profile-avatar"><i class="bi bi-person-circle"></i>
            </div>
            <h1 class="profile-username" id="username-display">${username}</h1>
        </div>
        <div class="profile-body">
            <div class="info-item">
                <div class="info-icon"><i class="bi bi-person-badge"></i>
                </div>
                <div class="info-content">
                    <div class="info-label">
                        Full Name
                    </div>
                    <div class="info-value" id="name-display">
                        ${accountName}
                    </div>
                </div>
            </div>
            <div class="info-item">
                <div class="info-icon"><i class="bi bi-telephone"></i>
                </div>
                <div class="info-content">
                    <div class="info-label">
                        Phone Number
                    </div>
                    <div class="info-value" id="phone-display">
                        ${accountPhone}
                    </div>
                </div>
            </div>
            <div class="info-item">
                <div class="info-icon"><i class="bi bi-envelope"></i>
                </div>
                <div class="info-content">
                    <div class="info-label">
                        Email Address
                    </div>
                    <div class="info-value" id="email-display">
                        ${accountEmail}
                    </div>
                </div>
            </div>
            <div class="info-item">
                <div class="info-icon"><i class="bi bi-geo-alt"></i>
                </div>
                <div class="info-content">
                    <div class="info-label">
                        Address
                    </div>
                    <div class="info-value" id="address-display">
                        ${accountAddress}
                    </div>
                </div>

            </div>
            <c:if test="${roleID != 2}">
                <div class="info-item">
                    <div class="info-icon"><i class="bi bi-calendar-check"></i></div>
                    <div class="info-content">
                        <div class="info-label">
                            Date of Birth
                        </div>
                        <div class="info-value" id="dateBirth">
                                ${accountDoB}
                        </div>
                    </div>
                </div>
            </c:if>

        </div>
    </div>
</div>
</body>
</html>
