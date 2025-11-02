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
    .top-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        width: 100%;
        padding: 22px;
        border-bottom: 2px solid #dee2e6; /* Horizontal separator line */
        background-color: var(--main-bg);
    }

    .project-title span{
        font-size: 1.5rem;
        font-weight: bold;
        color: #1A3A4A;
    }

    .user-profile {
        display: flex;
        align-items: center;
        margin-right: 20px;
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

<div class="top-header">
    <div class="project-title">
        <span>Customer Device Warranty Management</span>
    </div>
    <div class="user-profile">
        <div class="dropdown">
            <a href="#" class="d-block link-dark text-decoration-none dropdown-toggle" data-bs-toggle="dropdown"
               aria-expanded="false">
                <strong>
                    ${empty sessionScope.account ? 'Guest' : sessionScope.account.username}
                </strong>
            </a>
            <ul class="dropdown-menu text-small dropdown-menu-end">
                <li><a class="dropdown-item" href="#">Profile</a></li>
                <li><a class="dropdown-item" href="#">Settings</a></li>
                <li>
                    <hr class="dropdown-divider">
                </li>
                <c:if test="${not empty sessionScope.account}">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/auth/logout">Sign out</a></li>
                </c:if>
                <c:if test="${empty sessionScope.account}">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/auth/staff_login">Staff login</a></li>
                </c:if>
                <c:if test="${empty sessionScope.account}">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/auth/customer_login">Customer login</a></li>
                </c:if>
                <c:if test="${empty sessionScope.account}">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/auth/customer_register">Customer register</a></li>
                </c:if>
            </ul>
        </div>
    </div>
</div>

