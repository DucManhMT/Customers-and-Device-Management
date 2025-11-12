<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> <%@
taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Customer Detail</title>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <link
      href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <script src="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/js/bootstrap.bundle.min.js"></script>
    <style>
      body {
        background: #f6f7f9;
      }
      .container-page {
        max-width: 1200px;
        margin: 0 auto;
        padding: 24px;
      }
      .header {
        margin-bottom: 20px;
      }
      .header h1 {
        font-size: 28px;
        margin: 0;
      }
      .subtitle {
        color: #666;
        margin-top: 4px;
      }
      .grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(340px, 1fr));
        gap: 18px;
      }
      .card {
        background: #fff;
        border: 1px solid #e3e3e3;
        border-radius: 10px;
        padding: 18px;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.07);
      }
      .card h3 {
        margin: 0 0 12px;
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
      .muted {
        color: #999;
        font-style: italic;
      }
      .accordion-button {
        font-weight: 600;
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
      .actions {
        margin-top: 24px;
        display: flex;
        gap: 12px;
      }
    </style>
  </head>
  <body>
    <jsp:include page="../components/header.jsp" />
    <c:set var="activePage" value="staffCustomerDetail" scope="request" />
    <div class="container-page">
      <div class="header">
        <h1><i class="fas fa-user"></i> Customer Detail</h1>
        <p class="subtitle">
          Complete information and related contracts & requests
        </p>
      </div>

      <c:if test="${not empty error}">
        <div class="alert alert-danger">
          <i class="fas fa-exclamation-circle"></i> ${error}
        </div>
      </c:if>

      <c:if test="${not empty customer}">
        <div class="grid">
          <div class="card">
            <h3><i class="fas fa-address-card"></i> Customer Information</h3>
            <div class="item">
              <span class="label">Customer ID:</span
              ><span class="value">#${customer.customerID}</span>
            </div>
            <div class="item">
              <span class="label">Name:</span
              ><span class="value">${customer.customerName}</span>
            </div>
            <div class="item">
              <span class="label">Address:</span
              ><span class="value">${customer.address}</span>
            </div>
            <div class="item">
              <span class="label">Phone:</span
              ><span class="value">${customer.phone}</span>
            </div>
            <div class="item">
              <span class="label">Email:</span
              ><span class="value">${customer.email}</span>
            </div>
            <div class="item">
              <span class="label">Account Status:</span>
              <span class="value">
                <c:choose>
                  <c:when test="${not empty customerAccountStatus}">
                    ${customerAccountStatus}
                  </c:when>
                  <c:otherwise><span class="muted">N/A</span></c:otherwise>
                </c:choose>
              </span>
            </div>
          </div>
        </div>

        <div class="card mt-4">
          <h3><i class="fas fa-file-contract"></i> Contracts</h3>
          <c:choose>
            <c:when test="${empty contracts}">
              <div class="muted">No contracts found for this customer.</div>
            </c:when>
            <c:otherwise>
              <div class="accordion" id="contractsAccordion">
                <c:forEach var="c" items="${contracts}" varStatus="loop">
                  <div class="accordion-item">
                    <h2 class="accordion-header" id="heading-${c.contractID}">
                      <button
                        class="accordion-button collapsed"
                        type="button"
                        data-bs-toggle="collapse"
                        data-bs-target="#collapse-${c.contractID}"
                        aria-expanded="false"
                        aria-controls="collapse-${c.contractID}"
                      >
                        <span class="me-3"
                          ><i class="fas fa-file-alt"></i> Contract
                          #${c.contractID}</span
                        >
                        <span class="text-muted">Code: ${c.contractCode}</span>
                      </button>
                    </h2>
                    <div
                      id="collapse-${c.contractID}"
                      class="accordion-collapse collapse"
                      aria-labelledby="heading-${c.contractID}"
                      data-bs-parent="#contractsAccordion"
                    >
                      <div class="accordion-body">
                        <div class="row mb-3">
                          <div class="col-md-3">
                            <strong>Contract Code:</strong> ${c.contractCode}
                          </div>
                          <div class="col-md-3">
                            <strong>Start Date:</strong> ${c.startDate}
                          </div>
                          <div class="col-md-3">
                            <strong>Expired Date:</strong> ${c.expiredDate}
                          </div>
                          <div class="col-md-3 text-end">
                            <a
                              class="btn btn-sm btn-outline-primary"
                              href="${pageContext.request.contextPath}/contract/detail?contractId=${c.contractID}"
                            >
                              <i class="fas fa-eye"></i> View Detail
                            </a>
                          </div>
                        </div>
                        <hr />
                        <h6 class="mb-2">
                          <i class="fas fa-list"></i> Requests
                        </h6>
                        <c:set
                          var="reqList"
                          value="${contractRequests[c.contractID]}"
                        />
                        <c:choose>
                          <c:when test="${empty reqList}">
                            <div class="muted">
                              No requests under this contract.
                            </div>
                          </c:when>
                          <c:otherwise>
                            <div class="table-responsive">
                              <table class="table table-sm table-bordered">
                                <thead class="table-light">
                                  <tr>
                                    <th scope="col">Request ID</th>
                                    <th scope="col">Status</th>
                                    <th scope="col">Start Date</th>
                                    <th scope="col">Finished Date</th>
                                  </tr>
                                </thead>
                                <tbody>
                                  <c:forEach var="r" items="${reqList}">
                                    <tr>
                                      <td>#${r.requestID}</td>
                                      <td>
                                        <span
                                          class="badge status-${r.requestStatus}"
                                          >${r.requestStatus}</span
                                        >
                                      </td>
                                      <td>${r.startDate}</td>
                                      <td>
                                        <c:choose
                                          ><c:when
                                            test="${not empty r.finishedDate}"
                                            >${r.finishedDate}</c:when
                                          ><c:otherwise
                                            ><span class="muted"
                                              >Not finished</span
                                            ></c:otherwise
                                          ></c:choose
                                        >
                                      </td>
                                    </tr>
                                  </c:forEach>
                                </tbody>
                              </table>
                            </div>
                          </c:otherwise>
                        </c:choose>
                      </div>
                    </div>
                  </div>
                </c:forEach>
              </div>
            </c:otherwise>
          </c:choose>
        </div>
        <div class="actions">
          <button class="btn btn-secondary" onclick="history.back()">
            <i class="fas fa-arrow-left"></i> Back
          </button>
        </div>
      </c:if>

      <c:if test="${empty customer && empty error}">
        <div class="alert alert-warning">
          <i class="fas fa-info-circle"></i> Customer not found.
        </div>
      </c:if>
    </div>
  </body>
</html>
