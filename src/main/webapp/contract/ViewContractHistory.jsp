<!DOCTYPE html>
<html lang="vi">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Thông Tin Chi Tiết Hợp Đồng</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">

</head>

<body>
  <div class="container-fluid">
    <div class="main-container">
      <div class="header-section">
        <div class="row align-items-center position-relative">
          <div class="col-md-8">
            <h1 class="mb-2">
              Contract History
            </h1>
          </div>

        </div>
      </div>

      <div class="p-4">
        <div class="search-section">
          <h5 class="mb-3"><i class="bi bi-search me-2"></i>Search Contracts</h5>
          <div class="row g-3">
            <div class="col-md-3">
              <label class="form-label">Contract ID</label>
              <input type="text" class="form-control" id="contractIdSearch" placeholder="Enter contract ID...">
            </div>
            <div class="col-md-3">
              <label class="form-label">Status</label>
              <select class="form-select" id="statusFilter">
                <option value="">All Statuses</option>
                <option value="active">Active</option>
                <option value="expired">Expired</option>
                <option value="pending">Pending</option>
              </select>
            </div>
            <div class="col-md-3">
              <label class="form-label">Start Date</label>
              <input type="date" class="form-control" id="startDateSearch">
            </div>
            <div class="col-md-3 d-flex align-items-end gap-2">
              <button class="btn btn-primary-custom w-50" onclick="searchContracts()">
                <i class="bi bi-search me-1"></i>Search
              </button>
              <button class="btn btn-secondary-custom w-50" onclick="resetFilters()">
                <i class="bi bi-arrow-clockwise me-1"></i>Reset
              </button>
            </div>
          </div>

        </div>
      </div>
    </div>

    <div class="contract-summary">
      <div class="row">
        <div class="col-md-3 text-center">
          <h3 class="text-success mb-1" id="totalContracts">1</h3>
          <small class="text-muted">Total Contracts</small>
        </div>
        <div class="col-md-3 text-center">
          <h3 class="text-primary mb-1" id="activeContracts">1</h3>
          <small class="text-muted">Active</small>
        </div>
        <div class="col-md-3 text-center">
          <h3 class="text-warning mb-1" id="expiringSoon">0</h3>
          <small class="text-muted">Expiring Soon</small>
        </div>
        <div class="col-md-3 text-center">
          <h3 class="text-danger mb-1" id="expiredContracts">0</h3>
          <small class="text-muted">Expired</small>
        </div>
      </div>
    </div>

    <!-- Contracts Table -->
    <div class="contract-card">
      <div class="card-header-custom">
        <h5 class="mb-0">
          <i class="bi bi-table me-2"></i>
          Contract List
        </h5>
      </div>
      <div class="table-responsive">
        <table class="table table-hover mb-0" id="contractsTable">
          <thead class="table-dark">
            <tr>
              <th>Contract ID</th>
              <th>Start Date</th>
              <th>End Date</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody id="contractsTableBody">
            <tr class="align-middle">
              <td>
                <strong class="text-primary">HD001</strong>
              </td>

              <td>
                <i class="bi bi-calendar-check text-success me-1"></i>
                15/01/2024
              </td>
              <td>
                <i class="bi bi-calendar-x text-danger me-1"></i>
                31/12/2024
              </td>

              <td>
                <span class="status-badge status-active">
                  Active
                </span>
              </td>
              <td>
                <div class="btn-group-vertical btn-group-sm" role="group">
                  <button class="btn btn-outline-primary btn-sm mb-1" onclick="viewContractDetails('HD001')"
                    title="Xem chi tiết">
                    View detail
                  </button>

                </div>
              </td>
            </tr>

          </tbody>
        </table>
      </div>
    </div>
    <!-- Pagination Controls -->
    <div>
      <div class="row mt-4 align-items-center">
        <div class="col-md-6">
          <div class="d-flex align-items-center">
            <span class="me-3">Show:</span>
            <select class="form-select form-select-sm" style="width: auto;" id="itemsPerPageSelect">
              <option value="5">5 </option>
              <option value="10">10</option>
              <option value="15">15</option>
              <option value="20">20</option>
            </select>

          </div>
        </div>
        <!-- Pagination -->
        <nav aria-label="Phân trang hợp đồng" class="mt-4">
          <ul class="pagination justify-content-center" id="pagination">
            <li class="page-item disabled">
              <a class="page-link" href="#" onclick="changePage(0)">Previous</a>
            </li>
            <li class="page-item active">
              <a class="page-link" href="#" onclick="changePage(1)">1</a>
            </li>
            <li class="page-item">
              <a class="page-link" href="#" onclick="changePage(2)">2</a>
            </li>
            <li class="page-item">
              <a class="page-link" href="#" onclick="changePage(3)">3</a>
            </li>
            <li class="page-item">
              <a class="page-link" href="#" onclick="changePage(2)">Next</a>
            </li>
          </ul>
        </nav>
      </div>
    </div>




</html>