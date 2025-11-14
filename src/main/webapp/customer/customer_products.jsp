<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Customer Products</title>
    <link
      href="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css"
      rel="stylesheet"
    />
    <script src="${pageContext.request.contextPath}/css/bootstrap/bootstrap-5.3.8-dist/js/bootstrap.bundle.min.js"></script>
  </head>
  <body>
    <jsp:include page="../components/header.jsp" />
    <jsp:include page="../components/customer_sidebar.jsp" />

    <div class="container-fluid p-4">
      <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="mb-0">All Products of Customer</h2>
        <button
          type="button"
          class="btn btn-outline-secondary"
          onclick="history.back()"
        >
          <i class="bi bi-arrow-left"></i> Back
        </button>
      </div>

      <c:if test="${not empty error}">
        <div class="alert alert-danger">
          <i class="bi bi-exclamation-triangle"></i> ${error}
        </div>
      </c:if>

      <div class="row g-3">
        <div class="col-12">
          <div class="card">
            <div class="card-header">Customer</div>
            <form
              class="card mb-3"
              method="get"
              action="${pageContext.request.contextPath}/customer/products"
            >
              <div class="card-body">
                <div class="row g-2 align-items-end">
                  <input
                    type="hidden"
                    name="customerId"
                    value="${param.customerId}"
                  />
                  <div class="col-md-3">
                    <label class="form-label" for="username"
                      >Customer Username</label
                    >
                    <input
                      id="username"
                      class="form-control"
                      type="text"
                      name="username"
                      placeholder="e.g. john.doe"
                      value="${param.username}"
                    />
                  </div>
                  <div class="col-md-3">
                    <label class="form-label" for="productName"
                      >Product Name</label
                    >
                    <input
                      id="productName"
                      class="form-control"
                      type="text"
                      name="productName"
                      placeholder="e.g. Router"
                      value="${param.productName}"
                    />
                  </div>
                  <div class="col-md-3">
                    <label class="form-label" for="serial">Item Serial</label>
                    <input
                      id="serial"
                      class="form-control"
                      type="text"
                      name="serial"
                      placeholder="e.g. SN-12345"
                      value="${param.serial}"
                    />
                  </div>
                  <div class="col-md-3 d-flex gap-2">
                    <button type="submit" class="btn btn-primary">
                      <i class="bi bi-search"></i> Search
                    </button>
                    <a
                      class="btn btn-outline-secondary"
                      href="${pageContext.request.contextPath}/customer/products?customerId=${param.customerId}"
                    >
                      <i class="bi bi-x-circle"></i> Clear
                    </a>
                  </div>
                </div>
              </div>
            </form>
            <div class="card-body">
              <div class="mb-2">
                <strong>Customer ID:</strong>
                <span
                  ><c:choose
                    ><c:when
                      test="${not empty customer and not empty customer.customerID}"
                      >#${customer.customerID}</c:when
                    ><c:otherwise>N/A</c:otherwise></c:choose
                  ></span
                >
              </div>
              <div class="mb-2">
                <strong>Customer Name:</strong>
                <span
                  ><c:choose
                    ><c:when
                      test="${not empty customer and not empty customer.customerName}"
                      >${customer.customerName}</c:when
                    ><c:otherwise>N/A</c:otherwise></c:choose
                  ></span
                >
              </div>
              <div class="mb-2">
                <strong>Total Products:</strong>
                <span>${totalProducts}</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="card mt-4">
        <div class="card-header">
          <i class="bi bi-box-seam"></i> Products Across Contracts
        </div>
        <div class="card-body">
          <c:choose>
            <c:when test="${not empty products}">
              <div class="table-responsive">
                <table class="table table-striped align-middle">
                  <thead>
                    <tr>
                      <th style="width: 10%">Contract ID</th>
                      <th style="width: 20%">Contract Code</th>
                      <th style="width: 10%">Product ID</th>
                      <th style="width: 30%">Product Name</th>
                      <th style="width: 30%">Item Serial</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="row" items="${products}">
                      <tr>
                        <td>${row.contractId}</td>
                        <td>
                            <a
                            href="${pageContext.request.contextPath}/contract/detail?contractId=${row.contractCode}"
                            class="text-decoration-none text-primary fw-semibold"
                          >
                            ${row.contractCode}</td>
                        <td>${row.productId}</td>
                        <td>${row.productName}</td>
                        <td>${row.itemSerial}</td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </div>
            </c:when>
            <c:otherwise>
              <div class="alert alert-info mb-0">
                <i class="bi bi-info-circle"></i> No products found for this
                customer.
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>
  </body>
</html>
