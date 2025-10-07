<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assign Tasks</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }

        .header-section {
            background: #2c3e50;
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }

        .task-card {
                                         <button class="btn btn-success-custom btn-custom">
                                        <i class="bi bi-check-circle me-2"></i>Assign Tasks
                                    </button>
                                    <button class="btn btn-outline-secondary">
                                        <i class="bi bi-x-circle me-2"></i>Clear Selection
                                    </button> border: 1px solid #ddd;
            border-radius: 8px;
            transition: all 0.2s;
            cursor: pointer;
            background: white;
        }

        .task-card:hover {
            border-color: #007bff;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .task-card.selected {
            border-color: #28a745;
            background-color: #f8fff8;
        }

        .badge-pending {
            background-color: #ffc107;
            color: #212529;
        }

        .badge-progress {
            background-color: #007bff;
            color: white;
        }

        .badge-review {
            background-color: #6f42c1;
            color: white;
        }

        .badge-high {
            background-color: #dc3545;
            color: white;
        }

        .badge-medium {
            background-color: #fd7e14;
            color: white;
        }

        .badge-low {
            background-color: #6c757d;
            color: white;
        }

        /* Selected Tasks Styles */
        .selected-task-item {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            transition: all 0.2s ease;
        }

        .selected-task-item:hover {
            background: #e9ecef;
            border-color: #dee2e6;
            transform: translateY(-1px);
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        #emptyState {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 10px;
            border: 2px dashed #dee2e6;
        }

        #selectedTasksList {
            max-height: 400px;
            overflow-y: auto;
        }

        #selectedTasksList::-webkit-scrollbar {
            width: 6px;
        }

        #selectedTasksList::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 3px;
        }

        #selectedTasksList::-webkit-scrollbar-thumb {
            background: #c1c1c1;
            border-radius: 3px;
        }

        #selectedTasksList::-webkit-scrollbar-thumb:hover {
            background: #a8a8a8;
        }

        #selectedCountBadge {
            font-size: 0.875rem;
            padding: 0.5rem 1rem;
        }

        .alert-primary {
            background: linear-gradient(135deg, #cce7ff 0%, #b3d9ff 100%);
            border-color: #99ccff;
        }

        /* Quick Assignment Button Styles */
        #quickAssignBtn {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        #quickAssignBtn:hover:not(:disabled) {
            background: linear-gradient(135deg, #20c997 0%, #17a2b8 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4);
        }

        #quickAssignBtn:disabled {
            background: #6c757d;
            cursor: not-allowed;
            opacity: 0.6;
        }

        #quickAssignCount {
            background: rgba(255, 255, 255, 0.9) !important;
            color: #28a745 !important;
            font-weight: bold;
            min-width: 24px;
            border-radius: 12px;
        }

        .btn-outline-secondary.btn-lg {
            border-width: 2px;
            transition: all 0.3s ease;
        }

        .btn-outline-secondary.btn-lg:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(108, 117, 125, 0.3);
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
        <div class="container">
            <a class="navbar-brand fw-bold" href="#">
                <i class="bi bi-gear-fill me-2"></i>Tech Lead Dashboard
            </a>
            <div class="navbar-nav ms-auto">
                <div class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="bi bi-person-circle me-1"></i>Tech Lead
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/task/techlead/assignTask.jsp">
                            <i class="bi bi-plus-circle me-2"></i>Single Assignment</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/task/viewTechnicianList.jsp">
                            <i class="bi bi-people me-2"></i>View Technicians</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="#">
                            <i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>

    <!-- Page Header -->
    <div class="page-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="display-5 fw-bold mb-0">
                        <i class="bi bi-list-check me-3"></i>Assign Task
                    </h1>
                      </div>
                <div class="col-md-4 text-end">
                    <div class="d-flex align-items-center justify-content-end">
                        <div class="me-3">
                            <div class="text-white-50 small">Total Approved Requests</div>
                            <div class="h4 mb-0 fw-bold" id="totalTasksCount">8</div>
                        </div>
                        <i class="bi bi-clipboard-check display-4 opacity-50"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="row">
            <!-- Tasks List Column -->
            <div class="col-lg-8">
                <!-- Filters -->
                <div class="card card-custom filter-card mb-4">
                    <div class="card-header bg-transparent border-0">
                        <h5 class="card-title mb-0">
                            <i class="bi bi-funnel me-2"></i>Filter Requests
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label fw-semibold">Search by Phone</label>
                                <input type="text" class="form-control" id="phoneFilter" 
                                       placeholder="Enter phone number...">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label fw-semibold">Date Period</label>
                                <select class="form-select" id="datePeriodFilter">
                                    <option value="">All Time</option>
                                    <option value="1week">Last 1 Week</option>
                                    <option value="1month">Last 1 Month</option>
                                    <option value="6months">Last 6 Months</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label fw-semibold">Customer Name</label>
                                <input type="text" class="form-control" id="customerFilter" 
                                       placeholder="Search customer...">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label fw-semibold">&nbsp;</label>
                                <div class="d-grid gap-2">
                                    <button class="btn btn-primary">
                                        <i class="bi bi-search"></i> Apply Filter
                                    </button>
                                    <button class="btn btn-outline-secondary">
                                        <i class="bi bi-arrow-clockwise"></i> Clear
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Bulk Actions -->
                <div class="card card-custom mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="d-flex align-items-center">
                                <input type="checkbox" class="form-check-input me-3 task-checkbox" 
                                       id="selectAll" onchange="toggleSelectAll()">
                                <label class="form-check-label fw-semibold" for="selectAll">
                                    Select All Requests (<span id="visibleRequestsCount">8</span>)
                                </label>
                            </div>
                            <div class="d-flex align-items-center gap-3">
                                <span class="badge badge-custom bg-primary me-2">
                                    <span id="selectedRequestsCount">0</span> selected
                                </span>
                                <button class="btn btn-outline-primary btn-sm">
                                    <i class="bi bi-x-circle"></i> Clear Selection
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tasks Table -->
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">
                            <i class="bi bi-list-ul"></i> Request List 
                            (<span id="totalCount">8</span> requests)
                        </h5>
                        <div class="d-flex align-items-center gap-2">
                            <label class="form-label mb-0 me-2">Show:</label>
                            <select class="form-select form-select-sm" id="pageSize" style="width: 80px;">
                                <option value="5">5</option>
                                <option value="8" selected>8</option>
                                <option value="10">10</option>
                                <option value="15">15</option>
                            </select>
                            <span class="text-muted ms-2">per page</span>
                        </div>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-dark">
                                <tr>
                                    <th width="40">
                                        <input type="checkbox" class="form-check-input" id="selectAll">
                                    </th>
                                    <th>Request Details</th>
                                    <th>Customer Info</th>
                                    <th>Date</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                            </thead>
                            <tbody id="requestsTableBody">
                                <!-- Static Sample Data -->
                                
                                <tr>
                                    <td>  

                                        <input type="checkbox" class="form-check-input">
                                    </td>
                                    <td>
                                        <div class="fw-bold text-primary mb-1">Software Installation Request</div>
                                        <small class="text-muted">Microsoft Office 365 installation and configuration on 5 office computers. License activation and user training included.</small>
                                        <div class="mt-1">
                                            <small class="badge bg-light text-dark border">REQ-006</small>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="fw-semibold">Nguyen Thi Hong</div>
                                        <small class="text-muted">
                                            <i class="bi bi-telephone me-1"></i>0976-456-123
                                        </small>
                                    </td>
                                    <td>
                                        <small><i class="bi bi-calendar me-1"></i>01/02/2024</small>
                                    </td>
                                    <td>
                                        <span class="badge bg-success">Approved</span>
                                    </td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary">
                                            <i class="bi bi-eye"></i> View
                                        </button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <input type="checkbox" class="form-check-input">
                                    </td>
                                    <td>
                                        <div class="fw-bold text-primary mb-1">Network Security Setup Request</div>
                                        <small class="text-muted">Configure firewall and security protocols for small business network. VPN setup and access control implementation.</small>
                                        <div class="mt-1">
                                            <small class="badge bg-light text-dark border">REQ-007</small>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="fw-semibold">Vo Thi Kim</div>
                                        <small class="text-muted">
                                            <i class="bi bi-telephone me-1"></i>0918-765-432
                                        </small>
                                    </td>
                                    <td>
                                        <small><i class="bi bi-calendar me-1"></i>18/02/2024</small>
                                    </td>
                                    <td>
                                        <span class="badge bg-success">Approved</span>
                                    </td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary">
                                            <i class="bi bi-eye"></i> View
                                        </button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <input type="checkbox" class="form-check-input">
                                    </td>
                                    <td>
                                        <div class="fw-bold text-primary mb-1">Database Backup System Request</div>
                                        <small class="text-muted">Automated database backup system implementation for MySQL server. Daily backup schedule and recovery procedures setup.</small>
                                        <div class="mt-1">
                                            <small class="badge bg-light text-dark border">REQ-008</small>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="fw-semibold">Tran Van Long</div>
                                        <small class="text-muted">
                                            <i class="bi bi-telephone me-1"></i>0909-876-543
                                        </small>
                                    </td>
                                    <td>
                                        <small><i class="bi bi-calendar me-1"></i>20/02/2024</small>
                                    </td>
                                    <td>
                                        <span class="badge bg-success">Approved</span>
                                    </td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary">
                                            <i class="bi bi-eye"></i> View
                                        </button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    
                    <!-- Pagination -->
                    <div class="card-footer">
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="text-muted">
                                Showing <span id="showingStart">1</span> to <span id="showingEnd">8</span> 
                                of <span id="showingTotal">8</span> entries
                            </div>
                            <nav aria-label="Request pagination">
                                <ul class="pagination mb-0" id="pagination">
                                    <li class="page-item disabled">
                                        <a class="page-link" href="#">
                                            <i class="bi bi-chevron-left"></i> Previous
                                        </a>
                                    </li>
                                    <li class="page-item active">
                                        <a class="page-link" href="#">1</a>
                                    </li>
                                    <li class="page-item">
                                        <a class="page-link" href="#">2</a>
                                    </li>
                                    <li class="page-item">
                                        <a class="page-link" href="#">
                                            Next <i class="bi bi-chevron-right"></i>
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>

                <!-- Quick Assignment Actions -->
                <div class="card mt-3">
                    <div class="card-body text-center">
                        <div class="d-flex gap-2 justify-content-center">
                            <button class="btn btn-success btn-lg" id="quickAssignBtn" disabled>
                                <i class="bi bi-person-plus me-2"></i>
                                Assign Selected Tasks
                                <span class="badge bg-light text-dark ms-2" id="quickAssignCount">0</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Assignment Panel Column -->
            <div class="col-lg-4">
                <div class="floating-summary">
                    <!-- Assignment Summary -->
                    <div class="assignment-summary mb-4" id="assignmentSummary" style="display: none;">
                        <h5 class="fw-bold mb-3">
                            <i class="bi bi-clipboard-check me-2"></i>Assignment Summary
                        </h5>
                        <div class="d-flex align-items-center mb-3">
                            <div class="task-count-badge me-3" id="selectedCountBadge">0</div>
                            <div>
                                <div class="fw-semibold">Tasks Selected</div>
                                <div class="small text-muted">Ready to assign</div>
                            </div>
                        </div>
                        <div id="selectedTasksList" class="small mb-3"></div>
                    </div>

                    <!-- Selected Tasks Summary -->
                    <div class="card card-custom">
                        <div class="card-header bg-transparent border-0">
                            <div class="d-flex justify-content-between align-items-center">
                                <h5 class="card-title mb-0">
                                    <i class="bi bi-check-circle me-2"></i>Selected Tasks
                                </h5>
                                <span class="badge bg-primary fs-6" id="selectedCountBadge">0 selected</span>
                            </div>
                        </div>
                        <div class="card-body">
                            <!-- Empty State -->
                            <div id="emptyState" class="text-center py-5">
                                <div class="mb-3">
                                    <i class="bi bi-inbox display-1 text-muted"></i>
                                </div>
                                <h6 class="text-muted">No tasks selected</h6>
                                <p class="text-muted small">Select tasks from the table above to view them here</p>
                            </div>

                            <!-- Selected Tasks List -->
                            <div id="selectedTasksList" style="display: none;">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h6 class="mb-0">
                                        <i class="bi bi-list-check me-2"></i>Tasks Ready for Assignment
                                    </h6>
                                    <button class="btn btn-outline-danger btn-sm">
                                        <i class="bi bi-trash"></i> Clear All
                                    </button>
                                </div>

                                <!-- Sample Selected Tasks -->
                                <div class="selected-task-item mb-3 p-3 border rounded">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div class="flex-grow-1">
                                            <h6 class="fw-bold mb-1">Laptop Screen Replacement Request</h6>
                                            <div class="small text-muted mb-2">
                                                <i class="bi bi-person me-1"></i>Nguyen Van Duc
                                                <span class="mx-2">•</span>
                                                <i class="bi bi-telephone me-1"></i>0938-123-456
                                                <span class="mx-2">•</span>
                                                <i class="bi bi-calendar me-1"></i>10/02/2024
                                            </div>
                                            <div class="small">
                                                <span class="badge bg-light text-dark border">REQ-001</span>
                                                <span class="badge bg-success ms-1">Approved</span>
                                            </div>
                                        </div>
                                        <button class="btn btn-outline-danger btn-sm">
                                            <i class="bi bi-x"></i>
                                        </button>
                                    </div>
                                </div>

                                <div class="selected-task-item mb-3 p-3 border rounded">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div class="flex-grow-1">
                                            <h6 class="fw-bold mb-1">PC Motherboard Diagnosis Request</h6>
                                            <div class="small text-muted mb-2">
                                                <i class="bi bi-person me-1"></i>Tran Thi Mai
                                                <span class="mx-2">•</span>
                                                <i class="bi bi-telephone me-1"></i>0987-654-321
                                                <span class="mx-2">•</span>
                                                <i class="bi bi-calendar me-1"></i>08/02/2024
                                            </div>
                                            <div class="small">
                                                <span class="badge bg-light text-dark border">REQ-002</span>
                                                <span class="badge bg-success ms-1">Approved</span>
                                            </div>
                                        </div>
                                        <button class="btn btn-outline-danger btn-sm">
                                            <i class="bi bi-x"></i>
                                        </button>
                                    </div>
                                </div>

                                <div class="selected-task-item mb-3 p-3 border rounded">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div class="flex-grow-1">
                                            <h6 class="fw-bold mb-1">Printer Network Setup Request</h6>
                                            <div class="small text-muted mb-2">
                                                <i class="bi bi-person me-1"></i>Le Van Nam
                                                <span class="mx-2">•</span>
                                                <i class="bi bi-telephone me-1"></i>0912-345-678
                                                <span class="mx-2">•</span>
                                                <i class="bi bi-calendar me-1"></i>12/02/2024
                                            </div>
                                            <div class="small">
                                                <span class="badge bg-light text-dark border">REQ-003</span>
                                                <span class="badge bg-success ms-1">Approved</span>
                                            </div>
                                        </div>
                                        <button class="btn btn-outline-danger btn-sm">
                                            <i class="bi bi-x"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <!-- Assignment Actions -->
                            <div id="assignmentActions" class="mt-4" style="display: none;">
                                <div class="alert alert-primary" role="alert">
                                    <div class="d-flex align-items-center">
                                        <i class="bi bi-info-circle me-2"></i>
                                        <div class="flex-grow-1">
                                            <strong>Ready for Assignment</strong>
                                            <div class="small mt-1">
                                                <span id="selectedTasksCount">3</span> tasks selected • 
                                                Click "Assign to Technician" to proceed
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="d-grid gap-2">
                                    <button class="btn btn-success btn-lg">
                                        <i class="bi bi-person-plus me-2"></i>Assign to Technician
                                    </button>
                                    <button class="btn btn-outline-secondary">
                                        <i class="bi bi-arrow-clockwise me-2"></i>Reset Selection
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // UI Only - No Functions
    </script>

</body>
</html>