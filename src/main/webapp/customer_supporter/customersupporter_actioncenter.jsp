<%-- Created by IntelliJ IDEA. User: MasterLong Date: 10/10/2025 Time: 7:50 AM
To change this template use File | Settings | File Templates. --%>
<%@ page import="crm.common.URLConstants" %>
<%@ page
        contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Action Center</title>
    <link
            href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
            rel="stylesheet"
    />
</head>
<body>
<jsp:include page="../components/header.jsp"/>
<p>THIS IS CUSTOMERSUPPORTER</p>
<h1>Customer Supporter Action Center</h1>
<p>
    Welcome to the Customer Supporter Action Center. Here you can manage
    customer requests and assist customers.
</p>
<a
        href="${pageContext.request.contextPath}/customer_supporter/create_contract"
>Create contract</a
>
<a href="../supporter/requests/list">Customer supporter request</a>
<a href="../supporter/requests/dashboard">Request Dashboard</a>
<a href="${pageContext.request.contextPath}${URLConstants.CUSTOMER_SUPPORTER_FEEDBACK_MANAGEMENT}">Feedback Management</a>
<a href="${pageContext.request.contextPath}/staff/profile">Profile</a>
</body>
</html>
