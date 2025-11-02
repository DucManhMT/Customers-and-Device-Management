<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
            </ul>
        </div>
    </div>
</div>