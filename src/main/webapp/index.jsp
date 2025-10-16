<%-- Created by IntelliJ IDEA. User: anhtu Date: 9/27/2025 Time: 9:16 AM To
change this template use File | Settings | File Templates. --%> <%@ page
contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>Title</title>
  </head>
  <body>
    <p>
      Hello World!
      <a href="${pageContext.request.contextPath}/auth/customer_login"
        >Login here</a
      ><br />
      <a href="${pageContext.request.contextPath}/auth/staff_login"
        >Login here</a
      ><br />
      <a
        href="${pageContext.request.contextPath}/warehousekeeper/import_product"
        >Import product</a
      ><br />
    </p>

  <div>
    <h1>CAC LINK MAN HINH DE CHAY LUONG CHINH</h1>
    <a href="#">Tao hop dong</a>
    <a href="#">Customer tao request</a>
    <a href="#">Customer supporter xem request va forward cho techlead</a>
    <a href="#">TechLead giao viec cho tech enployee</a>
    <a href="#">Techemployee yeu cau san phan tu kho</a>
    <a href="#">Kho xuat san pham</a>
    <a href="#">Trang thai request duoc cap nhat</a>
  </div>
  </body>
</html>
