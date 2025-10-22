<%--
  Created by IntelliJ IDEA.
  User: MasterLong
  Date: 10/7/2025
  Time: 6:18 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>

</head>
<body>
    <p>${sessionScope.account.username}</p>
    <h1>Customer Action Center</h1>
    <p>Welcome to the Customer Action Center. Here you can manage your account and view
        your activities.</p>
<a href="${pageContext.request.contextPath}/customer/contract_history">Contract Histoy</a>
<a href="${pageContext.request.contextPath}/feedback/create" >
                    Customer Feedback
                </a>
</body>
</html>
  