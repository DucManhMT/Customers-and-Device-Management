<%--
  Created by IntelliJ IDEA.
  User: anhtu
  Date: 10/23/2025
  Time: 9:41 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="crm.common.URLConstants" %>

<style>
    .navbar-header {
        background-image: url("${pageContext.request.contextPath}/assets/images/header-background.jpg");
        background-color: transparent; /* Transparent background */
        backdrop-filter: blur(8px); /* Optional: glass effect */
        box-shadow: none; /* Remove drop shadow */
        padding: 1rem 2rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
        height: 70px;
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        z-index: 1030;
        transition: background-color 0.3s ease;
    }

    .navbar-logo {
        font-size: 1.5rem;
        font-weight: bold;
        color: white;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .navbar-logo a {
        color: white;
        text-decoration: none;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .navbar-logo a:hover {
        color: #a3bffa;
        transform: scale(1.05);
    }

    .navbar-user-info {
        display: flex;
        align-items: center;
        gap: 1rem;
    }

    .user-badge {
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        padding: 0.5rem 1rem;
        background-color: rgba(255, 255, 255, 0.15); /* subtle translucent background */
        border-radius: 20px;
        font-size: 0.9rem;
        color: white;
    }

    .user-badge strong {
        color: white;
        font-weight: 600;
    }

    .btn-logout {
        padding: 0.6rem 1.5rem;
        text-decoration: none;
        border-radius: 25px;
        font-weight: 600;
        transition: all 0.3s ease;
        border: 2px solid white;
        background-color: transparent;
        color: white;
        display: inline-block;
    }

    .btn-logout:hover {
        background-color: #a3bffa;
        color: #0e4274;
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(255, 255, 255, 0.3);
    }

    /* Responsive Design */
    @media (max-width: 768px) {
        .navbar-header {
            flex-direction: column;
            gap: 1rem;
            padding: 1rem;
            height: auto;
            margin-left: 0;
        }

        .navbar-user-info {
            flex-direction: column;
            width: 100%;
        }

        .user-badge {
            width: 100%;
            justify-content: center;
        }

        .btn-logout {
            width: 100%;
            text-align: center;
        }
    }
</style>


<c:choose>
    <c:when test="${not empty sessionScope.account}">
        <header class="navbar-header">
            <div class="navbar-logo">
                <span>🔧 DWMS</span>
            </div>

            <nav class="navbar-user-info" aria-label="Primary">
        <span class="user-badge">
            <span>Signed in as:</span>
            <strong>
                    ${empty sessionScope.account ? 'Guest' : sessionScope.account.username}
            </strong>
        </span>
                <c:if test="${not empty sessionScope.account}">
                    <a href="${pageContext.request.contextPath}/auth/logout" class="btn-logout">
                        Logout
                    </a>
                </c:if>
            </nav>
        </header>
    </c:when>
    <c:otherwise>
        <header class="navbar-header">
            <div class="logo">
                <a href="${pageContext.request.contextPath}/">
                    <span>🔧 CRM System</span>
                </a>
            </div>
            <div class="login-buttons">
                <a href="${pageContext.request.contextPath}/auth/staff_login" class="btn btn-staff">
                    Staff Login
                </a>
                <a href="${pageContext.request.contextPath}/auth/customer_login" class="btn btn-customer">
                    Customer Login
                </a>
                <a href="${pageContext.request.contextPath}/auth/customer_register" class="btn btn-customer">
                    Customer Register
                </a>
            </div>
        </header>
    </c:otherwise>
</c:choose>
