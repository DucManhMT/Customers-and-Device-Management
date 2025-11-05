<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Customer Device Warranty Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <style>
        /* Additional styles for the home page content */
        .welcome-card {
            background-color: var(--card-bg, #fff);
            border-radius: 12px;
            padding: 40px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            text-align: center;
        }

        .welcome-card h1 {
            font-weight: 700;
            color: var(--sidebar-bg, #1A3A4A);
        }

        .welcome-card p {
            color: var(--text-muted-light, #6c757d);
            font-size: 1.1rem;
        }

        .welcome-card .btn-primary {
            background-color: var(--sidebar-active-bg, #F9C941);
            border-color: var(--sidebar-active-bg, #F9C941);
            color: var(--sidebar-active-link-color, #0D1B2A);
            font-weight: 600;
            padding: 10px 20px;
        }
    </style>
</head>
<body>

<%-- Include a sidebar based on user role, or a default one. This is a placeholder. --%>
<%-- For example, for a warehouse keeper: --%>
<c:if test="${sessionScope.account.role.roleName == 'WarehouseKeeper'}">
    <jsp:include page="components/warehouse_keeper_sidebar.jsp"/>
</c:if>
<%-- You can add other <c:if> blocks for other roles --%>
<jsp:include page="components/warehouse_keeper_sidebar.jsp"></jsp:include>

<div class="main-content">
    <%-- Include the shared header --%>
    <jsp:include page="components/header.jsp"/>

    <div class="page-content">
        <div class="container-fluid">
            <div class="welcome-card mt-4">
                <h1>Welcome, ${empty sessionScope.account ? 'Guest' : sessionScope.account.username}!</h1>
                <p class="lead mt-3">
                    You are in the Customer Device Warranty Management system.
                </p>
                <c:if test="${not empty homeLink}">
                    <a href="${homeLink}" class="btn btn-primary mt-3">
                        <i class="fas fa-arrow-right me-2"></i> Go to your Dashboard
                    </a>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
