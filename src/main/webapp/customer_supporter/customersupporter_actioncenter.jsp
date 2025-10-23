<%--
  Created by IntelliJ IDEA.
  User: MasterLong
  Date: 10/10/2025
  Time: 7:50 AM
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
<jsp:include page="../components/supporter_header.jsp"/>
<p>THIS IS CUSTOMERSUPPORTER</p>
<h1>Customer Supporter Action Center</h1>
<p>Welcome to the Customer Supporter Action Center. Here you can manage customer requests
    and assist customers.</p>
<a href="${pageContext.request.contextPath}/customer_supporter/create_contract">Create contract</a>
</body>
</html>
