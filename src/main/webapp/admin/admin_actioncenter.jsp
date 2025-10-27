<%--
  Created by IntelliJ IDEA.
  User: MasterLong
  Date: 10/10/2025
  Time: 8:16 AM
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
<h1>Admin Action Center</h1>
<p>Welcome to the Admin Action Center. Here you can manage various administrative tasks.</p>
<a href="${pageContext.request.contextPath}/admin/role_list">View role list</a>
<a href="${pageContext.request.contextPath}/admin/account_list">View account list</a>
</body>
</html>
