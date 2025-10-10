<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %><%--
  Created by IntelliJ IDEA.
  User: anhtu
  Date: 10/8/2025
  Time: 10:37 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Request Dashboard</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
          rel="stylesheet"/>
</head>
<body>

<%
    // ======== SAMPLE DASHBOARD DATA ========

    Map<String, Integer> summary = new HashMap<>();
    summary.put("total", 24);
    summary.put("pending", 8);
    summary.put("approved", 7);
    summary.put("finish", 5);
    summary.put("reject", 4);

    // Đặt dữ liệu vào request để hiển thị qua EL
    for (Map.Entry<String, Integer> e : summary.entrySet()) {
        request.setAttribute(e.getKey(), e.getValue());
    }
%>
<div class="container mt-4">
    <h1 class="mb-4">Request Dashboard</h1>

    <div class="card p-3 mb-4">
        <div class="row g-3 align-items-center">
            <div class="col-md-3">
                <label for="fromDate" class="form-label">From</label>
                <input type="date" class="form-control" id="fromDate" name="fromDate"/>
            </div>
            <div class="col-md-3">
                <label for="toDate" class="form-label">To</label>
                <input type="date" class="form-control" id="toDate" name="toDate"/>
            </div>
            <div class="col-md-6 d-flex gap-2 mt-4">
                <button class="btn btn-primary">Filter</button>
                <button class="btn btn-outline-secondary" onclick="resetFilter()">Reset</button>
                <a href="./list" class="btn btn-info">View List</a>
            </div>
        </div>
    </div>

    <div class="card p-3">
        <h4>Summary</h4>
        <p>Total: ${total}</p>
        <p>Pending: ${pending}</p>
        <p>Approved: ${approved}</p>
        <p>Finish: ${finish}</p>
        <p>Reject: ${reject}</p>
    </div>

    <div id="chartContainer" style="height: 400px; width: 100%;"></div>
</div>

</body>
</html>
