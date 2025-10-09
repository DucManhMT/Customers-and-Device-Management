<%--
  Created by IntelliJ IDEA.
  User: anhtu
  Date: 10/8/2025
  Time: 9:42 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>

<%
    // Mock Customer
    Map<String, Object> customer = new java.util.HashMap<>();
    customer.put("customerName", "Nguyen Van A");
    customer.put("address", "123 Tran Hung Dao, District 1, Ho Chi Minh City");
    customer.put("phone", "0909-123-456");
    customer.put("email", "nguyenvana@example.com");

    // Mock Contract
    Map<String, Object> contract = new java.util.HashMap<>();
    contract.put("contractID", "CT2025-001");
    contract.put("customer", customer);

    // Mock Request
    Map<String, Object> requestDetail = new java.util.HashMap<>();
    requestDetail.put("contract", contract);
    requestDetail.put("requestDescription", "My computer is leaking water, please help me.");
    requestDetail.put("requestStatus", "Rejected");
    requestDetail.put("note", "Claims not covered by warranty.");
    requestDetail.put("startDate", "2025-09-29");
    requestDetail.put("finishedDate", "—");

    // Gán vào request attribute để EL (${}) có thể dùng
    request.setAttribute("request", requestDetail);
%>

<html>
<head>
    <title>Request Detail</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
          rel="stylesheet"/>
</head>
<body>
<div class="container py-5">
    <div class="card shadow-sm">
        <div class="card-header bg-primary text-white">
            <h3 class="mb-0">Request Detail</h3>
        </div>
        <div class="card-body">

            <div class="mb-4">
                <h5 class="border-bottom pb-2 text-secondary">Request Information</h5>
                <p><strong>Contract ID:</strong>
                    <a href="./requests/list">
                        ${request.contract.contractID}
                    </a>
                </p>
                <p><strong>Description:</strong> ${request.requestDescription}</p>
                <p><strong>Status:</strong>
                    <span class="text-danger" style="font-weight: bold">${request.requestStatus}</span>
                </p>
                <p><strong>Note:</strong> ${request.note}</p>
                <p><strong>Create Date:</strong> ${request.startDate}</p>
                <p><strong>Finish Date:</strong> ${request.finishedDate}</p>
            </div>


            <div class="d-flex justify-content-end gap-2">
                <button type="button" class="btn btn-success">View Timeline</button>
                <a href="./list" class="btn btn-secondary">Back to List</a>
            </div>

        </div>
    </div>
</div>
</body>
</html>
