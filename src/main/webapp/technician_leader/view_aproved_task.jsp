<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="crm.common.model.Request" %>
<%@ page import="crm.common.model.enums.RequestStatus" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>
<%
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    List<Request> approvedRequests = (List<Request>) request.getAttribute("approvedRequests");
    Integer totalApproved = request.getAttribute("totalCount") != null ? (Integer) request.getAttribute("totalCount") : (approvedRequests != null ? approvedRequests.size() : 0);
    Integer totalPages = request.getAttribute("totalPages") != null ? (Integer) request.getAttribute("totalPages") : 1;
    Integer currentPage = request.getAttribute("currentPage") != null ? (Integer) request.getAttribute("currentPage") : 1;
    Integer pageSize = request.getAttribute("pageSize") != null ? (Integer) request.getAttribute("pageSize") : 8;
    Integer showingStart = request.getAttribute("startItem") != null ? (Integer) request.getAttribute("startItem") : (totalApproved > 0 ? 1 : 0);
    Integer showingEnd = request.getAttribute("endItem") != null ? (Integer) request.getAttribute("endItem") : (approvedRequests != null ? approvedRequests.size() : 0);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Assign Tasks</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/assets/css/task-views.css" rel="stylesheet"/>
</head>
<body>
<jsp:include page="../components/teach_lead_header.jsp"/>
<div class="page-header">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-8">
                <h1 class="display-5 fw-bold mb-0">
                    <i class="bi bi-list-check me-3"></i>View Request
                </h1>
            </div>
            <div class="col-md-4 text-end">
                <div class="d-flex align-items-center justify-content-end">
                    <div class="me-3">
                        <div class="text-white-50 small">Total Approved Requests</div>
                        <div class="h4 mb-0 fw-bold" id="totalTasksCount"><%= totalApproved %>
                        </div>
                    </div>
                    <i class="bi bi-clipboard-check display-4 opacity-50"></i>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="container">
    <br>

        <%
        String successMessage = (String) session.getAttribute("successMessage");
        if (successMessage != null) {
          session.removeAttribute("successMessage");
      %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-check-circle me-2"></i><%= successMessage %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
        <% } %>

        <%
        String warningMessage = (String) session.getAttribute("warningMessage");
        if (warningMessage != null) {
          session.removeAttribute("warningMessage");
      %>
    <div class="alert alert-warning alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-triangle me-2"></i><%= warningMessage %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
        <% } %>

        <%
        String errorMessage = (String) session.getAttribute("errorMessage");
        if (errorMessage != null) {
          session.removeAttribute("errorMessage");
      %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-x-circle me-2"></i><%= errorMessage %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
        <% } %>

    <div class="row">
        <div class="col-lg-8">
            <div class="card card-custom filter-card mb-4">
                <div class="card-header bg-transparent border-0">
                    <h5 class="card-title mb-0">
                        <i class="bi bi-funnel me-2"></i>Filter Requests
                    </h5>
                </div>
                <div class="card-body">
                    <form method="POST" action="${pageContext.request.contextPath}/task/viewAprovedTask"
                          id="filterForm">
                        <input type="hidden" name="action" value="filter"/>
                        <div class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label fw-semibold">Search by Phone</label>
                                <input
                                        type="text"
                                        class="form-control"
                                        id="phoneFilter"
                                        name="phoneFilter"
                                        value="<%= request.getAttribute("phoneFilter") != null ? request.getAttribute("phoneFilter") : "" %>"
                                        placeholder="Enter phone number..."
                                />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label fw-semibold">From Date</label>
                                <input
                                        type="date"
                                        class="form-control"
                                        id="fromDate"
                                        name="fromDate"
                                        value="<%= request.getAttribute("fromDate") != null ? request.getAttribute("fromDate") : "" %>"
                                        title="Select start date for filtering requests"
                                />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label fw-semibold">To Date</label>
                                <input
                                        type="date"
                                        class="form-control"
                                        id="toDate"
                                        name="toDate"
                                        value="<%= request.getAttribute("toDate") != null ? request.getAttribute("toDate") : "" %>"
                                        title="Select end date for filtering requests"
                                />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label fw-semibold">Customer Name</label>
                                <input
                                        type="text"
                                        class="form-control"
                                        id="customerFilter"
                                        name="customerFilter"
                                        value="<%= request.getAttribute("customerFilter") != null ? request.getAttribute("customerFilter") : "" %>"
                                        placeholder="Search customer..."
                                />
                            </div>
                        </div>
                        <div class="row mt-3">
                            <div class="col-12">
                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-search"></i> Apply Filter
                                    </button>
                                    <button type="button" class="btn btn-outline-secondary" onclick="clearFilters()">
                                        <i class="bi bi-arrow-clockwise"></i> Clear
                                    </button>
                                </div>
                            </div>
                        </div>
                        <input type="hidden" name="page" value="1"/>
                        <input type="hidden" name="pageSize" value="<%= pageSize %>"/>
                    </form>
                </div>
            </div>

            <div class="card card-custom mb-4">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="d-flex align-items-center">
                            <label class="form-check-label fw-semibold">
                                Request List (<span id="visibleRequestsCount"><%= totalApproved %></span> requests)
                            </label>
                        </div>
                        <div class="d-flex align-items-center gap-3">
                  <span class="badge badge-custom bg-primary me-2">
                    <span id="selectedRequestsCount">0</span> selected
                  </span>
                            <button class="btn btn-outline-primary btn-sm" onclick="clearAllSelections()">
                                <i class="bi bi-x-circle"></i> Clear Selection
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div
                        class="card-header d-flex justify-content-between align-items-center"
                >
                    <h5 class="mb-0">
                        <i class="bi bi-list-ul"></i> Request List (<span id="totalCount"><%= totalApproved %></span>
                        requests)
                    </h5>
                    <div class="d-flex align-items-center gap-2">
                        <label class="form-label mb-0 me-2">Show:</label>
                        <select
                                class="form-select form-select-sm"
                                id="pageSize"
                                style="width: 80px"
                        >
                            <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                            <option value="8" ${pageSize == 8 ? 'selected' : ''}>8</option>
                            <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                            <option value="15" ${pageSize == 15 ? 'selected' : ''}>15</option>
                        </select>
                        <span class="text-muted ms-2">per page</span>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="table-dark">
                        <tr>
                            <th width="40">Select</th>
                            <th>Request Details</th>
                            <th>Customer Info</th>
                            <th>Date</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                        </thead>

                        <tbody id="requestsTableBody">
                        <%
                            if (approvedRequests != null && !approvedRequests.isEmpty()) {
                                for (Request reqObj : approvedRequests) {
                        %>
                        <tr>
                            <td>
                                <input type="checkbox" class="form-check-input request-checkbox" name="selectedTasks"
                                       value="<%= reqObj.getRequestID() %>"/>
                            </td>
                            <td>
                                <div class="fw-bold text-primary mb-1"><%= reqObj.getRequestDescription() != null ? reqObj.getRequestDescription() : "Service Request" %>
                                </div>
                                <small class="text-muted"><%= reqObj.getNote() != null ? reqObj.getNote() : "" %>
                                </small>
                                <div class="mt-1">
                                    <small class="badge bg-light text-dark border">REQ-<%= reqObj.getRequestID() %>
                                    </small>
                                </div>
                            </td>
                            <td>
                                <div class="fw-semibold"><%= (reqObj.getContract() != null && reqObj.getContract().getCustomer() != null && reqObj.getContract().getCustomer().getCustomerName() != null) ? reqObj.getContract().getCustomer().getCustomerName() : "" %>
                                </div>
                                <small class="text-muted"><i
                                        class="bi bi-telephone me-1"></i><%= (reqObj.getContract() != null && reqObj.getContract().getCustomer() != null && reqObj.getContract().getCustomer().getPhone() != null) ? reqObj.getContract().getCustomer().getPhone() : "" %>
                                </small>
                            </td>
                            <td>
                                <small><i
                                        class="bi bi-calendar me-1"></i><%= reqObj.getStartDate() != null ? reqObj.getStartDate().format(formatter) : "" %>
                                </small>
                            </td>
                            <td>
                                <span class="badge bg-success"><%= reqObj.getRequestStatus() %></span>
                            </td>
                            <td>
                                <form method="post" action="${pageContext.request.contextPath}/task/detail"
                                      style="display:inline-block;">
                                    <input type="hidden" name="id" value="<%= reqObj.getRequestID() %>"/>
                                    <button type="submit" class="btn btn-sm btn-outline-primary">
                                        <i class="bi bi-eye"></i> View
                                    </button>
                                </form>
                            </td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="6" class="text-center text-muted py-4">No approved requests found</td>
                        </tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
                </div>

                <div class="card-footer">
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="text-muted">
                            Showing <span id="showingStart"><%= showingStart %></span> to
                            <span id="showingEnd"><%= showingEnd %></span> of
                            <span id="showingTotal"><%= totalApproved %></span> entries
                        </div>
                        <nav aria-label="Request pagination">
                            <ul class="pagination mb-0" id="pagination">
                                <%
                                    int prev = Math.max(1, currentPage - 1);
                                    int next = Math.min(totalPages, currentPage + 1);
                                %>
                                <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
                                    <a class="page-link pagination-link" href="#"
                                       data-page="<%= prev %>" <%= currentPage == 1 ? "data-disabled='true'" : "" %>>
                                        <i class="bi bi-chevron-left"></i> Previous
                                    </a>
                                </li>
                                <%
                                    // render up to 7 page links: current +/- 3
                                    int startPage = Math.max(1, currentPage - 3);
                                    int endPage = Math.min(totalPages, currentPage + 3);
                                    for (int p = startPage; p <= endPage; p++) {
                                %>
                                <li class="page-item <%= p == currentPage ? "active" : "" %>">
                                    <a class="page-link pagination-link" href="#"
                                       data-page="<%= p %>" <%= p == currentPage ? "data-current='true'" : "" %>><%= p %>
                                    </a>
                                </li>
                                <%
                                    }
                                %>
                                <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
                                    <a class="page-link pagination-link" href="#"
                                       data-page="<%= next %>" <%= currentPage == totalPages ? "data-disabled='true'" : "" %>>
                                        Next <i class="bi bi-chevron-right"></i>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>

            <div class="card mt-3">
                <div class="card-body text-center">
                    <div class="d-flex gap-2 justify-content-center">
                        <button
                                class="btn btn-success btn-lg"
                                id="quickAssignBtn"
                                disabled
                        >
                            <i class="bi bi-person-plus me-2"></i>
                            Assign Selected Tasks
                            <span
                                    class="badge bg-light text-dark ms-2"
                                    id="quickAssignCount"
                            >0</span
                            >
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="floating-summary">
                <div
                        class="assignment-summary mb-4"
                        id="assignmentSummary"
                        style="display: none"
                >
                    <h5 class="fw-bold mb-3">
                        <i class="bi bi-clipboard-check me-2"></i>Assignment Summary
                    </h5>
                    <div class="d-flex align-items-center mb-3">
                        <div class="task-count-badge me-3" id="selectedCountBadge">
                            0
                        </div>
                        <div>
                            <div class="fw-semibold">Tasks Selected</div>
                            <div class="small text-muted">Ready to assign</div>
                        </div>
                    </div>
                    <div id="selectedTasksList" class="small mb-3"></div>
                </div>

                <div class="card card-custom">
                    <div class="card-header bg-transparent border-0">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="card-title mb-0">
                                <i class="bi bi-check-circle me-2"></i>Selected Tasks
                            </h5>
                            <span class="badge bg-primary fs-6" id="selectedCountBadge"
                            >0 selected</span
                            >
                        </div>
                    </div>
                    <div class="card-body">
                        <div id="emptyState" class="text-center py-5">
                            <div class="mb-3">
                                <i class="bi bi-inbox display-1 text-muted"></i>
                            </div>
                            <h6 class="text-muted">No tasks selected</h6>
                            <p class="text-muted small">
                                Select tasks from the table above to view them here
                            </p>
                        </div>

                        <div id="selectedTasksContainer" style="display: none">
                            <div
                                    class="d-flex justify-content-between align-items-center mb-3"
                            >
                                <h6 class="mb-0">
                                    <i class="bi bi-list-check me-2"></i>Tasks Ready for
                                    Assignment
                                </h6>
                                <button class="btn btn-outline-danger btn-sm" onclick="clearAllSelections()">
                                    <i class="bi bi-trash"></i> Clear All
                                </button>
                            </div>

                            <div id="selectedTasksDisplay"></div>

                            <template id="selectedTaskTemplate">
                                <div class="selected-task-item p-3 mb-2 rounded bg-light border d-flex justify-content-between align-items-start"
                                     data-task-id="">
                                    <div class="flex-grow-1">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div>
                                                <div class="fw-semibold text-primary selected-task-desc">Request
                                                    description
                                                </div>
                                                <div class="small text-muted selected-task-note">Note</div>
                                            </div>
                                            <div class="text-end ms-3">
                                                <div class="small text-muted">REQ-<span
                                                        class="selected-task-id">0</span></div>
                                                <div class="small text-muted selected-task-date">01/01/1970</div>
                                            </div>
                                        </div>

                                        <div class="mt-2 small text-muted">
                                            <i class="bi bi-person me-1"></i><span class="selected-task-customer">Customer Name</span>
                                            &nbsp;•&nbsp;
                                            <i class="bi bi-telephone me-1"></i><span class="selected-task-phone">0123456789</span>
                                            &nbsp;•&nbsp;
                                            <span class="badge bg-success selected-task-status">APPROVED</span>
                                        </div>
                                    </div>
                                    <div class="ms-3 text-end">
                                        <div class="d-flex flex-column gap-2">
                                            <button class="btn btn-sm btn-outline-primary selected-task-view"
                                                    type="button"><i class="bi bi-eye"></i> View
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger selected-task-remove"
                                                    type="button"><i class="bi bi-x"></i> Remove
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </template>

                            <div id="assignmentActions" class="mt-4" style="display: none">

                                <div class="d-grid gap-2">
                                    <button class="btn btn-success btn-lg" onclick="assignSelectedTasks()">
                                        <i class="bi bi-person-plus me-2"></i>Assign to Technician
                                    </button>
                                    <button class="btn btn-outline-secondary" onclick="clearAllSelections()">
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/view_aproved_task.js"></script>
</body>
</html>
