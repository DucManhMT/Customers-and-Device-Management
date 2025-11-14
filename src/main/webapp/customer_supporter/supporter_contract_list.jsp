<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="jakarta.tags.core" %> <%@ taglib prefix="fn"
uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>Contract List</title>
    <link
      href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <script src="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/js/bootstrap.bundle.min.js"></script>
    <style>
      body {
        background: #f8f9fa;
      }
      .card {
        border: none;
        border-radius: 16px;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
      }
      .filter-card {
        margin-bottom: 1rem;
      }
      .badge-small {
        font-size: 0.75rem;
      }
    </style>
  </head>
  <body>
    <jsp:include page="../components/header.jsp" />
    <jsp:include page="../components/sidebar.jsp" />
    <div class="container-fluid p-4">
      <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="mb-0">Customer Contracts</h2>
        <c:if test="${not empty totalRecords}"
          ><span class="text-muted"
            >Total: <strong>${totalRecords}</strong></span
          ></c:if
        >
      </div>

      <div class="card filter-card p-3">
        <form
          method="get"
          action="${pageContext.request.contextPath}/customer_supporter/contracts"
          class="row g-3 align-items-end"
        >
          <div class="col-md-3">
            <label class="form-label" for="customerName">Customer Name</label>
            <input
              type="text"
              id="customerName"
              name="customerName"
              value="${customerName}"
              class="form-control"
              placeholder="Search by Customer Name"
            />
          </div>
          <div class="col-md-3">
            <label class="form-label" for="contractCode">Contract Code</label>
            <input
              type="text"
              id="contractCode"
              name="contractCode"
              value="${contractCode}"
              class="form-control"
              placeholder="Search by Contract Code"
            />
          </div>
          <div class="col-md-2">
            <label class="form-label" for="size">Page Size</label>
            <input
              type="number"
              id="size"
              name="size"
              min="1"
              max="100"
              value="${recordsPerPage}"
              class="form-control"
            />
          </div>
          <div class="col-md-2">
            <label class="form-label" for="page">Page</label>
            <input
              type="number"
              id="page"
              name="page"
              min="1"
              value="${currentPage}"
              class="form-control"
            />
          </div>
          <div class="col-md-2 text-md-end">
            <button type="submit" class="btn btn-primary w-100">
              <i class="bi bi-funnel"></i> Filter
            </button>
          </div>
        </form>
      </div>

      <div class="card">
        <div class="card-body p-0">
          <table class="table table-hover mb-0">
            <thead class="table-light">
              <tr>
                <th style="width: 70px" class="text-center">#</th>
                <th>Contract Code</th>
                <th>Customer</th>
                <th>Start Date</th>
                <th>Expired Date</th>
                <th style="width: 120px" class="text-center">Requests</th>
                <th style="width: 180px" class="text-center">Actions</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="c" items="${contracts}" varStatus="st">
                <tr>
                  <td class="text-center">
                    ${st.index + 1 + (currentPage - 1) * recordsPerPage}
                  </td>
                  <td>${c.contractCode}</td>
                  <td>
                    <c:choose>
                      <c:when
                        test="${not empty c.customer and not empty c.customer.customerName}"
                      >
                        <a
                          href="${pageContext.request.contextPath}/staff/customer/detail?customerId=${c.customer.customerID}"
                          class="text-decoration-none fw-semibold"
                          >${c.customer.customerName}</a
                        ></c:when
                      >
                      <c:otherwise
                        ><span class="text-muted">N/A</span></c:otherwise
                      >
                    </c:choose>
                  </td>
                  <td>${c.startDate}</td>
                  <td>${c.expiredDate}</td>
                  <td class="text-center">
                    <span class="badge bg-secondary badge-small"
                      >${fn:length(c.requests)}</span
                    >
                  </td>
                  <td class="text-center">
                    <a
                      class="btn btn-info btn-sm"
                      href="${pageContext.request.contextPath}/contract/detail?contractId=${c.contractID}"
                      >View</a
                    >
                  </td>
                </tr>
              </c:forEach>
              <c:if test="${empty contracts}">
                <tr>
                  <td colspan="7" class="text-center text-muted py-4">
                    No contracts found.
                  </td>
                </tr>
              </c:if>
            </tbody>
          </table>
        </div>
      </div>

      <c:if test="${totalPages > 1}">
        <nav class="mt-3">
          <ul class="pagination mb-0">
            <c:forEach begin="1" end="${totalPages}" var="p">
              <li class="page-item ${p == currentPage ? 'active' : ''}">
                <a
                  class="page-link"
                  href="?page=${p}&size=${recordsPerPage}&customerName=${customerName}&contractCode=${contractCode}"
                  >${p}</a
                >
              </li>
            </c:forEach>
          </ul>
        </nav>
      </c:if>
    </div>
  </body>
</html>
