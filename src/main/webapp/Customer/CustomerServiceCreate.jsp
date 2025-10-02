<!-- <%--
  Created by IntelliJ IDEA.
  User: FPT SHOP
  Date: 10/2/2025
  Time: 10:11 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %> -->
<html>

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
  <title>Create Request</title>
</head>

<body>
  <div>

    <h1 class="text-center">Create Request</h1>

    <div class="row justify-content-center">
      <div class="col-lg-10">
        <div class="card shadow-lg border-0 rounded-4" id="mainForm">
          <div class="card-body p-5">
            <form>

              <div class="mb-4">
                <label>Request Type</label>
                <div class="row g-3 mt-2">
                  <div class="col-md-4">
                    <div class="service-card card h-100 text-center p-4 rounded-3 " data-service="support">
                      <input type="radio" id="support" name="serviceType" value="support" class="d-none" required>

                      <h6>Support</h6>
                    </div>
                  </div>
                  <div class="col-md-4">
                    <div class="service-card card h-100 text-center p-4 rounded-3" data-service="repair">
                      <input type="radio" id="repair" name="serviceType" value="repair" class="d-none">

                      <h6>Repair</h6>

                    </div>
                  </div>
                  <div class="col-md-4">
                    <div class="service-card card h-100 text-center p-4 rounded-3" data-service="warranty">
                      <input type="radio" id="warranty" name="serviceType" value="warranty" class="d-none">
                      <h6>Warranty</h6>
                    </div>
                  </div>
                </div>
              </div>


              <div class="row g-3 mb-4">
                <div class="col-md-6">
                  <label for="fullName" class="form-label fw-semibold">Fullname *</label>
                  <input type="text" id="fullName" name="fullName" required class="form-control form-control-lg"
                    placeholder="Enter fullname">
                </div>
                <div class="col-md-6">
                  <label for="phone" class="form-label fw-semibold">Phone Number *</label>
                  <input type="tel" id="phone" name="phone" required class="form-control form-control-lg"
                    placeholder="Enter phone number">
                </div>
              </div>

              <div class="mb-4">
                <label for="email" class="form-label fw-semibold">Email *</label>
                <input type="email" id="email" name="email" required class="form-control form-control-lg"
                  placeholder="example@email.com">
              </div>

              <div class="row g-3 mb-4">
                <div class="col-md-6">
                  <label for="productName" class="form-label fw-semibold">Product Name *</label>
                  <input type="text" id="productName" name="productName" required class="form-control form-control-lg"
                    placeholder="Enter product name">
                </div>
                <div class="col-md-6">
                  <label for="serialNumber" class="form-label fw-semibold">Serial number/model *</label>
                  <input type="text" id="serialNumber" name="serialNumber" required class="form-control form-control-lg"
                    placeholder="Enter serial number or model">
                </div>
              </div>
              <div class="mb-4">
                <label for="purchaseDate" class="form-label fw-semibold">Purchase Date *</label>
                <input type="date" id="purchaseDate" name="purchaseDate" class="form-control form-control-lg" required>
              </div>

              <div class="mb-4">
                <label for="description" class="form-label fw-semibold">Description *</label>
                <textarea id="description" name="description" rows="5" required class="form-control"
                  placeholder="Enter Description"></textarea>
              </div>
              <div class="text-center pt-3">
                <button type="submit" class="btn btn-primary btn-lg btn-submit px-5 py-3">
                  <i class="bi bi-send-fill me-2"></i>
                  Submit Request
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
      </div>
    </div>


</body>

</html>