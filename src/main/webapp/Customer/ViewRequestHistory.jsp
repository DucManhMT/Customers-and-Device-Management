<!-- <%--
  Created by IntelliJ IDEA.
  User: FPT SHOP
  Date: 10/3/2025
  Time: 12:29 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %> -->
<html>

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
  <title>View History</title>

</head>


<body>
  <div class="container mt-4">
    <div class="row mb-4">
      <div class="col-12">
        <h1 class="text-center mb-4">
          Request History
        </h1>
      </div>
    </div>
    <div class="row mb-4">
      <div class="col-md-3 col-sm-6 mb-3">
        <div class="card stats-card">
          <div class="stats-number" id="totalRequests">24</div>
          <div class="text-muted">Total requests</div>
        </div>
      </div>
      <div class="col-md-3 col-sm-6 mb-3">
        <div class="card stats-card">
          <div class="stats-number " id="completedRequests">18</div>
          <div class="text-muted">Completed</div>
        </div>
      </div>
      <div class="col-md-3 col-sm-6 mb-3">
        <div class="card stats-card">
          <div class="stats-number " id="pendingRequests">4</div>
          <div class="text-muted">Pending</div>
        </div>
      </div>
      <div class="col-md-3 col-sm-6 mb-3">
        <div class="card stats-card">
          <div class="stats-number" id="processingRequests">2</div>
          <div class="text-muted">In Progress</div>
        </div>
      </div>
    </div>

    <div class="card mt-4">
      <div class="row p-4">
        <div class="col-md-3 mb-3">
          <label for="contractID">Contract ID</label>
          <input type="text" id="contractID" class="form-control" placeholder="Enter Contract ID">
        </div>
        <div class="col-md-3 mb-3">
          <label for="startDate">Start Date</label>
          <input type="date" id="startDate" class="form-control">

        </div>

        <div class="col-md-3 mb-3">
          <label for="requestStatus">Request Status</label>
          <select id="requestStatus" class="form-select">
            <option value="">All</option>
            <option value="pending">Pending</option>
            <option value="in_progress">In Progress</option>
            <option value="completed">Completed</option>
          </select>
        </div>
        <div class="col-3">
          <div class="row">
            <div class="col-6 d-grid">
              <button id="filterBtn" class="btn btn-primary mt-4">Filter</button>
            </div>
            <div class="col-6 d-grid">
              <button id="resetBtn" class="btn btn-secondary mt-4">Reset</button>
            </div>
          </div>
        </div>

      </div>
    </div>
    <div>
      <table class="table table-bordered mt-4" id="requestsTable">
        <thead class="table-dark">
          <tr>
            <th>Contract ID</th>
            <th>Status</th>
            <th>Request Date</th>
            <th>Details</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>CON67890</td>
            <td>In Progress</td>
            <td>2024-09-15</td>
            <td class="text-center"><a href="#" class="btn btn-sm btn-info ">View</a></td>
          </tr>
        </tbody>
      </table>
    </div>
    <div class="row mt-4 align-items-center">
      <div class="col-md-6">
        <div class="d-flex align-items-center">
          <span class="me-3">Show:</span>
          <select class="form-select form-select-sm" style="width: auto;" id="itemsPerPageSelect">
            <option value="5">5</option>
            <option value="10">10</option>
            <option value="15">15</option>
            <option value="20">20</option>
          </select>
          <span class="ms-3 text-muted" id="paginationInfo">
            <!-- Info will be populated by JavaScript -->
          </span>
        </div>
      </div>
      <div class="col-md-6">
        <nav aria-label="Phân trang">
          <ul class="pagination justify-content-end mb-0">
            <!-- Trang đầu -->
            <li class="page-item disabled" id="firstPageBtn">
              <a class="page-link" href="#" onclick="changePage(1)" title="Trang đầu">
                <i class="bi bi-chevron-double-left"></i>
              </a>
            </li>

            <!-- Trang trước -->
            <li class="page-item disabled" id="prevPageBtn">
              <a class="page-link" href="#" onclick="changePage(currentPage - 1)" title="Trang trước">
                <i class="bi bi-chevron-left"></i>
              </a>
            </li>

            <!-- Trang 1 -->
            <li class="page-item active" id="page1">
              <a class="page-link" href="#" onclick="changePage(1)">1</a>
            </li>

            <!-- Trang 2 -->
            <li class="page-item" id="page2" style="display: none;">
              <a class="page-link" href="#" onclick="changePage(2)">2</a>
            </li>

            <!-- Trang 3 -->
            <li class="page-item" id="page3" style="display: none;">
              <a class="page-link" href="#" onclick="changePage(3)">3</a>
            </li>

            <!-- Dấu ... -->
            <li class="page-item disabled" id="ellipsis" style="display: none;">
              <span class="page-link">...</span>
            </li>

            <!-- Trang cuối -->
            <li class="page-item" id="lastPageItem" style="display: none;">
              <a class="page-link" href="#" onclick="changePage(totalPages)" id="lastPageLink">5</a>
            </li>

            <!-- Trang sau -->
            <li class="page-item" id="nextPageBtn">
              <a class="page-link" href="#" onclick="changePage(currentPage + 1)" title="Trang sau">
                <i class="bi bi-chevron-right"></i>
              </a>
            </li>

            <!-- Trang cuối cùng -->
            <li class="page-item" id="lastBtn">
              <a class="page-link" href="#" onclick="changePage(totalPages)" title="Trang cuối">
                <i class="bi bi-chevron-double-right"></i>
              </a>
            </li>
          </ul>
        </nav>
      </div>
    </div>

  </div>
</body>

</html>