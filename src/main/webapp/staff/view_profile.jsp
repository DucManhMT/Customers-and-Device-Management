<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--
  Created by IntelliJ IDEA.
  User: FPT SHOP
  Date: 11/2/2025
  Time: 4:24 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Profile</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
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
            max-width: 800px;
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

        .edit-input {
            border: 2px solid #667eea;
            border-radius: 8px;
            padding: 8px 12px;
            font-size: 16px;
            width: 100%;
            transition: all 0.3s ease;
        }

        .edit-input:focus {
            outline: none;
            border-color: #764ba2;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

    </style>

</head>

<body>
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>
<%-- TE CHEM --%>
<c:if test="${sessionScope.account.role.roleName == 'TechnicianEmployee'}">
    <c:set var="activePage" value="techemProfile" scope="request"/>
    <jsp:include page="../components/techem_sidebar.jsp"/>
</c:if>

<%-- TECH LEAD --%>
<c:if test="${sessionScope.account.role.roleName == 'TechnicianLeader'}">
    <c:set var="activePage" value="techleadProfile" scope="request"/>
    <jsp:include page="../components/techlead_sidebar.jsp"/>
</c:if>

<%-- SUPPORTER --%>
<c:if test="${sessionScope.account.role.roleName == 'CustomerSupporter'}">
    <c:set var="activePage" value="supporterProfile" scope="request"/>
    <jsp:include page="../components/supporter_sidebar.jsp"/>
</c:if>

<%-- CUSTOMER --%>
<c:if test="${sessionScope.account.role.roleName == 'Customer'}">
    <c:set var="activePage" value="cusProfile" scope="request"/>
    <jsp:include page="../components/customer_sidebar.jsp"/>
</c:if>
<div class="profile-container">
    <div class="profile-content">
        <div class="profile-header">
            <div class="profile-avatar">
                <img src="${pageContext.request.contextPath}/${accountImage}"
                     alt="Profile Image"
                     style="width:120px; height:120px; border-radius:50%; object-fit:cover;">
            </div>
            <h1 class="profile-username" id="username-display">${account.username}</h1>
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
                        ${staff.staffName}
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
                        ${staff.phone}
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
                        ${staff.email}
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
                        ${staff.address}
                    </div>
                </div>

            </div>
            <div class="info-item">
                <div class="info-icon"><i class="bi bi-calendar-check"></i>
                </div>
                <div class="info-content">
                    <div class="info-label">
                        Date of Birth
                    </div>
                    <div class="info-value" id="dateBirth">
                        ${staff.dateOfBirth}
                    </div>
                </div>

            </div>
            <div class="text-center mt-4">
                <a href="${pageContext.request.contextPath}/staff/profile/edit"
                   class="btn btn-primary btn-lg px-5 py-3">
                    <i
                            class="bi bi-pencil-square me-2"></i> Edit Profile
                </a>
            </div>
        </div>
    </div>
</div>
</body>
</html>

