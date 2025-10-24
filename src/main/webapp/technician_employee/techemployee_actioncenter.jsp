<%-- Created by IntelliJ IDEA. User: MasterLong Date: 10/9/2025 Time: 4:38 PM To
change this template use File | Settings | File Templates. --%> <%@ page
contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>Action center</title>
    <link
      href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
  </head>
  <body>
    <jsp:include page="../components/teach_employee_header.jsp" />
    <p>THIS IS TECHEMPLOYEE</p>
    <a
      href="${pageContext.request.contextPath}/technician_employee/create_product_request"
      >Create export request</a
    >
    <a href="${pageContext.request.contextPath}/task/viewAssignedTasks"
      >View Assigned Task</a
    >
  </body>
</html>
