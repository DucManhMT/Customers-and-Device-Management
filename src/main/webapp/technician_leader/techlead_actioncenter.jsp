<%--
  Created by IntelliJ IDEA.
  User: MasterLong
  Date: 10/9/2025
  Time: 3:26 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
    <p>THIS IS TECHLEAD</p>
    <a href="${pageContext.request.contextPath}/task/techlead/assignTask.jsp">
                    Assign Task 
                </a>
    <a href="${pageContext.request.contextPath}/tech/employees">
                    View Technician List
                </a>
    <a href="${pageContext.request.contextPath}/task/viewAprovedTask">
                    View Aproved Tasks
                </a>            
</body>
</html>
