<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> <%@
taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib
prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Task Detail</title>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/task/taskDetail.css"
    />
    <style>
      .container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 20px;
      }

      .header h1 {
        margin: 0;
        font-size: 28px;
      }

      .subtitle {
        color: #666;
        margin-top: 4px;
      }

      .info-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
        gap: 18px;
        margin-top: 20px;
      }

      .card {
        background: #fff;
        border: 1px solid #e3e3e3;
        border-radius: 10px;
        padding: 18px;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.07);
      }

      .card h3 {
        margin-top: 0;
        font-size: 18px;
        display: flex;
        align-items: center;
        gap: 8px;
      }

      .item {
        display: flex;
        justify-content: space-between;
        padding: 6px 0;
        border-bottom: 1px dashed #eee;
      }

      .item:last-child {
        border-bottom: none;
      }

      .label {
        font-weight: 600;
        color: #444;
      }

      .value {
        color: #222;
        text-align: right;
      }

      .badge {
        display: inline-block;
        padding: 4px 10px;
        font-size: 12px;
        border-radius: 14px;
        font-weight: 600;
      }

      .status-Pending {
        background: #fff3cd;
        color: #856404;
      }

      .status-Processing {
        background: #cce5ff;
        color: #004085;
      }

      .status-Finished {
        background: #d4edda;
        color: #155724;
      }

      .status-Reject,
      .status-Rejected {
        background: #f8d7da;
        color: #721c24;
      }

      .muted {
        color: #999;
        font-style: italic;
      }

      .section {
        margin-top: 28px;
      }

      .description-box {
        background: #fafafa;
        border: 1px solid #e3e3e3;
        padding: 16px;
        border-radius: 8px;
        white-space: pre-wrap;
      }

      .actions {
        margin-top: 30px;
        display: flex;
        gap: 12px;
        flex-wrap: wrap;
      }

      .btn {
        background: #007bff;
        color: #fff;
        padding: 10px 18px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
      }

      .btn-secondary {
        background: #6c757d;
      }

      .alert {
        padding: 12px 16px;
        border-radius: 6px;
        margin-top: 16px;
        display: flex;
        gap: 10px;
        align-items: center;
      }

      .alert-error {
        background: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
      }

      .alert-success {
        background: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <jsp:include page="../components/header.jsp" />
      <jsp:include page="../components/sidebar.jsp" />
      <div class="header">
        <h1><i class="fas fa-tasks"></i> Task Detail</h1>
      </div>

      <c:if test="${not empty errorMessage}">
        <div class="alert alert-error">
          <i class="fas fa-exclamation-circle"></i> ${errorMessage}
        </div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert alert-error">
          <i class="fas fa-exclamation-circle"></i> ${error}
        </div>
      </c:if>
      <c:if test="${not empty successMessage}">
        <div class="alert alert-success">
          <i class="fas fa-check-circle"></i> ${successMessage}
        </div>
      </c:if>

      <c:if test="${empty task}">
        <div class="alert alert-error">
          <i class="fas fa-exclamation-triangle"></i> Task not found or
          inaccessible.
        </div>
      </c:if>

      <c:if test="${not empty task}">
        <div class="info-grid">
          <div class="card">
            <h3><i class="fas fa-info-circle"></i> Task Information</h3>
            <div class="item">
              <span class="label">Task ID:</span
              ><span class="value">#${task.taskID}</span>
            </div>
            <div class="item">
              <span class="label">Assign By:</span
              ><span class="value"
                ><c:choose
                  ><c:when
                    test="${not empty assignBy and not empty assignBy.staffName}"
                    >${assignBy.staffName}</c:when
                  ><c:otherwise
                    ><span class="muted">N/A</span></c:otherwise
                  ></c:choose
                ></span
              >
            </div>
            <div class="item">
              <span class="label">Assign To:</span
              ><span class="value"
                ><c:choose
                  ><c:when
                    test="${not empty assignTo and not empty assignTo.staffName}"
                    >${assignTo.staffName}</c:when
                  ><c:otherwise
                    ><span class="muted">N/A</span></c:otherwise
                  ></c:choose
                ></span
              >
            </div>
            <div class="item">
              <span class="label">Request ID:</span
              ><span class="value"
                ><c:choose
                  ><c:when
                    test="${not empty requestObj and not empty requestObj.requestID}"
                    >#${requestObj.requestID}</c:when
                  ><c:otherwise
                    ><span class="muted">N/A</span></c:otherwise
                  ></c:choose
                ></span
              >
            </div>
            <div class="item">
              <span class="label">Status:</span
              ><span class="value"
                ><c:choose
                  ><c:when test="${not empty task.status}"
                    ><span class="badge status-${task.status}"
                      >${task.status}</span
                    ></c:when
                  ><c:otherwise
                    ><span class="muted">Unknown</span></c:otherwise
                  ></c:choose
                ></span
              >
            </div>
            <div class="item">
              <span class="label">Start Date:</span
              ><span class="value"
                ><c:choose
                  ><c:when test="${not empty task.startDate}"
                    >${task.startDate}</c:when
                  ><c:otherwise
                    ><span class="muted">Not set</span></c:otherwise
                  ></c:choose
                ></span
              >
            </div>
            <div class="item">
              <span class="label">Deadline:</span
              ><span class="value"
                ><c:choose
                  ><c:when test="${not empty task.deadline}"
                    >${task.deadline}</c:when
                  ><c:otherwise
                    ><span class="muted">Not set</span></c:otherwise
                  ></c:choose
                ></span
              >
            </div>
            <div class="item">
              <span class="label">End Date:</span
              ><span class="value"
                ><c:choose
                  ><c:when test="${not empty task.endDate}"
                    >${task.endDate}</c:when
                  ><c:otherwise
                    ><span class="muted">Not finished</span></c:otherwise
                  ></c:choose
                ></span
              >
            </div>
          </div>

          <div class="card">
            <h3><i class="fas fa-user"></i> Request</h3>
            <div class="item">
              <span class="label">Request Id:</span
              ><span class="value"
                ><c:choose
                  ><c:when
                    test="${not empty requestObj and not empty requestObj.requestID}"
                  >
                    <a
                      href="${pageContext.request.contextPath}/technician_leader/requests/detail?requestId=${requestObj.requestID}"
                      >#${requestObj.requestID}</a
                    > </c:when
                  ><c:otherwise
                    ><span class="muted">N/A</span></c:otherwise
                  ></c:choose
                ></span
              >
            </div>
            <div class="item">
              <span class="label">Customer Name:</span
              ><span class="value"
                ><c:choose
                  ><c:when
                    test="${not empty customer and not empty customer.customerName}"
                  >
                    <a
                      href="${pageContext.request.contextPath}/staff/customer/detail?customerId=${customer.customerID}"
                      >${customer.customerName}</a
                    ></c:when
                  ><c:otherwise
                    ><span class="muted">N/A</span></c:otherwise
                  ></c:choose
                ></span
              >
            </div>
            <div class="item">
              <span class="label">Phone:</span
              ><span class="value"
                ><c:choose
                  ><c:when
                    test="${not empty customer and not empty customer.phone}"
                    >${customer.phone}</c:when
                  ><c:otherwise
                    ><span class="muted">N/A</span></c:otherwise
                  ></c:choose
                ></span
              >
            </div>
            <div class="item">
              <span class="label">Email:</span
              ><span class="value"
                ><c:choose
                  ><c:when
                    test="${not empty customer and not empty customer.email}"
                    >${customer.email}</c:when
                  ><c:otherwise
                    ><span class="muted">N/A</span></c:otherwise
                  ></c:choose
                ></span
              >
            </div>
            <div class="item">
              <span class="label">Contract ID:</span
              ><span class="value"
                ><c:choose
                  ><c:when
                    test="${not empty contract and not empty contract.contractID}"
                    >#${contract.contractID}</c:when
                  ><c:otherwise
                    ><span class="muted">N/A</span></c:otherwise
                  ></c:choose
                ></span
              >
            </div>
            <div class="item">
              <span class="label">Contract Start:</span
              ><span class="value"
                ><c:choose
                  ><c:when
                    test="${not empty contract and not empty contract.startDate}"
                    >${contract.startDate}</c:when
                  ><c:otherwise
                    ><span class="muted">N/A</span></c:otherwise
                  ></c:choose
                ></span
              >
            </div>
            <div class="item">
              <span class="label">Contract End:</span
              ><span class="value"
                ><c:choose
                  ><c:when
                    test="${not empty contract and not empty contract.expiredDate}"
                    >${contract.expiredDate}</c:when
                  ><c:otherwise
                    ><span class="muted">N/A</span></c:otherwise
                  ></c:choose
                ></span
              >
            </div>
          </div>
        </div>

        <div class="section">
          <h3><i class="fas fa-file-alt"></i> Description</h3>
          <div class="description-box">
            <c:choose>
              <c:when test="${not empty task.description}"
                >${task.description}</c:when
              >
              <c:otherwise
                ><span class="muted"
                  >No description provided.</span
                ></c:otherwise
              >
            </c:choose>
          </div>
        </div>

        <div class="section">
          <h3><i class="fas fa-sticky-note"></i> Task Note</h3>
          <div class="description-box">
            <c:choose>
              <c:when test="${not empty task.taskNote}"
                >${task.taskNote}</c:when
              >
              <c:otherwise
                ><span class="muted">No additional notes.</span></c:otherwise
              >
            </c:choose>
          </div>
        </div>

        <div class="actions">
          <button
            type="button"
            class="btn btn-secondary"
            onclick="history.back()"
          >
            <i class="fas fa-arrow-left"></i> Back
          </button>
        </div>
      </c:if>
    </div>
  </body>
</html>
