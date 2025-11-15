<%@ page import="java.util.Map" %><%-- Created by IntelliJ IDEA. User: anhtu
Date: 10/5/2025 Time: 4:05 PM To change this template use File | Settings | File
Templates. --%> <%@ page contentType="text/html;charset=UTF-8" language="java"
%> <%@ taglib uri="jakarta.tags.core" prefix="c" %>
<html>
  <head>
    <title>View Request Detail</title>
    <link
      href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
  </head>
  <body>
    <jsp:include page="../components/header.jsp" />
    <jsp:include page="../components/sidebar.jsp" />
    <div class="container py-5">
      <div class="card shadow-sm">
        <div class="card-header bg-primary text-white">
          <h3 class="mb-0">Request Detail</h3>
        </div>
        <div class="card-body">
          <c:set var="statusClass" value="bg-secondary" />
          <c:choose>
            <c:when test="${request.requestStatus == 'Pending'}">
              <c:set var="statusClass" value="bg-warning text-dark" />
            </c:when>
            <c:when test="${request.requestStatus == 'Processing'}">
              <c:set var="statusClass" value="bg-primary" />
            </c:when>
            <c:when test="${request.requestStatus == 'Tech_Finished'}">
              <c:set var="statusClass" value="bg-info" />
            </c:when>
            <c:when test="${request.requestStatus == 'Finished'}">
              <c:set var="statusClass" value="bg-success" />
            </c:when>
            <c:when test="${request.requestStatus == 'Rejected'}">
              <c:set var="statusClass" value="bg-danger" />
            </c:when>
          </c:choose>

          <c:if test="${request.requestStatus == 'Tech_Finished'}">
            <div class="alert alert-info" role="alert">
              Technical team marked this request as completed. Please confirm
              finish or mark as not finished to reopen.
            </div>
          </c:if>
          <div class="mb-4">
            <h5 class="border-bottom pb-2 text-secondary">
              Customer Information
            </h5>
            <p>
              <strong>Customer Name:</strong>
              <a
                href="../../staff/customer/detail?customerId=${request.contract.customer.customerID}"
                class="text-decoration-none"
              >
                ${request.contract.customer.customerName}
              </a>
            </p>
            <p>
              <strong>Address:</strong> ${request.contract.customer.address}
            </p>
            <p><strong>Phone:</strong> ${request.contract.customer.phone}</p>
            <p><strong>Email:</strong> ${request.contract.customer.email}</p>
          </div>

          <div class="mb-4">
            <h5 class="border-bottom pb-2 text-secondary">
              Request Information
            </h5>
            <p>
              <strong>Contract Code:</strong>
              <a
                href="../../contract/detail?contractId=${request.contract.contractID}"
                class="text-decoration-none"
              >
                ${request.contract.contractCode}
              </a>
            </p>
            <p><strong>Description:</strong> ${request.requestDescription}</p>
            <p>
              <strong>Status:</strong>
              <span class="badge ${statusClass}">${request.requestStatus}</span>
            </p>
            <p><strong>Note:</strong> ${request.note}</p>
            <p><strong>Create Date:</strong> ${request.startDate}</p>
            <p><strong>Finish Date:</strong> ${request.finishedDate}</p>
          </div>

          <div class="d-flex justify-content-end gap-2">
            <c:if test="${request.requestStatus == 'Pending'}">
              <a
                href="./process?requestId=${request.requestID}"
                class="btn btn-warning"
                >Process Request</a
              >
            </c:if>
            <c:if test="${request.requestStatus == 'Tech_Finished'}">
              <button
                type="button"
                class="btn btn-success"
                onclick="handleSupporterFinish('${request.requestID}')"
              >
                Confirm Finish
              </button>
              <button
                type="button"
                class="btn btn-danger"
                onclick="handleSupporterNotFinish('${request.requestID}')"
              >
                Mark Not Finished
              </button>
            </c:if>
            <a
              href="../../staff/requests/timeline?requestId=${request.requestID}"
              class="btn btn-primary"
              >Timeline</a
            >
            <a href="./list" class="btn btn-secondary">Back to List</a>
          </div>
        </div>
      </div>
    </div>
    <script>
      async function postJson(url, payload) {
        const res = await fetch(url, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(payload),
        });

        const text = await res.text(); // tránh lỗi JSON rỗng
        let data;
        try {
          data = JSON.parse(text);
        } catch {
          data = { message: text || "No response message." };
        }

        if (!res.ok) {
          const msg = data.message || `Request failed (${res.status})`;
          throw new Error(msg);
        }

        return data;
      }

      async function handleSupporterFinish(requestId) {
        if (!confirm("Confirm this service request is fully finished?")) return;
        const btn = event.target;
        btn.disabled = true;
        const oldText = btn.innerText;
        btn.innerText = "Processing...";

        const url =
          "${pageContext.request.contextPath}/customer_supporter/request/finish";

        try {
          const result = await postJson(url, { requestId: String(requestId) });
          alert(result.message || "Finished successfully.");
          // Reload lại toàn trang, đảm bảo dữ liệu mới được hiển thị
          window.location.href = window.location.href;
        } catch (err) {
          alert(err.message || "Failed to finish request.");
        } finally {
          btn.disabled = false;
          btn.innerText = oldText;
        }
      }

      async function handleSupporterNotFinish(requestId) {
        if (!confirm("Mark this request as NOT finished and reopen?")) return;

        const message = prompt(
          "Please enter the reason to notify the technician lead:"
        );
        if (message === null) return; // user bấm Cancel
        if (!message.trim()) {
          alert("Message is required.");
          return;
        }

        const btn = event.target;
        btn.disabled = true;
        const oldText = btn.innerText;
        btn.innerText = "Processing...";

        const url =
          "${pageContext.request.contextPath}/customer_supporter/request/not_finish";

        try {
          const result = await postJson(url, {
            requestId: String(requestId),
            message: message.trim(),
          });
          alert(result.message || "Request reopened successfully.");
          window.location.href = window.location.href;
        } catch (err) {
          alert(err.message || "Failed to reopen request.");
        } finally {
          btn.disabled = false;
          btn.innerText = oldText;
        }
      }
    </script>
  </body>
</html>
