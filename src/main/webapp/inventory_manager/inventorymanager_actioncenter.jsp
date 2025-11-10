<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 11/7/2025
  Time: 6:59 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Action Center</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>

<body>
<jsp:include page="../components/header.jsp"/>
<jsp:include page="../components/sidebar.jsp"/>

<p>THIS IS WAREHOUSEKEEPER</p>
<a href="${pageContext.request.contextPath}/inventory_manager/view_warehouse_product_requests">View Product Request</a>
<a href="${pageContext.request.contextPath}/warehouse_keeper/view_inventory">View Inventory</a>
<a href="${pageContext.request.contextPath}/warehouse_keeper/view_product_transaction">View all product transaction</a><br/>
<a href="${pageContext.request.contextPath}/inventory_manager/view_transfer_requests">Import product</a><br/>
<a href="${pageContext.request.contextPath}/staff/profile">Profile</a>
</body>
</html>
