<%--
  Created by IntelliJ IDEA.
  User: MasterLong
  Date: 10/10/2025
  Time: 7:49 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Action Center</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
          rel="stylesheet">
</head>
<body>
<jsp:include page="../components/header.jsp"/>
<p>THIS IS WAREHOUSEKEEPER</p>
<a href="${pageContext.request.contextPath}/warehouse_keeper/export_product"></a>
<a href="${pageContext.request.contextPath}/warehouse_keeper/view_warehouse_product_requests">View Product Request</a>
<a href="${pageContext.request.contextPath}/warehouse_keeper/view_inventory">View Inventory</a>
<a href="${pageContext.request.contextPath}/warehouse_keeper/view_product_warehouse">View My Warehouse</a>
<a href="${pageContext.request.contextPath}/warehouse_keeper/view_warehouse_product_requests">View Product Request</a>
<a href="${pageContext.request.contextPath}/warehouse_keeper/view_product_transaction">View all product transaction</a><br/>
<a href="${pageContext.request.contextPath}/warehouse_keeper/import_product">Import product</a><br/>

</body>
</html>
