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
        background-color: #0e4274;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        padding: 1rem 2rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
        position: sticky;
        top: 0;
        z-index: 1000;
    }

    .navbar-logo {
        font-size: 1.5rem;
        font-weight: bold;
        color: #667eea;
    }

    .navbar-logo a {
        color:#faebef;
        text-decoration: none;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .navbar-logo a:hover {
        color: #5568d3;
        transform: scale(1.05);
    }

    .navbar-logo a:active {
        transform: scale(0.98);
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
        background-color: #f8f9fa;
        border-radius: 20px;
        font-size: 0.9rem;
        color: #666;
    }

    .user-badge strong {
        color: #0e4274;
        font-weight: 600;
    }

    .btn-logout {
        padding: 0.6rem 1.5rem;
        text-decoration: none;
        border-radius: 25px;
        font-weight: 600;
        transition: all 0.3s ease;
        border: 2px solid #667eea;
        background-color: transparent;
        color: #faebef;
        display: inline-block;
    }

    .btn-logout:hover {
        background-color: #667eea;
        color: white;
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
    }

    /* Responsive Design */
    @media (max-width: 768px) {
        .navbar-header {
            flex-direction: column;
            gap: 1rem;
            padding: 1rem;
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
<c:if test="${not empty sessionScope.account}">
    <c:choose>
        <c:when test="${sessionScope.account.role.roleName == 'Admin'}">
            <c:set var="homeLink" value="${URLConstants.ADMIN_ACTION_CENTER}"/>
        </c:when>
        <c:when test="${sessionScope.account.role.roleName == 'Customer'}">
            <c:set var="homeLink" value="${URLConstants.CUSTOMER_ACTION_CENTER}"/>
        </c:when>
        <c:when test="${sessionScope.account.role.roleName == 'CustomerSupporter'}">
            <c:set var="homeLink" value="${URLConstants.CUSTOMER_SUPPORTER_ACTION_CENTER}"/>
        </c:when>
        <c:when test="${sessionScope.account.role.roleName == 'WarehouseKeeper'}">
            <c:set var="homeLink" value="${URLConstants.WAREHOUSE_ACTION_CENTER}"/>
        </c:when>
        <c:when test="${sessionScope.account.role.roleName == 'TechnicianLeader'}">
            <c:set var="homeLink" value="${URLConstants.TECHLEAD_ACTION_CENTER}"/>
        </c:when>
        <c:when test="${sessionScope.account.role.roleName == 'TechnicianEmployee'}">
            <c:set var="homeLink" value="${URLConstants.TECHEM_ACTION_CENTER}"/>
        </c:when>
    </c:choose>
</c:if>

<c:choose>
    <c:when test="${not empty sessionScope.account}">
        <header class="navbar-header">
            <div class="navbar-logo">
                <a href="${pageContext.request.contextPath}${homeLink}">
                    <span>🔧 CRM System</span>
                </a>
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

